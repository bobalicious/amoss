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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromDouble, 'when no methods are defined, and a method called, will return null' );
    }

    /**
    * @case   for an interface, when no methods are defined, and a method is called
    * @result will return null
    */
    @isTest
    private static void forAnInterface_whenNoMethodsAreDefinedAndAMethodIsCalled_willReturnNull() {
        
        Amoss_Instance interfaceUnderDoubleController = new Amoss_Instance( Amoss_InterfaceToDouble.class );
        Amoss_InterfaceToDouble interfaceUnderDouble = (Amoss_InterfaceToDouble)interfaceUnderDoubleController.generateDouble();

        Test.startTest();
            String returnFromDouble = interfaceUnderDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromDouble, 'when no methods are defined, and a method called, will return null' );
    }

    /**
    * @method when.method.willReturn
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWillReturn_whenTheMethodIsCalled_willReturnTheStatedValue() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.willReturn, and the method called, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method when.method.willReturn
    * @case   for an interface, when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWillReturn_forAnInterface_whenTheMethodIsCalled_willReturnTheStatedValue() {
        
        Amoss_Instance interfaceUnderDoubleController = new Amoss_Instance( Amoss_InterfaceToDouble.class );
        Amoss_InterfaceToDouble interfaceUnderDouble = (Amoss_InterfaceToDouble)interfaceUnderDoubleController.generateDouble();

        interfaceUnderDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = interfaceUnderDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.willReturn, for an interface, and the method called, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method when.method.willReturn
    * @case   when a different method is called
    * @result will return null
    */
    @isTest
    private static void whenMethodWillReturn_whenADifferentMethodIsCalled_willReturnNull() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .willReturn( 'willNotBeReturned' );

        Test.startTest();
            String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromDouble, 'when.method.willReturn, and a different method called, will return null' );
    }

    /**
    * @method when.method.withParameter.willReturn
    * @case   when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterWillReturn_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameter.willReturn, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.willReturn
    * @case   for an interface, when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterWillReturn_forAnInterface_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {
        
        Amoss_Instance interfaceUnderDoubleController = new Amoss_Instance( Amoss_InterfaceToDouble.class );
        Amoss_InterfaceToDouble interfaceUnderDouble = (Amoss_InterfaceToDouble)interfaceUnderDoubleController.generateDouble();

        interfaceUnderDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = interfaceUnderDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameter.willReturn, for an interface, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.willReturn
    * @case   when that method is called with different parameters
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterWillReturn_whenTheMethodIsCalledWithDifferentParameters_willReturnNull() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'willNotSeeThis' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'DifferentParam', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.willReturn, and the method called with the different parameters, will return null' );
    }

    /**
    * @method when.method.withParameter.willReturn multiple times
    * @case   when that method is called with the stated parameters
    * @result will return the stated value for each call
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValues() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam2' )
                .andThenParameter( 2 )
                .willReturn( 'expectedReturn2' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.methodUnderDouble( 'ActualParam2', 2 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'when.method.withParameter.willReturn multiple times, and the method called with the stated parameters, will return the stated value for the matching parameters' );
        System.assertEquals( 'expectedReturn2', returnFromDouble2, 'when.method.withParameter.willReturn multiple times, and the method called with the stated parameters, will return the stated value for the matching parameters' );
    }

    /**
    * @method when.method.withParameter.willReturn multiple times 
    * @case   when the same method is defiend with the same parameters and it is called multiple times
    * @result will always return the first value with parameters that match
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenSameParamsUsed_willAlwaysReturnTheFirstMatch() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'when.method.withParameter.willReturn multiple times, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (1st call)' );
        System.assertEquals( 'expectedReturn1', returnFromDouble2, 'when.method.withParameter.willReturn multiple times, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (2nd call)' );
    }    

    /**
    * @method when.method.withParameter.willReturn multiple times
    * @case   when different methods are defined with the same parameters
    * @result will return the stated value for each call, based on the method called
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenDifferentMethodsDefined_willReturnTheStatedValues() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'otherMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'expectedReturn2' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.otherMethodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'when.method.withParameter.willReturn multiple times, with different methods with the same parameters, will return the stated value for the matching method (1)' );
        System.assertEquals( 'expectedReturn2', returnFromDouble2, 'when.method.withParameter.willReturn multiple times, with different methods with the same parameters, will return the stated value for the matching method (2)' );
    }

    /**
    * @method when.method.withAnyParameter.willReturn
    * @case   and multiple method calls are defined
    * @result will match in order, returning the first definition that matches
    */
    @isTest
    private static void whenMethodWithAnyParameterWillReturnMultiple_whenTheMethodIsCalledWithTheParameters_willReturnTheFirstMatching() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .willReturn( 'willNotSeeThis' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withAnyParameter()
                .andThenParameter( 1 )
                .willReturn( 'expectedReturnFor1' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .willReturn( 'expectedReturnForAnythingElse' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'DropToWithAnyParam' , 1 );
            String returnFromDouble2 = classToDouble.methodUnderDouble( 'DropToWithAnyParams', 100 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturnFor1'           , returnFromDouble1, 'when.method.withParameter.willReturn multiple times, and the method called with parameters that match many options, will return the first matching value (1)' );
        System.assertEquals( 'expectedReturnForAnythingElse', returnFromDouble2, 'when.method.withParameter.willReturn multiple times, and the method called with parameters that match many options, will return the first matching value (2)' );
    }

    /**
    * @method allows.method.returning
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void allowsMethodReturning_whenTheMethodIsCalled_willReturnTheStatedValue() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromDouble, 'allows.method.returning, and the method called, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method allows.method.returning
    * @case   when a different method is called
    * @result will fail the test
    */
    @isTest
    private static void allowsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassToDouble.otherMethodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method.returning, when a different method is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method.returning, when a different method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method allows.method.returning
    * @case   when the method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassToDouble.otherMethodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method.returning, when the method is called with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method.returning, when the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method allows.method.returning
    * @case   when multiple methods are defined and called
    * @result will return the stated value for each method
    */
    @isTest
    private static void allowsMethodReturning_whenMultipleMethodsAreDefinedAndCalled_willReturnTheStatedValues() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn1' )
            .also().allows()
                .method( 'otherMethodUnderDouble' )
                .returning( 'expectedReturn2' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.otherMethodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'allows.method.returning, when multiple methods are defined and each are called, will return the stated value for each method (1)' );
        System.assertEquals( 'expectedReturn2', returnFromDouble2, 'allows.method.returning, when multiple methods are defined and each are called, will return the stated value for each method (2)' );
    }

    /**
    * @method allows.method.returning
    * @case   when the same method is defined with different parameters
    * @result will return the stated value for the first matching
    */
    @isTest
    private static void allowsMethodReturning_whenMethodIsDefinedWithMultipleParameters_willReturnTheFirstThatMatches() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'returnForExactMatch' )
            .also().allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenAnyParameter()
                .returning( 'returnForFirstParamMatch' )
            .also().allows()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'returnForGenericMatch' );

        Test.startTest();
            String returnFromExactMatch      = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromFirstParamMatch = classToDouble.methodUnderDouble( 'ActualParam1', 100 );
            String returnFromGenericMatch    = classToDouble.methodUnderDouble( 'AnyOleParam', 100 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn', returnFromDouble, 'expects.method.returning, and the method called once, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method expects.method.returning
    * @case   when a different method is called
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was expected to be called';
        System.assertEquals( 'methodUnderDouble'     , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with the expected method' );
        System.assertEquals( 'otherMethodUnderDouble', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with the actual method called' );
        System.assertEquals( expectedAssertion     , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expects.method.returning
    * @case   when the method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        // TODO: when we can inject a handler, change this over so we can fail the test, and then use latestCallOf instead
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called with the wrong parameter value in position 0';
        System.assertEquals( 'ActualParam1'     , assertsDoubleController.get().call(2).of( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when the method is called with different parameters, will fail by calling assertEquals with the expected parameter value' );
        System.assertEquals( 'OtherActualParam1', assertsDoubleController.get().call(2).of( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when the method is called with different parameters, will fail by calling assertEquals with the actual parameter value' );
        System.assertEquals( expectedAssertion  , assertsDoubleController.get().call(2).of( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when the method is called with different parameters, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expects.method.returning
    * @case   when multiple methods are defined and called in the stated order
    * @result will return the stated value for each method
    */
    @isTest
    private static void expectsMethodReturning_whenMultipleMethodsAreDefinedAndCalledInOrder_willReturnTheStatedValues() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn1' )
            .also().allows()
                .method( 'otherMethodUnderDouble' )
                .returning( 'expectedReturn2' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.otherMethodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'expects.method.returning, when multiple methods are defined and each are called in order, will return the stated value for each method (1)' );
        System.assertEquals( 'expectedReturn2', returnFromDouble2, 'expects.method.returning, when multiple methods are defined and each are called in order, will return the stated value for each method (2)' );
    }

    /**
    * @method expects.method.returning
    * @case   when the same method is defined with the same parameters, and called in order
    * @result will return the stated value for the first matching
    */
    @isTest
    private static void expectsMethodReturning_whenMethodIsDefinedWithSameParametersAndCalledInOrder_willReturnTheResultsInOrder() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenParameter( 1 )
                .returning( 'thirdReturn' );

        Test.startTest();
            String returnFromFirstCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromSecondCall = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromThirdCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withAnyParameter()
                .andThenParameter( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .andThenAnyParameter()
                .returning( 'thirdReturn' );

        Test.startTest();
            String returnFromFirstCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromSecondCall = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromThirdCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam2', 2 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 2 );
            classToDouble.methodUnderDouble( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 3 );
            classToDouble.methodUnderDouble( 'ActualParam4', 4 );

            Integer returnedMethodCallCount = classToDoubleController.countOf( 'methodUnderDouble' );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            Integer returnedMethodCallCount = classToDoubleController.countOf( 'methodUnderDouble' );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam', 2 );
            List<Object> passedParameters = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.methodUnderDoubleWithNoReturn( 'ActualParam', 2 );
            List<Object> passedParameters = classToDoubleController.call( 0 ).of( 'methodUnderDoubleWithNoReturn' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam2', 2 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 2 );
            classToDouble.methodUnderDouble( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 3 );
            classToDouble.methodUnderDouble( 'ActualParam4', 4 );

            List<Object> passedParameters = classToDoubleController.call( 2 ).of( 'methodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam2', 2 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 2 );
            classToDouble.methodUnderDouble( 'ActualParam3', 3 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam3', 3 );
            classToDouble.methodUnderDouble( 'ActualParam4', 4 );  // this is the one we're going to retrieve
            classToDouble.otherMethodUnderDouble( 'OtherActualParam4', 4 );

            List<Object> passedParameters = classToDoubleController.call( -1 ).of( 'methodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam2', 2 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 2 );
            classToDouble.methodUnderDouble( 'ActualParam3', 3 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam3', 3 );
            classToDouble.methodUnderDouble( 'ActualParam4', 4 );  // this is the one we're going to retrieve
            classToDouble.otherMethodUnderDouble( 'OtherActualParam4', 4 );

            List<Object> passedParameters = classToDoubleController.latestCallOf( 'methodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam2', 2 ); // this is the one we're going to retrieve
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 2 );
            classToDouble.methodUnderDouble( 'ActualParam3', 3 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 3 );
            classToDouble.methodUnderDouble( 'ActualParam4', 4 );

            List<Object> passedParameters = classToDoubleController.call( -3 ).of( 'methodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            Contact passedContact = new Contact( FirstName = 'Person' );

            classToDouble.sobjectmethodUnderDouble( passedContact );
            List<Object> passedParameters = classToDoubleController.call( 0 ).of( 'sobjectmethodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.methodWithNoParametersUnderDouble();
            List<Object> passedParameters = classToDoubleController.call( 0 ).of( 'methodWithNoParametersUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            classToDouble.methodUnderDouble( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classToDoubleController.call( 1 ).of( 'methodUnderDouble' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a call number that did not happen, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was not called 2 times', exceptionMessage, 'call.of.parameters, when given the details of a call number that did not happen, will throw an exception with a useful message' );
    }


    /**
    * @method  call.of.parameters
    * @case    when given a negative call number that did not happen
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameters_whenGivenANegativeCallNumberThatDidNotHappen_willThrowAnException() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            classToDouble.methodUnderDouble( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classToDoubleController.call( -2 ).of( 'methodUnderDouble' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a negative call number that did not happen, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was not called 2 times', exceptionMessage, 'call.of.parameters, when given the details of a negative mcall number that did not happen, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameters
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameters_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                List<Object> passedParameters = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameters();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameters, when given the details of a method that was never called, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was never called', exceptionMessage, 'call.of.parameters, when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method call that happened
    * @result  will return the stated parameter of that call
    */
    @isTest
    private static void callOfParameter_whenGivenACallThatHappened_willReturnTheStatedParameterOfThatCall() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam', 2 );
            Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( 0 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam2', 2 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 2 );
            classToDouble.methodUnderDouble( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 3 );
            classToDouble.methodUnderDouble( 'ActualParam4', 4 );

            Object passedParameter = classToDoubleController.call( 2 ).of( 'methodUnderDouble' ).parameter( 1 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            classToDouble.methodUnderDouble( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 1 ).of( 'methodUnderDouble' ).parameter( 1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given the details of a call number that did not happen, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was not called 2 times', exceptionMessage, 'call.of.parameter, when given the details of a call number that did not happen, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( 1 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given the details of a method that was never called, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was never called', exceptionMessage, 'call.of.parameter, when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number that is out of range
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNumberThatIsOutOfRange_willThrowAnException() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            classToDouble.methodUnderDouble( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( 2 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number that is out of range, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was not called with 3 parameters', exceptionMessage, 'call.of.parameter, when given a parameter number that is out of range, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number that is negative
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNumberThatIsNegative_willThrowAnException() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            classToDouble.methodUnderDouble( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( -1 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();

            classToDouble.methodWithNoParametersUnderDouble();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 0 ).of( 'methodWithNoParametersUnderDouble' ).parameter( 0 );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        
        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter, when given a parameter number for a method that has no parameters, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodWithNoParametersUnderDouble was not called with any parameters', exceptionMessage, 'call.of.parameter, when given a parameter number for a method that has no parameters, will throw an exception with a useful message' );
    }

    /**
    * @method  get.call.of.parameters
    * @case    when given the details of a method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void getCallOfParameters_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam', 2 );
            List<Object> passedParameters = classToDoubleController.get().call( 0 ).of( 'methodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam1', 2 );
            classToDouble.methodUnderDouble( 'ActualParam2', 3 );
            classToDouble.methodUnderDouble( 'ActualParam3', 4 );
            List<Object> passedParameters = classToDoubleController.get().latestCallOf( 'methodUnderDouble' ).parameters();
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            List<Object> parameterPassed = new List<Object>{ 2, '3', new Account() };

            classToDouble.methodWithListObject( parameterPassed );
            List<Object> parameterReturned = (List<Object>)classToDoubleController.call( 0 ).of( 'methodWithListObject' ).parameter( 0 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            Set<Object> parameterPassed = new Set<Object>{ 2, '3', new Account() };

            classToDouble.methodWithSetObject( parameterPassed );
            Set<Object> parameterReturned = (Set<Object>)classToDoubleController.call( 0 ).of( 'methodWithSetObject' ).parameter( 0 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            Map<String,Object> parameterPassed = new Map<String,Object>{ 'one' => 1, 'two' => '2', 'three' => new Contact() };

            classToDouble.methodWithMapStringObject( parameterPassed );
            Map<String,Object> parameterReturned = (Map<String,Object>)classToDoubleController.call( 0 ).of( 'methodWithMapStringObject' ).parameter( 0 );
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
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDoubleWithNoReturn' );

        Test.startTest();
            classToDouble.methodUnderDoubleWithNoReturn( 'this', 1 );
        Test.stopTest();
        
        System.assertEquals( 1, classToDoubleController.countOf( 'methodUnderDoubleWithNoReturn' ), 'expects.method, when the method is called once, will not fail - and the call count will be 1' );
    }

    /**
    * @method  expects.method
    * @case    when the method is called more than once
    * @result  will fail the test
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsCalledMoreThanOnce_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDoubleWithNoReturn' );

        Test.startTest();
            classToDouble.methodUnderDoubleWithNoReturn( 'this', 1 );

            try {
                classToDouble.methodUnderDoubleWithNoReturn( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDoubleWithNoReturn was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when the method is called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when the method is called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDoubleWithNoReturn' );

        Test.startTest();
            // we do nothing, because we're testing what happens when the method is not called
        Test.stopTest();
        
        System.assertEquals( 0, classToDoubleController.countOf( 'methodUnderDoubleWithNoReturn' ), 'expects.method, when the method is not called, and neither is verify, will not fail - and the call count will be zero' );
    }

    /**
    * @method  expects.method
    * @case    when the method is not called, and verify is
    * @result  will fail
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsNotCalledAndVerifyIs_willFail() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDoubleWithNoReturn' );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassToDouble should be empty, and it is not';

        System.assertEquals( ''                             , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderDoubleWithNoReturn()', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion              , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            String actualReturn = classToDouble.methodUnderDouble( 'this', 1 );
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
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );

            try {
                classToDouble.methodUnderDouble( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            // we do nothing, because we're testing what happens when the method is not called
        Test.stopTest();
        
        System.assertEquals( 0, classToDoubleController.countOf( 'methodUnderDouble' ), 'expects.method.returning, when the method is not called, and neither is verify, will not fail - and the call count will be zero' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is not called, and verify is
    * @result  will fail
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsNotCalledAndVerifyIs_willFail() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassToDouble should be empty, and it is not';

        System.assertEquals( ''                 , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderDouble()', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion  , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            String actualReturn = classToDouble.methodUnderDouble( 'this', 1 );
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
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );

            try {
                classToDouble.methodUnderDouble( 'thisNew', 2 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method.withAnyParameters.returning, when the method is not called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsNotCalledButNeitherIsVerify_willNotFail() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            // we do nothing, because we're testing what happens when the method is not called
        Test.stopTest();
        
        System.assertEquals( 0, classToDoubleController.countOf( 'methodUnderDouble' ), 'expects.method.withAnyParameters.returning, when the method is not called, and neither is verify, will not fail - and the call count will be zero' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is not called, and verify is
    * @result  will fail
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsNotCalledAndVerifyIs_willFail() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();
        
        String expectedAssertion = 'Expected call stack for Amoss_ClassToDouble should be empty, and it is not';

        System.assertEquals( ''                 , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( 'methodUnderDouble()', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion  , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.andThenParameter.returning
    * @case    when the method is called with matching parameters
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithParameterAndThenParameterReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            String actualReturn = classToDouble.methodUnderDouble( 'this', 1 );
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
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .when()
                .method( 'assertEquals' )
                .withParameter( 'this' )
                .andThenParameter( 'not-this' )
                .andThenAnyParameter()
                .throws( new TestException( 'Mismatching assertion would normally halt the test, so we will too' ) )
            .also().allows()
                .method( 'assertEquals' )
                .withAnyParameters();

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'not-this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();
        
        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called with the wrong parameter value in position 0';
        System.assertEquals( 'this'           , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assertEquals with the expected parameter value' );
        System.assertEquals( 'not-this'       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assertEquals with the actual parameter value' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.andThenParameter.returning, when the method is called with non-matching parameters, will fail, by calling assert with an assertion message that clearly describes the issue' );
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
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDoubleController
                .allowsAnyCall( false );

            try {
                classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall
    * @case    when given true, no methods are defined, and a method is called
    * @result  will return null
    */
    @isTest
    private static void allowAnyCall_whenGivenTrueAndAndNoMethodsAreDefinedAndAMethodIsCalled_willReturnNull() {
        
        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDoubleController
                .allowsAnyCall( true );
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();
        
        System.assertEquals( null, returnFromDouble, 'when given true, when no methods are defined, and a method is called, will return null' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning
    * @case    when the method is called more than once
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledMoreThanOnce_willNotFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );
            classToDouble.methodUnderDouble( 'this', 1 );
        Test.stopTest();

        classToDoubleController.verify();
        
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when the method is called more than once
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenTheMethodIsCalledMoreThanOnce_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );

            try {
                classToDouble.methodUnderDouble( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenADifferentMethodIsCalled_willNotFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );
            classToDouble.otherMethodUnderDouble( 'this', 1 );
        Test.stopTest();

        classToDoubleController.verify();
        
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and a method that is not expected is called, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and a method that is not expected is called, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );

            try {
                classToDouble.otherMethodUnderDouble( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.otherMethodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning
    * @case    when the method is called again with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );
            classToDouble.methodUnderDouble( 'that', 1 );
        Test.stopTest();

        classToDoubleController.verify();
        
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and the expected method is called too many times, with different parameters, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when the method is called again with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );

            try {
                classToDouble.methodUnderDouble( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.expects.method.returning.verify
    * @case    when the method is called only with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledOnlyWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'that', 1 );
        Test.stopTest();

        classToDoubleController.verify();
        
        System.assertEquals( ''                       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowAnyCalls is true, and the expected method only once, with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( 'methodUnderDouble(this,1)', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowAnyCalls is true, and the expected method only once, with different parameters, and verify is called, will call assertEquals with a non empty actual remaining call stack - and fail the test' );
    }

    /**
    * @method  allowAnyCall.false.expects.method.returning
    * @case    when the method is only called with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_expectsMethodReturning_whenTheMethodIsOnlyCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .when()
                .method( 'assertEquals' )
                .withParameter( 'this' )
                .andThenParameter( 'not-this' )
                .andThenAnyParameter()
                .throws( new TestException( 'Mismatching assertion would normally halt the test, so we will too' ) )
            .also().allows()
                .method( 'assertEquals' )
                .withAnyParameters();

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'not-this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called with the wrong parameter value in position 0';
        System.assertEquals( 'this'           , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.andThenParameter.returning, and allowAnyCalls with false, when the method is only called with non-matching parameters, will fail, by calling assertEquals with the expected parameter value' );
        System.assertEquals( 'not-this'       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.andThenParameter.returning, and allowAnyCalls with false, when the method is only called with non-matching parameters, will fail, by calling assertEquals with the actual parameter value' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.andThenParameter.returning, and allowAnyCalls with false, when the method is only called with non-matching parameters, will fail, by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.when.method.willReturn
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_whenMethodWillReturn_whenADifferentMethodIsCalled_willNotFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .when()
                .method( 'methodUnderDouble' )
                .willReturn( 'TheReturn' );

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'this', 1 );
        Test.stopTest();

        classToDoubleController.verify();
        
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'when.method, when allowAnyCalls is true, and a method that is not set up as a when is called, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'when.method, when allowAnyCalls is true, and a method that is not set up as a when is called, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.when.method.willReturn
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_whenMethodWillReturn_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .when()
                .method( 'methodUnderDouble' )
                .willReturn( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.otherMethodUnderDouble( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.otherMethodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'when.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'when.method, when allowAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.when.method.willReturn
    * @case    when the method is called again with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_whenMethodWillReturn_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .willReturn( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'that', 1 );
        Test.stopTest();

        classToDoubleController.verify();
        
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'when.method, when allowAnyCalls is true, and the when method is called with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( '', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'when.method, when allowAnyCalls is true, and the when method is called with different parameters, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowAnyCall.false.when.method.willReturn
    * @case    when the method is called again with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_whenMethodWillReturn_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .willReturn( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'when.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'when.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.allows.method.returning
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_allowsMethodReturning_whenADifferentMethodIsCalled_willNotFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .allows()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'this', 1 );
        Test.stopTest();

        System.assertEquals( 0, assertsDoubleController.countOf( 'assert'       ), 'allows.method, when allowAnyCalls is true, and a method that is not explicitly allowed is called, will not fail the tests (no assert called)' );
        System.assertEquals( 0, assertsDoubleController.countOf( 'assertEquals' ), 'allows.method, when allowAnyCalls is true, and a method that is not explicitly allowed is called, will not fail the tests (no assert equals called)' );
    }

    /**
    * @method  allowAnyCall.false.allows.method.returning
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_allowsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .allows()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.otherMethodUnderDouble( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.otherMethodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method, when allowAnyCall is called with false, and a method that is not explictly allowed is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method, when allowAnyCall is called with false, and a method that is not explictly allowed is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowAnyCall.true.allows.method.returning
    * @case    when the method is called with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowAnyCall_true_allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'that', 1 );
        Test.stopTest();

        System.assertEquals( 0, assertsDoubleController.countOf( 'assert'       ), 'allows.method, when allowAnyCalls is true, and the allowed method is called with different parameters, will not fail the test (no assert called)' );
        System.assertEquals( 0, assertsDoubleController.countOf( 'assertEquals' ), 'allows.method, when allowAnyCalls is true, and the allowed method is called with different parameters, will not fail the test (no assert equals called)' );
    }

    /**
    * @method  allowAnyCall.false.allows.method.returning
    * @case    when the method is called with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowAnyCall_false_allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {
        
        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.generateDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .andThenAnyParameter()
                .throws( new TestException( 'False assertion would normally halt the test, so we will too' ) );

        Amoss_Instance classToDoubleController = new Amoss_Instance( Amoss_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        Amoss_ClassToDouble classToDouble = (Amoss_ClassToDouble)classToDoubleController.generateDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .andThenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Amoss_ClassToDouble.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method, when allowAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    //
    // Limitation tests - If any of these tests begin to fail, then an important limitation
    // has been removed and we may consider changing the functionality / documentation a little
    //
    /**
    * @method generateDouble
    * @case   when given an Sobject to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void generateDouble_whenGivenAnSobjectToCreateATestDoubleFor_willThrowAnException() {
        
        Amoss_Instance sobjectToDoubleController = new Amoss_Instance( Contact.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            Contact classUnderDouble = (Contact)sobjectToDoubleController.generateDouble();
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'generateDouble, when given an Sobject to create a test double for, will throw an exception' );
    }

    /**
    * @method generateDouble
    * @case   when given an inner class to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void generateDouble_whenGivenAnInnerClassToCreateATestDoubleFor_willThrowAnException() {
        
        Amoss_Instance innerClassToDoubleController = new Amoss_Instance( Amoss_InstanceTest.InnerClassToDouble.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            Amoss_InstanceTest.InnerClassToDouble classUnderDouble = (Amoss_InstanceTest.InnerClassToDouble)innerClassToDoubleController.generateDouble();
            classUnderDouble.publicMethod( 'StringParameter' );
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'generateDouble, when given an inner class to create a test double for, will throw an exception' );
    }

    /**
    * @method generateDouble
    * @case   when given a System Type to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void generateDouble_whenGivenASystemTypeToCreateATestDoubleFor_willThrowAnException() {
        
        Amoss_Instance systemTypeToDoubleController = new Amoss_Instance( HttpRequest.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            HttpRequest classUnderDouble = (HttpRequest)systemTypeToDoubleController.generateDouble();
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'generateDouble, when given an system type to create a test double for, will throw an exception' );
    }

    /**
    * @method generateDouble
    * @case   when given a class with no public constructors to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void generateDouble_whenGivenAClassWithNoPublicConstructorToCreateATestDoubleFor_willThrowAnException() {
        
        Amoss_Instance singletonToDouble = new Amoss_Instance( Amoss_SingletonToDouble.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            Amoss_SingletonToDouble classUnderDouble = (Amoss_SingletonToDouble)singletonToDouble.generateDouble();
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'generateDouble, when given a class with no public constructor to create a test double for, will throw an exception' );
    }
    
    class InnerClassToDouble {
        public String publicMethod( String parameterOne ) {
            return 'returnString';
        }
    }
}