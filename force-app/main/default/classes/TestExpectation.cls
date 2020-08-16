/**
* Internal class that should not be referenced directly in a test
*
* Describes the definition and behaviour of an 'expectation' or 'when' that is defined within a test.
*
*/
@isTest
public class TestExpectation {

    private String expectedMethod;
    private List<Object> expectedParameters = new List<Object>();
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
    * Has 'withAnyParameter' as a synonym, and these methods are entirely interchangeable based on preference.
    */
    public TestExpectation withAnyParameters() {
        this.withAnyParameters = true;
        return this;
    }

    /**
    * States that this 'expection' or 'when' is valid for any combination of parameters.
    *
    * Is optional, as omitting parameter definitions will result in any parameter being valid.
    *
    * Generally used for stubbing methods that are not the primary focus of a given test.
    *
    * Has 'withAnyParameters' as a synonym, and these methods are entirely interchangeable based on preference.
    *
    * For example:
    *   .when()
    *       .method( 'methodName' )
    *       .withAnyParameters()
    *       .willReturn( 'theValueItShouldReturn' )
    */
    public TestExpectation withAnyParameter() {
        return withAnyParameters();
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
        this.expectedParameters = parameterValues;
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
        this.expectedParameters.add( parameterValue );
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
    * Has 'withParameter' as a synonym, and these methods are entirely interchangeable based on preference.
    *
    * @param Object - The parameter value to add to the list of expected ones
    */
    public TestExpectation andThenParameter( Object parameterValue ) {
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
            assertionMechanism.assertEquals( expectedParameters[ parameterNumber ], parameterValues[ parameterNumber ], String.format( '{0}.{1} was called with the wrong parameter value in position {2}', new List<String>{ className, expectedMethod, String.valueOf( parameterNumber ) } ) );
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
            if ( expectedParameters[ parameterNumber ] != parameterValues[ parameterNumber ] ) {
                return false;
            }
        }

        return true;
    }
}