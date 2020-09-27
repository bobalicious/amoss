/*
MIT License

Copyright (c) 2020 Robert Baillie

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
public class Amoss_Instance implements StubProvider {

    class Amoss_CallLogException extends Exception {}

    private Amoss_Expectations expectations = new Amoss_Expectations();
    private Amoss_Expectations whens        = new Amoss_Expectations();
    private Amoss_CallLog      callLog      = new Amoss_CallLog();

    Type classType;

    private Amoss_Asserts assertionMechanism = new Amoss_Asserts();

    private Boolean allowsAnyCall                  = true;
    private Boolean allowsAnyCallExplicitlyDefined = false;
    
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
    public Amoss_Expectation expects() {
        if ( ! allowsAnyCallExplicitlyDefined ) {
            allowsAnyCall = false;
        }
        Amoss_Expectation newExpectation = new Amoss_Expectation( this );
        this.expectations.add( newExpectation );
        return newExpectation;
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
    public Amoss_Expectation when() {
        Amoss_Expectation newExpectation = new Amoss_Expectation( this );
        this.whens.add( newExpectation );
        return newExpectation;
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
    public Amoss_Expectation allows() {
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
        this.allowsAnyCallExplicitlyDefined = true;
        this.allowsAnyCall = allowsAnyCall;
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
    public Object handleMethodCall( Object       mockedObject,
                                    String       mockedMethod,
                                    Type         returnType,
                                    List<Type>   parameterTypes,
                                    List<String> parameterNames,
                                    List<Object> parameters ) {

        callLog.addEntry( new Amoss_CallLogEntry().setMethod( mockedMethod ).setParameters( parameters ) );

        if ( whens.hasExpectations() ) {
            Amoss_Expectation whenExpectation = whens.getMatchingExpectation( mockedMethod, parameters );
            if ( whenExpectation != null ) {
                return whenExpectation.getReturnValue();
            }
        }

        // We could assertEquals( ! expectations.isEmpty() ), but I do it this way so that the test for this method is clearer

        if ( allowsAnyCall == false && expectations.isEmpty() ) {
            assertionMechanism.assert( false, String.format( '{0}.{1} was called more times than was expected', new List<String>{ getClassName(), mockedMethod } ) );
        }

        if ( allowsAnyCall == false || expectations.matchesNext( mockedMethod, parameters ) ) {
            Amoss_Expectation thisExpectation = expectations.unshift();
            thisExpectation.verify( assertionMechanism, mockedMethod, parameters );
            return thisExpectation.getReturnValue();
        }
        
        return null;
    }

    /**
    * Internal method that should not be called directly in tests.
    *
    * Provides the name of the class that this mock is mimicing.
    */
    public String getClassName() {
        return String.valueOf( this.classType );
    }

    /**
    * Internal method that should not be called directly in tests.
    * 
    * Get the assertion mechanism for this mock object implementation
    *
    * @return  Amoss_Asserts - The assertionMechanism object
    */
    public Amoss_Asserts getAsserts() {
        return this.assertionMechanism;
    }
    
    /**
    * Internal method that should not be called directly in tests.
    * 
    * Set the assertion mechanism for this mock object implementation
    *
    * @param   Amoss_Asserts - The assertionMechanism
    * @return  Amoss_Instance - Itself, allowing for a fluent interface
    */
    public Amoss_Instance setAsserts( Amoss_Asserts assertionMechanism ) {
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
            return callLog.getCallLogParameter( this.method, this.callNumber, this.parameterNumber );
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
        List<Object> parameters;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the name of the method that this stack represents.
        */
        public Amoss_CallLogEntry setMethod( String method ) {
            this.method = method;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the name of the method that this stack represents.
        */
        public String getMethod() {
            return this.method;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the parameters that were passed in on this method call.
        */
        public Amoss_CallLogEntry setParameters( List<Object> parameters ) {
            this.parameters = parameters;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameter at the specified position that was passed in on this method call.
        *
        * If the parameter does not exist then an exception is thrown.
        */
        public Object getParameter( Integer parameterNumber ) {
            if ( parameters == null ) {
                throw new Amoss_CallLogException( method + ' was not called' );
            }
            if ( parameters.size() == 0 ) {
                throw new Amoss_CallLogException( method + ' was not called with any parameters' );
            }

            if ( parameters.size() < parameterNumber + 1 ) {
                throw new Amoss_CallLogException( method + ' was not called with ' + ( parameterNumber + 1 ) + ' parameters' );
            }
            if ( parameterNumber < 0 ) {
                throw new Amoss_CallLogException( 'Cannot request a negative parameter number (got ' + parameterNumber + ')' );
            }
            return parameters[ parameterNumber ];
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Gets the parameters for this call.
        *
        * If the parameters do not exist then an exception is thrown.
        */
        public List<Object> getParameters() {
            if ( parameters == null ) {
                throw new Amoss_CallLogException( method + ' was not called' );
            }
            return parameters;
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
        * Gets the parameters that were passed into the stated method at the stated call number in the stack.
        *
        * @param  String  - The method to retrieve the parameters for.
        * @return Integer - The position in the call stack to get the parameters for. Indexed from 0.  Can be negative, -1 returning the last parameter.
        * @return List<Object> - The requested parameter values.
        */
        public List<Object> getCallLogParameters( String method, Integer callNumber ) {
            return getCallLog( method, callNumber ).getParameters();
        }
    }

    /**
    * Entirely Internal class that should not be referenced at all in a test
    *
    * Describes the definition of a mock object's 'expectations' or 'whens' within a test and allows the interrogation of that definition.
    *
    */
    public with sharing class Amoss_Expectations {

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
        * @param  List<Object> - The parameter values to match against
        * @return Boolean - States if the given method and parameterValues match the next expectation.
        */
        public Boolean matchesNext(  String method, List<Object> parameterValues ) {
            return expectations.size() > 0 && expectations[0].matches( method, parameterValues );
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
            return String.join( remainingCallDescriptions, ',' );
        }

        /**
        * Given the name of a method, and a list of parameters, checks the queue to see if any expectations
        * match that definition.
        *
        * Returns the *first* expectation that does, or null if non do.
        *
        * @param  String - The name of the method to match against
        * @param  List<Object> - The parameter values to match against
        * @return Amoss_Expectation - The matching expectation
        */
        public Amoss_Expectation getMatchingExpectation( String mockedMethod, List<Object> parameters ) {

            for ( Amoss_Expectation thisExpectation : expectations ) {
                if ( thisExpectation.matches( mockedMethod, parameters ) ) {
                    return thisExpectation;
                }
            }
            return null;
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the definition and behaviour of an 'expectation' or 'when' that is defined within a test.
    *
    */
    public class Amoss_Expectation {

        private String expectedMethod;
        private Boolean withAnyParameters = true;
        private List<Amoss_ExpectationParameter> expectedParameters = new List<Amoss_ExpectationParameter>();
        private Object returnValue;
        private Exception exceptionToThrow;

        private Amoss_Instance mockControl;

        private String className {
            get {
                return mockControl.getClassName();
            }
        }

        public Amoss_Expectation( Amoss_Instance mockControl ) {
            this.mockControl = mockControl;
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
        public Amoss_Expectation method( String method ) {
            this.expectedMethod = method;
            return this;
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
        public Amoss_Expectation withAnyParameters() {
            this.withAnyParameters = true;
            return this;
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
        * Although unusual, can be followed by an andThenParameter call.
        *
        * @param Object[] - The list of parameter values that are expected
        */
        public Amoss_Expectation withParameters( Object[] parameterValues ) { // to encourage the shorter syntax
            this.withAnyParameters = false;

            this.expectedParameters = new List<Amoss_ExpectationParameter>();
            for ( Object thisParameterValue : parameterValues ) {
                this.expectedParameters.add( new Amoss_ExpectationParameter().setValue( thisParameterValue ) );
            }

            return this;
        }

        /**
        * Adds a parameter to the list of parameters that are valid for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter( 'Parameter1' )
        *       .andThenParameter( 4 )
        *       .andThenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Has 'andThenParameter' as a synonym, and these methods are entirely interchangeable based on preference.
        *
        * @param Object - The parameter value to add to the list of expected ones
        */
        public Amoss_Expectation withParameter( Object parameterValue ) {
            this.withAnyParameters = false;
            this.expectedParameters.add( new Amoss_ExpectationParameter().setValue( parameterValue ) );
            return this;
        }


        /**
        * Adds a parameter to the list of parameters that are valid for this 'expection' or 'when', it being allowed to have any value.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withAnyParameter()
        *       .thenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Has 'andThenAnyParameter' and 'thenAnyParameter' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        */
        public Amoss_Expectation withAnyParameter() {
            this.expectedParameters.add( new Amoss_ExpectationParameter().anyValue() );
            return this;
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
        * Has 'andThenAnyParameter' and 'withAnyParameter' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        */
        public Amoss_Expectation thenAnyParameter() {
            return withAnyParameter();
        }

        /**
        * Adds a parameter to the list of parameters that are valid for this 'expection' or 'when', it being allowed to have any value.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter( 'Parameter1' )
        *       .andThenAnyParameter()
        *       .andThenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Has 'thenAnyParameter' and 'withAnyParameter' as synonyms, and these methods are entirely interchangeable based on preference.
        *
        */
        public Amoss_Expectation andThenAnyParameter() {
            return withAnyParameter();
        }    

        /**
        * Adds a parameter to the list of parameters that are valid for this 'expection' or 'when'.
        *
        * For example, to specify:
        *   .when()
        *       .method( 'methodName' )
        *       .withParameter( 'Parameter1' )
        *       .andThenParameter( 4 )
        *       .andThenParameter( false )
        *       .willReturn( 'theValueItShouldReturn' )
        *
        * Has 'withParameter' and 'thenParameter' as a synonym, and these methods are entirely interchangeable based on preference.
        *
        * @param Object - The parameter value to add to the list of expected ones
        */
        public Amoss_Expectation andThenParameter( Object parameterValue ) {
            return withParameter( parameterValue );
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
        * Has 'withParameter' and 'andThenParameter' as a synonym, and these methods are entirely interchangeable based on preference.
        *
        * @param Object - The parameter value to add to the list of expected ones
        */
        public Amoss_Expectation thenParameter( Object parameterValue ) {
            return withParameter( parameterValue );
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
        public Amoss_Expectation returning( Object returnValue ) {
            this.returnValue = returnValue;
            return this;
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
        public Amoss_Expectation returns( Object returnValue ) {
            return returning( returnValue );
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
        public Amoss_Expectation willReturn( Object returnValue ) {
            return returning( returnValue );
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
        public Amoss_Expectation throwing( Exception exceptionToThrow ) {
            this.exceptionToThrow = exceptionToThrow;
            return this;
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
        public Amoss_Expectation throws( Exception exceptionToThrow ) {
            return this.throwing( exceptionToThrow );
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
        public Amoss_Expectation willThrow( Exception exceptionToThrow ) {
            return this.throwing( exceptionToThrow );
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
            return this.mockControl;
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

        /**
        * Internal method that should not be called directly in tests.
        *
        * Returns the value that this expection is defined to.  If stated that it should throw an exception, will do so.
        *
        * @return Object - The value that this expectation is configured to return
        */
        public Object getReturnValue() {
            if ( this.exceptionToThrow != null ) {
                throw this.exceptionToThrow;
            }
            return this.returnValue;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Verifies that the given method and parameter values matches the current expectation, giving a clear description of what is wrong if the verification fails.
        *
        * @param String - The method to check this expectation against.
        * @param List<Object> - The parameters to check this expectation against.
        */
        public void verify( Amoss_Asserts assertionMechanism, String method, List<Object> parameterValues ) {

            assertionMechanism.assertEquals( expectedMethod, method, String.format( '{0}.{1} was expected to be called', new List<String>{ className, expectedMethod } ) );

            if ( withAnyParameters ) {
                return;
            }

            assertionMechanism.assertEquals( expectedParameters.size(), parameterValues.size(), String.format( '{0}.{1} was called with an unexpected number of parameters', new List<String>{ className, expectedMethod } ) );

            for ( Integer parameterNumber = 0; parameterNumber < expectedParameters.size(); parameterNumber++ ) {

                if ( expectedParameters[ parameterNumber ].allowsAnyValue() ) {
                    continue;
                }
                assertionMechanism.assertEquals( expectedParameters[ parameterNumber ].getValue(), parameterValues[ parameterNumber ], String.format( '{0}.{1} was called with the wrong parameter value in position {2}', new List<String>{ className, expectedMethod, String.valueOf( parameterNumber ) } ) );
            }
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Returns a description of the current expectation's call
        *
        * @return String - A description of the current expection's call.
        */
        public String getCallDescription() {
            List<String> stringParameters = new List<String>();
            for( Object thisParameter : expectedParameters ) {
                stringParameters.add( String.valueOf( thisParameter ) );
            }
            return this.expectedMethod + '(' + String.join( stringParameters, ',' ) + ')';
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Checks if the stated call and parameters matches the current expectation's definition.
        *
        * @param String - The method to check this expectation against.
        * @param List<Object> - The parameters to check this expectation against.
        * @return Boolean - States if this expectation matches that passed passed in.
        */
        public Boolean matches( String method, List<Object> parameterValues ) {

            if ( method != this.expectedMethod ) {
                return false;
            }

            if ( withAnyParameters ) {
                return true;
            }

            for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {
                if ( ! expectedParameters[ parameterNumber ].matches( parameterValues[ parameterNumber ] ) ) {
                    return false;
                }
            }

            return true;
        }
    }

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a Parameter that is expected to be passed into a mocked method call
    *
    */
    class Amoss_ExpectationParameter {

        Boolean anyValue = false;
        Object  value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * States that this parameter can be set to any value and will match when being checked against an actual call
        *
        * @return Amoss_ExpectationParameter - Itself, allowing for a fluent interface
        */
        public Amoss_ExpectationParameter anyValue() {
            anyValue = true;
            return this;
        }

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
        * Gets the value that this parameter is expected to be.
        *
        * @return Object - The value that this parameter is expected to be.
        */
        public Object getValue() {
            return this.value;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes whether this parameter is allowed to be any value (true), or must be a specific value (false)
        *
        * @return Boolean - Is this parameter allowed to be any value?
        */
        public Boolean allowsAnyValue() {
            return anyValue;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * @return String - String description of the expected value.
        */
        public override String toString() {
            if ( anyValue ) {
                return 'any';
            }
            return String.valueOf( this.value );
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Describes if this parameter matches the value that is passed into it.
        *
        * @return Boolean - Does the passed parameter match this object's expected parameter.
        */
        public Boolean matches( Object value ) {
            if ( anyValue ) {
                return true;
            }
            return this.value == value;
        }
    }
}