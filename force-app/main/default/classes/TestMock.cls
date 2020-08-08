public class TestMock implements StubProvider {

    class CallLogException extends Exception {}

    private TestExpectations expectations = new TestExpectations();
    private TestExpectations whens        = new TestExpectations();
    private CallLog          callLog      = new CallLog();

    Type classType;

    public TestMock( Type classType ) {
        this.classType = classType;
    }

    public String getClassName() {
        return String.valueOf( this.classType );
    }

    public Object proxy() {
        return Test.createStub( classType, this );
    }

    public TestExpectation expects() {
        TestExpectation newExpectation = new TestExpectation( this );
        this.expectations.add( newExpectation );
        return newExpectation;
    }

    public TestExpectation when() {
        TestExpectation newExpectation = new TestExpectation( this );
        this.whens.add( newExpectation );
        return newExpectation;
    }

    public Object handleMethodCall( Object       mockedObject,
                                    String       mockedMethod,
                                    Type         returnType,
                                    List<Type>   parameterTypes,
                                    List<String> parameterNames,
                                    List<Object> parameters ) {

        callLog.addEntry( new CallLogEntry().setMethod( mockedMethod ).setParameters( parameters ) );

        if ( whens.hasExpectations() ) {
            TestExpectation whenExpectation = whens.getMatchingExpectation( mockedMethod, parameters );
            if ( whenExpectation != null ) {
                return whenExpectation.getReturnValue();
            }
        }

        System.assertEquals( false, expectations.isEmpty(), String.format( '{0}.{1} was called more times than was expected', new List<String>{ getClassName(), mockedMethod } ) );
        TestExpectation thisExpectation = expectations.unshift();
        thisExpectation.verify( mockedMethod, parameters );
        return thisExpectation.getReturnValue();
    }

    public void verify() {
        System.assertEquals( '', expectations.getRemainingCallsDescription(), 'Expected call stack for ' + getClassName() + ' should be empty, and it is not' );
    }


    private String getCalledMethodContext;
    private Integer getCalledCallNumberContext;
    private Integer getCalledParameterNumberContext;

    public TestMock of( String method ) {
        this.getCalledMethodContext = method;
        return this;
    }

    public TestMock call( Integer callNumber ) {
        if ( callNumber > 0 ) {
            this.getCalledCallNumberContext = callNumber;
        } else {
            this.getCalledCallNumberContext = callLog.numberOfCalls( this.getCalledMethodContext ) - callNumber;
        }
        return this;
    }

    public TestMock latestCallOf( String method ) {
        this.getCalledMethodContext     = method;
        this.getCalledCallNumberContext = callLog.numberOfCalls( this.getCalledMethodContext );
        return this;
    }

    public Object parameter( Integer parameterNumber ) {
        this.getCalledParameterNumberContext = parameterNumber;
        return callLog.getCallLogParameter( this.getCalledMethodContext, this.getCalledCallNumberContext, this.getCalledParameterNumberContext );
    }

    public List<Object> parameters() {
        return callLog.getCallLogParameters( this.getCalledMethodContext, this.getCalledCallNumberContext );
    }

    private class CallLogEntry {

        String       method;
        List<Object> parameters;

        public CallLogEntry setMethod( String method ) {
            this.method = method;
            return this;
        }

        public String getMethod() {
            return this.method;
        }

        public CallLogEntry setParameters( List<Object> parameters ) {
            this.parameters = parameters;
            return this;
        }

        public Object getParameter( Integer parameterNumber ) {
            // TODO throw exception if not there
            return parameters[ parameterNumber ];
        }

        public List<Object> getParameters() {
            // TODO throw exception if not there
            return parameters;
        }
    }

    private class CallLog {

        Map<String,List<CallLogEntry>> callLogEntries = new Map<String,List<CallLogEntry>>();

        public CallLog addEntry( CallLogEntry entry ) {
            if ( ! callLogEntries.containsKey( entry.getMethod() ) ) {
                callLogEntries.put( entry.getMethod(), new List<CallLogEntry>() );
            }
            callLogEntries.get( entry.getMethod() ).add( entry );
            return this;
        }

        public CallLogEntry getCallLog( String method, Integer callNumber ) {
            if ( ! callLogEntries.containsKey( method ) ) {
                throw new CallLogException( method + ' was never called' );
            }

            if ( callLogEntries.get( method ).size() < callNumber ) {
                throw new CallLogException( method + ' was not called ' + callNumber + ' times' );
            }
            
            return callLogEntries.get( method )[ callNumber - 1 ];
        }

        public Integer numberOfCalls( String method ) {

            if ( ! callLogEntries.containsKey( method ) ) {
                return 0;
            }

            return callLogEntries.get( method ).size();
        }

        public Object getCallLogParameter( String method, Integer callNumber, Integer parameterNumber ) {
            return getCallLog( method, callNumber ).getParameter( parameterNumber );
        }

        public List<Object> getCallLogParameters( String method, Integer callNumber ) {
            return getCallLog( method, callNumber ).getParameters();
        }

    }
}