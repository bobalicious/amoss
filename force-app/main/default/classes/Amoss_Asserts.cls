public with sharing class Amoss_Asserts {

    public void assertEquals( Object expectedObject, Object actualObject, String assertionMessage ) {
        System.assertEquals( expectedObject, actualObject, assertionMessage );
    }

    public void assert( Boolean result, String assertionMessage ) {
        System.assert( result, assertionMessage );
    }

    public static void assertContains( String expectedString, String actualString, String assertionMessage ) {
        System.assert( actualString.contains( expectedString ), assertionMessage + ' (got ' + actualString + ')' );
    }
}