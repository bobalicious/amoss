@isTest
public with sharing class Amoss_ClassUnderMock {
    public String methodUnderMock( String parameter1, Integer parameter2 ) {
        return 'TheReturn';
    }
    public void methodUnderMockWithNoReturn( String parameter1, Integer parameter2 ) {
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
    public List<Object> methodWithListObject( List<Object> parameter1 ) {
        return new List<Object>();
    }
    public Set<Object> methodWithSetObject( Set<Object> parameter1 ) {
        return new Set<Object>();
    }
    public Map<String,Object> methodWithMapStringObject( Map<String,Object> parameter1 ) {
        return new Map<String,Object>();
    }    
}