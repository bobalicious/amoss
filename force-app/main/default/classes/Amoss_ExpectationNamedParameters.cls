/**
* Internal interface that allows for the specification of parameters that an Expectation should have using 'positional' notation.
* That is, they are specified using their names
*/
private with sharing class Amoss_ExpectationNamedParameters implements Amoss_ExpectationParameters {

    private Map<String,Amoss_ExpectationParameter> expectedParameters = new Map<String,Amoss_ExpectationParameter>();

    /**
    * Internal method that sets the expected parameter with the given name, to have the given value.
    *
    * @param String - The name of the parameter to add to the specification
    * @param Object - The value of the parameter to add to the specification
    * @return Amoss_Expectation - Itself, allowing for a fluent interface
    */
    public Amoss_Expectation setParameter( String parameterName, Object parameterValue ) {
        expectedParameters.put( parameterName, new Amoss_Instance.Amoss_ExpectationParameter().setValue( parameterValue ) );
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
    * @param Amoss_Asserts - The assertion mechanism to report via
    * @param String - The method that is being called, and therefore checked
    * @param List<String> - The names of the parameters being passed, and thereforce checked
    * @param List<Object> - The values of the parameters being passed, and thereforce checked
    */
    public void verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues ){

        for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {

            String actualParameterName  = parameterNames[ parameterNumber ];
            Object actualParameterValue = parameterValues[ parameterNumber ];
            Amoss_ExpectationParameter expectationParameter = expectedParameters.get( actualParameterName );

            if ( expectationParameter == null || expectationParameter.allowsAnyValue() ) {
                continue;
            }
            assertionMechanism.assertEquals( expectationParameter.getValue(), actualParameterValue, String.format( '{0}.{1} was called with the wrong parameter value for "{2}"', new List<String>{ className, expectedMethod, actualParameterName } ) );
        }
    }

    public Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
        for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {
            String actualParameterName  = parameterNames[ parameterNumber ];
            Object actualParameterValue = parameterValues[ parameterNumber ];

            Amoss_ExpectationParameter expectationParameter = expectedParameters.get( actualParameterName );
            if ( expectationParameter != null && ! expectationParameter.matches( parameterValues[ parameterNumber ] ) ) {
                return false;
            }
        }
    }
}
