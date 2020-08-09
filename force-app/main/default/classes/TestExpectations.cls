@isTest
public with sharing class TestExpectations {

    private List<TestExpectation> expectations = new List<TestExpectation>();

    public void add( TestExpectation expectation ) {
        expectations.add( expectation );
    }

    public TestExpectation unshift() {
        return expectations.remove(0);
    }

    public Boolean isEmpty() {
        return expectations.isEmpty();
    }

    public Boolean hasExpectations() {
        return !isEmpty();
    }

    public String getRemainingCallsDescription() {
        List<String> remainingCallDescriptions = new List<String>();
        for ( TestExpectation thisExpectation : expectations ) {
            remainingCallDescriptions.add( thisExpectation.getCallDescription() );
        }
        return String.join( remainingCallDescriptions, ',' );
    }

    public TestExpectation getMatchingExpectation( String mockedMethod, List<Object> parameters ) {

        for ( TestExpectation thisExpectation : expectations ) {
            if ( thisExpectation.matches( mockedMethod, parameters ) ) {
                return thisExpectation;
            }
        }
        return null;
    }
}