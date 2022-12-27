@isTest
public with sharing class AmossTest_HttpCalloutMock {
    /**
    * @method  respond
    * @result  will do nothing
    */
    @isTest
    private static void respond_willDoNothing() {

        Test.startTest();
            new Amoss_HttpCalloutMock().respond( null );
        Test.stopTest();

        Assert.isTrue( true, 'respond, when always, will do nothing' );
    }
}
