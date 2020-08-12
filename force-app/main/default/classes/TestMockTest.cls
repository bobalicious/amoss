@isTest
public with sharing class TestMockTest {

    /**
    * @method  countOf
    * @case    when given a method call that happened
    * @result  will return the number of times that method was called
    */
    @isTest
    private static void callCount_whenGivenAMethodCallThatHappened_willReturnTheNumberOfCalls() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'something' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam2', 2 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMockProxy.methodUnderMock( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMockProxy.methodUnderMock( 'ActualParam4', 4 );

            Integer returnedMethodCallCount = classUnderMock.countOf( 'methodUnderMock' );
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'something' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .willReturn( 'something' );

        Test.startTest();
            Integer returnedMethodCallCount = classUnderMock.countOf( 'methodUnderMock' );
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );
            List<Object> passedParameters = classUnderMock.call( 0 ).of( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam', 2 }, passedParameters, 'call.of.parameters, when given the details of a method call that happened, will return the parameters of that call' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method call that happened amongst many
    * @result  will return the parameters of that call
    */
    @isTest
    private static void callOfParameters_whenGivenACallThatHappenedAmongstMany_willReturnTheParametersOfThatCall() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'something' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam2', 2 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMockProxy.methodUnderMock( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMockProxy.methodUnderMock( 'ActualParam4', 4 );

            List<Object> passedParameters = classUnderMock.call( 2 ).of( 'methodUnderMock' ).parameters();
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'something' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam2', 2 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMockProxy.methodUnderMock( 'ActualParam3', 3 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam3', 3 );
            classUnderMockProxy.methodUnderMock( 'ActualParam4', 4 );  // this is the one we're going to retrieve
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam4', 4 );

            List<Object> passedParameters = classUnderMock.call( -1 ).of( 'methodUnderMock' ).parameters();
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'something' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam2', 2 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMockProxy.methodUnderMock( 'ActualParam3', 3 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam3', 3 );
            classUnderMockProxy.methodUnderMock( 'ActualParam4', 4 );  // this is the one we're going to retrieve
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam4', 4 );

            List<Object> passedParameters = classUnderMock.latestCallOf( 'methodUnderMock' ).parameters();
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'something' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam2', 2 ); // this is the one we're going to retrieve
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMockProxy.methodUnderMock( 'ActualParam3', 3 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMockProxy.methodUnderMock( 'ActualParam4', 4 );

            List<Object> passedParameters = classUnderMock.call( -3 ).of( 'methodUnderMock' ).parameters();
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'sobjectMethodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();
            Contact passedContact = new Contact( FirstName = 'Person' );

            classUnderMockProxy.sobjectMethodUnderMock( passedContact );
            List<Object> passedParameters = classUnderMock.call( 0 ).of( 'sobjectMethodUnderMock' ).parameters();
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodWithNoParametersUnderMock' )
            .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.methodWithNoParametersUnderMock();
            List<Object> passedParameters = classUnderMock.call( 0 ).of( 'methodWithNoParametersUnderMock' ).parameters();
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();

            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classUnderMock.call( 1 ).of( 'methodUnderMock' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a call number that did not happen, will throw an exception' );
        TestAsserts.assertContains( 'methodUnderMock was not called 2 times', exceptionMessage, 'call.of.parameters, when given the details of a call number that did not happen, will throw an exception with a useful message' );
    }


    /**
    * @method  call.of.parameters
    * @case    when given a negative call number that did not happen
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameters_whenGivenANegativeCallNumberThatDidNotHappen_willThrowAnException() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();

            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classUnderMock.call( -2 ).of( 'methodUnderMock' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a negative call number that did not happen, will throw an exception' );
        TestAsserts.assertContains( 'methodUnderMock was not called 2 times', exceptionMessage, 'call.of.parameters, when given the details of a negative mcall number that did not happen, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameters_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classUnderMock.call( 0 ).of( 'methodUnderMock' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a method that was never called, will throw an exception' );
        TestAsserts.assertContains( 'methodUnderMock was never called', exceptionMessage, 'call.of.parameters, when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method call that happened
    * @result  will return the stated parameter of that call
    */
    @isTest
    private static void callOfParameter_whenGivenACallThatHappened_willReturnTheStatedParameterOfThatCall() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );
            Object passedParameter = classUnderMock.call( 0 ).of( 'methodUnderMock' ).parameter( 0 );
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'something' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam1', 1 );
            classUnderMockProxy.methodUnderMock( 'ActualParam2', 2 );
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 2 );
            classUnderMockProxy.methodUnderMock( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classUnderMockProxy.otherMethodUnderMock( 'OtherActualParam2', 3 );
            classUnderMockProxy.methodUnderMock( 'ActualParam4', 4 );

            Object passedParameter = classUnderMock.call( 2 ).of( 'methodUnderMock' ).parameter( 1 );
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();

            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMock.call( 1 ).of( 'methodUnderMock' ).parameter( 1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given the details of a call number that did not happen, will throw an exception' );
        TestAsserts.assertContains( 'methodUnderMock was not called 2 times', exceptionMessage, 'call.of.parameter, when given the details of a call number that did not happen, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMock.call( 0 ).of( 'methodUnderMock' ).parameter( 1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given the details of a method that was never called, will throw an exception' );
        TestAsserts.assertContains( 'methodUnderMock was never called', exceptionMessage, 'call.of.parameter, when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number that is out of range
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNumberThatIsOutOfRange_willThrowAnException() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();

            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMock.call( 0 ).of( 'methodUnderMock' ).parameter( 2 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number that is out of range, will throw an exception' );
        TestAsserts.assertContains( 'methodUnderMock was not called with 3 parameters', exceptionMessage, 'call.of.parameter, when given a parameter number that is out of range, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number that is negative
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNumberThatIsNegative_willThrowAnException() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();

            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMock.call( 0 ).of( 'methodUnderMock' ).parameter( -1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number that is negative, will throw an exception' );
        TestAsserts.assertContains( 'Cannot request a negative parameter number (got -1)', exceptionMessage, 'call.of.parameter, when given a parameter number that is negative, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number for a method that has no parameters
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterForAMethodThatHasNoParameters_willThrowAnException() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodWithNoParametersUnderMock' )
            .willReturn( 'something' );

        Test.startTest();

            classUnderMockProxy.methodWithNoParametersUnderMock();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classUnderMock.call( 0 ).of( 'methodWithNoParametersUnderMock' ).parameter( 0 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number for a method that has no parameters, will throw an exception' );
        TestAsserts.assertContains( 'methodWithNoParametersUnderMock was not called with any parameters', exceptionMessage, 'call.of.parameter, when given a parameter number for a method that has no parameters, will throw an exception with a useful message' );
    }

    /**
    * @method  get.call.of.parameters
    * @case    when given the details of a method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void getCallOfParameters_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.methodUnderMock( 'ActualParam', 2 );
            List<Object> passedParameters = classUnderMock.get().call( 0 ).of( 'methodUnderMock' ).parameters();
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
        
        TestMock classUnderMock = new TestMock( ClassUnderMock.class );
        ClassUnderMock classUnderMockProxy = (ClassUnderMock)classUnderMock.proxy();

        classUnderMock
            .when()
            .method( 'methodUnderMock' )
            .willReturn( 'something' );

        Test.startTest();
            classUnderMockProxy.methodUnderMock( 'ActualParam1', 2 );
            classUnderMockProxy.methodUnderMock( 'ActualParam2', 3 );
            classUnderMockProxy.methodUnderMock( 'ActualParam3', 4 );
            List<Object> passedParameters = classUnderMock.get().latestCallOf( 'methodUnderMock' ).parameters();
        Test.stopTest();
        
        System.assertEquals( new List<Object>{ 'ActualParam3', 4 }, passedParameters, 'get.latestCallOf.parameters, when given the details of a method call that happened, will return the parameters of that call' );
    }   
}