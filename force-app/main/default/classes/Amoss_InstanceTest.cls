@isTest
public with sharing class Amoss_InstanceTest {

    class TestException extends Exception {}

    // TODO
    // full set of 'when' tests
        // prove that when can be specified, and the values are returned based on it
        //  include 'anyParameters' and 'anyParameter'
        // prove that when can be specified and other calls will return null

    // same as above, but for 'allows'

    //
    // Method definition tests
    //

    /**
    * @case    when no methods are defined, and one that exists against the doubled class is called
    * @result  will return null
    */
    @isTest
    private static void whenNoMethodsAreDefinedAndAValidOneIsCalled_willReturnNull() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            String returnFromMock = classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromMock, 'when no methods are defined, and one that exists against the doubled class is called, will return null' );
    }

    /**
    * @method  allowAnyCall
    * @case    when given false, no methods are defined, and one that exists against the doubled class is called
    * @result  will return null
    */
    @isTest
    private static void allowAnyCall_whenGivenFalseAndAndNoMethodsAreDefinedAndAValidOneIsCalled_willReturnNull() {
        
        // TODO: rename mockAsserts and mockAssertsgenerateMock

        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .allows()
                .method( 'assertEquals' )
            .also().when()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMockController
                .allowsAnyCall( false );

            try {
                classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAsserts.get().latestCallOf( 'assert' ).parameter( 0 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAsserts.get().latestCallOf( 'assert' ).parameter( 1 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall
    * @case    when given true, no methods are defined, and one that exists against the doubled class is called
    * @result  will return null
    */
    @isTest
    private static void allowAnyCall_whenGivenTrueAndAndNoMethodsAreDefinedAndAValidOneIsCalled_willReturnNull() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMockController
                .allowsAnyCall( true );
            String returnFromMock = classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromMock, 'when given true, when no methods are defined, and one that exists against the doubled class is called, will return null' );
    }

    // expectation set, allowsAnyCall(true) is set, something else called that doesn't match, returns null
    // allowAnyCall() combined with the following, when there is a match and there isn't a match
    //  when
    //  expects
    //  allows
    // cover both allowsAnyCall( true ) and allowsAnyCall( false )

    //
    // Test Spy behaviour tests
    //

    /**
    * @method  countOf
    * @case    when given a method call that happened
    * @result  will return the number of times that method was called
    */
    @isTest
    private static void callCount_whenGivenAMethodCallThatHappened_willReturnTheNumberOfCalls() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam2', 2 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMock.methodUnderMock( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMock.methodUnderMock( 'ActualParam4', 4 );

            Integer returnedMethodCallCount = classUnderMockController.countOf( 'methodUnderMock' );
        Test.stopTest();
        
        System.assertEquals( 4, returnedMethodCallCount, 'countOf, when given the details of a method call that happened amongst many - will return the number of calls' );
    }

    /**
    * @method  countOf
    * @case    when given a method call that did not happen
    * @result  will return zero
    */
    @isTest
    private static void callCount_whenGivenAMethodCallThatDidNotHappen_willReturnZero() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            Integer returnedMethodCallCount = classUnderMockController.countOf( 'methodUnderMock' );
        Test.stopTest();
        
        System.assertEquals( 0, returnedMethodCallCount, 'countOf, when given the details of a method call that did not happen - will return zero' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void callOfParameters_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.methodUnderMock( 'ActualParam', 2 );
            List<Object> passedParameters = classUnderMockController.call( 0 ).of( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam', 2 }, passedParameters, 'call.of.parameters, when given the details of a method call that happened, will return the parameters of that call' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method that does not return anything, and a call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void callOfParameters_whenGivenACallOfMethodWithNoReturnThatHappened_willReturnTheParametersOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.methodUnderMockWithNoReturn( 'ActualParam', 2 );
            List<Object> passedParameters = classUnderMockController.call( 0 ).of( 'methodUnderMockWithNoReturn' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam', 2 }, passedParameters, 'call.of.parameters, when given the details of a method call that returns nothing, will return the parameters of that call' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method call that happened amongst many
    * @result  will return the parameters of that call
    */
    @isTest
    private static void callOfParameters_whenGivenACallThatHappenedAmongstMany_willReturnTheParametersOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam2', 2 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMock.methodUnderMock( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMock.methodUnderMock( 'ActualParam4', 4 );

            List<Object> passedParameters = classUnderMockController.call( 2 ).of( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam3', 3 }, passedParameters, 'call.of.parameters, when given the details of a method call that happened amongst many - index from 0, will return the parameters of that call' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given a call number of -1
    * @result  will return the parameters of the last call
    */
    @isTest
    private static void callOfParameters_whenGivenAMinusOneCallNumber_willReturnTheParametersOfTheLastCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam2', 2 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMock.methodUnderMock( 'ActualParam3', 3 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam3', 3 );
            classUnderMock.methodUnderMock( 'ActualParam4', 4 );  // this is the one we're going to retrieve
            classUnderMock.otherMethodUnderMock( 'OtherActualParam4', 4 );

            List<Object> passedParameters = classUnderMockController.call( -1 ).of( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam4', 4 }, passedParameters, 'call.of.parameters, when given the details of a method call with -1 call number, will return the parameters of the last call' );
    }

    /**
    * @method  latestCallOf.parameters
    * @case    when the method has been called
    * @result  will return the parameters of the last call
    */
    @isTest
    private static void latestCallOfParameters_whenTheMethodHasBeenCalled_willReturnTheParametersOfTheLastCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam2', 2 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMock.methodUnderMock( 'ActualParam3', 3 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam3', 3 );
            classUnderMock.methodUnderMock( 'ActualParam4', 4 );  // this is the one we're going to retrieve
            classUnderMock.otherMethodUnderMock( 'OtherActualParam4', 4 );

            List<Object> passedParameters = classUnderMockController.latestCallOf( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam4', 4 }, passedParameters, 'latestCallOf.parameters, when the method has been called, will return the parameters of the last call' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given a negative call number
    * @result  will return the parameters of the call that many from the end
    */
    @isTest
    private static void callOfParameters_whenGivenANegativeCallNumber_willReturnTheParametersOfTheCallThatManyFromTheEnd() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam2', 2 ); // this is the one we're going to retrieve
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMock.methodUnderMock( 'ActualParam3', 3 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMock.methodUnderMock( 'ActualParam4', 4 );

            List<Object> passedParameters = classUnderMockController.call( -3 ).of( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam2', 2 }, passedParameters, 'call.of.parameters, when given the details of a method call with a negative call number, will return the parameters of the call that many from the end' );
    }    

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method call that happened with an Sobject
    * @result  will return the parameters of that call
    */
    @isTest
    private static void callOfParameters_whenGivenACallThatHappenedWithAnSobject_willReturnTheParametersOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            Contact passedContact = new Contact( FirstName = 'Person' );

            classUnderMock.sobjectMethodUnderMock( passedContact );
            List<Object> passedParameters = classUnderMockController.call( 0 ).of( 'sobjectMethodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ passedContact }, passedParameters, 'call.of.parameters, when given the details of a method call that happened with an sobject, will return the parameters of that call' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method call that happened with no parameters
    * @result  will return an empty list for that call
    */
    @isTest
    private static void callOfParameters_whenGivenACallThatHappenedWithNoParameters_willReturnAnEmptyList() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.methodWithNoParametersUnderMock();
            List<Object> passedParameters = classUnderMockController.call( 0 ).of( 'methodWithNoParametersUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>(), passedParameters, 'call.of.parameters, when given the details of a method call that happened without any parameters, will return an empty list' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a call number that did not happen
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameters_whenGivenACallNumberThatDidNotHappen_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            classUnderMock.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classUnderMockController.call( 1 ).of( 'methodUnderMock' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a call number that did not happen, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderMock was not called 2 times', exceptionMessage, 'call.of.parameters, when given the details of a call number that did not happen, will throw an exception with a useful message' );
    }


    /**
    * @method  call.of.parameters
    * @case    when given a negative call number that did not happen
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameters_whenGivenANegativeCallNumberThatDidNotHappen_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            classUnderMock.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classUnderMockController.call( -2 ).of( 'methodUnderMock' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a negative call number that did not happen, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderMock was not called 2 times', exceptionMessage, 'call.of.parameters, when given the details of a negative mcall number that did not happen, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameters_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classUnderMockController.call( 0 ).of( 'methodUnderMock' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a method that was never called, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderMock was never called', exceptionMessage, 'call.of.parameters, when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method call that happened
    * @result  will return the stated parameter of that call
    */
    @isTest
    private static void callOfParameter_whenGivenACallThatHappened_willReturnTheStatedParameterOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.methodUnderMock( 'ActualParam', 2 );
            Object passedParameter = classUnderMockController.call( 0 ).of( 'methodUnderMock' ).parameter( 0 );
        Test.stopTest();
        
        System.assertEquals( 'ActualParam', passedParameter, 'call.of.parameter, when given the details of a method call that happened, will return the stated parameter of that call' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method call that happened amongst many
    * @result  will return the parameter of that call
    */
    @isTest
    private static void callOfParameters_whenGivenACallThatHappenedAmongstMany_willReturnTheParameterOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            classUnderMock.methodUnderMock( 'ActualParam2', 2 );
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMock.methodUnderMock( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classUnderMock.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMock.methodUnderMock( 'ActualParam4', 4 );

            Object passedParameter = classUnderMockController.call( 2 ).of( 'methodUnderMock' ).parameter( 1 );
        Test.stopTest();
        
        System.assertEquals( 3, passedParameter, 'call.of.parameter, when given the details of a method call that happened amongst many - index from 0, will return the parameters of that call' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a call number that did not happen
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenACallNumberThatDidNotHappen_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            classUnderMock.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMockController.call( 1 ).of( 'methodUnderMock' ).parameter( 1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given the details of a call number that did not happen, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderMock was not called 2 times', exceptionMessage, 'call.of.parameter, when given the details of a call number that did not happen, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMockController.call( 0 ).of( 'methodUnderMock' ).parameter( 1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given the details of a method that was never called, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderMock was never called', exceptionMessage, 'call.of.parameter, when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number that is out of range
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNumberThatIsOutOfRange_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            classUnderMock.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMockController.call( 0 ).of( 'methodUnderMock' ).parameter( 2 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number that is out of range, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderMock was not called with 3 parameters', exceptionMessage, 'call.of.parameter, when given a parameter number that is out of range, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number that is negative
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNumberThatIsNegative_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            classUnderMock.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMockController.call( 0 ).of( 'methodUnderMock' ).parameter( -1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number that is negative, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot request a negative parameter number (got -1)', exceptionMessage, 'call.of.parameter, when given a parameter number that is negative, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number for a method that has no parameters
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterForAMethodThatHasNoParameters_willThrowAnException() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();

            classUnderMock.methodWithNoParametersUnderMock();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMockController.call( 0 ).of( 'methodWithNoParametersUnderMock' ).parameter( 0 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number for a method that has no parameters, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodWithNoParametersUnderMock was not called with any parameters', exceptionMessage, 'call.of.parameter, when given a parameter number for a method that has no parameters, will throw an exception with a useful message' );
    }

    /**
    * @method  get.call.of.parameters
    * @case    when given the details of a method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void getCallOfParameters_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.methodUnderMock( 'ActualParam', 2 );
            List<Object> passedParameters = classUnderMockController.get().call( 0 ).of( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam', 2 }, passedParameters, 'get.call.of.parameters, when given the details of a method call that happened, will return the parameters of that call' );
    }

    /**
    * @method  get.latestCallOf.parameters
    * @case    when given the details of the last method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void getLatestCallOfParameters_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            classUnderMock.methodUnderMock( 'ActualParam1', 2 );
            classUnderMock.methodUnderMock( 'ActualParam2', 3 );
            classUnderMock.methodUnderMock( 'ActualParam3', 4 );
            List<Object> passedParameters = classUnderMockController.get().latestCallOf( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam3', 4 }, passedParameters, 'get.latestCallOf.parameters, when given the details of a method call that happened, will return the parameters of that call' );
    }

    /**
    * @method  parameter
    * @case    when a parameter is a list of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameters_whenAParameterIsAListOfObjects_willReturnTheParameter() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            List<Object> parameterPassed = new List<Object>{ 2, '3', new Account() };

            classUnderMock.methodWithListObject( parameterPassed );
            List<Object> parameterReturned = (List<Object>)classUnderMockController.call( 0 ).of( 'methodWithListObject' ).parameter( 0 );
        Test.stopTest();
        
        System.assertEquals( parameterPassed, parameterReturned, 'parameters, when a parameter is a list of objects, will return the parameter' );
    }

    /**
    * @method  parameter
    * @case    when a parameter is a set of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameters_whenAParameterIsASetOfObjects_willReturnTheParameter() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            Set<Object> parameterPassed = new Set<Object>{ 2, '3', new Account() };

            classUnderMock.methodWithSetObject( parameterPassed );
            Set<Object> parameterReturned = (Set<Object>)classUnderMockController.call( 0 ).of( 'methodWithSetObject' ).parameter( 0 );
        Test.stopTest();
        
        System.assertEquals( parameterPassed, parameterReturned, 'parameters, when a parameter is a set of objects, will return the parameter' );
    }

    /**
    * @method  parameter
    * @case    when a parameter is a map of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameters_whenAParameterIsAMapOfObjects_willReturnTheParameter() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        Test.startTest();
            Map<String,Object> parameterPassed = new Map<String,Object>{ 'one' => 1, 'two' => '2', 'three' => new Contact() };

            classUnderMock.methodWithMapStringObject( parameterPassed );
            Map<String,Object> parameterReturned = (Map<String,Object>)classUnderMockController.call( 0 ).of( 'methodWithMapStringObject' ).parameter( 0 );
        Test.stopTest();
        
        System.assertEquals( parameterPassed, parameterReturned, 'parameters, when a parameter is a map of objects, will return the parameter' );
    }

    //
    // Mock Object behaviour tests
    //
    /**
    * @method  expects.method
    * @case    when the method is called
    * @result  will not fail
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsCalled_willNotFailAndWill() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMockWithNoReturn' );

        Test.startTest();
            classUnderMock.methodUnderMockWithNoReturn( 'this', 1 );
        Test.stopTest();
        
        System.assertEquals( 1, classUnderMockController.countOf( 'methodUnderMockWithNoReturn' ), 'expects.method, when the method is called once, will not fail - and the call count will be 1' );
    }

    /**
    * @method  expects.method
    * @case    when the method is called more than once
    * @result  will fail the test
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsCalledMoreThanOnce_willFailTheTest() {
        
        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .allows()
                .method( 'assertEquals' )
            .also().when()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMockWithNoReturn' );

        Test.startTest();
            classUnderMock.methodUnderMockWithNoReturn( 'this', 1 );

            try {
                classUnderMock.methodUnderMockWithNoReturn( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMockWithNoReturn was called more times than was expected';
        System.assertEquals( false            , mockAsserts.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when the method is not called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAsserts.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMockWithNoReturn' );

        Test.startTest();
            // we do nothing, because we're testing what happens when the method is not called
        Test.stopTest();
        
        System.assertEquals( 0, classUnderMockController.countOf( 'methodUnderMockWithNoReturn' ), 'expects.method, when the method is not called, and neither is verify, will not fail - and the call count will be zero' );
    }

    /**
    * @method  expects.method
    * @case    when the method is not called, and verify is
    * @result  will fail
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsNotCalledAndVerifyId_willFail() {
        
        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMockWithNoReturn' );

        Test.startTest();
            classUnderMockController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassUnderMock should be empty, and it is not';

        System.assertEquals( ''                             , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderMockWithNoReturn()', mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion              , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            String actualReturn = classUnderMock.methodUnderMock( 'this', 1 );
        Test.stopTest();
        
        System.assertEquals( 'TheReturn', actualReturn, 'expects.method, when the method is called, will not fail, and will return the stated result' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is called more than once
    * @result  will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalledMoreThanOnce_willFailTheTest() {
        
        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .allows()
                .method( 'assertEquals' )
            .also().when()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'this', 1 );

            try {
                classUnderMock.methodUnderMock( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAsserts.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAsserts.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            // we do nothing, because we're testing what happens when the method is not called
        Test.stopTest();
        
        System.assertEquals( 0, classUnderMockController.countOf( 'methodUnderMock' ), 'expects.method.returning, when the method is not called, and neither is verify, will not fail - and the call count will be zero' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is not called, and verify is
    * @result  will fail
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsNotCalledAndVerifyId_willFail() {
        
        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMockController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassUnderMock should be empty, and it is not';

        System.assertEquals( ''                 , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderMock()', mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion  , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            String actualReturn = classUnderMock.methodUnderMock( 'this', 1 );
        Test.stopTest();
        
        System.assertEquals( 'TheReturn', actualReturn, 'expects.method.withAnyParameters.returning, when the method is called, will not fail, and will return the stated result' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is called more than once
    * @result  will fail the test
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsCalledMoreThanOnce_willFailTheTest() {
        
        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .allows()
                .method( 'assertEquals' )
            .also().when()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'this', 1 );

            try {
                classUnderMock.methodUnderMock( 'thisNew', 2 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAsserts.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method.withAnyParameters.returning, when the method is not called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAsserts.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            // we do nothing, because we're testing what happens when the method is not called
        Test.stopTest();
        
        System.assertEquals( 0, classUnderMockController.countOf( 'methodUnderMock' ), 'expects.method.withAnyParameters.returning, when the method is not called, and neither is verify, will not fail - and the call count will be zero' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is not called, and verify is
    * @result  will fail
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsNotCalledAndVerifyId_willFail() {
        
        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMockController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassUnderMock should be empty, and it is not';

        System.assertEquals( ''                 , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderMock()', mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion  , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.andThenParameter.returning
    * @case    when the method is called with matching parameters
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithParameterAndThenParameterReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            String actualReturn = classUnderMock.methodUnderMock( 'this', 1 );
        Test.stopTest();
        
        System.assertEquals( 'TheReturn', actualReturn, 'expects.method.withParameter.andThenParameter.returning, when the method is called with matching parameters, will not fail, and will return the stated result' );
    }

    /**
    * @method  expects.method.withParameter.andThenParameter.returning
    * @case    when the method is called with non-matching parameters
    * @result  will fail the test
    */
    @isTest
    private static void expectsMethodWithParameterAndThenParameterReturning_whenTheMethodIsCalledWithNonMatchingParameters_willFailTheTest() {
        
        Amoss_Instance mockAsserts = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAssertsgenerateMock = (Amoss_Asserts)mockAsserts.generateMock();
        mockAsserts
            .when()
                .method( 'assertEquals' )
                .withParameter( 'this' )
                .andThenParameter( 'not-this' )
                .andThenAnyParameter()
                .throws( new TestException( 'Mismatching assertion would normally halt the test, so we will too' ) )
            .also().allows()
                .method( 'assertEquals' )
                .withAnyParameters();

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAssertsgenerateMock );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateMock();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classUnderMock.methodUnderMock( 'not-this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called with the wrong parameter value in position 0';
        System.assertEquals( 'this'           , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assertEquals with the expected parameter value' );
        System.assertEquals( 'not-this'       , mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assertEquals with the actual parameter value' );
        System.assertEquals( expectedAssertion, mockAsserts.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assert with an assertion message that clearly describes the issue' );
    }    

    // expects.method.withParameter.andThenParameter.returns - when the method call includes nulls and matches, passes
    // expects.method.withParameter.andThenParameter.returns - when the method call includes nulls and does not match, fails

    // expects.method.withParameter.andThenParameter.returns - when the method call includes nulls and matches, passes

    // expects.method.then.expects.method - when both methods are called in order, passes
    // expects.method.then.expects.method - when both methods called, but out of order, fails
    // expects.method.then.expects.method - no verify when one method called, passes
    // expects.method.then.expects.method - verify when one method called, fails

    // expects.method.also.expects.method - when both methods are called in order, passes

}