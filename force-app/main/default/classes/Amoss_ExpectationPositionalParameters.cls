/**
* Internal interface that allows for the specification of parameters that an Expectation should have using 'positional' notation.
* That is, they are specified in order.
*/
private with sharing class Amoss_ExpectationPositionalParameters implements Amoss_ExpectationParameters {

    private List<Amoss_ExpectationParameter> expectedParameters = new List<Amoss_ExpectationParameter>();

    /**
    * Internal method that adds a parameter to the list of parameters that are valid for this Expectation.
    *
    * @param Object - The parameter value to add to the list of expected ones
    * @return Amoss_Expectation - Itself, allowing for a fluent interface
    */
    public Amoss_Expectation addParameterValue( Object parameterValue ) {
        expectedParameters.add( new Amoss_ExpectationParameter().setValue( parameterValue ) );
        return this;
    }

    /**
    * Internal method that adds an 'any parameter value' to the list of parameters that are valid for this Expectation.
    * 
    * @return Amoss_Expectation - Itself, allowing for a fluent interface
    */
    public Amoss_Expectation addAnyParameterValue() {
        expectedParameters.add( new Amoss_ExpectationParameter().anyValue() );
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
    * @param Amoss_Asserts - The assertion mechanism to report via
    * @param String - The method that is being called, and therefore checked
    * @param List<String> - The names of the parameters being passed, and thereforce checked
    * @param List<Object> - The values of the parameters being passed, and thereforce checked
    */
    public void verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues ){

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
    * Checks if the stated call and parameters matches the current expectation's definition.
    *
    * @param String - The method to check this expectation against.
    * @param List<Object> - The names of the parameters to check this expectation against.
    * @param List<Object> - The parameters to check this expectation against.
    * @return Boolean - States if this expectation matches that passed passed in.
    */
    public Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
        for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {
            if ( ! expectedParameters[ parameterNumber ].matches( parameterValues[ parameterNumber ] ) ) {
                return false;
            }
        }
    }    
}
