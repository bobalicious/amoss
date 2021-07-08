/*
MIT License

Copyright (c) 2020 Robert Baillie

https://github.com/bobalicious/amoss

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/**
* The entry point for all creations of Amoss Test Doubles, Spies and Mocks.
*
* Is instantiated with a class Type, then configured with combinations of 'expect', 'when' and 'allows'.
*
* Once configured, is used to 'getDouble', which can then be used in place of the class being doubled.
*
* On completion, a call-log can be spied for parameter values, and mock the expected call stack can be
* checked using 'verify'.
*
* Can be used to create a test double for any class that can be stubbed using the standard Salesforce
* 'StubProvider' interface (which this class implements), and has the same limitations as that functionality.
*
*/
@isTest
public without sharing class Amoss_Instance implements StubProvider { //NOPMD - Is a single class library, hence the requirement for a significant number of public methods

    public class Amoss_ClassTypeNotDefinedException extends Exception {}
    public class Amoss_ClassTypeAlreadyDefinedException extends Exception {}
    public class Amoss_CallLogException extends Exception {}
    public class Amoss_ExpectsNoCallsAndCallsConfiguredException extends Exception {}
    public class Amoss_ExpectedObjectCannotBeNullException extends Exception {}
    public class Amoss_NotAnHttpCalloutMockException extends Exception {}

    private Amoss_Expectations expectations = new Amoss_Expectations();
    private Amoss_Expectations whens        = new Amoss_Expectations();
    private Amoss_CallLog      callLog      = new Amoss_CallLog();

    private Object  defaultMethodReturn;
    private Boolean isFluent = false;

    private Type classType;

    private Amoss_Asserts assertionMechanism = new Amoss_Asserts();

    private Boolean allowsAnyCall                  = true;
    private Boolean allowsAnyCallExplicitlyDefined = false;
    private Boolean expectsNoCalls                 = false;

    private String moreCallsThanExpectedMessage = '{0}.{1} was called more times than was expected';
    private String expectedNoCallsMessage = '{0} did not expect any methods to be called';
    private String expectedEmptyCallStackMessage = 'Expected call stack for {0} should be empty, and it is not';

    public static Amoss_ValueVerifierBuilder valueVerifierBuilder = new Amoss_ValueVerifierBuilder();

    public enum Value { NOT_NULL, ANY_VALUE, NOT_EMPTY }

    public Amoss_Instance() {
    }

    public Amoss_Instance( Type classType ) {
        this.classType = classType;
    }

    private Amoss_Instance( Amoss_Instance toClone ) {

        this.latestGeneratedDouble = null;

        this.expectations = toClone.expectations.createClone().setAmossInstance( this );
        this.whens        = toClone.whens.createClone().setAmossInstance( this );

        this.classType                      = toClone.classType;
        this.allowsAnyCall                  = toClone.allowsAnyCall;
        this.allowsAnyCallExplicitlyDefined = toClone.allowsAnyCallExplicitlyDefined;
        this.expectsNoCalls                 = toClone.expectsNoCalls;
        this.defaultMethodReturn            = toClone.defaultMethodReturn;

        if ( toClone.isFluent ) {
            this.isFluent();
        }
    }

    /**
    * Allows the setting of the class that this Amoss Instance should generate test doubles for.s
    *
    * In general, the constructor that takes a class Type should be used over this, unless you particularly require
    * the need to defer the setting of the class type (e.g. you have a templated instance that can be used for different types)
    *
    * @param  Type - The class type that this instance should generate test doubles for.
    * @return Amoss_Instance - The instance to use in your test
    */
    public Amoss_Instance setClass( Type classType ) {
        if ( this.classType != null ) {
            throw new Amoss_ClassTypeAlreadyDefinedException( 'The class type on this Amoss_Instance has already been set to ' + this.classType );
        }
        this.classType = classType;
        return this;
    }

    /**
    * Returns the instance of the class that you use in the application under test.
    *
    * @return Object  - The instance to use in your test
    */
    private Object latestGeneratedDouble;
    public Object getDouble() {
        if ( latestGeneratedDouble == null ) {
            return generateDouble();
        }
        return latestGeneratedDouble;
    }

    /**
    * States that this controller is an HttpCalloutMock, registering it as the mock callout and
    * switching the grammar to that required for specifying expected callouts and their responses.
    *
    * Example usage:
    *    new Amoss_Instance()
    *        .isACalloutMock()
    *        .when()
    *            .method( 'GET' )
    *            .respondsWith()
    *                .body( '{some JSON}' )
    */
    public Amoss_CalloutMockDefiner isACalloutMock() {
        if ( this.classType == null ) {
            setClass( Amoss_HttpCalloutMock.class );
            setMoreCallsThanExpectedMessage( 'More HTTP Callouts were made than expected' );
            setExpectedNoCallsMessage( 'Did not expect any HTTP Callouts to be made' );
            setExpectedEmptyCallStackMessage( 'Expected more HTTP Callouts to be made' );
            byDefaultMethodsReturn( new HttpResponse() );
        }
        return new Amoss_CalloutMockDefiner( this );
    }

    /**
    * Generates a new instance of the class that you use in the application under tests.
    * Used to generate multiple objects that all behave in the same way when you do not require
    * access to the conroller.
    *
    * Will clone the Amoss_Instance, although will not provide access to it.
    *
    * Is generally not required, and getDouble should be used in most cases.
    *
    * @return Object  - The instance to use in your test
    */
    public Object generateDouble() {
        if ( classType == null ) {
            throw new Amoss_ClassTypeNotDefinedException( 'The class type on this Amoss_Instance has not been defined.  Either set it on construction, or by calling setClass' );
        }
        latestGeneratedDouble = Test.createStub( classType, this );
        return latestGeneratedDouble;
    }

    /**
    * Creates a clone of this instance, allowing multiple versions of the object being doubled to
    * be created, along with access to the controller (as opposed to the behaviour of generateNewDouble)
    *
    * Is generally not required.
    *
    * @return Amoss_Instance - The new instance of the controller
    */
    public Amoss_Instance createClone() {
        return new Amoss_Instance( this );
    }

    /**
    * States that the next method definition is expected to be called in the order it appears.
    *
    * If a method is subsequently called out of order, will fail the test.
    *
    * Calling 'verify' will check that all expectations have been met, failing the test if not.
    *
    * 'Expectations' take lower priority than 'whens' (I.E. if a matching 'when' is defined at call time, then it will match that over the next 'expect').
    *
    * Define in the format:
    *   expects()
    *     .method( 'methodName' )
    *     .withParameter( 'parameterValue' )
    *     .returning( 'theValueItShouldReturn' )
    */
    public Amoss_MethodDefiner expects() {

        if ( expectsNoCalls ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the double expects a call when it has been stated that it expectsNoCalls' );
        }

        if ( ! allowsAnyCallExplicitlyDefined ) {
            allowsAnyCall = false;
        }
        Amoss_Expectation newExpectation = new Amoss_Expectation( this );
        this.expectations.add( newExpectation );
        return new Amoss_MethodDefiner( newExpectation );
    }

    /**
    * States that the next method definition is expected to be called in the order it appears.
    *
    * If a method is subsequently called out of order, will fail the test.
    *
    * Calling 'verify' will check that all expectations have been met, failing the test if not.
    *
    * 'Expectations' take lower priority than 'whens' (I.E. if a matching 'when' is defined at call time, then it will match that over the next 'expect').
    *
    * Define in the format:
    *   expects( 'methodName' )
    *     .withParameter( 'parameterValue' )
    *     .returning( 'theValueItShouldReturn' )
    */
    public Amoss_ParametersDefiner expects( String method ) {
        return expects().method( method );
    }

    /**
    * States that when a method is called that matches the definition, the stated behaviour will
    * be exhibited.
    *
    * Call order is not checked, and 'verify' will not check that 'whens' have been met.
    *
    * 'Whens' take higher priority than 'expectations' (I.E. if a matching 'when' is defined at call time, then it
    * will match that over the next 'expect').
    *
    * Define in the format:
    *   when()
    *     .method( 'methodName' )
    *     .withParameter( 'parameterValue' )
    *     .willReturn( 'theValueItShouldReturn' )
    */
    public Amoss_MethodDefiner when() {

        if ( expectsNoCalls ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the when on a double when it has been stated that it expectsNoCalls' );
        }

        Amoss_Expectation newExpectation = new Amoss_Expectation( this );
        this.whens.add( newExpectation );
        return new Amoss_MethodDefiner( newExpectation );
    }

    /**
    * States that when a method is called that matches the definition, the stated behaviour will
    * be exhibited.
    *
    * Call order is not checked, and 'verify' will not check that 'whens' have been met.
    *
    * 'Whens' take higher priority than 'expectations' (I.E. if a matching 'when' is defined at call time, then it
    * will match that over the next 'expect').
    *
    * Define in the format:
    *   when( 'methodName' )
    *     .withParameter( 'parameterValue' )
    *     .willReturn( 'theValueItShouldReturn' )
    */
    public Amoss_ParametersDefiner when( String method ) {
        return when().method( method );
    }

    /**
    * States that when a method is called that matches the definition, the stated behaviour will
    * be exhibited.  Very similar to 'when'
    *
    * Call order is not checked, and 'verify' will not check that 'whens' have been met.
    *
    * 'Whens' take higher priority than 'expectations' (I.E. if a matching 'when' is defined at call time, then it
    * will match that over the next 'expect').
    *
    * Define in the format:
    *   allows()
    *     .method( 'methodName' )
    *     .withParameter( 'parameterValue' )
    *     .willReturn( 'theValueItShouldReturn' )
    */
    public Amoss_MethodDefiner allows() {

        if ( expectsNoCalls ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the double allows a call when it has been stated that it expectsNoCalls' );
        }

        if ( ! allowsAnyCallExplicitlyDefined ) {
            allowsAnyCall = false;
        }
        return when();
    }

    /**
    * States that when a method is called that matches the definition, the stated behaviour will
    * be exhibited.  Very similar to 'when'
    *
    * Call order is not checked, and 'verify' will not check that 'whens' have been met.
    *
    * 'Whens' take higher priority than 'expectations' (I.E. if a matching 'when' is defined at call time, then it
    * will match that over the next 'expect').
    *
    * Define in the format:
    *   allows( 'methodName' )
    *   .withParameter( 'parameterValue' )
    *   .willReturn( 'theValueItShouldReturn' )
    */
    public Amoss_ParametersDefiner allows( String method ) {
        return allows().method( method );
    }

    /**
    * States that whatever mechanism is used to defined the 'expectations' or 'whens' against this
    * object, it will either:
    *   * True  - Allow any call to a method to be successful and for those that are not defined to return null.
    *   * False - Fail the test
    *
    * Example usage:
    *   allowsAnyCall( false )
    *     .when( 'methodName' )
    *     .method( 'methodName' )
    *     .withParameter( 'parameterValue' )
    *     .willReturn( 'theValueItShouldReturn' )
    */
    public Amoss_Instance allowsAnyCall( Boolean allowsAnyCall ) {

        if ( expectsNoCalls ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the double allowsAnyCall when it has been stated that it expectsNoCalls' );
        }

        this.allowsAnyCallExplicitlyDefined = true;
        this.allowsAnyCall = allowsAnyCall;
        return this;
    }

    /**
    * States that when a method is called that does not have a return type defined, it will return the stated object
    *
    * Example usage:
    *   setDefaultMethodReturn( new Contact( Name='The default contact' ) )
    */
    public Amoss_Instance byDefaultMethodsReturn( Object defaultMethodReturn ) {
        this.defaultMethodReturn = defaultMethodReturn;
        return this;
    }

    /**
    * States that when a method is called that does not have a return type defined, it will return itself.
    *
    * I.E. the interface of the object being doubled implements a fluent interface
    *
    * Example usage:
    *   isFluent()
    */
    public Amoss_Instance isFluent() {
        this.isFluent = true;
        return this;
    }

    /**
    * States that whatever mechanism is used to defined the 'expectations' or 'whens' against this
    * object, it will allow any call to a method to be successful and for those that are not defined
    * to return null.
    *
    * Example usage:
    *   allowsAnyCall()
    *     .when( 'methodName' )
    *     .withParameter( 'parameterValue' )
    *     .willReturn( 'theValueItShouldReturn' )
    */
    public Amoss_Instance allowsAnyCall( ) {
        return allowsAnyCall( true );
    }

    /**
    * States that this double does not expect any calls against it, and that when a call is made, the test should fail.
    *
    * Example usage:
    *   expectsNoCalls()
    */
    public void expectsNoCalls() {

        if ( !expectations.isEmpty() || !whens.isEmpty() ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the double expectsNoCalls when expectations or whens have been defined' );
        }

        if ( allowsAnyCallExplicitlyDefined && allowsAnyCall ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the double expectsNoCalls when allowsAnyCall has been set to true' );
        }

        this.expectsNoCalls = true;
    }

    /**
    * Checks that all configured 'expectations' have been met, failing the test if they have not.
    *
    * Generally called immediately prior to the test's assertions.
    */
    public void verify() {
        assertionMechanism.assertEquals( new List<String>(), expectations.getRemainingCallsDescriptions(), String.format( expectedEmptyCallStackMessage, new List<String>{ getClassName() } ) );
    }

    /**
    * The start of a request for information on a call in the mock's call stack.
    *
    * Allows the object to be used as a Test Spy.
    *
    * Use in the following formats:
    *   get().call( 2 ).of( 'methodName' ).parameter( 1 )
    *   get().latestCallOf( 'methodName' ).parameter( 'parameterName' )
    *
    */
    public Amoss_CallChecker get() {
        return new Amoss_CallChecker( callLog );
    }

    /**
    * The start of a request for information on a call in the mock's call stack.
    *
    * Allows the object to be used as a Test Spy.
    *
    * Use in the format:
    *   call( 2 ).of( 'methodName' ).parameter( 1 )
    *   call( 2 ).of( 'methodName' ).parameter( 'parameterName' )
    *
    * @param Integer - The number of the call of the stated method.  Indexed from 0.  Can be negative, -1 returning the last call.
    */
    public Amoss_CallChecker call( Integer callNumber ) {
        return new Amoss_CallChecker( callLog ).call( callNumber );
    }

    /**
    * The start of a request for information on the last call of a given method in the mock's call stack.
    *
    * Allows the object to be used as a Test Spy.
    *
    * Use in the format:
    *   latestCallOf( 'methodName' ).parameter( 1 )
    *
    * @param String - The method to get the last call of
    */
    public Amoss_CallChecker latestCallOf( String method ) {
        return new Amoss_CallChecker( callLog ).latestCallOf( method );
    }

    /**
    * Returns the count of the number of calls that were made of the stated method.
    *
    * Allows the object to be used as a Test Spy.
    *
    * @param String - The method to get the count of calls of
    * @return Integer - The count of the number calls that were made
    */
    public Integer countOf( String method ) {
        return callLog.numberOfCalls( method );
    }

    /**
    * Defines the base content of the assertion message to use when more, or unspecified calls
    * are made against a generated Test Double.
    *
    * @param String - The message
    * @return Amoss_Instance - Itself, allowing for a fluent interface
    */
    private Amoss_Instance setMoreCallsThanExpectedMessage( String message ) {
        this.moreCallsThanExpectedMessage = message;
        return this;
    }

    /**
    * Defines the base content of the assertion message to use when more, or unspecified calls
    * are made against a generated Test Double.
    *
    * @param String - The message
    * @return Amoss_Instance - Itself, allowing for a fluent interface
    */
    private Amoss_Instance setExpectedNoCallsMessage( String message ) {
        this.expectedNoCallsMessage = message;
        return this;
    }

    /**
    * Defines the base content of the assertion message to use when verify is called and
    * the expected call stack is not empty
    *
    * @param String - The message
    * @return Amoss_Instance - Itself, allowing for a fluent interface
    */
    private Amoss_Instance setExpectedEmptyCallStackMessage( String message ) {
        this.expectedEmptyCallStackMessage = message;
        return this;
    }

    /**
    * Internal method that should not be called directly in tests.
    *
    * Is the StubProvider.handleMethodCall method that handles the resulting method calls to the mock object.
    */
    public Object handleMethodCall( Object       mockedObject,              //NOPMD - matches spec of StubProvider.handleMethodCall
                                    String       mockedMethod,
                                    Type         returnType,
                                    List<Type>   parameterTypes,
                                    List<String> parameterNames,
                                    List<Object> parameters ) {

        String callDescription = new Amoss_CallDescriber().getCallDescription( mockedMethod, parameters );

        callLog.addEntry( new Amoss_CallLogEntry().setMethod( mockedMethod ).setParameters( parameterTypes, parameterNames, parameters ) );

        if ( expectsNoCalls ) {
            assertionMechanism.assertEquals( '', callDescription, String.format( expectedNoCallsMessage, new List<String>{ getClassName() } ) );
        }

        if ( whens.hasExpectations() ) {
            Amoss_Expectation whenExpectation = whens.getMatchingExpectation( mockedMethod, parameterNames, parameters );
            if ( whenExpectation != null ) {
                // If this throws a System.TypeException exception, it is likely you have misconfigured your
                // return type in your when or allows.  See the note below for more context.
                return whenExpectation.getReturnValue( mockedObject, mockedMethod, returnType, parameterTypes, parameterNames, parameters );
            }
        }

        if ( allowsAnyCall == false && expectations.isEmpty() ) {
            assertionMechanism.assert( false, String.format( moreCallsThanExpectedMessage + ', and no matching "when" or "allows" exists.  Was: {2}', new List<String>{ getClassName(), mockedMethod, callDescription } ) );
        }

        if ( allowsAnyCall == false || expectations.matchesNext( mockedMethod, parameterNames, parameters ) ) {
            Amoss_Expectation thisExpectation = expectations.unshift();

                try {
                    thisExpectation.verify( assertionMechanism, mockedMethod, parameterNames, parameters );
                } catch ( Amoss_Instance.Amoss_AssertionFailureException assertionFailure ) {
                    assertionFailure.issueAsserton( assertionMechanism );
                }
            // If this throws a System.TypeException exception, it is likely you have misconfigured your
            // return type in your expectation.  See the note below for more context.
            return thisExpectation.getReturnValue( mockedObject, mockedMethod, returnType, parameterTypes, parameterNames, parameters );
        }

        // NOTE:
        // Would love to be able to guard against invalid returns being configured, but that would need
        // Salesforce to implement a dynamic 'instanceOf' method that uses Type, or similar to do that comparison.
        // At that point we could check "defaultMethodReturn instanceOf returnType", and similar above.
        // Until then, we're stuck with a System.TypeException that cannot be caught by the framework.  Sorry!
        if ( isFluent ) {
            return mockedObject;
        }
        return defaultMethodReturn;
    }

    /**
    * Internal method that should not be called directly in tests.
    *
    * Provides the name of the class that this mock is mimicing.
    *
    * @return - String - The name of the class
    */
    private String getClassName() {
        return String.valueOf( this.classType );
    }

    /**
    * Internal method that should not be called directly in tests.
    *
    * Set the assertion mechanism for this mock object implementation.
    * Exists to that the assertion mechanism can be mocked when unit
    * testing the framework itself.
    *
    * Is private and testVisible in the hope that auto-complete will not
    * pick the method up in normal usage.
    *
    * @param   Amoss_Asserts - The assertionMechanism
    * @return  Amoss_Instance - Itself, allowing for a fluent interface
    */
    @testVisible
    private Amoss_Instance setAsserts( Amoss_Asserts assertionMechanism ) {
        this.assertionMechanism = assertionMechanism;
        return this;
    }

    /**
    * Internal method that should not be called directly in tests.
    *
    * Get the assertion mechanism for this mock object implementation.
    *
    * @return Amoss_Asserts - The assertionMechanism
    */
    private Amoss_Asserts getAssertionMechanism() {
        return assertionMechanism;
    }

    /**
    * Internal class that provides a mechanism for checking if a call of a method
    * was made against a given call log.
    *
    * Should not be referenced directly in tests, only via the return from
    * methods on other classes.
    */
    public class Amoss_CallChecker {

        String  method;
        Integer callNumber;
        Integer parameterNumber;
        String  parameterName;

        Amoss_CallLog callLog;

        public Amoss_CallChecker( Amoss_CallLog callLog ) {
            this.callLog = callLog;
        }

        /**
        * Defines the name of the method that is being checked.
        *
        * Use in the format:
        *   call( 2 ).of( 'methodName' ).parameter( 1 )
        *
        * @param String - The method to check
        */
        public Amoss_CallChecker of( String method ) {
            this.method = method;
            return this;
        }

        /**
        * The start of a request for information on a call in the mock's call stack.
        *
        * Allows the object to be used as a Test Spy.
        *
        * Use in the format:
        *   get().call( 2 ).of( 'methodName' ).parameter( 1 )
        *   get().call( 2 ).of( 'methodName' ).parameter( 'parameterName' )
        *
        * @param Integer - The number of the call of the stated method.  Indexed from 0.  Can be negative, -1 returning the last call.
        */
        public Amoss_CallChecker call( Integer callNumber ) {
            this.callNumber = callNumber;
            return this;
        }

        /**
        * The start of a request for information on the last call of a given method in the mock's call stack.
        *
        * Allows the object to be used as a Test Spy.
        *
        * Use in the format:
        *   get().latestCallOf( 'methodName' ).parameter( 1 )
        *
        * @param String - The method to get the last call of
        */
        public Amoss_CallChecker latestCallOf( String method ) {
            this.method     = method;
            this.callNumber = -1;
            return this;
        }

        /**
        * Requests the parameter at the stated position (zero-indexed), for the
        * current method and call count context.
        *
        * Allows the object to be used as a Test Spy.
        *
        * Use in the formats:
        *   call( 1 ).of( 'methodName' ).parameter( 1 )
        *   latestCallOf( 'methodName' ).parameter( 1 )
        *
        * @param Object - The parameter that was passed in when the stated method was called
        */
        public Object parameter( Integer parameterNumber ) {
            this.parameterNumber = parameterNumber;
            this.parameterName = null;
            return callLog.getCallLogParameter( this.method, this.callNumber, this.parameterNumber );
        }

        /**
        * Requests the parameter with the stated name, for the
        * current method and call count context.
        *
        * Allows the object to be used as a Test Spy.
        *
        * Use in the formats:
        *   call( 1 ).of( 'methodName' ).parameter( 'parameterName' )
        *   latestCallOf( 'methodName' ).parameter( 'parameterName' )
        *
        * @param Object - The parameter that was passed in when the stated method was called
        */
        public Object parameter( String parameterName ) {
            this.parameterName = parameterName;
            this.parameterNumber = null;
            return callLog.getCallLogParameter( this.method, this.callNumber, this.parameterName );
        }

        /**
        * Requests a list of the parameters for the current method and call count context.
        *
        * Allows the object to be used as a Test Spy.
        *
        * Use in the formats:
        *   call( 1 ).of( 'methodName' ).parameters()
        *   latestCallOf( 'methodName' ).parameters()
        *
        * @param List<Object> - The parameters that were passed in when the stated method was called
        */
        public List<Object> parameters() {
            return callLog.getCallLogParameters( this.method, this.callNumber );
        }

        /**
        * Requests a map of the parameters for the current method and call count context, indexed by their name.
        *
        * Allows the object to be used as a Test Spy.
        *
        * Use in the formats:
        *   call( 1 ).of( 'methodName' ).parametersByName()
        *   latestCallOf( 'methodName' ).parametersByName()
        *
        * @param Map<String,Object> - The parameters that were passed in when the stated method was called
        */
        public Map<String,Object> parametersByName() {
            return callLog.getCallLogParametersByName( this.method, this.callNumber );
        }
    }

    /**
    * Internal class that provides a mechanism for representing a call to a given method
    * with a given list of parameter values and means of retrieving some or all of those
    * parameters.
    *
    * Should not be referenced directly in tests, only via the return from
    * methods on other classes.
    */
    private class Amoss_CallLogEntry {

        String       method;
        List<Object> parameterValues;
        List<String> parameterNames;
        List<Object> parameterTypes;

        Map<String,Object> parameterValuesByName;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the name of the method that this stack represents.
        *
        * @param  String - The method name.
        * @return Amoss_CallLogEntry - Itself, allowing for a fluent interface
        */
        public Amoss_CallLogEntry setMethod( String method ) {
            this.method = method;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the name of the method that this stack represents.
        *
        * @return String - The name of the method
        */
        public String getMethod() {
            return this.method;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the parameters that were passed in on this method call.
        *
        * @param  List<Object> - The types of the parameters that were passed
        * @param  List<String> - The names of the parameters that were passed
        * @param  List<Object> - The values of the parameters that were passed
        * @return Amoss_CallLogEntry - Itself, allowing for a fluent interface
        */
        public Amoss_CallLogEntry setParameters( List<Object> parameterTypes, List<String> parameterNames, List<Object> parameterValues ) {
            this.parameterNames  = parameterNames;
            this.parameterTypes  = parameterTypes;
            this.parameterValues = parameterValues;
            parameterValuesByName = new Map<String,Object>();

            for ( Integer i=0; i<parameterNames.size(); i++ ) {
                parameterValuesByName.put( parameterNames[i], parameterValues[i] );
            }
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameter at the specified position that was passed in on this method call.
        *
        * If the parameter does not exist then an exception is thrown.
        *
        * @param  Integer - The number of the parameter that should be returned
        * @return Object  - The parameter value that was passed in the stated position
        */
        public Object getParameter( Integer parameterNumber ) {
            if ( parameterValues.isEmpty()  ) {
                throw new Amoss_CallLogException( method + ' was not called with any parameters' );
            }
            if ( parameterValues.size() < parameterNumber + 1 ) {
                throw new Amoss_CallLogException( method + ' was not called with ' + ( parameterNumber + 1 ) + ' parameters' );
            }
            if ( parameterNumber < 0 ) {
                throw new Amoss_CallLogException( 'Cannot request a negative parameter number (got ' + parameterNumber + ')' );
            }
            return parameterValues[ parameterNumber ];
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameter with the specified name that was passed in on this method call.
        *
        * If the parameter does not exist then an exception is thrown.
        *
        * @param  Integer - The name of the parameter that should be returned
        * @return Object  - The parameter value that was passed with the stated name
        */
        public Object getParameter( String parameterName ) {
            if ( parameterValuesByName.isEmpty() ) {
                throw new Amoss_CallLogException( method + ' was not called with any parameters' );
            }
            if ( ! parameterValuesByName.containsKey( parameterName ) ) {
                throw new Amoss_CallLogException( method + ' was not called with parameter "' + parameterName + '"' );
            }
            return parameterValuesByName.get( parameterName );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameters for this call.
        *
        * If the parameters do not exist then an exception is thrown.
        *
        * @return List<Object> - The parameter values that were passed.
        */
        public List<Object> getParameters() {
            return parameterValues;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameters for this call, indexed by their name.
        *
        * If the parameters do not exist then an exception is thrown.
        *
        * @return Map<String,Object> - The parameter values that were passed, indexed by their name.
        */
        public Map<String,Object> getParametersByName() {
            return parameterValuesByName;
        }
    }

    /**
    * Internal class that provides a mechanism for representing a stack of calls
    * with a means of getting a reference to a particular call of a particular method.
    *
    * Should not be referenced directly in tests, only via the return from
    * methods on other classes.
    */
    private class Amoss_CallLog {

        Map<String,List<Amoss_CallLogEntry>> callLogEntries = new Map<String,List<Amoss_CallLogEntry>>();

        /**
        * Internal method that should not be called directly in tests.
        *
        * Adds the given call log entry to the call stack.
        *
        * @param Amoss_CallLogEntry - The call log entry to add.
        */
        public Amoss_CallLog addEntry( Amoss_CallLogEntry entry ) {
            if ( ! callLogEntries.containsKey( entry.getMethod() ) ) {
                callLogEntries.put( entry.getMethod(), new List<Amoss_CallLogEntry>() );
            }
            callLogEntries.get( entry.getMethod() ).add( entry );
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the call log entry for the given method, at the given position on the stack.
        *
        * If the method wasn't called, or called enough times, will throw an exception
        *
        * @param String  - The method to retrieve the call log entry for.
        * @param Integer - The number of the call of the stated method.  Indexed from 0.  Can be negative, -1 returning the last call.
        */
        public Amoss_CallLogEntry getCallLog( String method, Integer callNumber ) {

            if ( ! callLogEntries.containsKey( method ) ) {
                throw new Amoss_CallLogException( method + ' was never called' );
            }
            if ( callNumber >= callLogEntries.get( method ).size() ) {
                throw new Amoss_CallLogException( method + ' was not called ' + ( callNumber + 1 ) + ' times' );
            }
            if ( ( callLogEntries.get( method ).size() + callNumber ) < 0 ) {
                throw new Amoss_CallLogException( method + ' was not called ' + ( Math.abs( callNumber ) ) + ' times' );
            }
            if ( callNumber < 0 ) {
                callNumber = callLogEntries.get( method ).size() + callNumber;
            }

            return callLogEntries.get( method )[ callNumber ];
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the number of times the stated method appears in the call stack.
        *
        * @param  String  - The method to retrieve the call count for.
        * @return Integer - The number of times the stated method was called.
        */
        public Integer numberOfCalls( String method ) {

            if ( ! callLogEntries.containsKey( method ) ) {
                return 0;
            }

            return callLogEntries.get( method ).size();
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameter at the stated position that was passed into the stated method at the stated call number in the stack.
        *
        * @param  String  - The method to retrieve the parameters for.
        * @param  Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last call.
        * @param  Integer - The position of the parameter in the call. Indexed from 0.
        * @return Object  - The requested parameter value.
        */
        public Object getCallLogParameter( String method, Integer callNumber, Integer parameterNumber ) {
            return getCallLog( method, callNumber ).getParameter( parameterNumber );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameter at the stated position that was passed into the stated method at the stated call number in the stack.
        *
        * @param  String  - The method to retrieve the parameters for.
        * @param  Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last call.
        * @param  Integer - The position of the parameter in the call. Indexed from 0.
        * @return Object  - The requested parameter value.
        */
        public Object getCallLogParameter( String method, Integer callNumber, String parameterName ) {
            return getCallLog( method, callNumber ).getParameter( parameterName );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameters that were passed into the stated method at the stated call number in the stack.
        *
        * @param  String  - The method to retrieve the parameters for.
        * @return Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last call.
        * @return List<Object> - The requested parameter values.
        */
        public List<Object> getCallLogParameters( String method, Integer callNumber ) {
            return getCallLog( method, callNumber ).getParameters();
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameters that were passed into the stated method at the stated call number in the stack.
        *
        * @param  String  - The method to retrieve the parameters for.
        * @return Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last call.
        * @return Map<String,Object> - The requested parameter values, indexed by their name.
        */
        public Map<String,Object> getCallLogParametersByName( String method, Integer callNumber ) {
            return getCallLog( method, callNumber ).getParametersByName();
        }
    }

    /**
    * Entirely Internal class that should not be referenced at all in a test
    *
    * Describes the definition of a mock object's 'expectations' or 'whens' within a test and allows the interrogation of that definition.
    *
    */
    private class Amoss_Expectations {

        private List<Amoss_Expectation> expectations = new List<Amoss_Expectation>();

        public Amoss_Expectations() {
        }

        private Amoss_Expectations( Amoss_Expectations toClone ) {
            for ( Amoss_Expectation thisExpectation : toClone.expectations ) {
                // individual Amoss_Expectation elements should not change once created
                // This means we shouldn't need to clone them
                this.add( thisExpectation );
            }
        }

        /**
        * Creates a clone of this 'expectations' description
        *
        * @return Amoss_Expectations - The new Expectations
        */
        public Amoss_Expectations createClone() {
            return new Amoss_Expectations( this );
        }

        /**
        * Set the Amoss Instance that there Exceptions are for
        *
        * @param  Amoss_Instance - The Amoss Instance
        * @return Amoss_Expectations - Itself, allowing for a fluent interface
        */
        public Amoss_Expectations setAmossInstance( Amoss_Instance amossInstance ) {
            for ( Amoss_Expectation thisExpectation : expectations ) {
                thisExpectation.setAmossInstance( amossInstance );
            }
            return this;
        }

        /**
        * Adds an expectation to the list of expectations
        *
        * @param  Amoss_Expectation - The expectation to add
        * @return Amoss_Expectations - Itself, allowing for a fluent interface
        */
        public Amoss_Expectations add( Amoss_Expectation expectation ) {
            expectations.add( expectation );
            return this;
        }

        /**
        * Checks if the given method and parameterValues combination matches the next expection.
        *
        * Returns false if no more expections exist.
        *
        * @param  String - The name of the method to match against
        * @param  List<String> - The parameter names to match against
        * @param  List<Object> - The parameter values to match against
        * @return Boolean - States if the given method and parameterValues match the next expectation.
        */
        public Boolean matchesNext( String method, List<String> parameterNames, List<Object> parameterValues ) {
            return expectations.size() > 0 && expectations[0].matches( method, parameterNames, parameterValues );
        }

        /**
        * Removes the first expectation in the queue and then returns it.
        *
        * @return Amoss_Expectation - The first expectation from the queue.
        */
        public Amoss_Expectation unshift() {
            return expectations.remove(0);
        }

        /**
        * States if the current expectation queue is empty.
        *
        * @return Boolean - Is the current expectation queue empty?
        */
        public Boolean isEmpty() {
            return expectations.isEmpty();
        }

        /**
        * States if the current expectation queue has expectations in it.
        *
        * @return Boolean - Are there any expectations in the current queue?
        */
        public Boolean hasExpectations() {
            return !isEmpty();
        }

        /**
        * Generates and returns a description of the expectations that remain in the current queue.
        *
        * @return List<String> - A list of the descriptions of the remaining expectations.
        */
        public List<String> getRemainingCallsDescriptions() {
            List<String> remainingCallDescriptions = new List<String>();
            for ( Amoss_Expectation thisExpectation : expectations ) {
                remainingCallDescriptions.add( thisExpectation.getCallDescription() );
            }
            return remainingCallDescriptions;
        }

        /**
        * Given the name of a method, and a list of parameters, checks the queue to see if any expectations
        * match that definition.
        *
        * Returns the *first* expectation that does, or null if non do.
        *
        * @param  String - The name of the method to match against
        * @param  List<String> - The parameter names to match against
        * @param  List<Object> - The parameter values to match against
        * @return Amoss_Expectation - The matching expectation
        */
        public Amoss_Expectation getMatchingExpectation( String mockedMethod, List<String> parameterNames, List<Object> parameters ) {

            for ( Amoss_Expectation thisExpectation : expectations ) {
                if ( thisExpectation.matches( mockedMethod, parameterNames, parameters ) ) {
                    return thisExpectation;
                }
            }
            return null;
        }
    }

    /**
     * The base class for all Expectation Definers - being the classes that embody the grammar for specifying expectations
     */
    public virtual class Amoss_ExpectationDefiner {
        protected Amoss_Expectation expectation;

        public Amoss_ExpectationDefiner( Amoss_Expectation expectation ) {
            this.expectation = expectation;
        }
    }

    /**
     * The main entry point of the grammar - the specification of a method
     */
    public class Amoss_MethodDefiner extends Amoss_ExpectationDefiner {
        public Amoss_MethodDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Allows the definition of the method that this 'expectation' or 'when' is for
        *
        * For example:
        *   .expects()
        *       .method( 'methodName' )
        *       .withParameter( 'parameterValue' )
        *       .returning( 'theValueItShouldReturn' )
        *
        * @param String - The method that this expectation is for
        */
        public Amoss_ParametersDefiner method( String method ) {
            expectation.setMethod( method );
            return new Amoss_ParametersDefiner( expectation );
        }
    }

    /**
     * The linking point of the grammar - stating that another expectation is to be configured
     * Effectively ends this instance of the configuration and hands control back to the
     * Amoss_Instance, which can start a new expectation
     */
    public virtual class Amoss_NextExpectationDefiner extends Amoss_ExpectationDefiner {
        public Amoss_NextExpectationDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Allows another 'expectation' or 'when' to be defined against the Amoss_Instance
        *
        * For example:
        * .then().expects()
        *       .method( 'methodName' )
        *       .withParameter( 'parameterValue' )
        *       .returning( 'theValueItShouldReturn' )
        */
        public Amoss_Instance then() {
            return expectation.getAmossInstance();
        }

        /**
        * Allows another 'expectation' or 'when' to be defined against the Amoss_Instance.
        *
        * Is a synonym for 'then'.
        *
        * For example:
        * .also().when()
        *       .method( 'methodName' )
        *       .withParameter( 'parameterValue' )
        *       .willReturn( 'theValueItShouldReturn' )
        */
        public Amoss_Instance also() {
            return then();
        }
    }

    /**
     * The part of the grammar that allows the specification of the return behaviour.
     *
     * Allows returns or the throwing of exceptions to be specified.
     *
     * Extends Next Expectation, as a method does not have to return anything.
     */
    public virtual class Amoss_ReturnsDefiner extends Amoss_NextExpectationDefiner {
        public Amoss_ReturnsDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * States the value that should be returned when this 'expectation' or 'when' is met.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .returns( 'theValueItShouldReturn' )
        *
        * Has 'returning' and 'willReturn' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Object - The value to return when this expectation is met.
        */
        public Amoss_NextExpectationDefiner returns( Object returnValue ) {
            expectation.setExpectionReturns( new Amoss_ExpectationValueReturn().setReturnValue( returnValue ) );
            return new Amoss_NextExpectationDefiner( expectation );
        }

        /**
        * States the value that should be returned when this 'expectation' or 'when' is met.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Has 'returning' and 'returns' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Object - The value to return when this expectation is met.
        */
        public Amoss_NextExpectationDefiner willReturn( Object returnValue ) {
            return this.returns( returnValue );
        }

        /**
        * States the value that should be returned when this 'expectation' or 'when' is met.
        *
        * For example, to specify:
        *   .expects()
        *       .method( 'methodName' )
        *       .returning( 'theValueItShouldReturn' )
        *
        * Has 'returns' and 'willReturn' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Object - The value to return when this expectation is met.
        */
        public Amoss_NextExpectationDefiner returning( Object returnValue ) {
            return this.returns( returnValue );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the method show throw the given exception.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .throws( new DmlException( 'The exception' ) )
        *
        * Has 'throwing' and 'willThrow' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Exception - The Exception to throw when this expectation is met.
        */
        public Amoss_NextExpectationDefiner throws( Exception exceptionToThrow ) {
            expectation.setExpectionReturns( new Amoss_ExpectationExceptionThrower().setExceptionToThrow( exceptionToThrow ) );
            return new Amoss_NextExpectationDefiner( expectation );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the method show throw the given exception.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .willThrow( new DmlException( 'The exception' ) )
        *
        * Has 'throwing' and 'throws' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Exception - The Exception to throw when this expectation is met.
        */
        public Amoss_NextExpectationDefiner willThrow( Exception exceptionToThrow ) {
            return this.throws( exceptionToThrow );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the method show throw the given exception.
        *
        * For example, to specify:
        *   .expects()
        *       .method( 'methodName' )
        *       .throwing( new DmlException( 'The exception' ) )
        *
        * Has 'throws'and 'willThrow' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Exception - The Exception to throw when this expectation is met.
        */
        public Amoss_NextExpectationDefiner throwing( Exception exceptionToThrow ) {
            return this.throws( exceptionToThrow );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the method will be handled by the provided StubProvider
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .handleBy( new StubProviderImplementation() )
        *
        * @param StubProvider - The handler to use when returning from the doubled method
        */
        public Amoss_NextExpectationDefiner handledBy( StubProvider returnHandler ) {
            expectation.setExpectionReturns( new Amoss_ExpectationStubProviderHandledReturn().setReturnHandler( returnHandler ) );
            return new Amoss_NextExpectationDefiner( expectation );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the method will be handled by the provided Amoss_MethodHandler
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .handleBy( new Amoss_MethodHandlerImplementation() )
        *
        * @param Amoss_MethodHandler - The handler to use when returning from the doubled method
        */
        public Amoss_NextExpectationDefiner handledBy( Amoss_MethodHandler returnHandler ) {
            expectation.setExpectionReturns( new Amoss_ExpectationAmossHandlerHandledReturn().setReturnHandler( returnHandler ) );
            return new Amoss_NextExpectationDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the specification of parameters based on their
     * position.  I.E. expected parameters are defined in order.
     */
    public virtual class Amoss_PositionalParametersDefiner extends Amoss_ReturnsDefiner {

        public Amoss_PositionalParametersDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Adds a parameter value to the list of parameters that are valid for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter( 'Parameter1' )
        *       .thenParameter( 4 )
        *       .thenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The parameter value to add to the list of expected ones
        */
        public Amoss_PositionalParametersDefiner thenParameter( Object parameterValue ) {
            return thenParameter().setTo( parameterValue );
        }

        /**
        * Adds a parameter value to the list of parameters that are valid for this 'expection' or 'when', leading
        * to the ability to specify its shape in ways other than its precise value.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().setTo( 'Parameter1' )
        *       .thenParameter().setTo( 4 )
        *       .thenParameter().setTo( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        */
        public Amoss_PositionalParameterValueDefiner thenParameter() {
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters())
                .moveToNextParameter();
            return new Amoss_PositionalParameterValueDefiner( expectation );
        }

        /**
        * Adds a parameter value to the list of parameters that are valid for this 'expection' or 'when', it being allowed to have any value.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter( 'Parameter1' )
        *       .thenAnyParameter()
        *       .thenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        */
        public Amoss_PositionalParametersDefiner thenAnyParameter() {
            return thenParameter().setTo( Amoss_Instance.Value.ANY_VALUE );
        }
    }

    /**
     * The part of the grammar that allows the specification of the value of a positional parameter.
     *
     * At this point in the syntax, the only valid thing to do is define the parameter value.
     */
    public class Amoss_PositionalParameterValueDefiner extends Amoss_ExpectationDefiner {

        public Amoss_PositionalParameterValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter must:
        *   * Be the same instance as that specified.
        *   * Implement the method 'equals', and return true when called with the specified parameter.
        *
        * For primitives, it is sufficient that they are the same value.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().setTo( 'Parameter1' )
        *       .andParameter().withAnyElement().setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be set to
        */
        public Amoss_PositionalParametersDefiner setTo( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildEqualsVerifier( parameterValue ) );
        }

        /**
        * States that a parameter is expected to be set to a not null value.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().set()
        *       .andParameter().withAnyElement().set()
        *       .willReturn( 'theValueItShouldReturn' )
        */
        public Amoss_PositionalParametersDefiner set() {
            return setTo( Amoss_Instance.Value.NOT_NULL );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter only needs to equate when serialised as a JSON string.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().setToTheSameValueAs( 'Parameter1' )
        *       .andParameter().withAnyElement().setToTheSameValueAs( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be evaluated against
        */
        public Amoss_PositionalParametersDefiner setToTheSameValueAs( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildSameValueAsVerifier( parameterValue ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter needs to be a String that contains the specified value
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().containing( 'a string' )
        *       .andParameter().withAnyElement().containing( 'a string' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The String to search for in the parameter
        */
        public Amoss_PositionalParametersDefiner containing( String searchString ) {
            return setParameterVerifier( valueVerifierBuilder.buildContainingStringVerifier( searchString ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter needs to be a String that matches the specified regular expression
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().matching( 'a*b' )
        *       .andParameter().withAnyElement().matching( 'a*b' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The Regular Expression to match against the parameter
        */
        public Amoss_PositionalParametersDefiner matching( String searchString ) {
            try {
                return setParameterVerifier( valueVerifierBuilder.buildMatchingExpressionVerifier( searchString ) );
            } catch ( Amoss_Instance.Amoss_AssertionFailureException assertionFailure ) {
                assertionFailure.issueAsserton( expectation.getAssertionMechanism() );
            }
            return null;
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter needs to be a List of the specified length
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().aListOfLength( 3 )
        *       .andParameter().withAnyElement().aListOfLength( 4 )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The expected length
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner aListOfLength( Integer expectedLength ) {
            setParameterVerifier( valueVerifierBuilder.buildListOfLengthVerifier( expectedLength ) );
            return new Amoss_PositionalParameterAdditionalCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of the SObject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated on the
        * specified sobject set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withFieldsSetLike( contact )
        *       .andParameter().withAnyElement().withFieldsSetLike( account )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Sobject - The SObject that the parameter should be checked against
        */
        public Amoss_PositionalParametersDefiner withFieldsSetLike( Sobject parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetLikeVerifier( parameterValue ) );
        }

        /**
        * States the shape of the sobject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated in the
        * specified map set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withFieldsSetTo( contactFieldsMap )
        *       .andParameter().withAnyElement().withFieldsSetTo( accountFieldsMap )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Map<String,Object> - The Map of values that the parameter should be checked against
        */
        public Amoss_PositionalParametersDefiner withFieldsSetTo( Map<String,Object> parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetToVerifier( parameterValue ) );
        }

        /**
        * States the verifier that should be used to check the currently specified parameter.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().verifiedBy( customVerifier )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Amoss_ValueVerifier - The verifier that should be used to check the parameter
        */
        public Amoss_PositionalParametersDefiner verifiedBy( Amoss_ValueVerifier verifier ) {
            return setParameterVerifier( verifier );
        }

        /**
        * States the shape of a List parameter value that is expected for the next parameter.
        *
        * In order to match, the ultimately passed parameter be a list where EVERY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withAllElements().withFieldsSetTo( contactFieldsMap )
        *       .withParameter().withAllElements().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        */
        public Amoss_PositionalAllElementsInCollectionValueDefiner withAllElements() {
            return new Amoss_PositionalAllElementsInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the next parameter.
        *
        * In order to match, the ultimately passed parameter be a list where ANY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withAnyElement().withFieldsSetTo( contactFieldsMap )
        *       .withParameter().withAnyElement().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        */
        public Amoss_PositionalAnyElementInCollectionValueDefiner withAnyElement() {
            return new Amoss_PositionalAnyElementInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the next parameter.
        *
        * In order to match, the ultimately passed parameter be a list where the specified element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withElementAt( 1 ).withFieldsSetTo( contactFieldsMap )
        *       .withParameter().withElementAt( 2 ).setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The position in the list to add the specification against
        */
        public Amoss_PositionalElementAtPositionInCollectionValueDefiner withElementAt( Integer elementPosition ) {
            return new Amoss_PositionalElementAtPositionInCollectionValueDefiner( expectation, elementPosition );
        }

        /**
        * Internal method that sets the next parameter's verifier on the expectation to that specified
        * and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The verifier to set on the expectation
        * @return Amoss_PositionalParametersDefiner - The next definer
        */
        private Amoss_PositionalParametersDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter( verifier );
            return new Amoss_PositionalParametersDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the specification of the value of a positional parameter once it is
     * defined as being a list.
     *
     * At this point in the syntax, the only valid thing to do is define the parameter value via verifiers.
     *
     * Defines the core of the behaviour - can be applied in different ways by overriding 'setParameterVerifier'
     */
    public abstract class Amoss_AbstractPositionalCollectionParameterValueDefiner extends Amoss_ExpectationDefiner {

        public Amoss_AbstractPositionalCollectionParameterValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Internal method that sets the next parameter on the expectation to that specified
        * and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The parameter to set on the expectation
        * @return Amoss_PositionalParameterAdditionalCollectionValueDefiner - The next definer
        */
        protected abstract Amoss_PositionalParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier verifier );

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter must:
        *   * Be the same instance as that specified.
        *   * Implement the method 'equals', and return true when called with the specified parameter.
        *
        * For primitives, it is sufficient that they are the same value.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().setTo( 'Parameter1' )
        *       .andParameter().withAnyElement().setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be set to
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner setTo( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildEqualsVerifier( parameterValue ) );
        }

        /**
        * States that a parameter is expected to be set to a not null value.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().set()
        *       .andParameter().withAnyElement().set()
        *       .willReturn( 'theValueItShouldReturn' )
        */
        public Amoss_PositionalParametersDefiner set() {
            return setTo( Amoss_Instance.Value.NOT_NULL );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter only needs to equate when serialised as a JSON string.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().setToTheSameValueAs( 'Parameter1' )
        *       .andParameter().withAnyElement().setToTheSameValueAs( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be evaluated against
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner setToTheSameValueAs( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildSameValueAsVerifier( parameterValue ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter needs to be a String that contains the specified value
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().containing( 'a string' )
        *       .andParameter().withAnyElement().containing( 'a string' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The String to search for in the parameter
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner containing( String searchString ) {
            return setParameterVerifier( valueVerifierBuilder.buildContainingStringVerifier( searchString ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter needs to be a String that matches the specified regular expression
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().matching( 'a*b' )
        *       .andParameter().withAnyElement().matching( 'a*b' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The Regular Expression to match against the parameter
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner matching( String regularExpression ) {
            return setParameterVerifier( valueVerifierBuilder.buildMatchingExpressionVerifier( regularExpression ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter needs to be a List of the specified length
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().aListOfLength( 3 )
        *       .andParameter().withAnyElement().aListOfLength( 4 )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The expected length
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner aListOfLength( Integer expectedLength ) {
            return setParameterVerifier( valueVerifierBuilder.buildListOfLengthVerifier( expectedLength ) );
        }

        /**
        * States the shape of the SObject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated on the
        * specified sobject set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withFieldsSetLike( contact )
        *       .andParameter().withAnyElement().withFieldsSetLike( account )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Sobject - The SObject that the parameter should be checked against
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner withFieldsSetLike( Sobject parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetLikeVerifier( parameterValue ) );
        }

        /**
        * States the shape of the sobject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated in the
        * specified map set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withFieldsSetTo( contactFieldsMap )
        *       .andParameter().withAnyElement().withFieldsSetTo( accountFieldsMap )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Map<String,Object> - The Map of values that the parameter should be checked against
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner withFieldsSetTo( Map<String,Object> parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetToVerifier( parameterValue ) );
        }

        /**
        * States the verifier that should be used to check the currently specified parameter.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().verifiedBy( customVerifier )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Amoss_ValueVerifier - The verifier that should be used to check the parameter
        */
        public Amoss_PositionalParameterAdditionalCollectionValueDefiner verifiedBy( Amoss_ValueVerifier verifier ) {
            return setParameterVerifier( verifier );
        }
    }

    /**
     * The part of the grammar that allows the specification of positional collection parameters
     * based on *every* element in the list matching the specified verifier
     */
    public class Amoss_PositionalAllElementsInCollectionValueDefiner extends Amoss_AbstractPositionalCollectionParameterValueDefiner {

        public Amoss_PositionalAllElementsInCollectionValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Internal method that sets the next parameter on the expectation to be checked that every element matches the specified
        * verifier and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The verifier to set on the expectation
        * @return Amoss_PositionalParameterAdditionalCollectionValueDefiner - The next definer
        */
        protected override Amoss_PositionalParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter(
                valueVerifierBuilder.buildAllElementsVerifier( verifier )
             );
            return new Amoss_PositionalParameterAdditionalCollectionValueDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the specification of positional collection parameters
     * based on any element in the list matching the specified verifier
     */
    public class Amoss_PositionalAnyElementInCollectionValueDefiner extends Amoss_AbstractPositionalCollectionParameterValueDefiner {

        public Amoss_PositionalAnyElementInCollectionValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Internal method that sets the next parameter on the expectation to be checked that any element matches the specified
        * verifier and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The verifier to set on the expectation
        * @return Amoss_PositionalParameterAdditionalCollectionValueDefiner - The next definer
        */

        protected override Amoss_PositionalParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter(
                valueVerifierBuilder.buildAnyElementVerifier( verifier )
             );
            return new Amoss_PositionalParameterAdditionalCollectionValueDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the specification of positional collection parameters
     * based on a given element in the list matching the specified verifier
     */
    public class Amoss_PositionalElementAtPositionInCollectionValueDefiner extends Amoss_AbstractPositionalCollectionParameterValueDefiner {

        Integer elementPosition;

        public Amoss_PositionalElementAtPositionInCollectionValueDefiner( Amoss_Expectation expectation, Integer elementPosition ) {
            super( expectation );
            this.elementPosition = elementPosition;
        }

        /**
        * Internal method that sets the next parameter on the expectation to be checked that any element matches the specified
        * verifier and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The verifier to set on the expectation
        * @return Amoss_PositionalParameterAdditionalCollectionValueDefiner - The next definer
        */

        protected override Amoss_PositionalParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter(
                valueVerifierBuilder.buildElementAtVerifier( verifier, elementPosition )
             );
            return new Amoss_PositionalParameterAdditionalCollectionValueDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the additional specification of the shape of a value of a named parameter once
     * the parameter is defined as being a list.
     *
     * The name must have already been specified.
     *
     */
    public class Amoss_PositionalParameterAdditionalCollectionValueDefiner extends Amoss_PositionalParametersDefiner {

        public Amoss_PositionalParameterAdditionalCollectionValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the next parameter.
        *
        * In order to match, the ultimately passed parameter be a list where EVERY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withAllElements().withFieldsSetTo( contactFieldsMap )
        *       .withParameter().withAllElements().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_PositionalAllElementsInCollectionValueDefiner withAllElements() {
            return new Amoss_PositionalAllElementsInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the next parameter.
        *
        * In order to match, the ultimately passed parameter be a list where ANY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withAnyElement().withFieldsSetTo( contactFieldsMap )
        *       .withParameter().withAnyElement().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_PositionalAnyElementInCollectionValueDefiner withAnyElement() {
            return new Amoss_PositionalAnyElementInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the next parameter.
        *
        * In order to match, the ultimately passed parameter be a list where the specified element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().withElementAt( 1 ).withFieldsSetTo( contactFieldsMap )
        *       .withParameter().withElementAt( 2 ).setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The position in the list to add the specification against
        */
        public Amoss_PositionalElementAtPositionInCollectionValueDefiner withElementAt( Integer elementPosition ) {
            return new Amoss_PositionalElementAtPositionInCollectionValueDefiner( expectation, elementPosition );
        }
    }

    /**
     * The part of the grammar that allows the specification of parameters based on their
     * names.  I.E. expected parameters are defined in a name and value pairing.
     */
    public virtual class Amoss_NamedParametersDefiner extends Amoss_ReturnsDefiner implements Amoss_NamedParametersMethodDefiner {
        public Amoss_NamedParametersDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Adds the stated parameter to the list of parameters that are valid for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setTo( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Has 'withParameterNamed' as a synonym, and these methods are entirely interchangeable based on preference.
        *
        * @param Object - The name of the parameter to add to the specification
        */
        public Amoss_NamedParameterValueDefiner andParameterNamed( String parameterName ) {
            ((Amoss_ExpectationNamedParameters)expectation.getExpectationParameters()).moveToParameter( parameterName );
            return new Amoss_NamedParameterValueDefiner( expectation );
        }

        public Amoss_NamedParameterValueDefiner withParameterNamed( String parameterName ) {
            return andParameterNamed( parameterName );
        }
    }

    /**
     * The part of the grammar that allows the specification of the shape of a value of a named parameter.
     * The name must have already been specified.
     *
     * At this point in the syntax, the only valid thing to do is define the parameter value.
     */
    public class Amoss_NamedParameterValueDefiner extends Amoss_ExpectationDefiner {

        public Amoss_NamedParameterValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter must:
        *   * Be the same instance as that specified.
        *   * Implement the method 'equals', and return true when called with the specified parameter.
        *
        * For primitives, it is sufficient that they are the same value.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setTo( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be set to
        */
        public Amoss_NamedParametersDefiner setTo( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildEqualsVerifier( parameterValue ) );
        }

        /**
        * States that a parameter is expected to be set to a not null value.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().set()
        *       .andParameter().withAnyElement().set()
        *       .willReturn( 'theValueItShouldReturn' )
        */
        public Amoss_NamedParametersDefiner set() {
            return setTo( Amoss_Instance.Value.NOT_NULL );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter only needs to equate when serialised as a JSON string.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setToTheSameValueAs( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().setToTheSameValueAs( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be evaluated against
        */
        public Amoss_NamedParametersDefiner setToTheSameValueAs( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildSameValueAsVerifier( parameterValue ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter needs to be a String that contains the specified value
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).containing( 'a string' )
        *       .withParameterNamed( 'parmeterName2' ).withAnyElement().containing( 'a string' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The String to search for in the parameter
        */
        public Amoss_NamedParametersDefiner containing( String searchString ) {
            return setParameterVerifier( valueVerifierBuilder.buildContainingStringVerifier( searchString ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter needs to be a String that matches the specified regular expression
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).matching( 'a*b' )
        *       .withParameterNamed( 'parmeterName2' ).withAnyElement().matching( 'a*b' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The Regular Expression to match against the parameter
        */
        public Amoss_NamedParametersDefiner matching( String regularExpression ) {
            return setParameterVerifier( valueVerifierBuilder.buildMatchingExpressionVerifier( regularExpression ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter needs to be a List of the specified length
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).aListOfLength( 3 )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().aListOfLength( 4 )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The expected length
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner aListOfLength( Integer expectedLength ) {
            setParameterVerifier( valueVerifierBuilder.buildListOfLengthVerifier( expectedLength ) );
            return new Amoss_NamedParameterAdditionalCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of the SObject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated on the
        * specified sobject set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withFieldsSetLike( contact )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().withFieldsSetLike( account )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Sobject - The SObject that the parameter should be checked against
        */
        public Amoss_NamedParametersDefiner withFieldsSetLike( Sobject parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetLikeVerifier( parameterValue ) );
        }

        /**
        * States the shape of the SObject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated in the
        * specified map set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().withFieldsSetTo( accountFieldsMap )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Map<String,Object> - The Map of values that the parameter should be checked against
        */
        public Amoss_NamedParametersDefiner withFieldsSetTo( Map<String,Object> parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetToVerifier( parameterValue ) );
        }

        /**
        * States the verifier that should be used to check the currently specified parameter.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parameterName1' ).verifiedBy( customVerifier )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Amoss_ValueVerifier - The verifier that should be used to check the parameter
        */
        public Amoss_NamedParametersDefiner verifiedBy( Amoss_ValueVerifier verifier ) {
            return setParameterVerifier( verifier );
        }

        /**
        * States the shape of a List parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter be a list where EVERY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withAllElements().withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withAllElements().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        */
        public Amoss_NamedAllElementsInCollectionValueDefiner withAllElements() {
            return new Amoss_NamedAllElementsInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter be a list where ANY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withAnyElement().withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        */
        public Amoss_NamedAnyElementInCollectionValueDefiner withAnyElement() {
            return new Amoss_NamedAnyElementInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter be a list where the element at the specified position matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withElementAt( 2 ).withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withElementAt( 2 ).setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The position in the list to add the specification against
        */
        public Amoss_NamedElementAtPositionInCollectionValueDefiner withElementAt( Integer elementPosition ) {
            return new Amoss_NamedElementAtPositionInCollectionValueDefiner( expectation, elementPosition );
        }

        /**
        * Internal method that sets the next parameter on the expectation to the specified verifier
        * and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The parameter to set on the expectation
        * @return Amoss_NamedParametersDefiner - The next definer
        */
        private Amoss_NamedParametersDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationNamedParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter( verifier );
            return new Amoss_NamedParametersDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the specification of the shape of a value of a named parameter that
     * has been defined as a list.
     *
     * The name must have already been specified.
     *
     * At this point in the syntax, the only valid thing to do is define the parameter value.
     *
     * Defines the core of the behaviour - can be applied in different ways by overriding 'setParameterVerifier'
     */
    public abstract class Amoss_AbstractNamedParameterCollectionValueDefiner extends Amoss_ExpectationDefiner {

        public Amoss_AbstractNamedParameterCollectionValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Internal method that sets the parameter on the expectation to be expected to match the specified
        * verifier and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The parameter to set on the expectation
        * @return Amoss_NamedParameterAdditionalCollectionValueDefiner - The next definer
        */
        protected abstract Amoss_NamedParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier parameter );

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter must:
        *   * Be the same instance as that specified.
        *   * Implement the method 'equals', and return true when called with the specified parameter.
        *
        * For primitives, it is sufficient that they are the same value.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setTo( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be set to
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner setTo( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildEqualsVerifier( parameterValue ) );
        }

        /**
        * States that a parameter is expected to be set to a not null value.
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).set()
        *       .andParameterNamed( 'parmeterName1' ).withAnyElement().set()
        *       .willReturn( 'theValueItShouldReturn' )
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner set() {
            return setTo( Amoss_Instance.Value.NOT_NULL );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter only needs to equate when serialised as a JSON string.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setToTheSameValueAs( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().setToTheSameValueAs( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value that the parameter should be evaluated against
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner setToTheSameValueAs( Object parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildSameValueAsVerifier( parameterValue ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter needs to be a String that contains the specified value
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).containing( 'a string' )
        *       .withParameterNamed( 'parmeterName2' ).withAnyElement().containing( 'a string' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The String to search for in the parameter
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner containing( String searchString ) {
            return setParameterVerifier( valueVerifierBuilder.buildContainingStringVerifier( searchString ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match an object, the passed parameter needs to be a String that matches the specified regular expression
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).matching( 'a*b' )
        *       .withParameterNamed( 'parmeterName2' ).withAnyElement().matching( 'a*b' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param String - The String to search for in the parameter
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner matching( String regularExpression ) {
            return setParameterVerifier( valueVerifierBuilder.buildMatchingExpressionVerifier( regularExpression ) );
        }

        /**
        * States the parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the passed parameter needs to be a List of the specified length
        *
        * Is used in combination with 'withParameter'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().aListOfLength( 3 )
        *       .andParameter().withAnyElement().aListOfLength( 4 )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The expected length
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner aListOfLength( Integer expectedLength ) {
            return setParameterVerifier( valueVerifierBuilder.buildListOfLengthVerifier( expectedLength ) );
        }

        /**
        * States the shape of the SObject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated on the
        * specified sobject set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withFieldsSetLike( contact )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().withFieldsSetLike( account )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Sobject - The SObject that the parameter should be checked against
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner withFieldsSetLike( Sobject parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetLikeVerifier( parameterValue ) );
        }

        /**
        * States the shape of the SObject parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter must have the properties that are populated in the
        * specified map set to the same value.
        *
        * The ultimate parameter may have more properties set.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().withFieldsSetTo( accountFieldsMap )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Map<String,Object> - The Map of values that the parameter should be checked against
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner withFieldsSetTo( Map<String,Object> parameterValue ) {
            return setParameterVerifier( valueVerifierBuilder.buildFieldsSetToVerifier( parameterValue ) );
        }

        /**
        * States the verifier that should be used to check the currently specified parameter.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parameterName1' ).verifiedBy( customVerifier )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Amoss_ValueVerifier - The verifier that should be used to check the parameter
        */
        public Amoss_NamedParameterAdditionalCollectionValueDefiner verifiedBy( Amoss_ValueVerifier verifier ) {
            return setParameterVerifier( verifier );
        }
    }

    /**
     * The part of the grammar that allows the specification of named collection parameters
     * based on *every* element in the list matching the specified verifier
     */
    public class Amoss_NamedAllElementsInCollectionValueDefiner extends Amoss_AbstractNamedParameterCollectionValueDefiner {

        public Amoss_NamedAllElementsInCollectionValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Internal method that sets the current parameter on the expectation to be checked that every element matches the
        * specified verifier and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The verifier to set on the expectation
        * @return Amoss_NamedParameterAdditionalCollectionValueDefiner - The next definer
        */
        protected override Amoss_NamedParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationNamedParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter(
                valueVerifierBuilder.buildAllElementsVerifier( verifier )
            );
            return new Amoss_NamedParameterAdditionalCollectionValueDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the specification of named collection parameters
     * based on *any* element in the list matching the specified verifier
     */
    public class Amoss_NamedAnyElementInCollectionValueDefiner extends Amoss_AbstractNamedParameterCollectionValueDefiner {

        public Amoss_NamedAnyElementInCollectionValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Internal method that sets the current parameter on the expectation to be checked if any element matches the verifier
        * specified and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The verifier to set on the expectation
        * @return Amoss_NamedParameterAdditionalCollectionValueDefiner - The next definer
        */
        protected override Amoss_NamedParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationNamedParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter(
                valueVerifierBuilder.buildAnyElementVerifier( verifier )
            );
            return new Amoss_NamedParameterAdditionalCollectionValueDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the specification of named collection parameters
     * based on the element at the specified position in the list matching the specified verifier
     */
    public class Amoss_NamedElementAtPositionInCollectionValueDefiner extends Amoss_AbstractNamedParameterCollectionValueDefiner {

        Integer elementPosition;

        public Amoss_NamedElementAtPositionInCollectionValueDefiner( Amoss_Expectation expectation, Integer elementPosition ) {
            super( expectation );
            this.elementPosition = elementPosition;
        }

        /**
        * Internal method that sets the current parameter on the expectation to be checked if any element matches the verifier
        * specified and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ValueVerifier - The verifier to set on the expectation
        * @return Amoss_NamedParameterAdditionalCollectionValueDefiner - The next definer
        */
        protected override Amoss_NamedParameterAdditionalCollectionValueDefiner setParameterVerifier( Amoss_ValueVerifier verifier ) {
            ((Amoss_ExpectationNamedParameters)expectation.getExpectationParameters()).addVerifierToCurrentParameter(
                valueVerifierBuilder.buildElementAtVerifier( verifier, elementPosition )
            );
            return new Amoss_NamedParameterAdditionalCollectionValueDefiner( expectation );
        }
    }

    /**
     * The part of the grammar that allows the additional specification of the shape of a value of a named parameter once
     * the parameter is defined as being a list.
     *
     * The name must have already been specified.
     *
     */
    public class Amoss_NamedParameterAdditionalCollectionValueDefiner extends Amoss_NamedParametersDefiner {

        public Amoss_NamedParameterAdditionalCollectionValueDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter be a list where EVERY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withAllElements().withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withAllElements().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_NamedAllElementsInCollectionValueDefiner withAllElements() {
            return new Amoss_NamedAllElementsInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter be a list where ANY element matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withAnyElement().withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withAnyElement().setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_NamedAnyElementInCollectionValueDefiner withAnyElement() {
            return new Amoss_NamedAnyElementInCollectionValueDefiner( expectation );
        }

        /**
        * States the shape of a List parameter value that is expected for the currently specified parameter.
        *
        * In order to match, the ultimately passed parameter be a list where the element at the specified position matches the next specification.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).withElementAt( 2 ).withFieldsSetTo( contactFieldsMap )
        *       .andParameterNamed( 'parmeterName2' ).withElementAt( 2 ).setTo( true )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Integer - The position in the list to add the specification against
        */
        public Amoss_NamedElementAtPositionInCollectionValueDefiner withElementAt( Integer elementPosition ) {
            return new Amoss_NamedElementAtPositionInCollectionValueDefiner( expectation, elementPosition );
        }
    }

    public interface Amoss_Thenable {
        Amoss_Instance then();
    }

    public interface Amoss_NamedParametersMethodDefiner extends Amoss_Thenable {
        Amoss_NamedParameterValueDefiner withParameterNamed( String parameterName );
        Amoss_NextExpectationDefiner returns( Object returnValue );
        Amoss_NextExpectationDefiner handledBy( StubProvider returnHandler );
        Amoss_NextExpectationDefiner handledBy( Amoss_MethodHandler returnHandler );
        Amoss_NextExpectationDefiner throws( Exception exceptionToThrow );
    }

    /**
     * The part of the grammar that allows the first specification of a parameter.
     *
     * The choice of parameter specification method at this point defines the syntax that will
     * be used for the remainder of the specification - Any, Positional or Named.
     */
    public class Amoss_ParametersDefiner extends Amoss_ReturnsDefiner implements Amoss_NamedParametersMethodDefiner {
        public Amoss_ParametersDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * States that this 'expection' or 'when' is valid for any combination of parameters.
        *
        * Is optional, as omitting parameter definitions will result in any parameter being valid.
        *
        * Generally used for stubbing methods that are not the primary focus of a given test.
        *
        * For example:
        *   .when()
        *       .method( 'methodName' )
        *       .withAnyParameters()
        *       .willReturn( 'theValueItShouldReturn' )
        *
        */
        public Amoss_ReturnsDefiner withAnyParameters() {
            expectation.setExpectationParameters( new Amoss_ExpectationAnyParameters() );
            return new Amoss_ReturnsDefiner( expectation );
        }

        /**
        * States that this 'expection' or 'when' is valid for this given list of parameters.
        *
        * For example:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameters( Object[]{ 'Parameter1' 4, false })
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object[] - The list of parameter values that are expected
        */
        public Amoss_ReturnsDefiner withParameters( Object[] parameterValues ) {

            Amoss_PositionalParametersDefiner parameterDefiner;
            // Yep, the difference between the first call (withParameter) and later ones (thenParameter) came back to bite me
            for ( Object thisParameterValue : parameterValues ) {
                if ( parameterDefiner == null ) {
                    parameterDefiner = withParameter().setTo( thisParameterValue );
                } else {
                    parameterDefiner = parameterDefiner.thenParameter().setTo( thisParameterValue );
                }
            }
            return new Amoss_ReturnsDefiner( expectation );
        }

        /**
        * States that this 'expection' or 'when' is valid for this given map of parameters, indexed by the parameter name.
        *
        * For example:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameters( new Map<String,Object>{
        *                        'parameterName1' => 'The Parameter Value',
        *                        'parameterName2' => 15,
        *                       })
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Map<String,Object> - The map of parameter values that are expected
        */
        public Amoss_ReturnsDefiner withParameters( Map<String,Object> parameters ) {

            Amoss_NamedParametersDefiner parameterDefiner;

            for ( String thisParameterName : parameters.keySet() ) {

                // TODO: is there a way of removing the if from here.  Feels uncomfortable
                if ( parameterDefiner == null ) {
                    parameterDefiner = withParameterNamed( thisParameterName ).setTo( parameters.get( thisParameterName ) );
                } else {
                    parameterDefiner = parameterDefiner.withParameterNamed( thisParameterName ).setTo( parameters.get( thisParameterName ) );
                }
            }
            return new Amoss_ReturnsDefiner( expectation );
        }

        /**
        * Sets the expected value of the first parameter in the list of parameters that are valid for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter( 'Parameter1' )
        *       .thenParameter( 4 )
        *       .thenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Once called, allows 'thenParameter' and similar to be called (positional syntax), to add further parameters
        *
        * @param Object - The parameter value to add to the list of expected ones
        */
        public Amoss_PositionalParametersDefiner withParameter( Object parameterValue ) {
            return withParameter().setTo( parameterValue );
        }

        /**
        * Sets the expected value of the first parameter in the list of parameters that are valid for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().setTo( 'Parameter1' )
        *       .thenParameter().setTo( 4 )
        *       .thenParameter().setTo( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Once called, allows 'thenParameter' and similar to be called (positional syntax), to add further parameters
        *
        * @param Object - The parameter value to add to the list of expected ones
        */
        public Amoss_PositionalParameterValueDefiner withParameter() {

            Amoss_ExpectationPositionalParameters expectedParameters = new Amoss_ExpectationPositionalParameters().moveToNextParameter();
            expectation.setExpectationParameters( expectedParameters );
            return new Amoss_PositionalParameterValueDefiner( expectation );
        }

        /**
        * Sets the expected value of the first parameter in the list of parameters to be 'any value' for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withAnyParameter()
        *       .thenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Once called, allows 'thenParameter' and similar to be called (positional parameter syntax), to add further parameters.
        *
        */
        public Amoss_PositionalParametersDefiner withAnyParameter() {
            return withParameter().setTo( Amoss_Instance.Value.ANY_VALUE );
        }

        /**
        * Sets the name of an expected parameter, to be followed by 'setTo' in order to specify the value.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setTo( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Once used, defines the parameter specifications as using 'named parameter' syntax, and 'andParameterNamed' can be called to add further parameters.
        *
        * @param String - The name of the parameter to add to the specification
        */
        public Amoss_NamedParameterValueDefiner withParameterNamed( String parameterName ) {
            Amoss_ExpectationNamedParameters expectedParameters = new Amoss_ExpectationNamedParameters().moveToParameter( parameterName );
            expectation.setExpectationParameters( expectedParameters );

            return new Amoss_NamedParameterValueDefiner( expectation );
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the definition and behaviour of an 'expectation' or 'when' that is defined within a test.
    *
    * Is configured using 'Expectation Definers'
    *
    */
    public class Amoss_Expectation {

        private String expectedMethod;

        private Amoss_ExpectationParameters      expectedParameters = new Amoss_ExpectationAnyParameters();
        private Amoss_ExpectationReturnMechanism returnMechanism    = new Amoss_ExpectationValueReturn();

        private Amoss_Instance amossInstance;

        private String className {
            get {
                return amossInstance.getClassName();
            }
        }

        public Amoss_Expectation( Amoss_Instance amossInstance ) {
            this.amossInstance = amossInstance;
        }

        private Amoss_Expectation( Amoss_Expectation expectation ) {
            this.expectedMethod     = expectation.expectedMethod;
            this.expectedParameters = expectation.expectedParameters;
            this.returnMechanism    = expectation.returnMechanism;
        }

        /**
        * Creates a clone of this instance.
        *
        * @return Amoss_Expectation - The new instance of the exectation
        */
        public Amoss_Expectation createClone( Amoss_Expectation expectation ) {
            return new Amoss_Expectation( expectation );
        }

        /**
        * Get the Amoss Instance that this Exception is for
        *
        * @return  Amoss_Instance - The Amoss Instance
        */
        public Amoss_Instance getAmossInstance() {
            return this.amossInstance;
        }

        /**
        * Set the Amoss Instance that this Exception is for
        *
        * @param  Amoss_Instance - The Amoss Instance
        * @return Amoss_Expectation - Itself, allowing for a fluent interface
        */
        public Amoss_Expectation setAmossInstance( Amoss_Instance amossInstance ) {
            this.amossInstance = amossInstance;
            return this;
        }

        /**
        * Internal method that sets the expectation parameter object for this expectation.
        * In essence, defines the behaviour of the parameter matching.
        *
        * @param Amoss_ExpectationParameters - The expectation parameters object to use
        * @return Amoss_Expectation - Itself, allowing for a fluent interface
        */
        public Amoss_Expectation setExpectationParameters( Amoss_ExpectationParameters expectationParameters ) {
            this.expectedParameters = expectationParameters;
            return this;
        }

        /**
        * Internal method that retrieves the expectation parameter object for this expectation.
        *
        * @return Amoss_ExpectationParameters - The expectation parameters object that is in use
        */
        public Amoss_ExpectationParameters getExpectationParameters() {
            return expectedParameters;
        }

        /**
        * Internal method that sets the expectation parameter object for this expectation.
        * In essence, defines the behaviour of the parameter matching.
        *
        * @param Amoss_ExpectationReturnMechanism - The expectation return mechanism object to use
        * @return Amoss_Expectation - Itself, allowing for a fluent interface
        */
        public Amoss_Expectation setExpectionReturns( Amoss_ExpectationReturnMechanism returnMechanism ) {
            this.returnMechanism = returnMechanism;
            return this;
        }

        /**
        * Internal method that assigns the methods that this expectation is for.
        *
        * @param String - The method that this expectation is for
        * @return Amoss_Expectation - Itself, allowing for a fluent interface
        */
        public Amoss_Expectation setMethod( String method ) {
            this.expectedMethod = method;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Returns the value that this expection is defined to.  If stated that it should throw an exception, will do so.
        *
        * @return Object - The value that this expectation is configured to return
        */
        public Object getReturnValue( Object       mockedObject  , String       mockedMethod  , Type         returnType,         //NOPMD - matches spec of StubProvider.handleMethodCall
                                      List<Type>   parameterTypes, List<String> parameterNames, List<Object> parameters  ) {

            return returnMechanism.getReturn( mockedObject, mockedMethod, returnType, parameterTypes, parameterNames, parameters );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Get the assertion mechanism for this mock object implementation.
        *
        * @return Amoss_Asserts - The assertionMechanism
        */
        public Amoss_Asserts getAssertionMechanism() {
            return amossInstance.getAssertionMechanism();
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Verifies that the given method and parameter values matches the current expectation, giving a clear description of what is wrong if the verification fails.
        *
        * @param Amoss_Asserts - The assertion mechanism that should be used for issuing assertions
        * @param String - The method to check this expectation against.
        * @param List<String> - The parameter namess to check this expectation against.
        * @param List<Object> - The parameters to check this expectation against.
        */
        public void verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues ) {
            assertionMechanism.assertEquals( expectedMethod, method, String.format( '{0}.{1} was expected to be called', new List<String>{ className, expectedMethod } ) );
            expectedParameters.verify( className, method, parameterNames, parameterValues );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Returns a description of the current expectation's call
        *
        * @return String - A description of the current expection's call.
        */
        public String getCallDescription() {
            String callDescription = this.expectedMethod;
            String parametersDescription = expectedParameters.getParametersDescription();
            return this.expectedMethod + '( ' + parametersDescription + ' )';
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if the stated call and parameters matches the current expectation's definition.
        *
        * @param String - The method to check this expectation against.
        * @param List<Object> - The names of the parameters to check this expectation against.
        * @param List<Object> - The parameters to check this expectation against.
        * @return Boolean - States if this expectation matches that passed passed in.
        */
        public Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
            if ( method != this.expectedMethod ) {
                return false;
            }
            return expectedParameters.matches( method, parameterNames, parameterValues );
        }
    }

    /**
    * Internal interface that allows for the specification of the return behaviour that an Expectation should have
    *
    * An implementing class should provide a mechanism to return a value, or perform an action (e.g. throw an exception)
    * when a return should have been made
    */
    private interface Amoss_ExpectationReturnMechanism {
        Object getReturn( Object       mockedObject  , String       mockedMethod  , Type         returnType,        //NOPMD - matches spec of StubProvider.handleMethodCall
                          List<Type>   parameterTypes, List<String> parameterNames, List<Object> parameters  );
    }

    /**
    * Internal class that allows for the specification that an Expectation will return a value
    */
    private class Amoss_ExpectationValueReturn implements Amoss_ExpectationReturnMechanism {

        private Object returnValue;

        /**
        * Internal method that sets the value for this return mechanism
        *
        * @param Object - The return value that this mechanism should return
        * @return Amoss_ExpectationValueReturn - This object, allowing for a fluent interface
        */
        public Amoss_ExpectationValueReturn setReturnValue( Object returnValue ) {
            this.returnValue = returnValue;
            return this;
        }

        /**
        * Internal method that returns the specified value of this return mechanism
        *
        * @return Object - The return value that was specified
        */
        public Object getReturn( Object       mockedObject  , String       mockedMethod  , Type         returnType,     //NOPMD - matches spec of StubProvider.handleMethodCall
                                 List<Type>   parameterTypes, List<String> parameterNames, List<Object> parameters  ) {
            return returnValue;
        }
    }

    /**
    * Internal class that allows for the specification that an Expectation will throw an exception
    */
    private class Amoss_ExpectationExceptionThrower implements Amoss_ExpectationReturnMechanism {

        private Exception exceptionToThrow;

        /**
        * Internal method that sets the exception for this return mechanism to throw
        *
        * @param Object - The exception that this mechanism should throw
        * @return Amoss_ExpectationValueReturn - This object, allowing for a fluent interface
        */
        public Amoss_ExpectationExceptionThrower setExceptionToThrow( Exception exceptionToThrow ) {
            this.exceptionToThrow = exceptionToThrow;
            return this;
        }

        /**
        * Internal method that throws the configured exception
        */
        public Object getReturn( Object       mockedObject  , String       mockedMethod  , Type         returnType,     //NOPMD - matches spec of StubProvider.handleMethodCall
                                 List<Type>   parameterTypes, List<String> parameterNames, List<Object> parameters  ) {
            throw exceptionToThrow;
        }
    }

    /**
    * Internal class that allows for the specification that an Expectation's return will be handled by a StubProvider
    */
    private class Amoss_ExpectationStubProviderHandledReturn implements Amoss_ExpectationReturnMechanism {

        private StubProvider returnHandler;

        /**
        * Internal method that sets the handler for this return mechanism to use
        *
        * @param StubProvider - The return handler that this mechanism should use
        * @return Amoss_ExpectationStubProviderHandledReturn - This object, allowing for a fluent interface
        */
        public Amoss_ExpectationStubProviderHandledReturn setReturnHandler( StubProvider returnHandler ) {
            this.returnHandler = returnHandler;
            return this;
        }

        /**
        * Internal method that calls the exception handler
        */
        public Object getReturn( Object       mockedObject  , String       mockedMethod  , Type         returnType,     //NOPMD - matches spec of StubProvider.handleMethodCall
                                 List<Type>   parameterTypes, List<String> parameterNames, List<Object> parameters  ) {
            return returnHandler.handleMethodCall( mockedObject, mockedMethod, returnType, parameterTypes, parameterNames, parameters );
        }
    }

    /**
    * Internal class that allows for the specification that an Expectation's return will be handled by an Amoss_MethodHandler
    */
    private class Amoss_ExpectationAmossHandlerHandledReturn implements Amoss_ExpectationReturnMechanism {

        private Amoss_MethodHandler returnHandler;

        /**
        * Internal method that sets the handler for this return mechanism to use
        *
        * @param Amoss_MethodHandler - The return handler that this mechanism should use
        * @return Amoss_ExpectationAmossHandlerHandledReturn - This object, allowing for a fluent interface
        */
        public Amoss_ExpectationAmossHandlerHandledReturn setReturnHandler( Amoss_MethodHandler returnHandler ) {
            this.returnHandler = returnHandler;
            return this;
        }

        /**
        * Internal method that calls the exception handler
        */
        public Object getReturn( Object       mockedObject  , String       mockedMethod  , Type         returnType,         //NOPMD - matches spec of StubProvider.handleMethodCall
                                 List<Type>   parameterTypes, List<String> parameterNames, List<Object> parameters  ) {
            return returnHandler.handleMethodCall( parameters );
        }
    }

    /**
    * Internal interface that allows for the specification of parameters that an Expectation should have
    *
    * An implementing class should provide a mechanism to get a String description, verify passed parameters are as stated (reporting via assertions)
    * and checking passed parameters are as stated (returning a Boolean)
    */
    private abstract class Amoss_ExpectationParameters {

        /**
        * Is the collection of ValueVerifiers for the parameter that is in the process of being specified.
        *
        * Allows us to add new verifiers to the current parameter without having to keep track of which parameter
        * it is we are specifying.
        */
        Amoss_CompositeValueVerifier currentParameterVerifier;

        /**
        * Build a new 'current parameter verifier' and apply that as the new current one so we can add
        * new value verifiers to it.
        */
        public Amoss_CompositeValueVerifier buildCurrentParameterVerifier() {
            currentParameterVerifier = new Amoss_CompositeValueVerifier();
            return currentParameterVerifier;
        }

        /**
        * Sets the 'current parameter verifier' to be the one specified so we can add new value verifiers to it.
        */
        public Amoss_ExpectationParameters setCurrentParameterVerifier( Amoss_ValueVerifier currentParameterVerifier ) {
            this.currentParameterVerifier = (Amoss_CompositeValueVerifier)currentParameterVerifier;
            return this;
        }

        /**
        * Add a new value verifier to the current parameter
        */
        public Amoss_ExpectationParameters addVerifierToCurrentParameter( Amoss_ValueVerifier verifier ) {
            currentParameterVerifier.addVerifier( verifier );
            return this;
        }

        public abstract String getParametersDescription();
        public abstract void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues );
        public abstract Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues );
    }

    /**
    * Internal class that allows for the specification that an Expectation can have any parameters
    *
    * Always assumes that any parameters will match (since 'any' should)
    */
    private class Amoss_ExpectationAnyParameters extends Amoss_ExpectationParameters {

        /**
        * Internal method that returns a String description of the parameter values that are expected.
        *
        * Always returns 'any'
        *
        * @return String - The description of the expected parameter values
        */
        public override String getParametersDescription() {
            return 'any';
        }

        /**
        * Internal method that checks if the passed parameters match those that are configured, reporting via Assertions.
        *
        * Does nothing.
        *
        * @param String - The method that is being called, and therefore checked
        * @param List<String> - The names of the parameters being passed, and thereforce checked
        * @param List<Object> - The values of the parameters being passed, and thereforce checked
        */
        public override void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues ){
            return;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if the stated call and parameters matches the current expectation's definition.
        *
        * @param String - The method to check this expectation against.
        * @param List<Object> - The names of the parameters to check this expectation against.
        * @param List<Object> - The parameters to check this expectation against.
        * @return Boolean - States if this expectation matches that passed passed in.
        */
        public override Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
            return true;
        }
    }

    /**
    * Internal interface that allows for the specification of parameters that an Expectation should have using 'positional' notation.
    * That is, they are specified in order.
    */
    private class Amoss_ExpectationPositionalParameters extends Amoss_ExpectationParameters {

        private List<Amoss_ValueVerifier> expectedParameters = new List<Amoss_ValueVerifier>();

        /**
        * Internal method that moves the current specification on to the next parameter so that any further
        * parameter specifications apply to that parameter.
        */
        Amoss_ExpectationPositionalParameters moveToNextParameter() {
            expectedParameters.add( buildCurrentParameterVerifier() );
            return this;
        }

        /**
        * Internal method that returns a String description of the parameter values that are expected, as a comma seperated list.
        *
        * @return String - The description of the expected parameter values
        */
        public override String getParametersDescription() {
            List<String> stringParameters = new List<String>();
            for( Object thisParameter : expectedParameters ) {
                stringParameters.add( String.valueOf( thisParameter ) );
            }
            return String.join( stringParameters, ', ' );
        }

        /**
        * Internal method that checks if the passed parameters match those that are configured, reporting via Assertions.
        *
        * @param String - The method that is being called, and therefore checked
        * @param List<String> - The names of the parameters being passed, and thereforce checked
        * @param List<Object> - The values of the parameters being passed, and thereforce checked
        */
        public override void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues ){

            if ( expectedParameters.size() != parameterValues.size() ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( expectedParameters.size() )
                            .setActual( parameterValues.size() )
                            .setAssertionMessage( String.format( '{0}.{1} was called with an unexpected number of parameters', new List<String>{ className, method } ) );
            }

            for ( Integer parameterNumber = 0; parameterNumber < expectedParameters.size(); parameterNumber++ ) {
                try {
                    expectedParameters[ parameterNumber ].verify( parameterValues[ parameterNumber ] );
                } catch ( Amoss_AssertionFailureException e ) {
                    throw e.addContextToMessage( String.format( '{0}.{1} had a problem with the parameter value in position {2}: \'{0}\'', new List<Object>{ className, method, parameterNumber } ) );
                }
            }
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if the stated call and parameters matches the current expectation's definition.
        *
        * @param String - The method to check this expectation against.
        * @param List<Object> - The names of the parameters to check this expectation against.
        * @param List<Object> - The parameters to check this expectation against.
        * @return Boolean - States if this expectation matches that passed passed in.
        */
        public override Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
            try {
                verify( 'class', method, parameterNames, parameterValues );
            } catch ( Exception e ) {
                return false;
            }
            return true;
        }
    }

    /**
    * Internal interface that allows for the specification of parameters that an Expectation should have using 'positional' notation.
    * That is, they are specified using their names
    */
    private class Amoss_ExpectationNamedParameters extends Amoss_ExpectationParameters {

        private Map<String,Amoss_ValueVerifier> expectedParameters = new Map<String,Amoss_ValueVerifier>();

        /**
        * Internal method that moves the current specification on to the parameter named, so that any further
        * parameter specifications apply to that parameter.
        *
        * If that parameter has previously been specified, will return the existing parameter verifier so more verifications can be
        * added to it.  Otherwise ensures a new one is created.
        */
        Amoss_ExpectationNamedParameters moveToParameter( String parameterName ) {

            if ( !expectedParameters.containsKey( parameterName ) ) {
                expectedParameters.put( parameterName, buildCurrentParameterVerifier() );
            } else {
                setCurrentParameterVerifier( expectedParameters.get( parameterName ) );
            }

            return this;
        }

        /**
        * Internal method that returns a String description of the parameter values that are expected, rendered in a similar
        * format to a Map.
        *
        * @return String - The description of the expected parameter values
        */
        public override String getParametersDescription() {
            List<String> stringParameters = new List<String>();
            for( String thisParameterName : expectedParameters.keySet() ) {
                stringParameters.add( thisParameterName + ' => ' + String.valueOf( expectedParameters.get( thisParameterName ) ) );
            }
            return String.join( stringParameters, ', ' );
        }

        /**
        * Internal method that checks if the passed parameters match those that are configured, reporting via Assertions.
        *
        * @param String - The method that is being called, and therefore checked
        * @param List<String> - The names of the parameters being passed, and thereforce checked
        * @param List<Object> - The values of the parameters being passed, and thereforce checked
        */
        public override void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues ){

            Set<String> expectedParameterNames = expectedParameters.keySet();
            Set<String> actualParameterNames   = new Set<String>( parameterNames );

            if ( ! actualParameterNames.containsAll( expectedParameterNames ) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( new List<String>( expectedParameterNames ) )
                            .setActual( new List<String>( actualParameterNames ) )
                            .setAssertionMessage( String.format( '{0}.{1} was called with different parameters to those specified', new List<String>{ className, method } ) );
            }

            for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {

                String actualParameterName  = parameterNames[ parameterNumber ];
                Object actualParameterValue = parameterValues[ parameterNumber ];
                Amoss_ValueVerifier expectationParameter = expectedParameters.get( actualParameterName );

                if ( expectationParameter != null ) {
                    try {
                        expectationParameter.verify( actualParameterValue );
                    } catch ( Amoss_AssertionFailureException e ) {
                        throw e.addContextToMessage( String.format( '{0}.{1} had a problem with the parameter value for "{2}": \'{0}\'', new List<String>{ className, method, actualParameterName } ) );
                    }
                }
            }
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if the stated call and parameters matches the current expectation's definition.
        *
        * @param String - The method to check this expectation against.
        * @param List<Object> - The names of the parameters to check this expectation against.
        * @param List<Object> - The parameters to check this expectation against.
        * @return Boolean - States if this expectation matches that passed passed in.
        */
        public override Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
            try {
                verify( 'class', method, parameterNames, parameterValues );
            } catch ( Exception e ) {
                return false;
            }
            return true;
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Allows for multiple ValueVerifier implementations to be evaluated against a single value
    */
    class Amoss_CompositeValueVerifier implements Amoss_ValueVerifier {

        List<Amoss_ValueVerifier> valueVerifiers = new List<Amoss_ValueVerifier>();

        public Amoss_CompositeValueVerifier addVerifier( Amoss_ValueVerifier verifier ) {
            valueVerifiers.add( verifier );
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            switch on valueVerifiers.size() {
                when 0 {
                    return 'ERROR: No specification of the parameter shape was made (e.g. setTo)';
                }
                when 1 {
                    return String.valueOf( valueVerifiers[0] );
                }
                when else {
                    List<String> descriptions = new List<String>();
                    for( Amoss_ValueVerifier thisVerifier : valueVerifiers ) {
                        descriptions.add( String.valueOf( thisVerifier ) );
                    }
                    return 'Should match all of [ ' + String.join( descriptions, ', ' ) + ' ]';
                }
            }
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {
            if ( valueVerifiers.size() == 0 ) {
                throw new Amoss_AssertionFailureException()
                            .setAssertionMessage( 'The specification of the expected parameter value is incompletely set up' );
            }

            for( Amoss_ValueVerifier thisValueVerifier : valueVerifiers ) {
                thisValueVerifier.verify( actualValue );
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of 'any' parameter value that is expected to be passed into a mocked method call
    *
    */
    class Amoss_AnyValueVerifier implements Amoss_ValueVerifier {

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {          //NOPMD - Amoss_ExpectationAnyParameter is a special case that behaves predominantly like a 'Null Object'
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return 'Any value';
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of 'non empty String' parameter value that is expected to be passed into a mocked method call
    *
    */
    class Amoss_NotEmptyStringValueVerifier implements Amoss_ValueVerifier {

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {
            if ( String.isEmpty( (String)actualValue ) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'Non Empty' )
                            .setActual( actualValue )
                            .setAssertionMessage( 'The value was "empty" when it was expected not be be' );
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of 'not null' parameter value that is expected to be passed into a mocked method call
    *
    */
    class Amoss_NotNullValueVerifier implements Amoss_ValueVerifier {

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {
            if ( actualValue == null ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'Not Null' )
                            .setActual( actualValue )
                            .setAssertionMessage( 'The value was "null" when it was expected not be be' );
            }
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return 'Any value';
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a 'Same Instance As' Parameter that is expected to be passed into a mocked method call
    */
    class Amoss_EqualsValueVerifier implements Amoss_ValueVerifier {

        Object value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expected to be
        *
        * @param  Object - The value that this parameter is expected to be
        * @return Amoss_EqualsValueVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_EqualsValueVerifier setValueToVerifyAgainst( Object value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.valueOf( this.value );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {
            if ( this.value != actualValue ) {
                if ( Amoss_Asserts.getType( this.value ) != Amoss_Asserts.getType( actualValue ) ) {
                    throw new Amoss_EqualsAssertionFailureException()
                                .setExpected( Amoss_Asserts.getType( this.value ) )
                                .setActual( Amoss_Asserts.getType( actualValue ) )
                                .setAssertionMessage( 'The value is not what was expected - The types do not match' );

                } else {
                    throw new Amoss_EqualsAssertionFailureException()
                                .setExpected( this.value )
                                .setActual( actualValue )
                                .setAssertionMessage( 'The value is not what was expected - If it is an object, it may be the wrong instance' );
                }
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of an Object Parameter that is expected to be the same instance
    * when passed into a mocked method call
    */
    class Amoss_SameInstanceVerifier implements Amoss_ValueVerifier {

        Object value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expected to be
        *
        * @param  Object - The value that this parameter is expected to be (actually an Sobject)
        * @return Amoss_SameInstanceVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_SameInstanceVerifier setValueToVerifyAgainst( Object value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( 'Same instance as {0}', new List<Object>{ value } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {
            if ( actualValue !== this.value ) {
                if ( actualValue == this.value ) {
                    throw new Amoss_EqualsAssertionFailureException()
                                .setExpected( this.value )
                                .setActual( actualValue )
                                .setAssertionMessage( 'The value is the same, but not the same instance as was expected' );
                } else {
                    throw new Amoss_EqualsAssertionFailureException()
                                .setExpected( this.value )
                                .setActual( actualValue )
                                .setAssertionMessage( 'The value is not what was expected' );
                }
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of String parameter value that is expected to contain the given string
    *
    */
    class Amoss_ContainingVerifier implements Amoss_ValueVerifier {

        String value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expected to contain
        *
        * @param  String - The value that this parameter is expected to contain
        * @return Amoss_ContainingVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_ContainingVerifier setValueToVerifyAgainst( String value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf String) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'String' )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value was expected to be a String, and was not' );
            }

            if ( !((String)actualValue).contains( value ) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( value )
                            .setActual( actualValue )
                            .setAssertionMessage( 'The value does not contain the expected String' );
            }
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return 'String value containing "' + value + '"';
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of String parameter value that is expected to match the given regular expression
    *
    */
    class Amoss_MatchingVerifier implements Amoss_ValueVerifier {

        String  value;
        Pattern valuePattern;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the regular expression that this parameter is expected to match
        *
        * @param  String - The pattern that this parameter is expected to match
        * @return Amoss_ContainingVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_MatchingVerifier setValueToVerifyAgainst( String value ) {

            this.value = value;
            try {
                valuePattern = Pattern.compile( value );
            } catch ( Exception e ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'A valid regular expression as per https://docs.oracle.com/javase/1.5.0/docs/api/index.html?java/util/regex/Pattern.html' )
                            .setActual( value )
                            .setAssertionMessage( 'The regular expression "' + value + '" does not appear to be valid: ' + e.getMessage() );
            }
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf String) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'String' )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value was expected to be a String, and was not' );
            }

            if ( ! valuePattern.matcher( (String)actualValue ).matches() ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( value )
                            .setActual( actualValue )
                            .setAssertionMessage( 'The value does not match the expected expression' );
            }
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return 'String value matching "' + value + '"';
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a List Parameter that is expected to be
    * the same instance when passed into a mocked method call
    */
    class Amoss_ListSameInstanceVerifier implements Amoss_ValueVerifier {

        List<Object> value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expected to be
        *
        * @param  List<Object> - The value that this parameter is expected to be
        * @return Amoss_ValueVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_ListSameInstanceVerifier setValueToVerifyAgainst( List<Object> value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( 'Same instance as {0}', new List<Object>{ value } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf List<Object>) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( Amoss_Asserts.getType( this.value ) )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value is not what was expected - The types do not match' );
            }

            if ( actualValue !== this.value ) {
                if ( actualValue == this.value ) {
                    if ( !allElementsMatch( (List<Object>)actualValue ) ) {
                        throw new Amoss_EqualsAssertionFailureException()
                                    .setExpected( this.value )
                                    .setActual( actualValue )
                                    .setAssertionMessage( 'The value is the same, but the list and some of its elements are not the same instances as was expected' );

                    } else {
                        throw new Amoss_EqualsAssertionFailureException()
                                    .setExpected( this.value )
                                    .setActual( actualValue )
                                    .setAssertionMessage( 'The value is the same, but not the same instance as was expected' );
                    }
                } else {
                    throw new Amoss_EqualsAssertionFailureException()
                                .setExpected( this.value )
                                .setActual( actualValue )
                                .setAssertionMessage( 'The value is not what was expected' );
                }
            }
        }

        /*
        * Checks if any of the elements in the list do not '===' the expected ones.
        *
        * @param List<Object> - The value to check
        */
        private Boolean allElementsMatch( List<Object> actualValue ) {
            for ( Integer i=0; i<this.value.size(); i++ ) {
                if ( actualValue[i] !== this.value[i] ) {
                    return false;
                }
            }
            return true;
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of an 'same value as' Parameter that is expected to be passed into a mocked method call
    */
    class Amoss_SameValueAsVerifier implements Amoss_ValueVerifier {

        Object value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expected to be
        *
        * @param  Object - The value that this parameter is expected to be
        * @return Amoss_SameValueAsVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_SameValueAsVerifier setValueToVerifyAgainst( Object value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.valueOf( this.value );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {
            if ( JSON.serialize( this.value ) != JSON.serialize( actualValue ) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( 'The value is not what was expected' );
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of an 'Fields Set Like' Parameter that is expected to be passed into a mocked method call
    */
    class Amoss_FieldsSetLikeVerifier implements Amoss_ValueVerifier {

        Sobject value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expected to be
        *
        * @param  Sobject - The value that this parameter is expected to be
        * @return Amoss_FieldsSetLikeVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_FieldsSetLikeVerifier setValueToVerifyAgainst( Sobject value ) {

            if ( value == null ) {
                throw new Amoss_ExpectedObjectCannotBeNullException( 'Cannot specify NULL for a "FieldsSetLike" expectation' );
            }

            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( 'SObject with fields set like {0}', new List<Object>{ value } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Sobject - The value to check
        */
        public void verify( Object actualValue ) {

            if ( actualValue == null ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( 'Expected an sObject, and got NULL' );
            }
            Sobject sobjectActualValue;
            try {
                sobjectActualValue = (SObject)actualValue;
            } catch ( Exception e ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( String.format( 'Expected an sObject, and got {0}', new List<String>{ Amoss_Asserts.getType( actualValue ) } ) );
            }

            List<String> fieldsWithProblems = new List<String>();

            Map<String,Object> expectedPopulatedFields = this.value.getPopulatedFieldsAsMap();
            for ( String fieldName : expectedPopulatedFields.keySet() ) {
                if ( sobjectActualValue.get( fieldName ) != expectedPopulatedFields.get( fieldName ) ) {
                    fieldsWithProblems.add( fieldName );
                }
            }
            if ( ! fieldsWithProblems.isEmpty() ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( String.format( 'The following fields were not set as expected: {0}', new List<Object>{ fieldsWithProblems } ) );
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of an 'Fields Set To' Parameter that is expected to be passed into a mocked method call
    */
    class Amoss_FieldsSetToVerifier implements Amoss_ValueVerifier {

        Map<String,Object> value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expected to be
        *
        * @param  Sobject - The value that this parameter is expected to be
        * @return Amoss_FieldsSetToVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_FieldsSetToVerifier setValueToVerifyAgainst( Map<String,Object> value ) {

            if ( value == null ) {
                throw new Amoss_ExpectedObjectCannotBeNullException( 'Cannot specify NULL for a "FieldsSetTo" expectation' );
            }

            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( 'SObject with at least the same fields set as {0}', new List<Object>{ value } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Sobject - The value to check
        */
        public void verify( Object actualValue ) {

            if ( actualValue == null ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( 'Expected an sObject, and got NULL' );
            }

            Sobject sobjectActualValue;
            try {
                sobjectActualValue = (SObject)actualValue;
            } catch ( Exception e ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( String.format( 'Expected an sObject, and got {0}', new List<String>{ Amoss_Asserts.getType( actualValue ) } ) );
            }

            List<String> fieldsWithProblems = new List<String>();

            for ( String fieldName : value.keySet() ) {

                try {
                    if ( sobjectActualValue.get( fieldName ) != value.get( fieldName ) ) {
                        fieldsWithProblems.add( fieldName );
                    }
                } catch ( SObjectException e ) {
                    throw new Amoss_AssertionFailureException()
                                .setAssertionMessage( String.format( 'Problem comparing field "{0}": {1}', new List<Object>{ fieldName, e.getMessage() } ) );
                }
            }
            if ( ! fieldsWithProblems.isEmpty() ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( String.format( 'The following fields were not set as expected: {0}', new List<Object>{ fieldsWithProblems } ) );
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a List Parameter that must have the specified length
    */
    class Amoss_ListOfLengthVerifier implements Amoss_ValueVerifier {

        Integer expectedLength;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the length that the specification expects the list to be.
        *
        * @param  Integer - The length that is expected
        * @return Amoss_ListOfLengthVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_ListOfLengthVerifier setExpectedLength( Integer expectedLength ) {
            this.expectedLength = expectedLength;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( 'List of length {0}', new List<Object>{ expectedLength } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the verifier that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf List<Object>) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'List<Object>' )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value is not what was expected - The types do not match' );
            }

            List<Object> actualList = (List<Object>)actualValue;

            if ( this.expectedLength != actualList.size() ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( expectedLength )
                            .setActual( actualList.size() )
                            .setAssertionMessage( 'The value is not what was expected - The list is not the expected length' );
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a List Parameter that must contain elements that all pass
    * the verifier configured
    */
    class Amoss_ListElementsAllVerifier implements Amoss_ValueVerifier {

        Amoss_ValueVerifier elementVerifier;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the Element Verifier that the list parameter elements are expected to pass.
        *
        * @param  Amoss_ValueVerifier - The Verifier that the passed value must pass.
        * @return Amoss_ListElementsAllVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_ListElementsAllVerifier setValueToVerifyAgainst( Amoss_ValueVerifier value ) {
            this.elementVerifier = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( 'All => {0}', new List<Object>{ elementVerifier } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the verifier that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf List<Object>) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'List<Object>' )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value is not what was expected - The types do not match' );
            }

            List<Object> actualList = (List<Object>)actualValue;

            for ( Integer index=0; index < actualList.size(); index++ ) {
                try {
                    elementVerifier.verify( actualList[ index ] );
                } catch ( Amoss_AssertionFailureException e ) {
                    throw e.addContextToMessage( String.format( 'List element {0} does not match what was expected: \'{0}\'', new List<Object>{ index } ) );
                }
            }
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a List Parameter that must contain at least one element that all passes
    * the verifier configured
    */
    class Amoss_ListElementsAnyVerifier implements Amoss_ValueVerifier {

        Amoss_ValueVerifier elementVerifier;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the Element Verifier that at least one of the list parameter's element is expected to pass
        *
        * @param  Amoss_ValueVerifier - The Verifier that one of the passed elements must pass.
        * @return Amoss_ListElementsAnyVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_ListElementsAnyVerifier setValueToVerifyAgainst( Amoss_ValueVerifier value ) {
            this.elementVerifier = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( 'At least one => {0}', new List<Object>{ elementVerifier } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the verifier that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf List<Object>) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'List<Object>' )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value is not what was expected - The types do not match' );
            }

            List<Object> actualList = (List<Object>)actualValue;

            for ( Integer index=0; index < actualList.size(); index++ ) {
                try {
                    elementVerifier.verify( actualList[ index ] );
                    return;
                } catch ( Amoss_AssertionFailureException e ) { //NOPMD - Intentionally left empty - verify throws an exception if a value does not pass verification.  We just want one element that passes
                }
            }

            throw new Amoss_EqualsAssertionFailureException()
                        .setExpected( String.valueOf( elementVerifier ) )
                        .setActual( actualValue )
                        .setAssertionMessage( 'The value is not what was expected - At least one element in the list should pass the described verification' );
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification that the element in a particlar position of a List must pass the configured verifier
    */
    class Amoss_ListElementAtVerifier implements Amoss_ValueVerifier {

        Integer             elementPosition;
        Amoss_ValueVerifier elementVerifier;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the position in the list to check.
        *
        * @param  Object - The Verifier that the congigured element must pass.  Is actually an Amoss_ValueVerifier.
        * @return Amoss_ListElementAtVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_ListElementAtVerifier setElementToVerify( Integer elementPosition ) {
            this.elementPosition = elementPosition;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the Element Verifier that the element is expected to pass
        *
        * @param  Amoss_ValueVerifier - The Verifier that the congigured element must pass.
        * @return Amoss_ListElementAtVerifier - Itself, allowing for a fluent interface
        */
        public Amoss_ListElementAtVerifier setValueToVerifyAgainst( Amoss_ValueVerifier value ) {
            this.elementVerifier = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes the verification that this object to configured to make
        *
        * @return String - A clear description of the value's verification
        */
        public override String toString() {
            return String.format( '{0} => {1}', new List<Object>{ elementPosition, elementVerifier } );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this value is correct for the verifier that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf List<Object>) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'List<Object>' )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value is not what was expected - The types do not match' );
            }

            List<Object> actualList = (List<Object>)actualValue;

            if ( actualList.size() < elementPosition + 1 ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( elementPosition + 1 )
                            .setActual( actualList.size() )
                            .setAssertionMessage( 'The value is not what was expected - The list is not as long as required' );
            }

            try {
                elementVerifier.verify( actualList[ elementPosition ] );
            } catch ( Amoss_AssertionFailureException e ) {
                throw e.addContextToMessage( String.format( 'List element {0} does not match what was expected: \'{0}\'', new List<Object>{ elementPosition } ) );
            }
        }
    }

    /**
    * Internal class that should not be refenced in tests.
    *
    * Constructs instances of Amoss_ValueVerifier.
    */
    private class Amoss_ValueVerifierBuilder {

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of Amoss_ValueVerifier based on the passed Object.
        *
        * @param  Object - The value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this parameter
        */
        public Amoss_ValueVerifier buildEqualsVerifier( Object value ) {

            // Not ideal, but since we don't want to implement multiple versions of
            // setTo in the grammer, every call to buildEqualsVerifier would resolve to the Object (this)
            // version.
            // As we only want to distinguish between a couple of types, this seems the
            // simplest way.
            if ( value == Amoss_Instance.Value.ANY_VALUE ) {
                return buildAnyVerifier();
            }
            if ( value == Amoss_Instance.Value.NOT_NULL ) {
                return buildNotNullVerifier();
            }
            if ( value == Amoss_Instance.Value.NOT_EMPTY ) {
                return buildNotEmptyStringVerifier();
            }
            if ( value instanceOf List<Object> ) {
                return buildSameInstanceVerifier( (List<Object>)value );
            }
            if ( Amoss_Asserts.getType( value ).startsWith( 'Map<' ) ) { // because of the way we can't cast Maps with different types of keys, and to avoid loads of instance of checks
                return buildSameInstanceVerifier( value );
            }
            if ( Amoss_Asserts.getType( value ).startsWith( 'Set<' ) ) { // because of the way we can't cast Set, and to avoid loads of instance of checks
                return buildSameInstanceVerifier( value );
            }
            if ( value instanceOf Sobject ) {
                return buildSameInstanceVerifier( (Sobject)value );
            }

            return new Amoss_EqualsValueVerifier().setValueToVerifyAgainst( value );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_SameInstanceVerifier
        *
        * @param  Object - The Object value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this value (actually a Amoss_SameInstanceVerifier)
        */
        public Amoss_ValueVerifier buildSameInstanceVerifier( Object value ) {
            return new Amoss_SameInstanceVerifier().setValueToVerifyAgainst( value );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_SameInstanceVerifier
        *
        * @param  Sobject - The Sobject value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this value (actually a Amoss_SameInstanceVerifier)
        */
        public Amoss_ValueVerifier buildSameInstanceVerifier( Sobject value ) {
            return new Amoss_SameInstanceVerifier().setValueToVerifyAgainst( value );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_SameInstanceVerifier
        *
        * @param  List<Object> - The List value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this value (actually a Amoss_SameInstanceVerifier)
        */
        public Amoss_ValueVerifier buildSameInstanceVerifier( List<Object> value ) {
            return new Amoss_ListSameInstanceVerifier().setValueToVerifyAgainst( value );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_SameValueAsVerifier
        *
        * @param  Object - The Sobject value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this value (actually a Amoss_SameValueAsVerifier)
        */
        public Amoss_ValueVerifier buildSameValueAsVerifier( Object value ) {
            return new Amoss_SameValueAsVerifier().setValueToVerifyAgainst( value );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ContainingVerifier
        *
        * @param  String - The String value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this value (actually a Amoss_ContainingVerifier)
        */
        public Amoss_ValueVerifier buildContainingStringVerifier( String value ) {
            return new Amoss_ContainingVerifier().setValueToVerifyAgainst( value );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_MatchingVerifier
        *
        * @param  String - The Regular Expression value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this value (actually a Amoss_MatchingVerifier)
        */
        public Amoss_ValueVerifier buildMatchingExpressionVerifier( String value ) {
            return new Amoss_MatchingVerifier().setValueToVerifyAgainst( value );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_FieldsSetLikeVerifier, which checks that Sobjects have the same properties set as the defined 'sobjectSetLike'.
        *
        * @param  Sobject - The Sobject value that is expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this value (actually a Amoss_FieldsSetLikeVerifier)
        */
        public Amoss_ValueVerifier buildFieldsSetLikeVerifier( Sobject sobjectSetLike ) {
            return new Amoss_FieldsSetLikeVerifier().setValueToVerifyAgainst( sobjectSetLike );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_FieldsSetToVerifier, which checks that SObjects have the same fields set as the defined Map.
        *
        * @param  Map<String,Object> - The Map that contains the fields that are expected for the Amoss_ValueVerifier
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this parameter (actually a Amoss_FieldsSetToVerifier)
        */
        public Amoss_ValueVerifier buildFieldsSetToVerifier( Map<String,Object> fields ) {
            return new Amoss_FieldsSetToVerifier().setValueToVerifyAgainst( fields );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ListOfLengthVerifier, which checks that a given value is a list that has the specified
        * number of elements
        *
        * @param  Integer - The number of elements that are expected
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this parameter (actually a Amoss_ListOfLengthVerifier)
        */
        public Amoss_ValueVerifier buildListOfLengthVerifier( Integer expectedLength ) {
            return new Amoss_ListOfLengthVerifier().setExpectedLength( expectedLength );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ListElementsAllVerifier, which checks that a given value is a list that has all elements passing
        * the provided Amoss_ValueVerifier.
        *
        * @param  Amoss_ValueVerifier - The value verifier that should be used to check all the elements in the later passed value.
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this parameter (actually a Amoss_ListElementsAllVerifier)
        */
        public Amoss_ValueVerifier buildAllElementsVerifier( Amoss_ValueVerifier elementVerifier ) {
            return new Amoss_ListElementsAllVerifier().setValueToVerifyAgainst( elementVerifier );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ListElementsAnyVerifier, which checks that a given value is a list that has any of the elements passing
        * the provided Amoss_ValueVerifier.
        *
        * @param  Amoss_ValueVerifier - The value verifier that should be used to check the elements in the later passed value.
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this parameter (actually a Amoss_ListElementsAnyVerifier)
        */
        public Amoss_ValueVerifier buildAnyElementVerifier( Amoss_ValueVerifier elementVerifier ) {
            return new Amoss_ListElementsAnyVerifier().setValueToVerifyAgainst( elementVerifier );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ListElementAtVerifier, which checks that a given value is a list that has the specified element
        * the provided Amoss_ValueVerifier.
        *
        * @param  Amoss_ValueVerifier - The value verifier that should be used to check the elements in the later passed value.
        * @return Amoss_ValueVerifier - The appropriate value verifier instance for this parameter (actually a Amoss_ListElementAtVerifier)
        */
        public Amoss_ValueVerifier buildElementAtVerifier( Amoss_ValueVerifier elementVerifier, Integer elementPosition ) {
            return new Amoss_ListElementAtVerifier().setElementToVerify( elementPosition ).setValueToVerifyAgainst( elementVerifier );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_AnyValueVerifier
        *
        * @return Amoss_ValueVerifier - The Amoss_AnyValueVerifier
        */
        public Amoss_ValueVerifier buildAnyVerifier() {
            return new Amoss_AnyValueVerifier();
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_NotNullValueVerifier
        *
        * @return Amoss_ValueVerifier - The Amoss_NotNullValueVerifier
        */
        public Amoss_ValueVerifier buildNotNullVerifier() {
            return new Amoss_NotNullValueVerifier();
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_NotEmptyStringValueVerifier
        *
        * @return Amoss_ValueVerifier - The Amoss_NotEmptyStringValueVerifier
        */
        public Amoss_ValueVerifier buildNotEmptyStringVerifier() {
            return new Amoss_NotEmptyStringValueVerifier();
        }
    }

    public virtual class Amoss_AssertionFailureException extends Exception {

        private String message;

        /**
        * Set the message for failed assertion that this exception represents
        *
        * @param String - The assertion message for this exception.
        */
        public Amoss_AssertionFailureException setAssertionMessage( String message ) {
            this.message = message;
            return this;
        }

        /**
        * Adds more context to the current message on this exception.
        *
        * @param String - The context to add to the message, being a string containing {0}, the place the original message should exist
        */
        public Amoss_AssertionFailureException addContextToMessage( String context ) {
            this.message = String.format( context, new List<String>{ this.message } );
            return this;
        }

        /**
        * Issue an assertion failure based on the current configuration
        */
        public virtual void issueAsserton( Amoss_Asserts assertionMechanism ) {
            assertionMechanism.assert( false, message );
        }
    }

    public class Amoss_EqualsAssertionFailureException extends Amoss_AssertionFailureException {

        private Object expected;
        private Object actual;

        /**
        * Set the expected for this exception
        *
        * @param  Object - The expected value
        * @return Amoss_EqualsAssertionFailureException - Itself, allowing for a fluent interface
        */
        public Amoss_EqualsAssertionFailureException setExpected( Object expected ) {
            this.expected = expected;
            return this;
        }

        /**
        * Set the actual for this exception
        *
        * @param  Object - The actual value
        * @return Amoss_EqualsAssertionFailureException - Itself, allowing for a fluent interface
        */
        public Amoss_EqualsAssertionFailureException setActual( Object actual ) {
            this.actual = actual;
            return this;
        }

        /**
        * Issue an assertion failure based on the current configuration
        */
        public override void issueAsserton( Amoss_Asserts assertionMechanism ) {
            String message = String.format( '{0}.\nExpected: {1}\nActual: {2}', new List<Object>{ this.message, expected, actual } );
            assertionMechanism.assert( false, message );
        }
    }

    /**
    * Internal class that should not be refenced in tests.
    *
    * Can produce a text description of a method call
    */
    private class Amoss_CallDescriber {

        /**
        * Internal method that should not be called directly in tests.
        *
        * Given a method name, and a list of parameters, will return a string representation of it
        */
        public String getCallDescription( String method, List<Object> parameters ) {
            return String.format( '{0}({1})', new List<String>{ method, String.join( parameters, ', ' ) } );
        }
    }

    //
    // Callout Mock grammer and verifiers
    //
    /**
     * The part of the grammar that allows the specification of the behaviour of a Mock Http Callout instance,
     * defining whether requests are expected / allowed, and allow entry into the part of the grammer that
     * defines what should happen in what situation.
     *
     */
    public class Amoss_CalloutMockDefiner {

        Amoss_Instance instance;

        public Amoss_CalloutMockDefiner( Amoss_Instance instance ) {

            this.instance = instance;
            try {
                Test.setMock( HttpCalloutMock.class, (HttpCalloutMock)this.instance.generateDouble() );
            } catch( Exception e ) {
                throw new Amoss_NotAnHttpCalloutMockException( 'Attempted to create an Http Callout Mock when the Amoss_Instance is not a test double of a class or interface that implements HttpCalloutMock\n' + e.getMessage(), e );
            }
        }

        /**
        * States that a request of the provided shape is 'expected' and that the test should fail
        * if it does not happen, or a different request is made.
        *
        * For example:
        *   .expects()
        *       .method( 'GET' )
        *       .endpoint().containing( 'account/xxxxx' )
        *   .respondsWith()
        *       .body( '{some JSON}' )
        *
        */
        public Amoss_CalloutMockRequestDefiner expects() {
            return new Amoss_CalloutMockRequestDefiner( instance.expects( 'respond' ) );
        }

        /**
        * States that what should happen 'when' a request of the provided shape is sent.
        *
        * For example:
        *   .when()
        *       .method( 'GET' )
        *       .endpoint().containing( 'account/xxxxx' )
        *   .respondsWith()
        *       .body( '{some JSON}' )
        *
        */
        public Amoss_CalloutMockRequestDefiner when() {
            return new Amoss_CalloutMockRequestDefiner( instance.when( 'respond' ) );
        }

        /**
        * States that a request of the provided shape is 'allowed', implying that requests of shapes that are
        * not specified are *not* allowed.  Allows the definition of what should happen when a request of the provided shape is sent.
        *
        * For example:
        *   .allows()
        *       .method( 'GET' )
        *       .endpoint().containing( 'account/xxxxx' )
        *   .respondsWith()
        *       .body( '{some JSON}' )
        *
        */
        public Amoss_CalloutMockRequestDefiner allows() {
            return new Amoss_CalloutMockRequestDefiner( instance.allows( 'respond' ) );
        }

        /**
        * States that this double does not expect any calls against it, and that if a call is made, the test should fail.
        *
        * Example usage:
        *    new Amoss_Instance()
        *        .isACalloutMock()
        *        .expectsNoCalls();
        *
        */
        public void expectsNoCalls() {
            instance.expectsNoCalls();
        }

        /**
        * States that whatever mechanism is used to defined the 'expectations' or 'whens' against this
        * object, it will either:
        *   * True  - Allow any call to a method to be successful and for those that are not defined to return null.
        *   * False - Fail the test
        *
        * Example usage:
        *    new Amoss_Instance()
        *        .isACalloutMock()
        *        .allowsAnyCall( false )
        *        .when()
        *            .method( 'GET' )
        *            .endpoint().containing( 'account/xxxxx' )
        *            .respondsWith()
        *                .body( '{some JSON}' )
        *
        */
        public Amoss_CalloutMockDefiner allowsAnyCall( Boolean allowsAnyCall ) {
            instance.allowsAnyCall( allowsAnyCall );
            return this;
        }

        /**
        * States that when a request is made against this mock, it will return a response in the described state.
        *
        * Example usage:
        *    new Amoss_Instance()
        *        .isACalloutMock()
        *        .byDefault()
        *            .respondsWith()
        *               .statusCode( 404 )
        *               .status( 'Not Found' )
        *        .also().when()
        *            .method( 'GET' )
        *            .respondsWith()
        *                .body( '{some JSON}' )
        */
        public Amoss_CalloutMockByDefaultDefiner byDefault() {
            return new Amoss_CalloutMockByDefaultDefiner( instance );
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of the default behaviour when calling
     *
     */
    public class Amoss_CalloutMockByDefaultDefiner {

        Amoss_Instance instance;

        public Amoss_CalloutMockByDefaultDefiner( Amoss_Instance instance ) {
            this.instance = instance;
        }

        public Amoss_CalloutMockResponseDefiner respondsWith() {
            HttpResponse response = new HttpResponse();
            instance.byDefaultMethodsReturn( response );
            return new Amoss_CalloutMockResponseDefiner( instance, response );
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of the expected shape of a callout request
     *
     */
    public class Amoss_CalloutMockRequestDefiner {

        Amoss_NamedParametersMethodDefiner parametersDefiner;

        public Amoss_CalloutMockRequestDefiner( Amoss_NamedParametersMethodDefiner parametersDefiner ) {
            this.parametersDefiner = parametersDefiner;
        }

        /**
        * States the expected HTTP method of the call that this specification is describing.
        *
        * For example:
        *   .when()
        *       .method( 'GET' )
        *   .respondsWith()
        *       .body( '{some JSON}' )
        *
        * @param String - The HTTP method that is expected to be used
        */
        public Amoss_CalloutMockRequestDefiner method( String expectedHttpMethod ) {
            return new Amoss_CalloutMockRequestDefiner(
                parametersDefiner
                    .withParameterNamed( 'request' )
                    .verifiedBy( new Amoss_CalloutMockHttpMethodVerifier().setVerifier( valueVerifierBuilder.buildSameValueAsVerifier( expectedHttpMethod ) ) )
            );
        }

        /**
        * States that the given header has the specified expected properties.
        * Is immediately followed by a specification of the expected header shape.
        *
        * For example:
        *   .when()
        *       .method( 'GET' )
        *       .header( 'Authorisation' ).set()
        *       .header( 'SessionId' ).matches( '[0-9a-z]*' )
        *   .respondsWith()
        *       .body( '{some JSON}' )
        *
        * @param String - The key of the header that is to be specified
        */
        public Amoss_CalloutMockRequestHeaderValueDefiner header( String expectedHeaderKey ) {
            return new Amoss_CalloutMockRequestHeaderValueDefiner( parametersDefiner, expectedHeaderKey );
        }

        /**
        * States that the call's endpoint is expected to be the same value as the given string.
        *
        * For example:
        *   .when()
        *       .method( 'GET' )
        *       .endpoint( 'https://api.example.com/account/xxxxxxx' )
        *   .respondsWith()
        *       .body( '{some JSON}' )
        *
        * @param String - The endpoint that is expected to be called
        */
        public Amoss_CalloutMockRequestDefiner endpoint( String expectedEndpoint ) {
            return endpoint().setTo( expectedEndpoint );
        }

        /**
        * States that the call's endpoint is expected to have the specified properties.
        * Is immediately followed by a specification of the expected endpoint shape.
        *
        * Multiple specifications can be provided.
        *
        * For example:
        *   .when()
        *       .method( 'GET' )
        *       .endpoint().contains( 'https://' )
        *       .endpoint().contains( '/account/xxxxxxx' )
        *   .respondsWith()
        *       .body( '{some JSON}' )
        *
        */
        public Amoss_CalloutMockRequestEndpointValueDefiner endpoint() {
            return new Amoss_CalloutMockRequestEndpointValueDefiner( parametersDefiner );
        }

        /**
        * States that the call's body is expected to be the same value as the given string.
        *
        * For example:
        *   .when()
        *       .method( 'GET' )
        *       .body( '{some JSON}' )
        *   .respondsWith()
        *       .body( '{some other JSON}' )
        *
        * @param String - The String body that is expected to be passed
        */
        public Amoss_CalloutMockRequestDefiner body( String expectedBody ) {
            return body().setTo( expectedBody );
        }

        /**
        * States that the call's body is expected to have the specified properties.
        * Is immediately followed by a specification of the expected body shape.
        *
        * Multiple specifications can be provided.
        *
        * For example:
        *   .when()
        *       .method( 'GET' )
        *       .body.contains( '"param1":"value1"' )
        *       .body.contains( '"param2":"value2"' )
        *   .respondsWith()
        *       .body( '{some other JSON}' )
        *
        */
        public Amoss_CalloutMockRequestBodyValueDefiner body() {
            return new Amoss_CalloutMockRequestBodyValueDefiner( parametersDefiner );
        }

        /**
        * States that the call's request is expected to be compressed
        *
        * For example:
        *   .when()
        *       .method( 'POST' )
        *       .compressed()
        *   .respondsWith()
        *       .body( '{some other JSON}' )
        *
        */
        public Amoss_CalloutMockRequestDefiner compressed() {
            return new Amoss_CalloutMockRequestDefiner(
                parametersDefiner
                    .withParameterNamed( 'request' )
                    .verifiedBy( new Amoss_CalloutMockHttpCompressedVerifier().setVerifier( valueVerifierBuilder.buildSameValueAsVerifier( true ) ) )
            );
        }

        /**
        * States that the call's request is expected to be not compressed
        *
        * For example:
        *   .when()
        *       .method( 'POST' )
        *       .notCompressed()
        *   .respondsWith()
        *       .body( '{some other JSON}' )
        *
        */
        public Amoss_CalloutMockRequestDefiner notCompressed() {
            return new Amoss_CalloutMockRequestDefiner(
                parametersDefiner
                    .withParameterNamed( 'request' )
                    .verifiedBy( new Amoss_CalloutMockHttpCompressedVerifier().setVerifier( valueVerifierBuilder.buildSameValueAsVerifier( false ) ) )
            );
        }

        /**
        * States that the call's request should be verified by the given verifier
        *
        * For example:
        *   .when()
        *       .verifiedBy( customVerifier )
        *   .respondsWith()
        *       .body( '{some other JSON}' )
        *
        */
        public Amoss_CalloutMockRequestDefiner verifiedBy( Amoss_ValueVerifier customVerifier ) {
            return new Amoss_CalloutMockRequestDefiner(
                parametersDefiner
                    .withParameterNamed( 'request' )
                    .verifiedBy( customVerifier )
            );
        }

        /**
        * States that the call's request should be verified by the given verifier
        *
        * For example:
        *   .when()
        *       .verifiedBy( customVerifier )
        *   .respondsWith()
        *       .body( '{some other JSON}' )
        *
        */
        public Amoss_CalloutMockRequestDefiner verifiedBy( Amoss_HttpRequestVerifier customVerifier ) {
            return new Amoss_CalloutMockRequestDefiner(
                parametersDefiner
                    .withParameterNamed( 'request' )
                    .verifiedBy( new Amoss_CalloutMockHttpRequestVerifierAdaptor().setRequestVerifier( customVerifier ) )
            );
        }

        /**
        * Switches the mode of the specification over to defining how the call will respond
        *
        * For example:
        *   .when()
        *       .method( 'POST' )
        *   .respondsWith()
        *       .body( '{some other JSON}' )
        *
        */
        public Amoss_CalloutMockResponseDefiner respondsWith() {
            HttpResponse response = new HttpResponse();
            parametersDefiner.returns( response );
            return new Amoss_CalloutMockResponseDefiner( parametersDefiner, response );
        }

        /**
        * Defines the object that should be used to handle the call made in the specification, defining the
        * response that will be generated.
        *
        * Can be passed an implementation of any of the following:
        *   * Amoss_MethodHandler
        *   * StubProvider
        *   * HttpCalloutMock
        *
        * For example:
        *   .when()
        *       .method( 'POST' )
        *       .handledBy( new CustomRequestHandler() )
        */
        public Amoss_CalloutMockNextExpectationDefiner handledBy( Amoss_MethodHandler returnHandler ) {
            return new Amoss_CalloutMockNextExpectationDefiner(
                 parametersDefiner.handledBy( returnHandler )
            );
        }

        /**
        * Defines the object that should be used to handle the call made in the specification, defining the
        * response that will be generated.
        *
        * Can be passed an implementation of any of the following:
        *   * Amoss_MethodHandler
        *   * StubProvider
        *   * HttpCalloutMock
        *
        * For example:
        *   .when()
        *       .method( 'POST' )
        *       .handledBy( new CustomRequestHandler() )
        */
        public Amoss_CalloutMockNextExpectationDefiner handledBy( StubProvider returnHandler ) {
            return new Amoss_CalloutMockNextExpectationDefiner(
                 parametersDefiner.handledBy( returnHandler )
            );
        }

        /**
        * Defines the object that should be used to handle the call made in the specification, defining the
        * response that will be generated.
        *
        * Can be passed an implementation of any of the following:
        *   * Amoss_MethodHandler
        *   * StubProvider
        *   * HttpCalloutMock
        *
        * For example:
        *   .when()
        *       .method( 'POST' )
        *       .handledBy( new CustomRequestHandler() )
        */
        public Amoss_CalloutMockNextExpectationDefiner handledBy( HttpCalloutMock returnHandler ) {
            return new Amoss_CalloutMockNextExpectationDefiner(
                 parametersDefiner.handledBy( new Amoss_CalloutMockHttpHandlerAdaptor( returnHandler ) )
            );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the call show throw the given exception.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'GET' )
        *       .throws( new CalloutException( 'Unable to tunnel through proxy. Proxy returns "HTTP/1.1 503 Service Unavailable"' ) );
        *
        * Has 'throwing' and 'willThrow' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Exception - The Exception to throw when this expectation is met.
        */
        public Amoss_CalloutMockNextExpectationDefiner throws( Exception exceptionToThrow ) {
            return new Amoss_CalloutMockNextExpectationDefiner(
                parametersDefiner.throws( exceptionToThrow )
            );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the call show throw the given exception.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'GET' )
        *       .willThrow( new CalloutException( 'Unable to tunnel through proxy. Proxy returns "HTTP/1.1 503 Service Unavailable"' ) );
        *
        * Has 'throws' and 'throwing' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Exception - The Exception to throw when this expectation is met.
        */
        public Amoss_CalloutMockNextExpectationDefiner willThrow( Exception exceptionToThrow ) {
            return throws( exceptionToThrow );
        }

        /**
        * States that when this 'expectation' or 'when' is met, the call show throw the given exception.
        *
        * For example, to specify:
        *   .expects()
        *       .method( 'GET' )
        *       .throwing( new CalloutException( 'Unable to tunnel through proxy. Proxy returns "HTTP/1.1 503 Service Unavailable"' ) );
        *
        * Has 'throws' and 'willThrow' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        * @param Exception - The Exception to throw when this expectation is met.
        */
        public Amoss_CalloutMockNextExpectationDefiner throwing( Exception exceptionToThrow ) {
            return throws( exceptionToThrow );
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of the expected shape of a string property.
     * For example, a header.
     *
     * Is sub-classed for particular properties, so that the verifier used to specify the
     * property being checked can be specified.
     */
    public abstract class Amoss_CalloutMockRequestStringPropertyDefiner {

        Amoss_NamedParametersMethodDefiner  parametersDefiner;
        Amoss_CalloutMockHttpHeaderVerifier verifier;

        public Amoss_CalloutMockRequestStringPropertyDefiner( Amoss_NamedParametersMethodDefiner parametersDefiner ) {
            this.parametersDefiner = parametersDefiner;
        }

        private Amoss_CalloutMockRequestDefiner define( Amoss_ValueVerifier propertyVerifier ) {
            return new Amoss_CalloutMockRequestDefiner(
                parametersDefiner
                    .withParameterNamed( 'request' )
                    .verifiedBy( buildBaseVerifier().setVerifier( propertyVerifier ) )
            );
        }

        protected abstract Amoss_CalloutMockRequestVerifier buildBaseVerifier();

        /**
        * States that the specified property should be 'set' (meaning not empty) in order to match the specified expectation.
        *
        * For example, to specify:
        *   .expects()
        *       .endpoint().set()
        */
        public Amoss_CalloutMockRequestDefiner set() {
            return define( valueVerifierBuilder.buildNotEmptyStringVerifier() );
        }

        /**
        * States the value that the specified property should be 'setTo' in order to match the specified expectation.
        *
        * For example, to specify:
        *   .expects()
        *       .method( 'GET' )
        *       .endpoint().setTo( 'https://api.example.com/account/12345' )
        *
        * @param String - The value that the property is expected to be
        */
        public Amoss_CalloutMockRequestDefiner setTo( String expectedValue ) {
            return define( valueVerifierBuilder.buildSameValueAsVerifier( expectedValue ) );
        }

        /**
        * States a value that the specified property should 'contain' in order to match the specified expectation.
        *
        * For example, to specify:
        *   .expects()
        *       .method( 'GET' )
        *       .endpoint().containing( '/account/12345' )
        *
        * @param String - The value that the property is expected to contain
        */
        public Amoss_CalloutMockRequestDefiner containing( String expectedValue ) {
            return define( valueVerifierBuilder.buildContainingStringVerifier( expectedValue ) );
        }

        /**
        * States a regular expression that the specified property should 'match' in order to match the specified expectation.
        *
        * Note, in line with Apex and Java's regular expression 'match' method, the *whole* of the property is required to match.
        *
        * For example, to specify:
        *   .expects()
        *       .method( 'GET' )
        *       .endpoint().matching( 'http.*account/[0-9]*' )
        *
        * @param String - The regular expression that the property is expected to match
        */
        public Amoss_CalloutMockRequestDefiner matching( String expectedValue ) {
            return define( valueVerifierBuilder.buildMatchingExpressionVerifier( expectedValue ) );
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of the expected shape of a given request's header
     *
     * Is sub-classed for particular properties, so that the verifier used to specify the
     * property being checked can be specified.
     */
    public class Amoss_CalloutMockRequestHeaderValueDefiner extends Amoss_CalloutMockRequestStringPropertyDefiner {

        String expectedHeaderKey;

        public Amoss_CalloutMockRequestHeaderValueDefiner( Amoss_NamedParametersMethodDefiner parametersDefiner, String expectedHeaderKey ) {
            super( parametersDefiner );
            this.expectedHeaderKey = expectedHeaderKey;
        }

        /**
         * Builds the verifier that is used to verify the Header on an HttpRequest object
         */
        protected override Amoss_CalloutMockRequestVerifier buildBaseVerifier() {
            return new Amoss_CalloutMockHttpHeaderVerifier( expectedHeaderKey );
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of the expected shape of a given request's endpoint
     *
     * Is sub-classed for particular properties, so that the verifier used to specify the
     * property being checked can be specified.
     */
    public class Amoss_CalloutMockRequestEndpointValueDefiner extends Amoss_CalloutMockRequestStringPropertyDefiner {

        public Amoss_CalloutMockRequestEndpointValueDefiner( Amoss_NamedParametersMethodDefiner parametersDefiner ) {
            super( parametersDefiner );
        }

        /**
         * Builds the verifier that is used to verify the Endpoint on an HttpRequest object
         */
        protected override Amoss_CalloutMockRequestVerifier buildBaseVerifier() {
            return new Amoss_CalloutMockHttpEndpointVerifier();
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of the expected shape of a given request's body
     *
     * Is sub-classed for particular properties, so that the verifier used to specify the
     * property being checked can be specified.
     */
    public class Amoss_CalloutMockRequestBodyValueDefiner extends Amoss_CalloutMockRequestStringPropertyDefiner {

        public Amoss_CalloutMockRequestBodyValueDefiner( Amoss_NamedParametersMethodDefiner parametersDefiner ) {
            super( parametersDefiner );
        }

        /**
         * Builds the verifier that is used to verify the Body on an HttpRequest object
         */
        protected override Amoss_CalloutMockRequestVerifier buildBaseVerifier() {
            return new Amoss_CalloutMockHttpBodyVerifier();
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification that another expectation is about to be defined.
     *
     * Is sub-classed so it can be used at different points of the overall grammar
     */
    public virtual class Amoss_CalloutMockNextExpectationDefiner {

        protected Amoss_NextExpectationDefiner nextExpectationDefiner;

        public Amoss_CalloutMockNextExpectationDefiner( Amoss_NextExpectationDefiner nextExpectationDefiner ) {
            this.nextExpectationDefiner = nextExpectationDefiner;
        }

        /**
        * Allows another 'expectation' or 'when' to be defined against the Http Callout Mock
        *
        * Is actually synonymous with 'also'.
        *
        * For example:
        * .then().expects()
        *       .method( 'GET' )
        */
        public Amoss_CalloutMockDefiner then() {
            return new Amoss_CalloutMockDefiner( nextExpectationDefiner.then() );
        }

        /**
        * Allows another 'expectation' or 'when' to be defined against the Http Callout Mock
        *
        * Is actually synonymous with 'then'.
        *
        * For example:
        * .also().expects()
        *       .method( 'GET' )
        */
        public Amoss_CalloutMockDefiner also() {
            return then();
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of the response that is to be returned.
     */
    public class Amoss_CalloutMockResponseDefiner {

        HttpResponse response;
        Object returnsDefiner;

        public Amoss_CalloutMockResponseDefiner( Object returnsDefiner, HttpResponse response ) {
            this.returnsDefiner = returnsDefiner;
            this.response       = response;
        }

        /**
        * Allows another 'expectation' or 'when' to be defined against the Http Callout Mock
        *
        * Is actually synonymous with 'also'.
        *
        * For example:
        * .then().expects()
        *       .method( 'GET' )
        */
        public Amoss_CalloutMockDefiner then() {
            Amoss_Instance nextDefiner;
            // TODO: should be cleaned up - probably a class structure
            if ( returnsDefiner instanceOf Amoss_Instance ) {
                nextDefiner = (Amoss_Instance)returnsDefiner;
            } else {
                nextDefiner = ((Amoss_Thenable)returnsDefiner).then();
            }
            return new Amoss_CalloutMockDefiner( nextDefiner );
        }

        /**
        * Allows another 'expectation' or 'when' to be defined against the Http Callout Mock
        *
        * Is actually synonymous with 'then'.
        *
        * For example:
        * .also().expects()
        *       .method( 'GET' )
        */
        public Amoss_CalloutMockDefiner also() {
            return then();
        }

        /**
        * Specifies the status code that will be returned on the HttpResponse when the current expectation is matched.
        *
        * For example:
        * .when()
        *   .method( 'GET' )
        *   .respondsWith()
        *       .statusCode( 404 )
        */
        public Amoss_CalloutMockResponseDefiner statusCode( Integer statusCode ) {
            response.setStatusCode( statusCode );
            return this;
        }

        /**
        * Specifies the status that will be returned on the HttpResponse when the current expectation is matched.
        *
        * For example:
        * .when()
        *   .method( 'GET' )
        *   .respondsWith()
        *       .status( 'Complete' )
        */
        public Amoss_CalloutMockResponseDefiner status( String status ) {
            response.setStatus( status );
            return this;
        }

        /**
        * Specifies the body that will be returned on the HttpResponse when the current expectation is matched.
        *
        * For example:
        * .when()
        *   .method( 'GET' )
        *   .respondsWith()
        *       .body( 'the body' )
        */
        public Amoss_CalloutMockResponseDefiner body( String body ) {
            response.setBody( body );
            return this;
        }

       /**
        * Specifies the blob value of the body that will be returned on the HttpResponse when the current expectation is matched.
        *
        * For example:
        * .when()
        *   .method( 'GET' )
        *   .respondsWith()
        *       .body( blobValue )
        */
        public Amoss_CalloutMockResponseDefiner body( Blob body ) {
            response.setBodyAsBlob( body );
            return this;
        }

       /**
        * Specifies the body that will be returned on the HttpResponse when the current expectation is matched.
        *
        * The body will be JSON serialized at the point the method is called.
        *
        * For example:
        * .when()
        *   .method( 'GET' )
        *   .respondsWith()
        *       .body( objectValue )
        */
        public Amoss_CalloutMockResponseDefiner body( Object body ) {
            response.setBody( JSON.serialize( body ) );
            return this;
        }

       /**
        * Specifies a header that will be set on the HttpResponse when the current expectation is matched.
        *
        * For example:
        * .when()
        *   .method( 'GET' )
        *   .respondsWith()
        *       .header( 'Authorised' ).setTo( 'true' )
        */
        public Amoss_CalloutMockResponseHeaderDefiner header( String key ) {
            return new Amoss_CalloutMockResponseHeaderDefiner( this, response, key );
        }
    }

    /**
     * The part of the http mock callout grammar that allows the specification of a header on the response that is to be returned.
     */
    public class Amoss_CalloutMockResponseHeaderDefiner {

        String headerKey;
        HttpResponse response;
        Amoss_CalloutMockResponseDefiner responseDefiner;

        public Amoss_CalloutMockResponseHeaderDefiner( Amoss_CalloutMockResponseDefiner responseDefiner, HttpResponse response, String headerKey ) {
            this.headerKey       = headerKey;
            this.response        = response;
            this.responseDefiner = responseDefiner;
        }

        /**
        * Specifies a value that the specified header will be set on the HttpResponse when the current expectation is matched.
        *
        * For example:
        * .when()
        *   .method( 'GET' )
        *   .respondsWith()
        *       .header( 'Authorised' ).setTo( 'true' )
        */
        public Amoss_CalloutMockResponseDefiner setTo( String headerValue ) {
            response.setHeader( headerKey, headerValue );
            return responseDefiner;
        }
    }

    /**
     * Verifier that can be used to check the properties of an HttpRequest object.
     *
     * Verification of the property is actually performed by a verifer that is set as a member variable, allowing for
     * any type of verification to be performed (e.g. set / setTo / contains )
     *
     * Is subclassed, with the method 'verifyValue' overridden in order to retrieve the correct property from the request.
     */
    private abstract class Amoss_CalloutMockRequestVerifier implements Amoss_ValueVerifier {

        protected Amoss_ValueVerifier verifier;

        public Amoss_CalloutMockRequestVerifier setVerifier( Amoss_ValueVerifier verifier ) {
            this.verifier = verifier;
            return this;
        }

        protected abstract void verifyValue( HttpRequest actualRequest );

        public void verify( Object actualValue ) {

            if ( ! (actualValue instanceOf HttpRequest) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'HttpRequest' )
                            .setActual( Amoss_Asserts.getType( actualValue ) )
                            .setAssertionMessage( 'The value is not what was expected - The types do not match' );
            }

            verifyValue( (HttpRequest)actualValue );
        }
    }

    /**
     * An adaptor for Amoss_HttpRequestVerifier that allows it to operate as an Amoss_ValueVerifier
     */
    private class Amoss_CalloutMockHttpRequestVerifierAdaptor extends Amoss_CalloutMockRequestVerifier {

        protected Amoss_HttpRequestVerifier requestVerifier;

        public Amoss_CalloutMockHttpRequestVerifierAdaptor setRequestVerifier( Amoss_HttpRequestVerifier requestVerifier ) {
            this.requestVerifier = requestVerifier;
            return this;
        }

        public override String toString() {
            return requestVerifier.toString();
        }

        protected override void verifyValue( HttpRequest actualRequest ) {
            requestVerifier.verify( actualRequest );
        }
    }

    /**
     * Verifier that can be used to check the properties of the method on an HttpRequest object.
     *
     * Verification of the property is actually performed by a verifer that is set as a member variable, allowing for
     * any type of verification to be performed (e.g. set / setTo / contains )
     *
     */
    private class Amoss_CalloutMockHttpMethodVerifier extends Amoss_CalloutMockRequestVerifier {

        public override String toString() {
            return 'HttpRequest with the method ' + verifier.toString();
        }

        protected override void verifyValue( HttpRequest actualRequest ) {
            try {
                verifier.verify( actualRequest.getMethod() );
            } catch ( Amoss_AssertionFailureException e ) {
                throw e.addContextToMessage( 'Method is not what was expected: {0}' );
            }
        }
    }

    /**
     * Verifier that can be used to check the properties of the endpoint on an HttpRequest object.
     *
     * Verification of the property is actually performed by a verifer that is set as a member variable, allowing for
     * any type of verification to be performed (e.g. set / setTo / contains )
     *
     */
    private class Amoss_CalloutMockHttpEndpointVerifier extends Amoss_CalloutMockRequestVerifier {

        public override String toString() {
            return 'HttpRequest with the endpoint ' + verifier.toString();
        }

        protected override void verifyValue( HttpRequest actualRequest ) {
            try {
                verifier.verify( actualRequest.getEndpoint() );
            } catch ( Amoss_AssertionFailureException e ) {
                throw e.addContextToMessage( 'Endpoint is not what was expected: {0}' );
            }
        }
    }

    /**
     * Verifier that can be used to check the properties of the body on an HttpRequest object.
     *
     * Verification of the property is actually performed by a verifer that is set as a member variable, allowing for
     * any type of verification to be performed (e.g. set / setTo / contains )
     *
     */
    private class Amoss_CalloutMockHttpBodyVerifier extends Amoss_CalloutMockRequestVerifier {

        public override String toString() {
            return 'HttpRequest with the body ' + verifier.toString();
        }

        protected override void verifyValue( HttpRequest actualRequest ) {
            try {
                verifier.verify( actualRequest.getBody() );
            } catch ( Amoss_AssertionFailureException e ) {
                throw e.addContextToMessage( 'Body is not what was expected: {0}' );
            }
        }
    }

    /**
     * Verifier that can be used to check the properties of a header on an HttpRequest object.
     *
     * Verification of the property is actually performed by a verifer that is set as a member variable, allowing for
     * any type of verification to be performed (e.g. set / setTo / contains )
     *
     */
    private class Amoss_CalloutMockHttpHeaderVerifier extends Amoss_CalloutMockRequestVerifier {

        String headerKey;

        public Amoss_CalloutMockHttpHeaderVerifier( String headerKey ) {
            this.headerKey = headerKey;
        }

        public override String toString() {
            return 'HttpRequest with the header "' + headerKey + '" ' + verifier.toString();
        }

        protected override void verifyValue( HttpRequest actualRequest ) {
            try {
                verifier.verify( actualRequest.getHeader( headerKey ) );
            } catch ( Amoss_AssertionFailureException e ) {
                throw e.addContextToMessage( 'Header "' + headerKey + '" is not what was expected: {0}' );
            }
        }
    }

    /**
     * Verifier that can be used to check the properties of the 'compressed' property on an HttpRequest object.
     *
     * Verification of the property is actually performed by a verifer that is set as a member variable, allowing for
     * any type of verification to be performed (e.g. set / setTo / contains )
     *
     */
    private class Amoss_CalloutMockHttpCompressedVerifier extends Amoss_CalloutMockRequestVerifier {

        public override String toString() {
            return 'HttpRequest with the compressed ' + verifier.toString();
        }

        protected override void verifyValue( HttpRequest actualRequest ) {
            try {
                verifier.verify( actualRequest.getCompressed() );
            } catch ( Amoss_AssertionFailureException e ) {
                throw e.addContextToMessage( 'Compressed is not what was expected: {0}' );
            }
        }
    }

    /**
     * An adaptor for making the HttpCalloutMock compatible with Amoss as an Amoss_MethodHandler
     *
     */
    private class Amoss_CalloutMockHttpHandlerAdaptor implements Amoss_MethodHandler {

        HttpCalloutMock standardHandler;

        public Amoss_CalloutMockHttpHandlerAdaptor( HttpCalloutMock standardHandler ) {
            this.standardHandler = standardHandler;
        }

        public Object handleMethodCall( List<Object> parameters ) {

            // I'm really not sure how any of these error conditions could ever occur.
            // I certainly can't think of a way of unit testing them without making the class public
            // or testVisible, neither of which do I think is appropriate.
            // That said, it seems that this is a sensible chunk of checking, just in case I've missed
            // something.
            if ( parameters.size() != 1 ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( '1 parameter, being an HttpRequest' )
                            .setActual( parameters )
                            .setAssertionMessage( 'HttpCalloutMock handler was called with the wrong number of parameters' );
            }

            if ( parameters[0] == null ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'HttpRequest' )
                            .setActual( 'null' )
                            .setAssertionMessage( 'HttpCalloutMock handler was called with a null first parameter' );
            }

            if ( ! ( parameters[0] instanceOf HttpRequest ) ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( 'HttpRequest' )
                            .setActual( parameters[0] )
                            .setAssertionMessage( 'HttpCalloutMock handler was called with an object that was not an HttpCalloutMock' );
            }

            return standardHandler.respond( (HttpRequest)parameters[0] );
        }
    }
}