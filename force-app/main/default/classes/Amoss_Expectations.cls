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