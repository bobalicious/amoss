public interface Amoss_ExpectationParameters {

    Booleam verify( Amoss_Asserts assertionMechanism, String method, List<String> parameterNames, List<Object> parameterValues );
    String getParametersDescription();
    Boolean matches( String method, List<String> parameterNames, List<Object> parameterValues );
}
