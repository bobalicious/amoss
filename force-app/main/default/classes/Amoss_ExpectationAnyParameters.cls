public with sharing class Amoss_ExpectationAnyParameters implements Amoss_ExpectationParameters {

    public Boolean verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues ){
        return;
    }

    public String getParametersDescription() {
        return 'any';
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
        return true;
    }

}
