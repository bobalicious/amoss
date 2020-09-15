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
* Entirely Internal class that should not be referenced at all in a test
*
* Describes the definition of a mock object's 'expectations' or 'whens' within a test and allows the interrogation of that definition.
*
*/
@isTest
public with sharing class Amoss_Expectations {

    private List<Amoss_Expectation> expectations = new List<Amoss_Expectation>();

    public void add( Amoss_Expectation expectation ) {
        expectations.add( expectation );
    }


    /**
    * Checks if the given method and parameterValues combination matches the next expection.
    *
    * Returns false if no more expections exist.
    *
    * @param  String - The name of the method to match against
    * @param  List<Object> - The parameter values to match against
    * @return Boolean - States if the given method and parameterValues match the next expectation.
    */
    public Boolean matchesNext(  String method, List<Object> parameterValues ) {
        return expectations.size() > 0 && expectations[0].matches( method, parameterValues );
    }

    /**
    * Removes the first expectation in the queue and then returns it.  
    *
    * @return Amoss_Expectation - The first expectation from the queue.
    */
    public Amoss_Expectation unshift() {
        return expectations.remove(0);
    }

    /**
    * States if the current expectation queue is empty.
    *
    * @return Boolean - Is the current expectation queue empty?
    */
    public Boolean isEmpty() {
        return expectations.isEmpty();
    }

    /**
    * States if the current expectation queue has expectations in it.
    *
    * @return Boolean - Are there any expectations in the current queue?
    */
    public Boolean hasExpectations() {
        return !isEmpty();
    }

    /**
    * Generates and returns a description of the expectations that remain in the current queue.
    *
    * @return String - A description of the remaining expectations.
    */
    public String getRemainingCallsDescription() {
        List<String> remainingCallDescriptions = new List<String>();
        for ( Amoss_Expectation thisExpectation : expectations ) {
            remainingCallDescriptions.add( thisExpectation.getCallDescription() );
        }
        return String.join( remainingCallDescriptions, ',' );
    }

    /**
    * Given the name of a method, and a list of parameters, checks the queue to see if any expectations
    * match that definition.
    *
    * Returns the *first* expectation that does, or null if non do.
    *
    * @param  String - The name of the method to match against
    * @param  List<Object> - The parameter values to match against
    * @return Amoss_Expectation - The matching expectation
    */
    public Amoss_Expectation getMatchingExpectation( String mockedMethod, List<Object> parameters ) {

        for ( Amoss_Expectation thisExpectation : expectations ) {
            if ( thisExpectation.matches( mockedMethod, parameters ) ) {
                return thisExpectation;
            }
        }
        return null;
    }
}