public with sharing class TestAsserts {

    public static void assertContains( String expectedString, String actualString, String assertionMessage ) {
        System.assert( actualString.contains( expectedString ), assertionMessage + ' (got ' + actualString + ')' );
    }

}
