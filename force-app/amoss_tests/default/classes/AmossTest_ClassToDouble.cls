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
 *
 * Amoss test class that exists purely so that AmossTest_InstanceTest has a guaranteed class
 * that it can create a Test Double for.
 *
 * If StubProvider supported the stubbing of internal classes, then this would be part of
 * Amos_InstanceTest.  Until it does, it will need to stay here.
 *
 */
@isTest
public with sharing class AmossTest_ClassToDouble {

    // Non-empty parameter constructor defined to prove that
    // such classes can have a Test Double generated OK
    public AmossTest_ClassToDouble( String parameter1 ) {
    }

    public String methodUnderDouble( String parameter1, Integer parameter2 ) {
        return 'TheReturn';
    }
    public String overloadedMethodUnderDouble( String parameter1, String parameter2 ) {
        return 'TheReturn';
    }
    public String overloadedMethodUnderDouble( String parameter1, Integer parameter2 ) {
        return 'TheReturn';
    }
    public String overloadedMethodUnderDouble( String parameter1, String parameter2, String parameter3 ) {
        return 'TheReturn';
    }
    public void methodUnderDoubleWithNoReturn( String parameter1, Integer parameter2 ) {
    }
    public String methodWithNoParametersUnderDouble() {
        return 'TheReturn';
    }
    public String otherMethodUnderDouble( String parameter1, Integer parameter2 ) {
        return 'TheReturn';
    }
    public String sobjectMethodUnderDouble( Contact contactParam ) {
        return 'TheReturn';
    }
    public String sobjectMethodUnderDouble( Contact contactParam, Account accountParam ) {
        return 'TheReturn';
    }
    public String sobjectMethodUnderDouble( String notAnSobject ) {
        return 'TheReturn';
    }
    public String objectMethodUnderDouble( Object objectParam ) {
        return 'TheReturn';
    }
    public String objectMethodUnderDouble( String notAnObject ) {
        return 'TheReturn';
    }
    public List<Object> methodWithListOfObjects( List<Object> parameter1 ) {
        return new List<Object>();
    }
    public Set<Object> methodWithSetOfObjects( Set<Object> parameter1 ) {
        return new Set<Object>();
    }
    public Map<String,Object> methodWithMapStringToObject( Map<String,Object> parameter1 ) {
        return new Map<String,Object>();
    }
    public Map<Id,Object> methodWithMapIdToObject( Map<Id,Object> parameter1 ) {
        return new Map<Id,Object>();
    }
    public Map<Date,Object> methodWithMapDateToObject( Map<Date,Object> parameter1 ) {
        return new Map<Date,Object>();
    }
    public AmossTest_ClassToDouble fluentMethod() {
        return this;
    }

    public class PassableObject {
        String property;
        public PassableObject( String property ) {
            this.property = property;
        }
    }
}