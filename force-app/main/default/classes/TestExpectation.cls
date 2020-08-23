/**
* Internal class that should not be referenced directly in a test
*
* Describes the definition and behaviour of an 'expectation' or 'when' that is defined within a test.
*
*/
@isTest
public class TestExpectation {

    private String expectedMethod;
    private List<TestExpectationParameter> expectedParameters = new List<TestExpectationParameter>();
    private Boolean withAnyParameters = true;
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
    public TestExpectation method( String method ) {
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
    public TestExpectation withAnyParameters() {
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
    public TestExpectation withParameters( Object[] parameterValues ) { // to encourage the shorter syntax
        this.withAnyParameters = false;

        this.expectedParameters = new List<TestExpectationParameter>();
        for ( Object thisParameterValue : parameterValues ) {
            this.expectedParameters.add( new TestExpectationParameter().setValue( thisParameterValue ) );
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
    public TestExpectation withParameter( Object parameterValue ) {
        this.withAnyParameters = false;
        this.expectedParameters.add( new TestExpectationParameter().setValue( parameterValue ) );
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
    // TODO: test at the public interface level
    public TestExpectation withAnyParameter() {
        this.expectedParameters.add( new TestExpectationParameter().anyValue() );
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
    // TODO: test at the public interface level
    public TestExpectation thenAnyParameter() {
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
    // TODO: test at the public interface level
    public TestExpectation andThenAnyParameter() {
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
    public TestExpectation andThenParameter( Object parameterValue ) {
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
    // TODO: test at the public interface level
    public TestExpectation thenParameter( Object parameterValue ) {
        return withParameter( parameterValue );
    }

    /**
    * States the value that should be returned when this 'expectation' or 'when' is met. 
    *
    * For example, to specify:
    *   ..expects()
    *       .method( 'methodName' )
    *       .returning( 'theValueItShouldReturn' )
    *
    * Has 'returns' and 'willReturn' as synonyms, and these methods are entirely interchangeable based on preference.
    *
    * @param Object - The value to return when this expectation is met.
    */
    public TestExpectation returning( Object returnValue ) {
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
    public TestExpectation returns( Object returnValue ) {
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
    public TestExpectation willReturn( Object returnValue ) {
        return returning( returnValue );
    }

    /**
    * States that when this 'expectation' or 'when' is met, the method show throw the given exception.
    *
    * For example, to specify:
    *   ..expects()
    *       .method( 'methodName' )
    *       .throwing( new DmlException( 'The exception' ) )
    *
    * Has 'throws' as a synonym, and these methods are entirely interchangeable based on preference.
    *
    * @param Object - The Exception to throw when this expectation is met.
    */
    public TestExpectation throwing( Exception exceptionToThrow ) {
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
    * Has 'throwing' as a synonym, and these methods are entirely interchangeable based on preference.
    *
    * @param Object - The Exception to throw when this expectation is met.
    */
    public TestExpectation throws( Exception exceptionToThrow ) {
        return this.throwing( exceptionToThrow );
    }

    /**
    * Allows another 'expectation' or 'when' to be defined against the TestMock
    *
    * For example:
    * .then().expects()
    *       .method( 'methodName' )
    *       .withParameter( 'parameterValue' )
    *       .returning( 'theValueItShouldReturn' )
    */
    public TestMock then() {
        return this.mockControl;
    }

    /**
    * Allows another 'expectation' or 'when' to be defined against the TestMock.
    *
    * Is a synonym for 'then'.
    *
    * For example:
    * .also().when()
    *       .method( 'methodName' )
    *       .withParameter( 'parameterValue' )
    *       .willReturn( 'theValueItShouldReturn' )
    */
    public TestMock also() {
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
    public void verify( TestAsserts assertionMechanism, String method, List<Object> parameterValues ) {

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

    /**
    * Internal class that should not be referenced directly in a test
    *
    * Describes the specification of a Parameter that is expected to be passed into a mocked method call
    *
    */
    class TestExpectationParameter {

        Boolean anyValue = false;
        Object  value;

        /**
        * Internal method that should not be called directly in tests.
        *
        * States that this parameter can be set to any value and will match when being checked against an actual call
        *
        * @return TestExpectationParameter - Itself, allowing for a fluent interface
        */
        public TestExpectationParameter anyValue() {
            anyValue = true;
            return this;
        }

        /**
        * Internal method that should not be called directly in tests.
        *
        * Sets the value that this parameter is expectd to be
        *
        * @param  Object - The value that this parameter is expected to be
        * @return TestExpectationParameter - Itself, allowing for a fluent interface
        */
        public TestExpectationParameter setValue( Object value ) {
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