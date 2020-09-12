@isTest
public class Amoss_Instance implements StubProvider {

    class CallLogException extends Exception {}

    private Amoss_Expectations expectations = new Amoss_Expectations();
    private Amoss_Expectations whens        = new Amoss_Expectations();
    private CallLog            callLog      = new CallLog();

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
    public Object generateMock() {
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
    public CallChecker get() {
        return new CallChecker( callLog );
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
    public CallChecker call( Integer callNumber ) {
        return new CallChecker( callLog ).call( callNumber );
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
    public CallChecker latestCallOf( String method ) {
        return new CallChecker( callLog ).latestCallOf( method );
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

        callLog.addEntry( new CallLogEntry().setMethod( mockedMethod ).setParameters( parameters ) );

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
    public class CallChecker {

        String method;
        Integer callNumber;
        Integer parameterNumber;

        CallLog callLog;

        public CallChecker( CallLog callLog ) {
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
        public CallChecker of( String method ) {
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
        public CallChecker call( Integer callNumber ) {
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
        public CallChecker latestCallOf( String method ) {
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
    private class CallLogEntry {

        String       method;
        List<Object> parameters;

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the name of the method that this stack represents.
        */
        public CallLogEntry setMethod( String method ) {
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
        public CallLogEntry setParameters( List<Object> parameters ) {
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
                throw new CallLogException( method + ' was not called' );
            }
            if ( parameters.size() == 0 ) {
                throw new CallLogException( method + ' was not called with any parameters' );
            }

            if ( parameters.size() < parameterNumber + 1 ) {
                throw new CallLogException( method + ' was not called with ' + ( parameterNumber + 1 ) + ' parameters' );
            }
            if ( parameterNumber < 0 ) {
                throw new CallLogException( 'Cannot request a negative parameter number (got ' + parameterNumber + ')' );
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
                throw new CallLogException( method + ' was not called' );
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
    private class CallLog {

        Map<String,List<CallLogEntry>> callLogEntries = new Map<String,List<CallLogEntry>>();

        /**
        * Internal method that should not be called directly in tests.
        *
        * Adds the given call log entry to the call stack.
        *
        * @param CallLogEntry - The call log entry to add.
        */
        public CallLog addEntry( CallLogEntry entry ) {
            if ( ! callLogEntries.containsKey( entry.getMethod() ) ) {
                callLogEntries.put( entry.getMethod(), new List<CallLogEntry>() );
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
        public CallLogEntry getCallLog( String method, Integer callNumber ) {

            if ( ! callLogEntries.containsKey( method ) ) {
                throw new CallLogException( method + ' was never called' );
            }
            if ( callNumber >= callLogEntries.get( method ).size() ) {
                throw new CallLogException( method + ' was not called ' + ( callNumber + 1 ) + ' times' );
            }
            if ( ( callLogEntries.get( method ).size() + callNumber ) < 0 ) {
                throw new CallLogException( method + ' was not called ' + ( Math.abs( callNumber ) ) + ' times' );
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
}