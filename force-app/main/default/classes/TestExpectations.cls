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

    public String getRemainingCallsDescription() {
        List<String> remainingCallDescriptions = new List<String>();
        for ( TestExpectation thisExpectation : expectations ) {
            remainingCallDescriptions.add( thisExpectation.getCallDescription() );
        }
        return String.join( remainingCallDescriptions, ',' );
    }
}