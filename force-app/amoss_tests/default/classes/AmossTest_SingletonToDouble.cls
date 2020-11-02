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
 * with no public constructors that it can attempt to create a Test Double for.
 *
 * It follows a standard Singleton pattern, just to illustrate the kind of class that is limited
 * by the implementation of StubProvider
 *
 * If StubProvider supported the stubbing of internal classes, then this would be part of
 * Amos_InstanceTest.  Until it does, it will need to stay here.
 *
 */
@isTest
public with sharing class AmossTest_SingletonToDouble {

    private static AmossTest_SingletonToDouble instance;

    private AmossTest_SingletonToDouble() {
    }

    public static AmossTest_SingletonToDouble getInstance() {
        if ( AmossTest_SingletonToDouble.instance == null ) {
            AmossTest_SingletonToDouble.instance = new AmossTest_SingletonToDouble();
        }
        return AmossTest_SingletonToDouble.instance;
    }
}
