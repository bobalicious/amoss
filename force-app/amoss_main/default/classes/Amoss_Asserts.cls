/*
MIT License

Copyright (c) 2020 Robert Baillie

https://github.com/bobalicious/amoss

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
     * @param Object - The string to search within (actual)
     * @param String - The assertion message
     */
    public static void assertContains( String expectedString, Object actualString, String assertionMessage ) {
        System.assert( ((String)actualString).contains( expectedString ), assertionMessage + ' (looking for: ' + expectedString + ', got: ' + actualString + ')' );
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
    public static string getType( Object o ) {
        if( o instanceof SObject ) {
            try {
                return String.valueOf(((SObject)o).getSObjectType().getDescribe().getName());
            } catch ( Exception e ) {} // not actually an Sobject: There's a bug in Apex where List<Sobject> will return true for "instanceOf Sobject" when it shouldn't
        }
        if( o instanceof Boolean ) {
            return 'Boolean';
        }
        if( o instanceof Id ) {
            return 'Id';
        }
        if( o instanceof String ) {
            return 'String';
        }
        if( o instanceof Blob ) {
            return 'Blob';
        }
        if( o instanceof Date ) {
            return 'Date';
        }
        if( o instanceof Datetime ) {
            return 'DateTime';
        }
        if( o instanceof Time ) {
            return 'Time';
        }
        if( o instanceof String ) {
            return 'String';
        }
        if( o instanceof Integer ) {
            return 'Integer';
        }
        if( o instanceof Long ) {
            return 'Long';
        }
        if( o instanceof Double ) {
            return 'Decimal / Double'; // Cannot reliably distinguish between a decimal and a double
        }
        if( o instanceof Decimal ) {
            return 'Decimal / Double';
        }
        if( o == null ) return 'Unknown (null)'; // If it's null, we can't tell what it is

        // Having covered the primitives and special cases, we now try to cast the object
        // into something we know it can't be in order to get what Apex thinks it is from
        // the Exception.
        // Is a bit of a hack, but the test for this method should check that it continues
        // to work as Apex changes behaviour.
        try {
            DateTime impossibleCast = (DateTime)o;
        } catch ( Exception e ) {

            Matcher dataTypeMatcher = pattern.compile( 'Invalid conversion from runtime type (.*) to Datetime' ).matcher( e.getMessage() );
            if ( dataTypeMatcher.matches() ) {
                String dataType = dataTypeMatcher.group( 1 );
                // Don't like 'ANY' as a response - this exception is the only place you ever see it,
                // so we replace it with Object - but since an object type could have 'ANY' in it,
                // we have to only do it for places where it can appear and we are certain it's
                // Salesforce's doing, not the developer's
                return dataType.replace( ',ANY>', ',Object>' ).replace( '<ANY,', '<Object,' ).replace( '<ANY>', '<Object>' );
            }
        }

        // I can't think of any reason why would reach here,
        // but just in case...
        return 'Object';
    }
}