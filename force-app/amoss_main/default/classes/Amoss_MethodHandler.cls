/**
* Public interface for the specification of simple method handlers, for use by handledBy.
*
* The standard Salesforce StubProvider interface can be used if something more substantial is required.
*/
public interface Amoss_MethodHandler {
    Object handleMethodCall( List<Object> parameters );
}