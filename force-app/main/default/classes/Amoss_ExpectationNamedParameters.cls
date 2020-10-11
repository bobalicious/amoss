public with sharing class Amoss_ExpectationNamedParameters implements Amoss_ExpectationParameters {

    private Map<String,Amoss_ExpectationParameter> expectedNamedParameters = new Map<String,Amoss_ExpectationParameter>();

    public Amoss_ExpectationNamedParameters() {

    }

    /**
    * Internal method that sets the name of the current parameter being specified (named notation)
    *
    * @param String - The name of the parameter to add to the specification
    * @return Amoss_Expectation - Itself, allowing for a fluent interface
    */ 
    public Amoss_Expectation setParameter( String parameterName, Object parameterValue ) {
        expectedNamedParameters.put( parameterName, new Amoss_Instance.Amoss_ExpectationParameter().setValue( parameterValue ) );
        return this;
    }

    public Boolean verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues ){

        for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {

            String actualParameterName  = parameterNames[ parameterNumber ];
            Object actualParameterValue = parameterValues[ parameterNumber ];
            Amoss_ExpectationParameter expectationParameter = expectedNamedParameters.get( actualParameterName );

            if ( expectationParameter == null || expectationParameter.allowsAnyValue() ) {
                continue;
            }
            assertionMechanism.assertEquals( expectationParameter.getValue(), actualParameterValue, String.format( '{0}.{1} was called with the wrong parameter value for "{2}"', new List<String>{ className, expectedMethod, actualParameterName } ) );
        }
    }

    public String getParametersDescription() {
        List<String> stringParameters = new List<String>();
        for( String thisParameterName : expectedNamedParameters.keySet() ) {
            stringParameters.add( thisParameterName + ' => ' + String.valueOf( expectedNamedParameters.get( thisParameterName ) ) );
        }
        return String.join( stringParameters, ', ' );
    }

    public Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues ) {
        for ( Integer parameterNumber = 0; parameterNumber < parameterValues.size(); parameterNumber++ ) {
            String actualParameterName  = parameterNames[ parameterNumber ];
            Object actualParameterValue = parameterValues[ parameterNumber ];

            Amoss_ExpectationParameter expectationParameter = expectedNamedParameters.get( actualParameterName );
            if ( expectationParameter != null && ! expectationParameter.matches( parameterValues[ parameterNumber ] ) ) {
                return false;
            }
        }
    }
}
