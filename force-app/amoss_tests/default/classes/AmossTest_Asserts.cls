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

@isTest
public with sharing class AmossTest_Asserts {

    /**
    * @method  getType
    * @case    when given a parameter
    * @result  will return a String representing the type of that parameter
    */
    @isTest
    private static void getType_whenGivenAParameter_willReturnTheStringTypeOfIt() {

        List<Map<String,Object>> testCases = new List<Map<String,Object>>{
            new Map<String,Object>{
                'parameter' => true,
                'expected'  => 'Boolean',
                'case'      => 'a Boolean (true)'
            },
            new Map<String,Object>{
                'parameter' => true,
                'expected'  => 'Boolean',
                'case'      => 'a Boolean (false)'
            },
            new Map<String,Object>{
                'parameter' => (Boolean)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Boolean'
            },
            new Map<String,Object>{
                'parameter' => (Id)'003000000000000000',
                'expected'  => 'Id',
                'case'      => 'an Id'
            },
            new Map<String,Object>{
                'parameter' => (Id)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Id'
            },
            new Map<String,Object>{
                'parameter' => 'A string',
                'expected'  => 'String',
                'case'      => 'a String'
            },
            new Map<String,Object>{
                'parameter' => '',
                'expected'  => 'String',
                'case'      => 'an empty String'
            },
            new Map<String,Object>{
                'parameter' => (String)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null String'
            },
            new Map<String,Object>{
                'parameter' => Integer.valueOf( 1 ),
                'expected'  => 'Integer',
                'case'      => 'an Integer'
            },
            new Map<String,Object>{
                'parameter' => (Integer)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Integer'
            },
            new Map<String,Object>{
                'parameter' => Decimal.valueOf( 1 ),
                'expected'  => 'Decimal / Double',
                'case'      => 'a Decimal'
            },
            new Map<String,Object>{
                'parameter' => (Decimal)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Decimal'
            },
            new Map<String,Object>{
                'parameter' => Double.valueOf( 1 ),
                'expected'  => 'Decimal / Double',
                'case'      => 'a Double'
            },
            new Map<String,Object>{
                'parameter' => (Double)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Double'
            },
            new Map<String,Object>{
                'parameter' => Long.valueOf( '1' ),
                'expected'  => 'Long',
                'case'      => 'a Long'
            },
            new Map<String,Object>{
                'parameter' => (Long)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Long'
            },
            new Map<String,Object>{
                'parameter' => Blob.valueOf( '1' ),
                'expected'  => 'Blob',
                'case'      => 'a Blob'
            },
            new Map<String,Object>{
                'parameter' => Blob.valueOf( '' ),
                'expected'  => 'Blob',
                'case'      => 'an empty Blob'
            },
            new Map<String,Object>{
                'parameter' => (Blob)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Blob'
            },
            new Map<String,Object>{
                'parameter' => Date.newInstance( 2020, 12, 31 ),
                'expected'  => 'Date',
                'case'      => 'an Date'
            },
            new Map<String,Object>{
                'parameter' => (Date)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Date'
            },
            new Map<String,Object>{
                'parameter' => DateTime.newInstance( 2020, 12, 31, 12, 00, 00 ),
                'expected'  => 'DateTime',
                'case'      => 'a DateTime'
            },
            new Map<String,Object>{
                'parameter' => DateTime.newInstance( 2020, 12, 31 ),
                'expected'  => 'DateTime',
                'case'      => 'a DateTime with no time component'
            },
            new Map<String,Object>{
                'parameter' => (DateTime)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null DateTime'
            },
            new Map<String,Object>{
                'parameter' => Time.newInstance( 12, 00, 00, 0 ),
                'expected'  => 'Time',
                'case'      => 'a Time'
            },
            new Map<String,Object>{
                'parameter' => (Time)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null Time'
            },
            new Map<String,Object>{
                'parameter' => new Contact(),
                'expected'  => 'Contact',
                'case'      => 'an sObject (Contact)'
            },
            new Map<String,Object>{
                'parameter' => (Contact)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null sObject (Contact)'
            },
            new Map<String,Object>{
                'parameter' => new List<Contact>(),
                'expected'  => 'List<Contact>',
                'case'      => 'a List of sObjects (Contact)'
            },
            new Map<String,Object>{
                'parameter' => new List<String>(),
                'expected'  => 'List<String>',
                'case'      => 'a List of Strings'
            },
            new Map<String,Object>{
                'parameter' => new List<Decimal>(),
                'expected'  => 'List<Decimal>',
                'case'      => 'a List of Decimals'
            },
            new Map<String,Object>{
                'parameter' => (List<Contact>)null,
                'expected'  => 'Unknown (null)',
                'case'      => 'a null List of sObjects (Contact)'
            },
            new Map<String,Object>{
                'parameter' => new Map<String,Object>(),
                'expected'  => 'Map<String,Object>',
                'case'      => 'a Map<String,Object>'
            },
            new Map<String,Object>{
                'parameter' => new Map<String,String>(),
                'expected'  => 'Map<String,String>',
                'case'      => 'a Map<String,String>'
            },
            new Map<String,Object>{
                'parameter' => new Map<String,Contact>(),
                'expected'  => 'Map<String,Contact>',
                'case'      => 'a Map<String,Contact>'
            },
            new Map<String,Object>{
                'parameter' => new Map<Id,Object>(),
                'expected'  => 'Map<Id,Object>',
                'case'      => 'a Map<Id,Object>'
            },
            new Map<String,Object>{
                'parameter' => new Map<Integer,String>(),
                'expected'  => 'Map<Integer,String>',
                'case'      => 'a Map<Integer,String>'
            },
            new Map<String,Object>{
                'parameter' => new Set<Object>(),
                'expected'  => 'Set<Object>',
                'case'      => 'a Set<Object>'
            },
            new Map<String,Object>{
                'parameter' => new Set<String>(),
                'expected'  => 'Set<String>',
                'case'      => 'a Set<String>'
            },
            new Map<String,Object>{
                'parameter' => new Set<Contact>(),
                'expected'  => 'Set<Contact>',
                'case'      => 'a Set<Contact>'
            },
            new Map<String,Object>{
                'parameter' => new List<Map<Object,Set<Date>>>(),
                'expected'  => 'List<Map<Object,Set<Date>>>',
                'case'      => 'a nested collection'
            },
            new Map<String,Object>{
                'parameter' => new AmossTest_ClassToDouble( 'param' ),
                'expected'  =>  AmossTest_ClassToDouble.class.getName(),
                'case'      => 'a non-system class'
            },
            new Map<String,Object>{
                'parameter' => new Amoss_Instance( AmossTest_ClassToDouble.class ).getDouble(),
                'expected'  =>  AmossTest_ClassToDouble.class.getName(),
                'case'      => 'a test double of a class'
            }
        };

        for ( Map<String,Object> thisTestCase : testCases ) {
            Object parameter = thisTestCase.get( 'parameter' );
            String expected  = (String)thisTestCase.get( 'expected' );
            String assertion = 'getType, when passed ' + (String)thisTestCase.get( 'case' ) + ' will return its type';

            String actual = Amoss_Asserts.getType( parameter );
            System.assertEquals( expected, actual, assertion );
        }
    }
}