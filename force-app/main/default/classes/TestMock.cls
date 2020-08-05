public class TestMock implements StubProvider {

    private TestExpectations expectations = new TestExpectations();
    private TestExpectations whens        = new TestExpectations();

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
}