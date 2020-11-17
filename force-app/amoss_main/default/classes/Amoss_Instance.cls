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
* Once configured, is used to 'generateDouble', which can then be used in place of the class being doubled.
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

    public class Amoss_CallLogException extends Exception {}
    public class Amoss_ExpectsNoCallsAndCallsConfiguredException extends Exception {}
    public class Amoss_ExpectedObjectCannotBeNullException extends Exception {}

    private Amoss_Expectations expectations = new Amoss_Expectations();
    private Amoss_Expectations whens        = new Amoss_Expectations();
    private Amoss_CallLog      callLog      = new Amoss_CallLog();

    Type classType;

    private Amoss_Asserts assertionMechanism = new Amoss_Asserts();

    private Boolean allowsAnyCall                  = true;
    private Boolean allowsAnyCallExplicitlyDefined = false;
    private Boolean expectsNoCalls                 = false;

    public enum ParameterSpecialType { ANY_VALUE }

    public static Amoss_ExpectationParameterBuilder expectationParameterBuilder = new Amoss_ExpectationParameterBuilder();

    public Amoss_Instance( Type classType ) {
        this.classType = classType;
    }

    /**
    * Generates the instance of the class that you use in the application under test.
    *
    * @return Object  - The instance to use in your test
    */
    public Object generateDouble() {
        return Test.createStub( classType, this );
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
    * expects()
    *       .method( 'methodName' )
    *       .withParameter( 'parameterValue' )
    *       .returning( 'theValueItShouldReturn' )
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
    * States that the when a method is called that matched the definition, stated behaviour will
    * be exhibited.
    *
    * Call order is not checked, and 'verify' will not check that 'whens' have been met.
    *
    * 'Whens' take higher priority than 'expectations' (I.E. if a matching 'when' is defined at call time, then it
    * will match that over the next 'expect').
    *
    * Define in the format:
    *   when()
    *   .method( 'methodName' )
    *   .withParameter( 'parameterValue' )
    *   .willReturn( 'theValueItShouldReturn' )
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
    * States that the when a method is called that matched the definition, stated behaviour will
    * be exhibited.  Very similar to 'when'
    *
    * Call order is not checked, and 'verify' will not check that 'whens' have been met.
    *
    * 'Whens' take higher priority than 'expectations' (I.E. if a matching 'when' is defined at call time, then it
    * will match that over the next 'expect').
    *
    * Define in the format:
    *   allows()
    *   .method( 'methodName' )
    *   .withParameter( 'parameterValue' )
    *   .willReturn( 'theValueItShouldReturn' )
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
    * States that whatever mechanism is used to defined the 'expectations' or 'whens' against this
    * object, it will allow any call to a method to be successful and for those that are not defined
    * to return null.
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
    * States that this double does not expect any calls against it, and that when a call is made, the test should fail.
    *
    * Example usage:
    *   expectsNoCalls()
    */
    public Amoss_Instance expectsNoCalls() {

        if ( !expectations.isEmpty() || !whens.isEmpty() ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the double expectsNoCalls when expectations or whens have been defined' );
        }

        if ( allowsAnyCallExplicitlyDefined && allowsAnyCall ) {
            throw new Amoss_ExpectsNoCallsAndCallsConfiguredException( 'Cannot state the double expectsNoCalls when allowsAnyCall has been set to true' );
        }

        this.expectsNoCalls = true;
        return this;
    }

    /**
    * Checks that all configured 'expectations' have been met, failing the test if they have not.
    *
    * Generally called immediately prior to the test's assertions.
    */
    public void verify() {
        assertionMechanism.assertEquals( '', expectations.getRemainingCallsDescription(), String.format( 'Expected call stack for {0} should be empty, and it is not', new List<String>{ getClassName() } ) );
    }

    /**
    * The start of a request for information on a call in the mock's call stack.
    *
    * Allows the object to be used as a Test Spy.
    *
    * Use in the following formats:
    *   get().call( 2 ).of( 'methodName' ).parameter( 1 )
    *   get().latestCallOf( 'methodName' ).parameter( 1 )
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
    *
    * @param Integer - The number of the call of the stated method.  Indexed from 0.  Can be negative, -1 returning the last parameter.
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
    */
    public Integer countOf( String method ) {
        return callLog.numberOfCalls( method );
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

        try {

            String callDescription = new Amoss_CallDescriber().getCallDescription( mockedMethod, parameters );

            callLog.addEntry( new Amoss_CallLogEntry().setMethod( mockedMethod ).setParameters( parameterTypes, parameterNames, parameters ) );

            if ( expectsNoCalls ) {
                assertionMechanism.assertEquals( '', callDescription, String.format( '{0} did not expect any methods to be called', new List<String>{ getClassName() } ) );
            }

            if ( whens.hasExpectations() ) {
                Amoss_Expectation whenExpectation = whens.getMatchingExpectation( mockedMethod, parameterNames, parameters );
                if ( whenExpectation != null ) {
                    return whenExpectation.getReturnValue( mockedObject, mockedMethod, returnType, parameterTypes, parameterNames, parameters );
                }
            }

            if ( allowsAnyCall == false && expectations.isEmpty() ) {
                if ( !whens.isEmpty() ) {
                    assertionMechanism.assert( false, String.format( '{0}.{1} was called more times than was expected, and no matching "when" or "allows" exists.  Was: {2}', new List<String>{ getClassName(), mockedMethod, callDescription } ) );
                } else {
                    assertionMechanism.assert( false, String.format( '{0}.{1} was called more times than was expected', new List<String>{ getClassName(), mockedMethod } ) );
                }
            }

            if ( allowsAnyCall == false || expectations.matchesNext( mockedMethod, parameterNames, parameters ) ) {
                Amoss_Expectation thisExpectation = expectations.unshift();
                thisExpectation.verify( assertionMechanism, mockedMethod, parameterNames, parameters );
                return thisExpectation.getReturnValue( mockedObject, mockedMethod, returnType, parameterTypes, parameterNames, parameters );
            }
        } catch ( Amoss_AssertionFailureException assertionFailure ) {
            assertionFailure.issueAsserton( assertionMechanism );
        }        
        return null;
    }

    /**
    * Internal method that should not be called directly in tests.
    *
    * Provides the name of the class that this mock is mimicing.
    *
    * @return - String - The name of the class
    */
    public String getClassName() {
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
        *
        * @param Integer - The number of the call of the stated method.  Indexed from 0.  Can be negative, -1 returning the last parameter.
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
            if ( parameterValues == null ) {
                throw new Amoss_CallLogException( method + ' was not called' );
            }
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
            if ( parameterValuesByName == null ) {
                throw new Amoss_CallLogException( method + ' was not called' );
            }
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
            if ( parameterValues == null ) {
                throw new Amoss_CallLogException( method + ' was not called' );
            }
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
            if ( parameterValuesByName == null ) {
                throw new Amoss_CallLogException( method + ' was not called' );
            }
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
        * @param Integer - The number of the call of the stated method.  Indexed from 0.  Can be negative, -1 returning the last parameter.
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
        * @param  Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last parameter.
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
        * @param  Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last parameter.
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
        * @return Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last parameter.
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
        * @return Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last parameter.
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
        * @return String - A description of the remaining expectations.
        */
        public String getRemainingCallsDescription() {
            List<String> remainingCallDescriptions = new List<String>();
            for ( Amoss_Expectation thisExpectation : expectations ) {
                remainingCallDescriptions.add( thisExpectation.getCallDescription() );
            }
            return String.join( remainingCallDescriptions, ', ' );
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
     * The main entry point of the grammar - the specifiecation of a method
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
            return expectation.getMockControl();
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
        * @param Object - The Exception to throw when this expectation is met.
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
        * @param Object - The Exception to throw when this expectation is met.
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
        * @param Object - The Exception to throw when this expectation is met.
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
    public class Amoss_PositionalParametersDefiner extends Amoss_ReturnsDefiner {

        public Amoss_PositionalParametersDefiner( Amoss_Expectation expectation ) {
            super( expectation );
        }

        /**
        * Adds a parameter to the list of parameters that are valid for this 'expection' or 'when'.
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
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters()).addParameter( Amoss_Instance.expectationParameterBuilder.buildEqualsParameter( parameterValue ) );
            return this;
        }        

        /**
        * Adds a parameter to the list of parameters that are valid for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter().setTo( 'Parameter1' )
        *       .thenParameter().setTo( 4 )
        *       .thenParameter().setTo( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The parameter value to add to the list of expected ones
        */
        public Amoss_PositionalParameterValueDefiner thenParameter() {
            return new Amoss_PositionalParameterValueDefiner( expectation );
        }  

        /**
        * Adds a parameter to the list of parameters that are valid for this 'expection' or 'when', it being allowed to have any value.
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
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters()).addParameter( expectationParameterBuilder.buildParameter( ParameterSpecialType.ANY_VALUE ) );
            return this;
        }      
    }

    /**
     * The part of the grammar that allows the specification of the value of a named parameter.
     * The name must have already been specified.
     *
     * At this point in the syntax, the only valid thing to do is define the parameter value.
     */
    public class Amoss_NamedParameterValueDefiner extends Amoss_ExpectationDefiner {

        String parameterName;

        public Amoss_NamedParameterValueDefiner( Amoss_Expectation expectation, String parameterName ) {
            super( expectation );
            this.parameterName = parameterName;
        }

        /**
        * States the parameter value that is expected for the the currently specified parameter.
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
        *       .andParameterNamed( 'parmeterName2' ).setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_NamedParametersDefiner setTo( Object parameterValue ) {
            return setParameter( expectationParameterBuilder.buildEqualsParameter( parameterValue ) );
        }

        /**
        * States the parameter value that is expected for the the currently specified parameter.
        *
        * In order to match an object, the passed parameter only needs to equate when serialised as a JSON string.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setToTheSameValueAs( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).setToTheSameValueAs( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_NamedParametersDefiner setToTheSameValueAs( Object parameterValue ) {
            return setParameter( expectationParameterBuilder.buildSameValueAsParameter( parameterValue ) );
        }

        /**
        * States the shape of the sobject parameter value that is expected for the the currently specified parameter.
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
        *       .andParameterNamed( 'parmeterName2' ).withFieldsSetLike( account )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_NamedParametersDefiner withFieldsSetLike( Sobject parameterValue ) {
            return setParameter( expectationParameterBuilder.buildFieldsSetLikeParameter( parameterValue ) );
        }

        /**
        * States the shape of the sobject parameter value that is expected for the the currently specified parameter.
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
        *       .andParameterNamed( 'parmeterName2' ).withFieldsSetTo( accountFieldsMap )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_NamedParametersDefiner withFieldsSetTo( Map<String,Object> parameterValue ) {
            return setParameter( expectationParameterBuilder.buildFieldsSetToParameter( parameterValue ) );
        }

        /**
        * Internal method that sets the next parameter on the expectation to that specified
        * and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ExpectationParameter - The parameter to set on the expectation
        * @return Amoss_PositionalParametersDefiner - The next definer
        */
        private Amoss_NamedParametersDefiner setParameter( Amoss_ExpectationParameter parameter ) {
            ((Amoss_ExpectationNamedParameters)expectation.getExpectationParameters()).setParameter( parameterName, parameter );
            return new Amoss_NamedParametersDefiner( expectation );
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
        * States the parameter value that is expected for the the currently specified parameter.
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
        *       .andParameter().setTo( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_PositionalParametersDefiner setTo( Object parameterValue ) {
            return setParameter( expectationParameterBuilder.buildEqualsParameter( parameterValue ) );
        }

        /**
        * States the parameter value that is expected for the the currently specified parameter.
        *
        * In order to match an object, the passed parameter only needs to equate when serialised as a JSON string.
        *
        * Is used in combination with 'withParameterNamed'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameterNamed( 'parmeterName1' ).setToTheSameValueAs( 'Parameter1' )
        *       .andParameterNamed( 'parmeterName2' ).setToTheSameValueAs( 'Parameter2' )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_PositionalParametersDefiner setToTheSameValueAs( Object parameterValue ) {
            return setParameter( expectationParameterBuilder.buildSameValueAsParameter( parameterValue ) );
        }

        /**
        * States the shape of the sobject parameter value that is expected for the the currently specified parameter.
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
        *       .andParameter().withFieldsSetLike( account )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_PositionalParametersDefiner withFieldsSetLike( Sobject parameterValue ) {
            return setParameter( expectationParameterBuilder.buildFieldsSetLikeParameter( parameterValue ) );
        }

        /**
        * States the shape of the sobject parameter value that is expected for the the currently specified parameter.
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
        *       .andParameter().withFieldsSetTo( accountFieldsMap )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * @param Object - The value of the parameter to add to the specification
        */
        public Amoss_PositionalParametersDefiner withFieldsSetTo( Map<String,Object> parameterValue ) {
            return setParameter( expectationParameterBuilder.buildFieldsSetToParameter( parameterValue ) );
        }

        /**
        * Internal method that sets the next parameter on the expectation to that specified
        * and then returns the next definer in the allowed syntax
        *
        * @param  Amoss_ExpectationParameter - The parameter to set on the expectation
        * @return Amoss_PositionalParametersDefiner - The next definer
        */
        private Amoss_PositionalParametersDefiner setParameter( Amoss_ExpectationParameter parameter ) {
            ((Amoss_ExpectationPositionalParameters)expectation.getExpectationParameters()).addParameter( parameter );
            return new Amoss_PositionalParametersDefiner( expectation );
        }        
    }

    /**
     * The part of the grammar that allows the specification of parameters based on their
     * names.  I.E. expected parameters are defined in a name and value pairing.
     */
    public class Amoss_NamedParametersDefiner extends Amoss_ReturnsDefiner {
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
            return new Amoss_NamedParameterValueDefiner( expectation, parameterName );
        }
    }

    /**
     * The part of the grammar that allows the first specification of a parameter.
     *
     * The choice of parameter specification method at this point defines the syntax that will
     * be used for the remainder of the specification - Any, Positional or Named.
     */
    public class Amoss_ParametersDefiner extends Amoss_ReturnsDefiner {
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
        *       .withAnyParameter()
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

            Amoss_ExpectationPositionalParameters expectedParameters = new Amoss_ExpectationPositionalParameters();

            for ( Object thisParameterValue : parameterValues ) {
                expectedParameters.addParameter( expectationParameterBuilder.buildEqualsParameter( thisParameterValue ) );
            }

            expectation.setExpectationParameters( expectedParameters );

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

            Amoss_ExpectationNamedParameters expectedParameters = new Amoss_ExpectationNamedParameters();

            for ( String thisParameterName : parameters.keySet() ) {
                expectedParameters.setParameter( thisParameterName, expectationParameterBuilder.buildEqualsParameter( parameters.get( thisParameterName ) ) );
            }
            expectation.setExpectationParameters( expectedParameters );

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

            Amoss_ExpectationPositionalParameters expectedParameters = new Amoss_ExpectationPositionalParameters();
            expectedParameters.addParameter( expectationParameterBuilder.buildEqualsParameter( parameterValue ) );
            expectation.setExpectationParameters( expectedParameters );

            return new Amoss_PositionalParametersDefiner( expectation );
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

            Amoss_ExpectationPositionalParameters expectedParameters = new Amoss_ExpectationPositionalParameters();
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

            Amoss_ExpectationPositionalParameters expectedParameters = new Amoss_ExpectationPositionalParameters();
            expectation.setExpectationParameters( expectedParameters );

            expectedParameters.addParameter( expectationParameterBuilder.buildParameter( ParameterSpecialType.ANY_VALUE ) );

            return new Amoss_PositionalParametersDefiner( expectation );
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
            Amoss_ExpectationNamedParameters expectedParameters = new Amoss_ExpectationNamedParameters();
            expectation.setExpectationParameters( expectedParameters );

            return new Amoss_NamedParameterValueDefiner( expectation, parameterName );
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

        private Amoss_Instance mockControl;

        private String className {
            get {
                return mockControl.getClassName();
            }
        }

        public Amoss_Expectation( Amoss_Instance mockControl ) {
            this.mockControl = mockControl;
        }

        public Amoss_Instance getMockControl() {
            return this.mockControl;
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
    private interface Amoss_ExpectationParameters {
        String getParametersDescription();
        void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues );
        Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues );
    }

    /**
    * Internal class that allows for the specification that an Expectation can have any parameters
    *
    * Always assumes that any parameters will match (since 'any' should)
    */
    private class Amoss_ExpectationAnyParameters implements Amoss_ExpectationParameters {

        /**
        * Internal method that returns a String description of the parameter values that are expected.
        *
        * Always returns 'any'
        *
        * @return String - The description of the expected parameter values
        */
        public String getParametersDescription() {
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
        public void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues ){
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
        public Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
            return true;
        }
    }

    /**
    * Internal interface that allows for the specification of parameters that an Expectation should have using 'positional' notation.
    * That is, they are specified in order.
    */
    private class Amoss_ExpectationPositionalParameters implements Amoss_ExpectationParameters {

        private List<Amoss_ExpectationParameter> expectedParameters = new List<Amoss_ExpectationParameter>();

        /**
        * Internal method that adds a parameter to the list of parameters that are valid for this Expectation.
        *
        * @param Amoss_ExpectationParameter - The parameter to add to the list of expected ones
        * @return Amoss_ExpectationParameters - Itself, allowing for a fluent interface
        */
        Amoss_ExpectationPositionalParameters addParameter( Amoss_ExpectationParameter parameter ) {
            expectedParameters.add( parameter );
            return this;
        }

        /**
        * Internal method that returns a String description of the parameter values that are expected, as a comma seperated list.
        *
        * @return String - The description of the expected parameter values
        */
        public String getParametersDescription() {
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
        public void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues ){

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
                    throw e.addContextToMessage( String.format( '{0}.{1} had a problem with the parameter value in position {2}: \'{0}\'', new List<String>{ className, method, String.valueOf( parameterNumber ) } ) );
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
        public Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
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
    private class Amoss_ExpectationNamedParameters implements Amoss_ExpectationParameters {

        private Map<String,Amoss_ExpectationParameter> expectedParameters = new Map<String,Amoss_ExpectationParameter>();

        /**
        * Internal method that sets the expected parameter with the given name, to have the given parameter.
        *
        * @param String - The name of the parameter to add to the specification
        * @param Amoss_ExpectationParameter - The representation of the parameter to add to the specification
        * @return Amoss_ExpectationNamedParameters - Itself, allowing for a fluent interface
        */
        Amoss_ExpectationNamedParameters setParameter( String parameterName, Amoss_ExpectationParameter parameter ) {
            expectedParameters.put( parameterName, parameter );
            return this;
        }

        /**
        * Internal method that returns a String description of the parameter values that are expected, rendered in a similar
        * format to a Map.
        *
        * @return String - The description of the expected parameter values
        */
        public String getParametersDescription() {
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
        public void verify( String className, String method, List<String> parameterNames, List<Object> parameterValues ){

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
                Amoss_ExpectationParameter expectationParameter = expectedParameters.get( actualParameterName );

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
        public Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
            try {
                verify( 'class', method, parameterNames, parameterValues );
            } catch ( Exception e ) {
                return false;
            }
            return true;
        }
    }

    interface Amoss_ExpectationParameter {
        String toString();
        void verify( Object value );
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of 'any' parameter value that is expected to be passed into a mocked method call
    *
    */
    class Amoss_ExpectationAnyParameter implements Amoss_ExpectationParameter {

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
        */
        public override String toString() {
            return 'any';
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if this parameter is correct for the value that is passed into it, throwing an assertion failure expectation if not.
        *
        * @param Object - The value to check
        */
        public void verify( Object actualValue ) {          //NOPMD - Amoss_ExpectationAnyParameter is a special case that behaves predominantly like a 'Null Object'
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a 'Same Instance As' Parameter that is expected to be passed into a mocked method call
    */
    class Amoss_ExpectationEqualsParameter implements Amoss_ExpectationParameter {

        Object value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expectd to be
        *
        * @param  Object - The value that this parameter is expected to be
        * @return Amoss_ExpectationParameter - Itself, allowing for a fluent interface
        */
        public Amoss_ExpectationParameter setValue( Object value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
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
    class Amoss_ExpectationSameInstanceParameter implements Amoss_ExpectationParameter {

        Object value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expectd to be
        *
        * @param  Object - The value that this parameter is expected to be (actually an Sobject)
        * @return Amoss_ExpectationParameter - Itself, allowing for a fluent interface
        */
        public Amoss_ExpectationParameter setValue( Object value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
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
    * Describes the specification of a List Parameter that is expected to be
    * the same instance when passed into a mocked method call
    */
    class Amoss_ExpectationListSameInstanceParameter implements Amoss_ExpectationParameter {

        List<Object> value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expectd to be
        *
        * @param  Object - The value that this parameter is expected to be (actually an Sobject)
        * @return Amoss_ExpectationParameter - Itself, allowing for a fluent interface
        */
        public Amoss_ExpectationParameter setValue( Object value ) {
            this.value = (List<Object>)value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
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

            // TODO: test via overloading
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
    class Amoss_ExpectationSameValueAsParameter implements Amoss_ExpectationParameter {

        Object value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expectd to be
        *
        * @param  Object - The value that this parameter is expected to be
        * @return Amoss_ExpectationParameter - Itself, allowing for a fluent interface
        */
        public Amoss_ExpectationParameter setValue( Object value ) {
            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
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
    class Amoss_ExpectationFieldsSetLikeParameter implements Amoss_ExpectationParameter {

        Sobject value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expectd to be
        *
        * @param  Sobject - The value that this parameter is expected to be
        * @return Amoss_ExpectationParameter - Itself, allowing for a fluent interface
        */
        public Amoss_ExpectationParameter setValue( Sobject value ) {

            if ( value == null ) {
                throw new Amoss_ExpectedObjectCannotBeNullException( 'Cannot specify NULL for a "FieldsSetLike" expectation' );
            }

            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
        */
        public override String toString() {
            return String.valueOf( this.value );
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
                            .setAssertionMessage( String.format( 'The following fields were not set as expected: {0}', new List<String>{ String.valueOf( fieldsWithProblems ) } ) );
            }
        }        
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of an 'Fields Set To' Parameter that is expected to be passed into a mocked method call
    */
    class Amoss_ExpectationFieldsSetToParameter implements Amoss_ExpectationParameter {

        Map<String,Object> value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expectd to be
        *
        * @param  Sobject - The value that this parameter is expected to be
        * @return Amoss_ExpectationParameter - Itself, allowing for a fluent interface
        */
        public Amoss_ExpectationParameter setValue( Map<String,Object> value ) {

            if ( value == null ) {
                throw new Amoss_ExpectedObjectCannotBeNullException( 'Cannot specify NULL for a "FieldsSetTo" expectation' );
            }

            this.value = value;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
        */
        public override String toString() {
            return String.valueOf( this.value );
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
                                .setAssertionMessage( String.format( 'Problem comparing field "{0}": {1}', new List<String>{ fieldName, e.getMessage() } ) );
                }
            }
            if ( ! fieldsWithProblems.isEmpty() ) {
                throw new Amoss_EqualsAssertionFailureException()
                            .setExpected( this.value )
                            .setActual( actualValue )
                            .setAssertionMessage( String.format( 'The following fields were not set as expected: {0}', new List<String>{ String.valueOf( fieldsWithProblems ) } ) );
            }
        }        
    }

    /**
    * Internal class that should not be refenced in tests.
    *
    * Constructs instances of Amoss_ExpectationParameter.
    */
    private class Amoss_ExpectationParameterBuilder {

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of Amoss_ExpectationParameter based on the passed Object.
        *
        * @param  Object - The parameter value that is expected for the Amoss_ExpectationParameter
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this parameter
        */
        public Amoss_ExpectationParameter buildEqualsParameter( Object parameter ) {

            // Not ideal, but since we don't want to implement multiple versions of
            // setTo in the grammer, every call to buildEqualsParameter would resolve to the Object (this)
            // version.
            // As we only want to distinguish between a couple of types, this seems the
            // simplest way.
            if ( parameter instanceOf List<Object> ) {
                return buildSameInstanceParameter( (List<Object>)parameter );
            }
            if ( Amoss_Asserts.getType( parameter ).startsWith( 'Map<' ) ) { // because of the way we can't cast Maps with different types of keys, and to avoid loads of instance of checks
                return buildSameInstanceParameter( parameter );
            }
            if ( Amoss_Asserts.getType( parameter ).startsWith( 'Set<' ) ) { // because of the way we can't cast Set, and to avoid loads of instance of checks
                return buildSameInstanceParameter( parameter );
            }
            if ( parameter instanceOf Sobject ) {
                return buildSameInstanceParameter( (Sobject)parameter );
            }

            return new Amoss_ExpectationEqualsParameter().setValue( parameter );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ExpectationSameInstanceParameter
        *
        * @param  Object - The Object parameter value that is expected for the Amoss_ExpectationParameter
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this parameter (actually a Amoss_ExpectationSameInstanceParameter)
        */
        public Amoss_ExpectationParameter buildSameInstanceParameter( Object parameter ) {
            return new Amoss_ExpectationSameInstanceParameter().setValue( parameter );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ExpectationSameInstanceParameter
        *
        * @param  Sobject - The Sobject parameter value that is expected for the Amoss_ExpectationParameter
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this parameter (actually a Amoss_ExpectationSameInstanceParameter)
        */
        public Amoss_ExpectationParameter buildSameInstanceParameter( Sobject parameter ) {
            return new Amoss_ExpectationSameInstanceParameter().setValue( parameter );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ExpectationSameInstanceParameter
        *
        * @param  List<Object> - The List parameter value that is expected for the Amoss_ExpectationParameter
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this parameter (actually a Amoss_ExpectationSameInstanceParameter)
        */
        public Amoss_ExpectationParameter buildSameInstanceParameter( List<Object> parameter ) {
            return new Amoss_ExpectationListSameInstanceParameter().setValue( parameter );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ExpectationSameValueAsParameter
        *
        * @param  Object - The Sobject parameter value that is expected for the Amoss_ExpectationParameter
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this parameter (actually a Amoss_ExpectationSameValueAsParameter)
        */
        public Amoss_ExpectationParameter buildSameValueAsParameter( Object parameter ) {
            return new Amoss_ExpectationSameValueAsParameter().setValue( parameter );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ExpectationFieldsSetLikeParameter, which checks that parameters have the same properties set as the defined parameter.
        *
        * @param  Sobject - The Sobject parameter value that is expected for the Amoss_ExpectationParameter
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this parameter (actually a Amoss_ExpectationFieldsSetLikeParameter)
        */
        public Amoss_ExpectationParameter buildFieldsSetLikeParameter( Sobject parameter ) {
            return new Amoss_ExpectationFieldsSetLikeParameter().setValue( parameter );
        }

        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ExpectationFieldsSetToParameter, which checks that parameters have the same properties set as the defined Map.
        *
        * @param  Map<String,Object> - The Map that contains the properties that are expected for the Amoss_ExpectationParameter
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this parameter (actually a Amoss_ExpectationFieldsSetToParameter)
        */
        public Amoss_ExpectationParameter buildFieldsSetToParameter( Map<String,Object> parameter ) {
            return new Amoss_ExpectationFieldsSetToParameter().setValue( parameter );
        }
        
        /**
        * Internal method that should not be refenced in tests.
        *
        * Constructs an instance of an Amoss_ExpectationSameInstanceParameter, based on the passed in ParameterSpecialType.
        *
        * @param  Object - The Special Type of Expectation Parameter object to construct
        * @return Amoss_ExpectationParameter - The appropriate Expectation Parameter instance for this passed in special type.
        */
        public Amoss_ExpectationParameter buildParameter( ParameterSpecialType parameterType ) {

            switch on parameterType {
                when ANY_VALUE {
                    return new Amoss_ExpectationAnyParameter();
                }
            }
            return new Amoss_ExpectationEqualsParameter();
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
            String message = String.format( '{0}.\nExpected: {1}\nActual: {2}', new List<String>{ this.message, String.valueOf( expected ), String.valueOf( actual ) } );
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

            List<String> stringParameters = new List<String>();
            for ( Object thisParameter : parameters ) {
                stringParameters.add( String.valueOf( thisParameter ) );
            }
            return String.format( '{0}({1})', new List<String>{ method, String.join( stringParameters, ', ' ) } );
        }
    }    
}