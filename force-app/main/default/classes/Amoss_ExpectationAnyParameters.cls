/**
* Internal class that allows for the specification that an Expectation can have any parameters
*
* Always assumes that any parameters will match (since 'any' should)
*/
private with sharing class Amoss_ExpectationAnyParameters implements Amoss_ExpectationParameters {

    /**
    * Internal method that returns a String description of the parameter values that are expected.
    *
    * Always returns 'any'
    *
    * @return String - The description of the expected parameter values
    */
    public String getParametersDescription() {
        return 'any';
    }

    /**
    * Internal method that checks if the passed parameters match those that are configured, reporting via Assertions.
    *
    * Does nothing.
    *
    * @param Amoss_Asserts - The assertion mechanism to report via
    * @param String - The method that is being called, and therefore checked
    * @param List<String> - The names of the parameters being passed, and thereforce checked
    * @param List<Object> - The values of the parameters being passed, and thereforce checked
    */
    public void verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues ){
        return;
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