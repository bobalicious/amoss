/**
* Internal interface that allows for the specification of parameters that an Expectation should have
*
* An implementing class should provide a mechanism to get a String description, verify passed parameters are as stated (reporting via assertions)
* and checking passed parameters are as stated (returning a Boolean)
*/
private interface Amoss_ExpectationParameters {
    String getParametersDescription();
    void verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues );
    Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues );
}
