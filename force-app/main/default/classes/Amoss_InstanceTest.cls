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

@isTest
public with sharing class Amoss_InstanceTest {

    class TestException extends Exception {}

    //
    // Method definition tests
    //
    /**
    * @case   when no methods are defined, and a method is called
    * @result will return null
    */
    @isTest
    private static void whenNoMethodsAreDefinedAndAMethodIsCalled_willReturnNull() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        Test.startTest();
            String returnFromMock = classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromMock, 'when no methods are defined, and a method called, will return null' );
    }

    /**
    * @method when.method.willReturn
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWillReturn_whenTheMethodIsCalled_willReturnTheStatedValue() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromMock = classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromMock, 'when.method.willReturn, and the method called, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method when.method.willReturn
    * @case   when a different method is called
    * @result will return null
    */
    @isTest
    private static void whenMethodWillReturn_whenADifferentMethodIsCalled_willReturnNull() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'willNotBeReturned' );

        Test.startTest();
            String returnFromMock = classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromMock, 'when.method.willReturn, and a different method called, will return null' );
    }

    /**
    * @method when.method.withParameter.willReturn
    * @case   when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterWillReturn_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromMock = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromMock, 'when.method.withParameter.willReturn, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.willReturn
    * @case   when that method is called with different parameters
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterWillReturn_whenTheMethodIsCalledWithDifferentParameters_willReturnNull() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'willNotSeeThis' );

        Test.startTest();
            String returnFromMock = classUnderMock.methodUnderMock( 'DifferentParam', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromMock, 'when.method.withParameter.willReturn, and the method called with the different parameters, will return null' );
    }

    /**
    * @method when.method.withParameter.willReturn multiple times
    * @case   when that method is called with the stated parameters
    * @result will return the stated value for each call
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValues() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam2' )
                .andThenParameter( 2 )
                .willReturn( 'expectedReturn2' );

        Test.startTest();
            String returnFromMock1 = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromMock2 = classUnderMock.methodUnderMock( 'ActualParam2', 2 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromMock1, 'when.method.withParameter.willReturn multiple times, and the method called with the stated parameters, will return the stated value for the matching parameters' );
        System.assertEquals( 'expectedReturn2', returnFromMock2, 'when.method.withParameter.willReturn multiple times, and the method called with the stated parameters, will return the stated value for the matching parameters' );
    }

    /**
    * @method when.method.withParameter.willReturn multiple times 
    * @case   when the same method is defiend with the same parameters and it is called multiple times
    * @result will always return the first value with parameters that match
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenSameParamsUsed_willAlwaysReturnTheFirstMatch() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' );

        Test.startTest();
            String returnFromMock1 = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromMock2 = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromMock1, 'when.method.withParameter.willReturn multiple times, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (1st call)' );
        System.assertEquals( 'expectedReturn1', returnFromMock2, 'when.method.withParameter.willReturn multiple times, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (2nd call)' );
    }    

    /**
    * @method when.method.withParameter.willReturn multiple times
    * @case   when different methods are defined with the same parameters
    * @result will return the stated value for each call, based on the method called
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenDifferentMethodsDefined_willReturnTheStatedValues() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'otherMethodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn2' );

        Test.startTest();
            String returnFromMock1 = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromMock2 = classUnderMock.otherMethodUnderMock( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromMock1, 'when.method.withParameter.willReturn multiple times, with different methods with the same parameters, will return the stated value for the matching method (1)' );
        System.assertEquals( 'expectedReturn2', returnFromMock2, 'when.method.withParameter.willReturn multiple times, with different methods with the same parameters, will return the stated value for the matching method (2)' );
    }

    /**
    * @method when.method.withAnyParameter.willReturn
    * @case   and multiple method calls are defined
    * @result will match in order, returning the first definition that matches
    */
    @isTest
    private static void whenMethodWithAnyParameterWillReturnMultiple_whenTheMethodIsCalledWithTheParameters_willReturnTheFirstMatching() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'willNotSeeThis' )
            .also().when()
                .method( 'methodUnderMock' )
                .withAnyParameter()
                .andThenParameter( 1 )
                .willReturn( 'expectedReturnFor1' )
            .also().when()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .willReturn( 'expectedReturnForAnythingElse' );

        Test.startTest();
            String returnFromMock1 = classUnderMock.methodUnderMock( 'DropToWithAnyParam' , 1 );
            String returnFromMock2 = classUnderMock.methodUnderMock( 'DropToWithAnyParams', 100 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturnFor1'           , returnFromMock1, 'when.method.withParameter.willReturn multiple times, and the method called with parameters that match many options, will return the first matching value (1)' );
        System.assertEquals( 'expectedReturnForAnythingElse', returnFromMock2, 'when.method.withParameter.willReturn multiple times, and the method called with parameters that match many options, will return the first matching value (2)' );
    }

    /**
    * @method allows.method.returning
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void allowsMethodReturning_whenTheMethodIsCalled_willReturnTheStatedValue() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allows()
                .method( 'methodUnderMock' )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromMock = classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromMock, 'allows.method.returning, and the method called, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method allows.method.returning
    * @case   when a different method is called
    * @result will fail the test
    */
    @isTest
    private static void allowsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allows()
                .method( 'methodUnderMock' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromMock = classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassUnderMock.otherMethodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method.returning, when a different method is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method.returning, when a different method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method allows.method.returning
    * @case   when the method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allows()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromMock = classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassUnderMock.otherMethodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method.returning, when the method is called with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method.returning, when the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method allows.method.returning
    * @case   when multiple methods are defined and called
    * @result will return the stated value for each method
    */
    @isTest
    private static void allowsMethodReturning_whenMultipleMethodsAreDefinedAndCalled_willReturnTheStatedValues() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allows()
                .method( 'methodUnderMock' )
                .returning( 'expectedReturn1' )
            .also().allows()
                .method( 'otherMethodUnderMock' )
                .returning( 'expectedReturn2' );

        Test.startTest();
            String returnFromMock1 = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromMock2 = classUnderMock.otherMethodUnderMock( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromMock1, 'allows.method.returning, when multiple methods are defined and each are called, will return the stated value for each method (1)' );
        System.assertEquals( 'expectedReturn2', returnFromMock2, 'allows.method.returning, when multiple methods are defined and each are called, will return the stated value for each method (2)' );
    }

    /**
    * @method allows.method.returning
    * @case   when the same method is defined with different parameters
    * @result will return the stated value for the first matching
    */
    @isTest
    private static void allowsMethodReturning_whenMethodIsDefinedWithMultipleParameters_willReturnTheFirstThatMatches() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allows()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'returnForExactMatch' )
            .also().allows()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenAnyParameter()
                .returning( 'returnForFirstParamMatch' )
            .also().allows()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .returning( 'returnForGenericMatch' );

        Test.startTest();
            String returnFromExactMatch      = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromFirstParamMatch = classUnderMock.methodUnderMock( 'ActualParam1', 100 );
            String returnFromGenericMatch    = classUnderMock.methodUnderMock( 'AnyOleParam', 100 );
        Test.stopTest();
        
        System.assertEquals( 'returnForExactMatch'     , returnFromExactMatch     , 'allows.method.returning, when method is defined with multiple overlapping parameters, will return the first stated value that matches the parameters (1)' );
        System.assertEquals( 'returnForFirstParamMatch', returnFromFirstParamMatch, 'allows.method.returning, when method is defined with multiple overlapping parameters, will return the first stated value that matches the parameters (2)' );
        System.assertEquals( 'returnForGenericMatch'   , returnFromGenericMatch   , 'allows.method.returning, when method is defined with multiple overlapping parameters, will return the first stated value that matches the parameters (3)' );
    }

    /**
    * @method expects.method.returning
    * @case   when that method is called once
    * @result will return the stated value
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalledOnce_willReturnTheStatedValue() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromMock = classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromMock, 'expects.method.returning, and the method called once, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method expects.method.returning
    * @case   when a different method is called
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromMock = classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was expected to be called';
        System.assertEquals( 'methodUnderMock'     , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with the expected method' );
        System.assertEquals( 'otherMethodUnderMock', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with the actual method called' );
        System.assertEquals( expectedAssertion     , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expects.method.returning
    * @case   when the method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        // TODO: when we can inject a handler, change this over so we can fail the test, and then use latestCallOf instead
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromMock = classUnderMock.otherMethodUnderMock( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called with the wrong parameter value in position 0';
        System.assertEquals( 'ActualParam1'     , mockAssertsController.get().call(2).of( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when the method is called with different parameters, will fail by calling assertEquals with the expected parameter value' );
        System.assertEquals( 'OtherActualParam1', mockAssertsController.get().call(2).of( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when the method is called with different parameters, will fail by calling assertEquals with the actual parameter value' );
        System.assertEquals( expectedAssertion  , mockAssertsController.get().call(2).of( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when the method is called with different parameters, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expects.method.returning
    * @case   when multiple methods are defined and called in the stated order
    * @result will return the stated value for each method
    */
    @isTest
    private static void expectsMethodReturning_whenMultipleMethodsAreDefinedAndCalledInOrder_willReturnTheStatedValues() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'expectedReturn1' )
            .also().allows()
                .method( 'otherMethodUnderMock' )
                .returning( 'expectedReturn2' );

        Test.startTest();
            String returnFromMock1 = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromMock2 = classUnderMock.otherMethodUnderMock( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromMock1, 'expects.method.returning, when multiple methods are defined and each are called in order, will return the stated value for each method (1)' );
        System.assertEquals( 'expectedReturn2', returnFromMock2, 'expects.method.returning, when multiple methods are defined and each are called in order, will return the stated value for each method (2)' );
    }

    /**
    * @method expects.method.returning
    * @case   when the same method is defined with the same parameters, and called in order
    * @result will return the stated value for the first matching
    */
    @isTest
    private static void expectsMethodReturning_whenMethodIsDefinedWithSameParametersAndCalledInOrder_willReturnTheResultsInOrder() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'thirdReturn' );

        Test.startTest();
            String returnFromFirstCall  = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromSecondCall = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromThirdCall  = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'firstReturn' , returnFromFirstCall , 'expects.method.returning, when method is defined with multiple overlapping parameters, will return the values stated, in the order they are called (1)' );
        System.assertEquals( 'secondReturn', returnFromSecondCall, 'expects.method.returning, when method is defined with multiple overlapping parameters, will return the values stated, in the order they are called (2)' );
        System.assertEquals( 'thirdReturn' , returnFromThirdCall , 'expects.method.returning, when method is defined with multiple overlapping parameters, will return the values stated, in the order they are called (3)' );
    }

    /**
    * @method expects.method.returning
    * @case   when the same method is defined with the any parameters methods, and called in order
    * @result will return the stated value for the first matching
    */
    @isTest
    private static void expectsMethodReturning_whenMethodIsDefinedWithAnyParametersAndCalledInOrder_willReturnTheResultsInOrder() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderMock' )
                .withAnyParameter()
                .andThenParameter( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderMock' )
                .withParameter( 'ActualParam1' )
                .andThenAnyParameter()
                .returning( 'thirdReturn' );

        Test.startTest();
            String returnFromFirstCall  = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromSecondCall = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
            String returnFromThirdCall  = classUnderMock.methodUnderMock( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'firstReturn' , returnFromFirstCall , 'expects.method.returning, when method is defined with multiple overlapping parameters using the anyParameter methods, will return the values stated, in the order they are called (1)' );
        System.assertEquals( 'secondReturn', returnFromSecondCall, 'expects.method.returning, when method is defined with multiple overlapping parameters using the anyParameter methods, will return the values stated, in the order they are called (2)' );
        System.assertEquals( 'thirdReturn' , returnFromThirdCall , 'expects.method.returning, when method is defined with multiple overlapping parameters using the anyParameter methods, will return the values stated, in the order they are called (3)' );
    }

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
    private static void expectsMethod_whenTheMethodIsCalled_willNotFail() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when the method is called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when the method is called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
    private static void expectsMethod_whenTheMethodIsNotCalledAndVerifyIs_willFail() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMockWithNoReturn' );

        Test.startTest();
            classUnderMockController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassUnderMock should be empty, and it is not';

        System.assertEquals( ''                             , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderMockWithNoReturn()', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion              , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
    private static void expectsMethodReturning_whenTheMethodIsNotCalledAndVerifyIs_willFail() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMockController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassUnderMock should be empty, and it is not';

        System.assertEquals( ''                 , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderMock()', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion  , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method.withAnyParameters.returning, when the method is not called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsNotCalledAndVerifyIs_willFail() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .expects()
                .method( 'methodUnderMock' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMockController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassUnderMock should be empty, and it is not';

        System.assertEquals( ''                 , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderMock()', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion  , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.andThenParameter.returning
    * @case    when the method is called with matching parameters
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithParameterAndThenParameterReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
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
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

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
        System.assertEquals( 'this'           , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assertEquals with the expected parameter value' );
        System.assertEquals( 'not-this'       , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assertEquals with the actual parameter value' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assert with an assertion message that clearly describes the issue' );
    }    

    // expects.method.withParameter.andThenParameter.returns - when the method call includes nulls and matches, passes
    // expects.method.withParameter.andThenParameter.returns - when the method call includes nulls and does not match, fails

    // expects.method.withParameter.andThenParameter.returns - when the method call includes nulls and matches, passes

    // expects.method.then.expects.method - when both methods are called in order, passes
    // expects.method.then.expects.method - when both methods called, but out of order, fails
    // expects.method.then.expects.method - no verify when one method called, passes
    // expects.method.then.expects.method - verify when one method called, fails

    // expects.method.also.expects.method - when both methods are called in order, passes

    //
    // Allow any call tests
    //

    /**
    * @method  allowAnyCall
    * @case    when given false, no methods are defined, and a method is called
    * @result  will make the test fail
    */
    @isTest
    private static void allowAnyCall_whenGivenFalseAndNoMethodsAreDefinedAndAMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        Test.startTest();
            classUnderMockController
                .allowsAnyCall( false );

            try {
                classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall
    * @case    when given true, no methods are defined, and a method is called
    * @result  will return null
    */
    @isTest
    private static void allowAnyCall_whenGivenTrueAndAndNoMethodsAreDefinedAndAMethodIsCalled_willReturnNull() {
        
        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        Test.startTest();
            classUnderMockController
                .allowsAnyCall( true );
            String returnFromMock = classUnderMock.methodUnderMock( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromMock, 'when given true, when no methods are defined, and a method is called, will return null' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning
    * @case    when the method is called more than once
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledMoreThanOnce_willNotFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'this', 1 );
            classUnderMock.methodUnderMock( 'this', 1 );
        Test.stopTest();

        classUnderMockController.verify();
        
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when the method is called more than once
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenTheMethodIsCalledMoreThanOnce_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
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
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenADifferentMethodIsCalled_willNotFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'this', 1 );
            classUnderMock.otherMethodUnderMock( 'this', 1 );
        Test.stopTest();

        classUnderMockController.verify();
        
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and a method that is not expected is called, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and a method that is not expected is called, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'this', 1 );

            try {
                classUnderMock.otherMethodUnderMock( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.otherMethodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning
    * @case    when the method is called again with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'this', 1 );
            classUnderMock.methodUnderMock( 'that', 1 );
        Test.stopTest();

        classUnderMockController.verify();
        
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, with different parameters, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when the method is called again with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'this', 1 );

            try {
                classUnderMock.methodUnderMock( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning.verify
    * @case    when the method is called only with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledOnlyWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'that', 1 );
        Test.stopTest();

        classUnderMockController.verify();
        
        System.assertEquals( ''                       , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and the expected method only once, with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( 'methodUnderMock(this,1)', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and the expected method only once, with different parameters, and verify is called, will call assertEquals with a non empty actual remaining call stack - and fail the test' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when the method is only called with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenTheMethodIsOnlyCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
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
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
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
        System.assertEquals( 'this'           , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.andThenParameter.returning, and allowAnyCalls with false, when the method is only called with non-matching parameters, will fail, by calling assertEquals with the expected parameter value' );
        System.assertEquals( 'not-this'       , mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.andThenParameter.returning, and allowAnyCalls with false, when the method is only called with non-matching parameters, will fail, by calling assertEquals with the actual parameter value' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.andThenParameter.returning, and allowAnyCalls with false, when the method is only called with non-matching parameters, will fail, by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.when.method.willReturn
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_whenMethodWillReturn_whenADifferentMethodIsCalled_willNotFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'TheReturn' );

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'this', 1 );
        Test.stopTest();

        classUnderMockController.verify();
        
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'when.method, when allowAnyCalls is true, and a method that is not set up as a when is called, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'when.method, when allowAnyCalls is true, and a method that is not set up as a when is called, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.when.method.willReturn
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_whenMethodWillReturn_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
            .when()
                .method( 'methodUnderMock' )
                .willReturn( 'TheReturn' );

        Test.startTest();
            try {
                classUnderMock.otherMethodUnderMock( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.otherMethodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'when.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'when.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.when.method.willReturn
    * @case    when the method is called again with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_whenMethodWillReturn_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .willReturn( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'that', 1 );
        Test.stopTest();

        classUnderMockController.verify();
        
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'when.method, when allowAnyCalls is true, and the when method is called with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', mockAssertsController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'when.method, when allowAnyCalls is true, and the when method is called with different parameters, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.when.method.willReturn
    * @case    when the method is called again with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_whenMethodWillReturn_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
            .when()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .willReturn( 'TheReturn' );

        Test.startTest();
            try {
                classUnderMock.methodUnderMock( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'when.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'when.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.allows.method.returning
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_allowsMethodReturning_whenADifferentMethodIsCalled_willNotFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .allows()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.otherMethodUnderMock( 'this', 1 );
        Test.stopTest();

        System.assertEquals( 0, mockAssertsController.countOf( 'assert'       ), 'allows.method, when allowAnyCalls is true, and a method that is not explicitly allowed is called, will not fail the tests (no assert called)' );
        System.assertEquals( 0, mockAssertsController.countOf( 'assertEquals' ), 'allows.method, when allowAnyCalls is true, and a method that is not explicitly allowed is called, will not fail the tests (no assert equals called)' );
    }

    /**
    * @method  allowAnyCall.false.allows.method.returning
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_allowsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
            .allows()
                .method( 'methodUnderMock' )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classUnderMock.otherMethodUnderMock( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.otherMethodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method, when allowAnyCall is called with false, and a method that is not explictly allowed is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method, when allowAnyCall is called with false, and a method that is not explictly allowed is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.allows.method.returning
    * @case    when the method is called with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( true )
            .allows()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classUnderMock.methodUnderMock( 'that', 1 );
        Test.stopTest();

        System.assertEquals( 0, mockAssertsController.countOf( 'assert'       ), 'allows.method, when allowAnyCalls is true, and the allowed method is called with different parameters, will not fail the test (no assert called)' );
        System.assertEquals( 0, mockAssertsController.countOf( 'assertEquals' ), 'allows.method, when allowAnyCalls is true, and the allowed method is called with different parameters, will not fail the test (no assert equals called)' );
    }

    /**
    * @method  allowAnyCall.false.allows.method.returning
    * @case    when the method is called with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance mockAssertsController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts mockAsserts = (Amoss_Asserts)mockAssertsController.generateDouble();
        mockAssertsController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classUnderMockController = new Amoss_Instance( Amoss_ClassUnderMock.class );
        classUnderMockController.setAsserts( mockAsserts );
        Amoss_ClassUnderMock classUnderMock = (Amoss_ClassUnderMock)classUnderMockController.generateDouble();

        classUnderMockController
            .allowsAnyCall( false )
            .allows()
                .method( 'methodUnderMock' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classUnderMock.methodUnderMock( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassUnderMock.methodUnderMock was called more times than was expected';
        System.assertEquals( false            , mockAssertsController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, mockAssertsController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }
}