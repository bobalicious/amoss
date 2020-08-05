public class TestExpectation {

    // TODO: add the object name into this, so we can give a better message - can now mockControl.getClassName()

    private String expectedMethod;
    private List<Object> expectedParameters = new List<Object>();
    private Boolean withAnyParameters = false;
    private Object returnValue;
    private Exception exceptionToThrow;

    private TestMock mockControl;

    private String className {
        get {
            return mockControl.getClassName();
        }
    }

    public TestExpectation( TestMock mockControl ) {
        this.mockControl = mockControl;
    }

    public TestMock then() {
        return this.mockControl;
    }

    public TestMock also() {
        return then();
    }

    public TestExpectation method( String method ) {
        this.expectedMethod = method;
        return this;
    }

    public TestExpectation withAnyParameters() {
        this.withAnyParameters = true;
        return this;
    }

    public TestExpectation withAnyParameter() {
        return withAnyParameters();
    }

    public TestExpectation withParameters( Object[] parameters ) { // to encourage the shorter syntax
        this.expectedParameters = parameters;
        return this;
    }

    public TestExpectation withParameter( Object parameterValue ) {
        this.expectedParameters.add( parameterValue );
        return this;
    }

    public TestExpectation andParameter( Object parameterValue ) {
        return withParameter( parameterValue );
    }

    public TestExpectation returning( Object returnValue ) {
        this.returnValue = returnValue;
        return this;
    }

    public TestExpectation returns( Object returnValue ) {
        return returning( returnValue );
    }

    public TestExpectation throwing( Exception exceptionToThrow ) {
        this.exceptionToThrow = exceptionToThrow;
        return this;
    }

    public TestExpectation throws( Exception exceptionToThrow ) {
        return this.throwing( exceptionToThrow );
    }

    public Object getReturnValue() {
        if ( this.exceptionToThrow != null ) {
            throw this.exceptionToThrow;
        }
        return this.returnValue;
    }

    public void verify( String method, List<Object> parameterValues ) {

        System.assertEquals( expectedMethod, method, String.format( '{0}.{1} was expected to be called', new List<String>{ className, expectedMethod } ) );

        if ( withAnyParameters ) {
            return;
        }

        System.assertEquals( expectedParameters.size(), parameterValues.size(), String.format( '{0}.{1} was called with an unexpected number of parameters', new List<String>{ className, expectedMethod } ) );

        for ( Integer parameterNumber = 0; parameterNumber < expectedParameters.size(); parameterNumber++ ) {
            System.assertEquals( expectedParameters[ parameterNumber ], parameterValues[ parameterNumber ], String.format( '{0}.{1} was called with the wrong parameter value in position {2}', new List<String>{ className, expectedMethod, String.valueOf( parameterNumber ) } ) );
        }
    }

    public String getCallDescription() {
        // TODO: put the parameters in there
        return this.expectedMethod;
    }

    public Boolean matches( String mockedMethod, List<Object> parameters ) {

        if ( mockedMethod != this.expectedMethod ) {
            return false;
        }

        if ( withAnyParameters ) {
            return true;
        }

        for ( Integer parameterNumber = 0; parameterNumber < parameters.size(); parameterNumber++ ) {
            if ( expectedParameters[ parameterNumber ] != parameters[ parameterNumber ] ) {
                return false;
            }
        }

        return true;
    }
}