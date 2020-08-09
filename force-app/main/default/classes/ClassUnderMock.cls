public with sharing class ClassUnderMock {
    public String methodUnderMock( String parameter1, Integer parameter2 ) {
        return 'TheReturn';
    }
    public String methodWithNoParametersUnderMock() {
        return 'TheReturn';
    }
    public String otherMethodUnderMock( String parameter1, Integer parameter2 ) {
        return 'TheReturn';
    }
    public String sobjectMethodUnderMock( Contact contactParam ) {
        return 'TheReturn';
    }
}