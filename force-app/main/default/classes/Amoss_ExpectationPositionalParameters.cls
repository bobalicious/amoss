public with sharing class Amoss_ExpectationPositionalParameters implements Amoss_ExpectationParameters {

    private List<Amoss_ExpectationParameter>  expectedPositionalParameters = new List<Amoss_ExpectationParameter>();

    public Amoss_ExpectationPositionalParameters() {

    }

    /**
    * Internal method that adds a parameter to the list of parameters that are valid for this 'expection' or 'when'.
    *
    * @param Object - The parameter value to add to the list of expected ones
    * @return Amoss_Expectation - Itself, allowing for a fluent interface
    */
    public Amoss_Expectation addParameterValue( Object parameterValue ) {
        this.expectedPositionalParameters.add( new Amoss_ExpectationParameter().setValue( parameterValue ) );
        return this;
    }

    /**
    * Internal method that adds an 'any parameter value' to the list of parameters that are valid for this 'expection' or 'when'.
    * 
    * @return Amoss_Expectation - Itself, allowing for a fluent interface
    */
    public Amoss_Expectation addAnyParameterValue() {
        this.expectedPositionalParameters.add( new Amoss_ExpectationParameter().anyValue() );
        return this;
    }

    public Boolean verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues ){

        assertionMechanism.assertEquals( expectedPositionalParameters.size(), parameterValues.size(), String.format( '{0}.{1} was called with an unexpected number of parameters', new List<String>{ className, expectedMethod } ) );

        for ( Integer parameterNumber = 0; parameterNumber < expectedPositionalParameters.size(); parameterNumber++ ) {

            if ( expectedPositionalParameters[ parameterNumber ].allowsAnyValue() ) {
                continue;
            }
            assertionMechanism.assertEquals( expectedPositionalParameters[ parameterNumber ].getValue(), parameterValues[ parameterNumber ], String.format( '{0}.{1} was called with the wrong parameter value in position {2}', new List<String>{ className, expectedMethod, String.valueOf( parameterNumber ) } ) );
        }
    }

    public String getParametersDescription() {
        List<String> stringParameters = new List<String>();
        for( Object thisParameter : expectedPositionalParameters ) {
            stringParameters.add( String.valueOf( thisParameter ) );
        }
        return String.join( stringParameters, ', ' );
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
        for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {
            if ( ! expectedPositionalParameters[ parameterNumber ].matches( parameterValues[ parameterNumber ] ) ) {
                return false;
            }
        }
    }    
}
