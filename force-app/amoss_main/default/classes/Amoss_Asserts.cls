/*
MIT License

Copyright (c) 2020 Robert Baillie

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/**
* Provides assertion methods for Amoss_Instance to use.  Primarily so that the assertion mechanism
* can be overridden in the unit tests - otherwise we would not be able to test when failure assertions
* are issued.
*
* However, also provides 'assertContains' and 'assertDoesNotContain', which are useful additions
* to the assertion suite.
*
*/
@isTest
public with sharing class Amoss_Asserts {

    /**
     * Amoss specific version of assertEquals, which is intended to only be used by Amoss itself.
     *
     * Has the added capability of explictly checking for matching datatypes before issuing the equality assertion.
     * This helps in ensuring that datatype mis-match messages to the console are clear - rather then simply
     * throwing an exception, as would be the case without this check.
     *
     * Is a non-static method so that it can be mocked in the test for Amoss_Instance
     */
    public void assertEquals( Object expectedObject, Object actualObject, String assertionMessage ) {

        if ( expectedObject != null && actualObject != null ) {
            System.assertEquals( getType( expectedObject ), getType( actualObject ), assertionMessage + ' - Types do not match' );
        }

        System.assertEquals( expectedObject, actualObject, assertionMessage );
    }

    /**
     * Amoss specific version of assert, which is intended to only be used by Amoss itself.
     *
     * Is a non-static method so that it can be mocked in the test for Amoss_Instance
     */
    public void assert( Boolean result, String assertionMessage ) {
        System.assert( result, assertionMessage );
    }

    /**
     * Assert that the actualString contains the expectedString
     *
     * Provided as this is a common assertion case, and usually requires the building
     * of an assertion message for clarity when the assertion fails.
     *
     * @param String - The string to search for (expected)
     * @param String - The string to search within (actual)
     * @param String - The assertion message
     */
    public static void assertContains( String expectedString, String actualString, String assertionMessage ) {
        System.assert( actualString.contains( expectedString ), assertionMessage + ' (looking for: ' + expectedString + ', got: ' + actualString + ')' );
    }

    /**
     * Assert that the actualString does not contain the expectedString
     *
     * Provided as this is a common assertion case, and usually requires the building
     * of an assertion message for clarity when the assertion fails.
     *
     * @param String - The string to search for (expected)
     * @param String - The string to search within (actual)
     * @param String - The assertion message
     */
    public static void assertDoesNotContain( String expectedString, String actualString, String assertionMessage ) {
        System.assert( ! actualString.contains( expectedString ), assertionMessage + ' (looking for: ' + expectedString + ', got: ' + actualString + ')' );
    }

    /**
     * A simple 'getType' implementation that helps with checking that expected and actual
     * are of the same datatype.
     *
     * Is not exhaustive and is bound by Salesforce limits, but will reduce the number
     * of exceptions thrown by 'assertEquals' due to mismatching types.
     *
     * @param Object - The object to return the type of
     * @return String - The type of the passed in object
     */
    private static string getType( Object o ) {
        if( o==null ) return 'Unknown';              // we can't say much about null with our current techniques
        if( o instanceof SObject )            return String.valueOf(((SObject)o).getSObjectType().getDescribe().getName());
        if( o instanceof Boolean )            return 'Boolean';
        if( o instanceof Id )                 return 'Id';
        if( o instanceof String )             return 'String';
        if( o instanceof Blob )               return 'Blob';
        if( o instanceof Date )               return 'Date';
        if( o instanceof Datetime )           return 'DateTime';
        if( o instanceof Time )               return 'Time';
        if( o instanceof String )             return 'String';
        if( o instanceof Integer )            return 'Integer';
        if( o instanceof Long )               return 'Long';
        if( o instanceof Decimal )            return 'Decimal';
        if( o instanceof Double )             return 'Double';
        if( o instanceof List<Object> )       return 'List';
        return 'Object';
    }    
}