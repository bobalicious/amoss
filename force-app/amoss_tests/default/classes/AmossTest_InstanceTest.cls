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
@SuppressWarnings( 'MethodNamingConventions, EmptyCatchBlock' )
@isTest
public with sharing class AmossTest_InstanceTest {

    class TestException extends Exception {}

    private static final String CLASS_TO_DOUBLE = AmossTest_ClassToDouble.class.getName();

    //
    // Method definition tests
    //
    /**
    * @case   when no methods are defined, and a method is called
    * @result will return null
    */
    @isTest
    private static void whenNoMethodsAreDefinedAndAMethodIsCalled_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance interfaceUnderDoubleController = new Amoss_Instance( AmossTest_InterfaceToDouble.class );
        AmossTest_InterfaceToDouble interfaceUnderDouble = (AmossTest_InterfaceToDouble)interfaceUnderDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method when.method.willReturn (shortcut version)
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWillReturnShortcut_whenTheMethodIsCalled_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when( 'methodUnderDouble' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.willReturn (shortcut), and the method called, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method when.method.returns
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodReturns_whenTheMethodIsCalled_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .returns( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.returns, and the method called, will return the stated value' );
    }

    /**
    * @method when.method.returning
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodReturning_whenTheMethodIsCalled_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.returning, and the method called, will return the stated value' );
    }

    /**
    * @method isFluent
    * @case   when an unspecified, fluent method is called
    * @result will return the generated double
    */
    @isTest
    private static void isFluent_whenAnUnspecifiedFluentMethodIsCalled_willReturnTheGeneratedDouble() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .isFluent();

        Test.startTest();
            AmossTest_ClassToDouble returnFromDouble = classToDouble.fluentMethod();
        Test.stopTest();

        System.assertEquals( classToDouble, returnFromDouble, 'isFluent, when an unspecified, fluent method is called, will return the generated double' );
    }

    /**
    * @method isFluent
    * @case   when an unspecified, non fluent method is called
    * @result will throw an exception
    */
    @isTest
    private static void isFluent_whenAnUnspecifiedNonFluentMethodIsCalled_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .isFluent();

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( '1', 2 );
            } catch( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'isFluent, when an unspecified, non fluent method is called, will throw an exception' );
        System.assertEquals( 'Invalid conversion from runtime type AmossTest_ClassToDouble to String', exceptionMessage, 'isFluent, when an unspecified, non fluent method is called, will throw an exception' );
    }

    /**
    * @method isFluent
    * @case   when an unspecified, method with no return is called
    * @result will not throw an exception
    */
    @isTest
    private static void isFluent_whenAnUnspecifiedMethodWithNoReturnIsCalled_willNotThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .isFluent();

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                classToDouble.methodUnderDoubleWithNoReturn( '1', 2 );
            } catch( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( false, exceptionThrown, 'isFluent, when an unspecified, method with no return is called, will not throw an exception' );
    }

    /**
    * @method isFluent
    * @case   when a specified method with no defined return is called
    * @result will return null
    */
    @isTest
    private static void isFluent_whenAnSpecifiedMethodWithNoDefinedReturnIsCalled_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .isFluent()
            .when( 'fluentMethod' );

        Test.startTest();
            AmossTest_ClassToDouble returnFromMethod = classToDouble.fluentMethod();
        Test.stopTest();

        System.assertEquals( null, returnFromMethod, 'isFluent, when a specified method with no defined return is called, will return null' );
    }

    /**
    * @method isFluent
    * @case   when a specified method with a defined return is called
    * @result will return the defined return
    */
    @isTest
    private static void isFluent_whenAnSpecifiedMethodWithADefinedReturnIsCalled_willReturnTheDefinedReturn() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble specifiedReturn = new AmossTest_ClassToDouble( 'unimportant' );
        classToDoubleController
            .isFluent()
            .when( 'fluentMethod' )
            .returns( specifiedReturn );

        Test.startTest();
            AmossTest_ClassToDouble returnFromMethod = classToDouble.fluentMethod();
        Test.stopTest();

        System.assertEquals( specifiedReturn, returnFromMethod, 'isFluent, when a specified method with a defined return is called, will return the specified return' );
    }

    /**
    * @method byDefaultMethodsReturn
    * @case   when an unspecified, method is called
    * @result will return the specified value
    */
    @isTest
    private static void isFluent_whenAnUnspecifiedMethodIsCalled_willReturnTheSpecifiedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .byDefaultMethodsReturn( 'DefaultReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( '1', 2 );
        Test.stopTest();

        System.assertEquals( 'DefaultReturn', returnFromDouble, 'byDefaultMethodsReturn,  when an unspecified, method is called, will return the specified value' );
    }

    /**
    * @method byDefaultMethodsReturn
    * @case   when an unspecified, method with a different return type is called
    * @result will throw an exception
    */
    @isTest
    private static void byDefaultMethodsReturn_whenAnUnspecifiedMethodWithADifferentReturnTypeIsCalled_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .byDefaultMethodsReturn( 'DefaultReturn' );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( null );
            } catch( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'byDefaultMethodsReturn, when an unspecified method with a different return type is called, will throw an exception' );
        System.assertEquals( 'Invalid conversion from runtime type String to List<ANY>', exceptionMessage, 'byDefaultMethodsReturn, when an unspecified method with a different return type, will throw an exception' );
    }

    /**
    * @method byDefaultMethodsReturn
    * @case   when an unspecified, method with no return is called
    * @result will not throw an exception
    */
    @isTest
    private static void byDefaultMethodsReturn_whenAnUnspecifiedMethodWithNoReturnIsCalled_willNotThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .byDefaultMethodsReturn( 'DefaultReturn' );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                classToDouble.methodUnderDoubleWithNoReturn( '1', 2 );
            } catch( DmlException e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( false, exceptionThrown, 'byDefaultMethodsReturn, when an unspecified, method with no return is called, will not throw an exception' );
    }

    /**
    * @method when.method.handledBy, StubProvider
    * @case   when that method is called
    * @result will call handleMethodCall on the specified object and return the result
    */
    @isTest
    private static void whenMethodHandledByStubProvider_whenTheMethodIsCalled_willCallTheHandlerAndReturnTheResult() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        StubProvider methodHandler = new MethodHandlerUsingStubProvider();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .handledBy( methodHandler );

        String expectedReturn = 'methodUnderDouble:String|(String, Integer)|(parameter1, parameter2)|(OtherActualParam1, 1)';

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( expectedReturn, returnFromDouble, 'when.method.handledBy, when given a StubProvider, and the method called, will call handleMethodCall on the given object and return the result' );
    }

    // This cannot be mocked - ironically because of the limitations of StubProvider
    class MethodHandlerUsingStubProvider implements StubProvider {
        public Object handleMethodCall( Object       mockedObject,
                                        String       mockedMethod,
                                        Type         returnType,
                                        List<Type>   parameterTypes,
                                        List<String> parameterNames,
                                        List<Object> parameters ) {
            return mockedMethod + ':' + returnType + '|'+ String.valueOf( parameterTypes ) +'|'+ String.valueOf( parameterNames ) +'|'+ String.valueOf( parameters );
        }
    }

    /**
    * @method when.method.handledBy, Amoss_MethodHandler
    * @case   when that method is called
    * @result will call handleMethodCall on the specified object and return the result
    */
    @isTest
    private static void whenMethodHandledByAmossMethodHandler_whenTheMethodIsCalled_willCallTheHandlerAndReturnTheResult() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        // Generate a mock object version of an Amoss_MethodHandler to test handledBy with
        Amoss_Instance methodHandlerController = new Amoss_Instance( Amoss_MethodHandler.class );
        methodHandlerController
            .expects()
                .method( 'handleMethodCall' )
                .withParameter().setToTheSameValueAs( new List<Object>{ 'OtherActualParam1', 1 } )
                .returns( 'expectedReturn' );

        Amoss_MethodHandler methodHandler = (Amoss_MethodHandler)methodHandlerController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .handledBy( methodHandler );

        String expectedReturn = '(OtherActualParam1, 1)';

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        methodHandlerController.verify();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.handledBy, when given an Amoss_Instance.Amoss_MethodHandler, and the method called, will call handleMethodCall on the given object and return the result' );
    }

    /**
    * @method when.method.throws
    * @case   when that method is called
    * @result will throw the stated exception
    */
    @isTest
    private static void whenMethodThrows_whenTheMethodIsCalled_willThrowTheStatedException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .throws( new DmlException( 'The defined exception' ) );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch( DmlException e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'when.method.throw, and the method called, will throw the stated exception' );
        System.assertEquals( 'The defined exception', exceptionMessage, 'when.method.throw, and the method called, will throw the stated exception' );
    }

    /**
    * @method when.method.throwing
    * @case   when that method is called
    * @result will throw the stated exception
    */
    @isTest
    private static void whenMethodThrowing_whenTheMethodIsCalled_willThrowTheStatedException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .throwing( new DmlException( 'The defined exception' ) );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch( DmlException e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'when.method.throwing, and the method called, will throw the stated exception' );
        System.assertEquals( 'The defined exception', exceptionMessage, 'when.method.throwing, and the method called, will throw the stated exception' );
    }

    /**
    * @method when.method.willThrow
    * @case   when that method is called
    * @result will throw the stated exception
    */
    @isTest
    private static void whenMethodWillThrow_whenTheMethodIsCalled_willThrowTheStatedException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .willThrow( new DmlException( 'The defined exception' ) );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch( DmlException e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'when.method.willThrow, and the method called, will throw the stated exception' );
        System.assertEquals( 'The defined exception', exceptionMessage, 'when.method.willThrow, and the method called, will throw the stated exception' );
    }

    /**
    * @method when.method.willReturn
    * @case   for an interface, when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWillReturn_forAnInterface_whenTheMethodIsCalled_willReturnTheStatedValue() {

        Amoss_Instance interfaceUnderDoubleController = new Amoss_Instance( AmossTest_InterfaceToDouble.class );
        AmossTest_InterfaceToDouble interfaceUnderDouble = (AmossTest_InterfaceToDouble)interfaceUnderDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameter.willReturn, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.setTo.willReturn
    * @case   when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterSetToWillReturn_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().setTo( 'ActualParam1' )
                .thenParameter().setTo( 1 )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameter.setTo.willReturn, and the method called with the stated parameters, will return the stated value' );
    }


    /**
    * @method when.method.withParameter.noVerificationSet
    * @case   when that method is called
    * @result will fail
    */
    @isTest
    private static void whenMethodWithParameterNoVerificationSet_whenTheMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'objectMethodUnderDouble' )
                .withParameter();

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.objectMethodUnderDouble( 'ActualParam1' );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                  'The specification of the expected parameter value is incompletely set up',
                                                  CLASS_TO_DOUBLE + '.objectMethodUnderDouble',
                                                  0,
                                                  'when.method.withParameter.noVerificationSet, when the method is called, will fail, stating that the parameter is not fully set up' );
    }

    /**
    * @method when.method.withParameters.willReturn
    * @case   when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParametersWillReturn_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameters(
                    new List<Object>{ 'ActualParam1', 1 }
                )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameters.willReturn, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.setTo.willReturn
    * @case   when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToWillReturn_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter2' ).setTo( 1 )
                .andParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameterNamedSetTo.willReturn, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.setTo.willReturn
    * @case   when not all parameters set, but the method is called with the specified parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToWillReturn_whenNotAllSetAndTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameterNamedSetTo.willReturn, not all parameters set, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameters.willReturn (named version)
    * @case   when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParametersNamedWillReturn_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameters(
                    new Map<String,Object>{ 'parameter1' => 'ActualParam1', 'parameter2' => 1 }
                )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameters.willReturn, named version, and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameters.willReturn (named version)
    * @case   when not all parameters set, but the method is called with the specified parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParametersNamedWillReturn_whenNotAllSpecifiedAndTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameters(
                    new Map<String,Object>{ 'parameter2' => 1 }
                )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameters.willReturn, named version, when not all parameters are specified and the method called with the stated parameters, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.willReturn
    * @case   for an interface, when that method is called with the stated parameters
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterWillReturn_forAnInterface_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValue() {

        Amoss_Instance interfaceUnderDoubleController = new Amoss_Instance( AmossTest_InterfaceToDouble.class );
        AmossTest_InterfaceToDouble interfaceUnderDouble = (AmossTest_InterfaceToDouble)interfaceUnderDoubleController.getDouble();

        interfaceUnderDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'willNotSeeThis' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'DifferentParam', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.willReturn, and the method called with the different parameters, will return null' );
    }

    /**
    * @method when.method.withParameters.willReturn
    * @case   when that method is called with different parameters
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParametersWillReturn_whenTheMethodIsCalledWithDifferentParameters_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameters(
                    new List<Object>{'ActualParam1', 1 }
                )
                .willReturn( 'willNotSeeThis' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'DifferentParam', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameters.willReturn, and the method called with the different parameters, will return null' );
    }

    /**
    * @method when.method.withParameter.setTo.willReturn
    * @case   when that method is called with different parameters
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterSetToWillReturn_whenTheMethodIsCalledWithDifferentParameters_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().setTo( 'ActualParam1' )
                .thenParameter().setTo( 1 )
                .willReturn( 'willNotSeeThis' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'DifferentParam', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.setTo.willReturn, and the method called with the different parameters, will return null' );
    }

    /**
    * @method when.method.withParameterNamed.setTo.willReturn
    * @case   when that method is called with different parameters
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToWillReturn_whenTheMethodIsCalledWithDifferentParameters_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .willReturn( 'willNotSeeThis' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'DifferentParam', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.setTo.willReturn, and the method called with the different parameters, will return null' );
    }

    /**
    * @method when.method.withParameters.setTo.willReturn (named)
    * @case   when that method is called with different parameters
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParametersNamedSetToWillReturn_whenTheMethodIsCalledWithDifferentParameters_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameters(
                    new Map<String,Object>{
                        'parameter1' => 'ActualParam1',
                        'parameter2' => 1
                    }
                )
                .willReturn( 'willNotSeeThis' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'DifferentParam', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameters.setTo.willReturn (named), and the method called with the different parameters, will return null' );
    }

    //
    //
    // Advanced When Parameter Matching Tests
    //
    //

    /**
    * @method when.method.willReturn
    * @case   when the expectation is set with an object, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWillReturn_whenIsSetWithObjectAndPassed_willReturnThatValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameter( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.willReturn, when set up with an object, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.willReturn
    * @case   when set with an object, and a different instance is passed with same properties
    * @result will return null
    */
    @isTest
    private static void whenMethodWillReturn_whenIsSetWithObjectAndDifferentInstancePassed_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameter( objectExpected )
                .willReturn( 'notExpectedToReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.willReturn, when set up with an object, and a different instance is passed, will return null' ) ;
    }

    /**
    * @method when.method.setToTheSameValueAs.willReturn
    * @case   when the expectation is set with an object, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithObjectAndPassed_willReturnThatValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.setToTheSameValueAs.willReturn, when set up with an object, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.setToTheSameValueAs.willReturn
    * @case   when set with an object, and a different instance is passed with same properties
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithObjectAndDifferentInstancePassed_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .willReturn( 'ExpectedToReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'ExpectedToReturn', returnFromDouble, 'when.method.willReturn, when set up with an object, and a different instance is passed with same properties, will return the stated value' ) ;
    }

    /**
    * @method when.method.setToTheSameValueAs.willReturn
    * @case   when set with an object, and a different instance is passed with different properties
    * @result will return null
    */
    @isTest
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithObjectAndDifferentInstancePassedWithDifferentProperties_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .willReturn( 'notExpectedToReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'DifferentObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.willReturn, when set up with an object, and a different instance is passed with different properties, will return null' ) ;
    }

    /**
    * @method when.method.withParameterNamed.willReturn
    * @case   when the expectation is set with an object, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedWillReturn_whenIsSetWithObjectAndPassed_willReturnThatValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameterNamed( 'objectParam' ).setTo( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameterNamed.willReturn, when set up with an object, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.withParameterNamed.willReturn
    * @case   when set with an object, and a different instance is passed with same properties
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterNamedWillReturn_whenIsSetWithObjectAndDifferentInstancePassed_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameterNamed( 'objectParam' ).setTo( objectExpected )
                .willReturn( 'notExpectedToReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.willReturn, when set up with an object, and a different instance is passed, will return null' ) ;
    }

    /**
    * @method when.method.withParameterNamed.setToTheSameValueAs.willReturn
    * @case   when the expectation is set with an object, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithObjectAndPassed_willReturnThatValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameterNamed( 'objectParam' ).setToTheSameValueAs( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameterNamed.setToTheSameValueAs.willReturn, when set up with an object, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.withParameterNamed.setToTheSameValueAs.willReturn
    * @case   when set with an object, and a different instance is passed with same properties
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithObjectAndDifferentInstancePassed_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameterNamed( 'objectParam' ).setToTheSameValueAs( objectExpected )
                .willReturn( 'ExpectedToReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'ExpectedToReturn', returnFromDouble, 'when.method.withParameterNamed.willReturn, when set up with an object, and a different instance is passed with same properties, will return the stated value' ) ;
    }

    /**
    * @method when.method.withParameterNamed.setToTheSameValueAs.willReturn
    * @case   when set with an object, and a different instance is passed with different properties
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithObjectAndDifferentInstancePassedWithDifferentProperties_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .when()
                .method( 'objectMethodUnderDouble' )
                .withParameterNamed( 'objectParam' ).setToTheSameValueAs( objectExpected )
                .willReturn( 'notExpectedToReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'DifferentObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.willReturn, when set up with an object, and a different instance is passed with different properties, will return null' ) ;
    }

    /**
    * @method when.method.willReturn
    * @case   when the is set with an sobject, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWillReturn_whenIsSetWithSobjectAndPassed_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectPassed = new Contact( LastName = 'TheContact' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.willReturn, when set up with an sobject, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.willReturn
    * @case   when the expectation is set with an sobject, and a different instance is passed with same properties
    * @result will return null
    */
    @isTest
    private static void whenMethodWillReturn_whenIsSetWithSobjectAndDifferentInstancePassed_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter( objectExpected )
                .willReturn( 'NotExpectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.willReturn, when set up with an sobject, and a different instance is passed, will return null' ) ;
    }

    /**
    * @method when.method.setToTheSameValueAs.willReturn
    * @case   when is set with an sobject, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndPassed_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectPassed = new Contact( LastName = 'TheContact' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.setToTheSameValueAs.willReturn, when set up with an sobject, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.setToTheSameValueAs.willReturn
    * @case   when the expectation is set with an sobject, and a different instance is passed with same properties
    * @result will still return the stated value
    */
    @isTest
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDifferentInstancePassed_willStillReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .willReturn( 'ExpectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'ExpectedReturn', returnFromDouble, 'when.method.setToTheSameValueAs.willReturn, when set up with an sobject, and a different instance is passed with the same properies, will return the stated value' ) ;
    }

    /**
    * @method when.method.setToTheSameValueAs.willReturn
    * @case   when the expectation is set with an sobject, and a different instance is passed with different properties
    * @result will return null
    */
    @isTest
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDifferentInstancePassedWithDifferentValues_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .willReturn( 'NotExpectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject', FirstName = 'Different' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.setToTheSameValueAs.willReturn, when set up with an sobject, and a different instance is passed with different properies, will return null' ) ;
    }

    /**
    * @method when.method.withParamterNamed.willReturn
    * @case   when the is set with an sobject, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedWillReturn_whenIsSetWithSobjectAndPassed_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectPassed = new Contact( LastName = 'TheContact' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).setTo( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParamterNamed.willReturn, when set up with an sobject, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.withParamterNamed.willReturn
    * @case   when the expectation is set with an sobject, and a different instance is passed with same properties
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterNamedWillReturn_whenIsSetWithSobjectAndDifferentInstancePassed_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).setTo( objectExpected )
                .willReturn( 'NotExpectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParamterNamed.willReturn, when set up with an sobject, and a different instance is passed, will return null' ) ;
    }

    /**
    * @method when.method.withParamterNamed.setToTheSameValueAs.willReturn
    * @case   when is set with an sobject, and that instance is passed
    * @result will return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndPassed_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectPassed = new Contact( LastName = 'TheContact' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).setToTheSameValueAs( objectPassed )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParamterNamed.setToTheSameValueAs.willReturn, when set up with an sobject, and that instance is passed, will return the set up value' ) ;
    }

    /**
    * @method when.method.withParamterNamed.setToTheSameValueAs.willReturn
    * @case   when the expectation is set with an sobject, and a different instance is passed with same properties
    * @result will still return the stated value
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDifferentInstancePassed_willStillReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).setToTheSameValueAs( objectExpected )
                .willReturn( 'ExpectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( 'ExpectedReturn', returnFromDouble, 'when.method.withParamterNamed.setToTheSameValueAs.willReturn, when set up with an sobject, and a different instance is passed with the same properies, will return the stated value' ) ;
    }

    /**
    * @method when.method.withParamterNamed.setToTheSameValueAs.willReturn
    * @case   when the expectation is set with an sobject, and a different instance is passed with different properties
    * @result will return null
    */
    @isTest
    private static void whenMethodWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDifferentInstancePassedWithDifferentValues_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .when()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).setToTheSameValueAs( objectExpected )
                .willReturn( 'NotExpectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject', FirstName = 'Different' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParamterNamed.setToTheSameValueAs.willReturn, when set up with an sobject, and a different instance is passed with different properies, will return null' ) ;
    }

    /**
    * @method when.method.withParameter.willReturn multiple times
    * @case   when that method is called with the stated parameters
    * @result will return the stated value for each call
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenTheMethodIsCalledWithTheParameters_willReturnTheStatedValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam2' )
                .thenParameter( 2 )
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'expectedReturn1' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'when.method.withParameter.willReturn multiple times, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (1st call)' );
        System.assertEquals( 'expectedReturn1', returnFromDouble2, 'when.method.withParameter.willReturn multiple times, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (2nd call)' );
    }

    /**
    * @method when.method.withParameter.willReturn multiple times, position first, then named
    * @case   when the same method is defiend with the same parameters and it is called multiple times
    * @result will always return the first value with parameters that match
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiplePositionFirstThenNamed_whenSameParamsUsed_willAlwaysReturnTheFirstMatch() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter2' ) .setTo( 1 )
                .willReturn( 'expectedReturn1' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'when.method.withParameter.willReturn multiple times, position notation used first, then named notation, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (1st call)' );
        System.assertEquals( 'expectedReturn1', returnFromDouble2, 'when.method.withParameter.willReturn multiple times, position notation used first, then named notation, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (2nd call)' );
    }

    /**
    * @method when.method.withParameter.willReturn multiple times, named first, then position
    * @case   when the same method is defiend with the same parameters and it is called multiple times
    * @result will always return the first value with parameters that match
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultipleNamedFirstThenPosition_whenSameParamsUsed_willAlwaysReturnTheFirstMatch() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter2' ) .setTo( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'expectedReturn1' );

        Test.startTest();
            String returnFromDouble1 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromDouble2 = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn1', returnFromDouble1, 'when.method.withParameter.willReturn multiple times, named notation used first, then position notation, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (1st call)' );
        System.assertEquals( 'expectedReturn1', returnFromDouble2, 'when.method.withParameter.willReturn multiple times, named notation used first, then position notation, when the method is defined with the same parameters, and the method called with the stated parameters, will always return the first match (2nd call)' );
    }

    /**
    * @method when.method.withParameter.willReturn multiple times
    * @case   when different methods are defined with the same parameters
    * @result will return the stated value for each call, based on the method called
    */
    @isTest
    private static void whenMethodWithParameterWillReturnMultiple_whenDifferentMethodsDefined_willReturnTheStatedValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'expectedReturn1' )
            .also().when()
                .method( 'otherMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .willReturn( 'willNotSeeThis' )
            .also().when()
                .method( 'methodUnderDouble' )
                .withAnyParameter()
                .thenParameter( 1 )
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method allows.method.returning (shortcut)
    * @case   when that method is called
    * @result will return the stated value
    */
    @isTest
    private static void allowsMethodReturningShortcut_whenTheMethodIsCalled_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allows( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'allows.method.returning (shortcut), and the method called, will return the stated value, regardless of the parameters passed' );
    }
    /**
    * @method allows.method.returning
    * @case   when a different method is called
    * @result will fail the test
    */
    @isTest
    private static void allowsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.otherMethodUnderDouble was called more times than was expected, and no matching "when" or "allows" exists';
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method.returning, when a different method is called, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method.returning, when a different method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method allows.method.returning
    * @case   when the method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.otherMethodUnderDouble was called more times than was expected, and no matching "when" or "allows" exists';
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method.returning, when the method is called with different parameters, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method.returning, when the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method allows.method.returning
    * @case   when multiple methods are defined and called
    * @result will return the stated value for each method
    */
    @isTest
    private static void allowsMethodReturning_whenMultipleMethodsAreDefinedAndCalled_willReturnTheStatedValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .returning( 'returnForExactMatch' )
            .also().allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenAnyParameter()
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
    * @method expectsNoCalls
    * @case   when a method is called
    * @result will fail the test
    */
    @isTest
    private static void expectsNoCalls_whenAMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expectsNoCalls();

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();

        System.assertEquals( '' , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expectsNoCalls, when a method is called, will fail by calling assertEquals with an empty string as expected' );

        String expectedMethodCall = 'methodUnderDouble(OtherActualParam1, 1)';
        System.assertEquals( expectedMethodCall, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expectsNoCalls, when a method is called, will fail by calling assertEquals with the method called as actual' );

        String expectedAssertion = CLASS_TO_DOUBLE + ' did not expect any methods to be called';
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expectsNoCalls, when a method is called, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expectsNoCalls.verify
    * @case   when no method is called
    * @result will pass the test
    */
    @isTest
    private static void expectsNoCalls_whenAMethodIsNotCalled_willPassTheTest() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expectsNoCalls();

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();
    }

    /**
    * @method expects.method.returning
    * @case   when that method is called once
    * @result will return the stated value
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalledOnce_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method expects.method.returning (shortcut)
    * @case   when that method is called once
    * @result will return the stated value
    */
    @isTest
    private static void expectsMethodReturningShortcut_whenTheMethodIsCalledOnce_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'expects.method.returning (shortcut), and the method called once, will return the stated value, regardless of the parameters passed' );
    }

    /**
    * @method expects.method.returning
    * @case   when a different method is called
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was expected to be called';
        System.assertEquals( 'methodUnderDouble'     , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with the expected method' );
        System.assertEquals( 'otherMethodUnderDouble', assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with the actual method called' );
        System.assertEquals( expectedAssertion       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when a different method is called, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expects.method.returning
    * @case   when the method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodUnderDouble', 0, 'ActualParam1', 'OtherActualParam1', 'expects.method.returning, when the method is called with different parameters' );
    }

    //
    //
    // Advanced Expectation Parameter Matching Tests
    //
    //

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with an object, and that instance is passed
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenExpectsIsSetWithObjectAndPassed_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'objectMethodUnderDouble' )
                .withParameter( objectPassed )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with an object, and a different instance is passed with same properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenExpectsIsSetWithObjectAndDifferentInstancePassed_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'objectMethodUnderDouble' )
                .withParameter( objectExpected )
                .returning( 'expectedReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.objectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.returning, when specified with an object and the method is called with a different instance' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with an object, and a different instance is passed with same properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsIsSetWithObjectAndDifferentInstancePassed_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'objectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( 'expectedReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        Test.startTest();
            String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with an object, and a different instance is passed with different properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsIsSetWithObjectAndDifferentInstancePassedWithDifferentProperties_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        AmossTest_ClassToDouble.PassableObject objectExpected = new AmossTest_ClassToDouble.PassableObject( 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'objectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( 'expectedReturn' );

        AmossTest_ClassToDouble.PassableObject objectPassed = new AmossTest_ClassToDouble.PassableObject( 'TheOtherObject' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.objectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.objectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.setToTheSameValueAs.returning, when specified with an object and the method is called with a different instance with different values' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with an sobject, and that instance is passed
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenExpectsIsSetWithSobjectAndPassed_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectPassed = new Contact( LastName = 'TheContact' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter( objectPassed )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with same properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenExpectsIsSetWithSobjectAndDifferentInstancePassed_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionInstanceAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.returning, when specified with an sobject and the method is called with a different instance' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with same properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsIsSetWithSobjectAndDifferentInstancePassed_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with different properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsIsSetWithSobjectAndDifferentInstancePassedWithDifferentValues_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheOtherObject' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.setToTheSameValueAs.returning, when specified with an sobject and the method is called with a different instance with different values' );
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the expectation is set with an sobject, and that instance is passed
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenExpectsIsSetWithSobjectAndPassed_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetLike( objectPassed )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with same properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenDifferentInstancePassedWithSameProperties_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetLike( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with extra properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenDifferentInstancePassedWithExtraProperties_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetLike( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst', MobilePhone = '1234' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with different properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenDifferentInstancePassedWithDifferentProperties_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetLike( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'DifferentFirst' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterFieldsInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.withFieldsSetLike.returning, when specified with an sobject and the method is called with a different instance with different properties' );
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with fewer properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenDifferentInstancePassedWithFewerProperties_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetLike( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterFieldsInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.withFieldsSetLike.returning, when specified with an sobject and the method is called with a different instance with fewer properties' );
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the expectation is set with an sobject, and null is passed
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenExpectsIsSetWithSobjectAndNullIsPassed_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetLike( objectExpected )
                .returning( 'expectedReturn' );

        Contact nullContact;

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( nullContact );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForNullSObjectInPositionInstanceAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, null, 'expects.method.withFieldsSetLike.returning, when specified with an sobject and the method is called with null' );
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the parameter passed is not an sObject
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenParameterPassedIsNotAnSobject_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetLike( objectExpected )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( 'NotAnSobject' ); // possible because of overloading
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'Expected an sObject, and got String',
                                                    CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0,
                                                    objectExpected, 'NotAnSobject',
                                                    'expects.method.withFieldsSetLike.returning, when the parameter passed is not an sObject' );
    }

    /**
    * @method expects.method.withFieldsSetLike.returning
    * @case   when the expectation is set with null
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetLikeReturning_whenExpectsIsSetWithNull_willFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        String  exceptionMessage;

        Test.startTest();
            try {
                classToDoubleController
                    .expects()
                        .method( 'sobjectMethodUnderDouble' )
                        .withParameter().withFieldsSetLike( null )
                        .returning( 'expectedReturn' );
            } catch ( Amoss_Instance.Amoss_ExpectedObjectCannotBeNullException e ) {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( 'Cannot specify NULL for a "FieldsSetLike" expectation', exceptionMessage, 'expects.method.withFieldsSetLike.returning, when the expectation is set with null, will throw an exception detailing the problem' );
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the expectation is set with an map, and an sobject passed with same properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenSobjectPassedWithSameProperties_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.withParameterNamed.withFieldsSetTo.returning
    * @case   when the expectation is set with an map, and an sobject passed with same properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodWithParameterNamedWithFieldsSetToReturning_whenSobjectPassedWithSameProperties_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the expectation is set, and an sObject is passed with extra properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenSobjectPassedWithExtraProperties_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst', MobilePhone = '1234' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the expectation is set, and an sObject is passed with different properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenSobjectWithDifferentProperties_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'DifferentFirst' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterFieldsInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.withFieldsSetTo.returning, when the method is called with an sObject with different properties' );
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the expectation is set, and an sObject is passed with fewer properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenSobjectPassedWithFewerProperties_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterFieldsInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.withFieldsSetTo.returning, when the method is called with an Sobject with fewer properties' );
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the expectation is set, and null is passed
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenExpectsIsSetAndNullIsPassed_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact nullContact;

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( nullContact );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForNullSObjectInPositionInstanceAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, null, 'expects.method.withFieldsSetTo.returning, when specified, and the method is called with null' );
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the expectation is set with null
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenExpectsIsSetWithNull_willFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        String  exceptionMessage;

        Test.startTest();
            try {
                classToDoubleController
                    .expects()
                        .method( 'sobjectMethodUnderDouble' )
                        .withParameter().withFieldsSetTo( null )
                        .returning( 'expectedReturn' );
            } catch ( Amoss_Instance.Amoss_ExpectedObjectCannotBeNullException e ) {
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( 'Cannot specify NULL for a "FieldsSetTo" expectation', exceptionMessage, 'expects.method.withFieldsSetTo.returning, when the expectation is set with null, will throw an exception detailing the problem' );
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the expectation is set with an invalid field
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenExpectationIsSetWithAnInvalidField_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst', 'InvalidField' => 'A value' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ExpectedLast', FirstName = 'ExpectedFirst' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'Problem comparing field "InvalidField": Invalid field InvalidField for Contact',
                                                    CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0,
                                                    'expects.method.withFieldsSetTo.returning, when the expectation is set with an invalid field' );
    }

    /**
    * @method expects.method.withFieldsSetTo.returning
    * @case   when the parameter passed is not an sObject
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithFieldsSetToReturning_whenParameterPassedIsNotAnSobject_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'LastName' => 'ExpectedLast', 'FirstName' => 'ExpectedFirst' };

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().withFieldsSetTo( objectExpected )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( 'NotAnSobject' ); // possible because of overloading
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'Expected an sObject, and got String',
                                                    CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0,
                                                    objectExpected, 'NotAnSobject',
                                                    'expects.method.withFieldsSetTo.returning, when the parameter passed is not an sObject' );
    }

    /**
    * @method expects.method.withAllElements.setTo.returning
    * @case   when the list parameter passed does matches all elements
    * @result will pass the test
    */
    @isTest
    private static void expectsMethodWithAllElementsSetToReturning_whenAllElementsInTheParameterMatch_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().setTo( 'expected' )
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'expected', 'expected' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withAllElements.setTo.returning, when the list parameter passed does matches all elements, will return the specified value' );
    }

    /**
    * @method expects.method.withAllElements.setTo.returning
    * @case   when the list parameter passed does not match all elements
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithAllElementsSetToReturning_whenNotAllElementsInTheParameterMatch_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().setTo( 'expected' );

        Test.startTest();
            try {
                List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'expected', 'unexpected' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected: The value is not what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'expected', 'unexpected',
                                                    'expects.method.withAllElements.returning, when the list parameter passed does not match every element' );
    }

    /**
    * @method expects.method.withAllElements.setTo.returning
    * @case   when the list parameter passed is not a list
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithAllElementsSetToReturning_whenTheParameterPassedIsNotAList_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withAllElements().setTo( 'expected' )
                .thenAnyParameter()
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'not a list', 2 );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The types do not match',
                                                    CLASS_TO_DOUBLE + '.methodUnderDouble', 0,
                                                    'List<Object>', 'String',
                                                    'expects.method.withAllElements.returning, when the parameter passed is not a list' );
    }

    /**
    * @method expects.method.withAnyElement.setTo.returning
    * @case   when the list parameter passed matches any of the elements
    * @result will pass the test
    */
    @isTest
    private static void expectsMethodWithAnyElementSetToReturning_whenAnyElementsInTheParameterMatch_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().setTo( 'expected' )
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'unexpected', 'expected' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withAnyElement.setTo.returning, when the list parameter passed matches an element, will return the specified value' );
    }

    /**
    * @method expects.method.withAnyElement.setTo.returning
    * @case   when the list parameter passed does not match all elements
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithAnyElementSetToReturning_whenNoElementsInTheParameterMatch_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().setTo( 'expected' );

        Test.startTest();
            try {
                List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'unexpected', 'unexpected' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'At least one element in the list should pass the described verification',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'expected', '(unexpected, unexpected)',
                                                    'expects.method.withAnyElement.returning, when the list parameter passed does not match every element' );
    }

    /**
    * @method expects.method.withAnyElement.setTo.returning
    * @case   when the list parameter passed is not a list
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithAnyElementSetToReturning_whenTheParameterPassedIsNotAList_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withAnyElement().setTo( 'expected' )
                .thenAnyParameter()
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'not a list', 2 );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The types do not match',
                                                    CLASS_TO_DOUBLE + '.methodUnderDouble', 0,
                                                    'List<Object>', 'String',
                                                    'expects.method.withAnyElement.returning, when the parameter passed is not a list' );
    }

    /**
    * @method expects.method.withElementAt.setTo.returning
    * @case   when the list parameter passed has the element matching
    * @result will pass the test
    */
    @isTest
    private static void expectsMethodWithElementAtSetToReturning_whenElementInTheParameterMatches_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 1 ).setTo( 'expected' )
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'unexpected', 'expected' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withElementAt.setTo.returning, when the list parameter contains the element matching the specified value, will return the specified value' );
    }

    /**
    * @method expects.method.withElementAt.setTo.returning
    * @case   when specified multiple times and the list parameter passed has the elements matching
    * @result will pass the test
    */
    @isTest
    private static void expectsMethodWithElementAtSetToReturningMultipleTimes_whenElementInTheParameterMatches_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter()
                    .withElementAt( 0 ).setTo( 'expected1' )
                    .withElementAt( 1 ).setTo( 'expected2' )
                    .withElementAt( 2 ).setTo( 'expected3' )
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'expected1', 'expected2', 'expected3' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withElementAt.setTo.returning, when specified multiple times, and the list parameter contains the elements matching the specified value, will return the specified value' );
    }

    /**
    * @method expects.method.withElementAt.setTo.returning
    * @case   when the list parameter's element does not match
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithElementAtSetToReturning_whenSpecifiedElementDoesNotMatch_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 0 ).setTo( 'expected' );

        Test.startTest();
            try {
                List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'unexpected', 'unexpected' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 0 does not match what was expected: The value is not what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'expected', 'unexpected',
                                                    'expects.method.withElementAt.returning, when the list parameter\'s element does not match' );
    }

    /**
    * @method expects.method.withElementAt.setTo.returning
    * @case   when specified multiple times and one of the list parameter's element does not match
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithElementAtSetToReturningMultipleTimes_whenSpecifiedElementDoesNotMatch_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter()
                    .withElementAt( 0 ).setTo( 'expected1' )
                    .withElementAt( 1 ).setTo( 'expected2' )
                    .withElementAt( 2 ).setTo( 'expected3' );

        Test.startTest();
            try {
                List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'expected1', 'unexpected', 'expected3' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected: The value is not what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'expected2', 'unexpected',
                                                    'expects.method.withElementAt.returning, when the list parameter\'s element does not match' );
    }

    /**
    * @method expects.method.withElementAt.setTo.returning
    * @case   when the list parameter's element does not exist
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithElementAtSetToReturning_whenSpecifiedElementDoesNotExist_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 4 ).setTo( 'expected' );

        Test.startTest();
            try {
                List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'unexpected', 'unexpected' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is not what was expected - The list is not as long as required',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    5, 2,
                                                    'expects.method.withElementAt.returning, when the list parameter does not contain the specified element' );
    }

    /**
    * @method expects.method.withElementAt.setTo.returning
    * @case   when the parameter is not a list
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithElementAtSetToReturning_whenParameterIsNotAList_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withElementAt( 1 ).setTo( 'expected' )
                .thenAnyParameter();

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'not a list', 2 );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is not what was expected - The types do not match',
                                                    CLASS_TO_DOUBLE + '.methodUnderDouble', 0,
                                                    'List<Object>', 'String',
                                                    'expects.method.withElementAt.returning, when the parameter is not a list' );
    }

    /**
    * @method expects.method.withElementAt.setTo.returning
    * @case   when the parameter is null
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithElementAtSetToReturning_whenParameterIsNull_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 1 ).setTo( 'expected' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( null);
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is not what was expected - The types do not match',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'List<Object>', 'Unknown (null)',
                                                    'expects.method.withElementAt.returning, when the parameter is null' );
    }

    /**
    * @method expects.method.verifiedBy.returning
    * @case   when the verifier does not throw an exception
    * @result will pass the test
    */
    @isTest
    private static void expectsMethodVerifiedByReturning_whenTheVerifierDoesNotThrowAnException_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'verify' )
                .withParameter().setTo( 'expectedParameterValue' )
            .then().expects()
                .method( 'verify' )
                .withParameter().setTo( 1 );
        Amoss_ValueVerifier customVerifierThatPasses = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().verifiedBy( customVerifierThatPasses )
                .thenParameter().verifiedBy( customVerifierThatPasses )
                .returning( expectedReturn );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'expectedParameterValue', 1 );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.verifiedBy.returning, when the verifier does not throw an exception (I.E. passes) will pass the test' );
    }

    /**
    * @method expects.method.withParameterNamed.verifiedBy.returning
    * @case   when the verifier does not throw an exception
    * @result will pass the test
    */
    @isTest
    private static void expectsMethodWithParameterNamedVerifiedByReturning_whenTheVerifierDoesNotThrowAnException_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'verify' )
                .withParameter().setTo( 'expectedParameterValue' )
            .then().expects()
                .method( 'verify' )
                .withParameter().setTo( 1 );
        Amoss_ValueVerifier customVerifierThatPasses = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).verifiedBy( customVerifierThatPasses )
                .andParameterNamed( 'parameter2' ).verifiedBy( customVerifierThatPasses )
                .returning( expectedReturn );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'expectedParameterValue', 1 );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.verifiedBy.returning, when the verifier does not throw an exception (I.E. passes) will pass the test' );
    }

    /**
    * @method expects.method.verifiedBy.returning
    * @case   when the verifier throws an Amoss_AssertionFailureException
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodVerifiedByReturning_whenTheVerifierThrowsAnAssertException_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .allowsAnyCall()
            .expects()
                .method( 'verify' )
                .withParameter().setTo( 'expectedParameterValue' )
                .throwing( new Amoss_Instance.Amoss_EqualsAssertionFailureException()
                                .setExpected( 'expectedValue' )
                                .setActual( 'actualValue' )
                                .setAssertionMessage( 'This is the failure' ) );

        Amoss_ValueVerifier customVerifierThatFails = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().verifiedBy( customVerifierThatFails )
                .thenParameter().verifiedBy( customVerifierThatFails )
                .returning( expectedReturn );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'expectedParameterValue', 1 );
            } catch( TestException e ) {}
        Test.stopTest();

        classToDoubleController.verify();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'This is the failure',
                                                    CLASS_TO_DOUBLE + '.methodUnderDouble', 0,
                                                    'expectedValue', 'actualValue',
                                                    'expects.method.verifiedBy.returning, when the verifier throws an assertion exception' );
    }

    /**
    * @method when.method.verifiedBy.returning
    * @case   when the verifier does not throw an exception
    * @result will match the call and return the value
    */
    @isTest
    private static void whenMethodVerifiedByReturning_whenTheVerifierDoesNotThrowAnException_willMatchAndReturnTheValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'verify' )
                .withParameter().setTo( 'expectedParameterValue' )
            .then().expects()
                .method( 'verify' )
                .withParameter().setTo( 1 );
        Amoss_ValueVerifier customVerifierThatPasses = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().verifiedBy( customVerifierThatPasses )
                .thenParameter().verifiedBy( customVerifierThatPasses )
                .willReturn( expectedReturn )
            .also().when()
                .method( 'methodUnderDouble' )
                .willReturn( 'not this value' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'expectedParameterValue', 1 );
        Test.stopTest();

        System.assertEquals( expectedReturn, returnFromDouble, 'when.method.verifiedBy.returning, when the verifier does not throw an exception (I.E. passes) will match the return' );
    }

    /**
    * @method when.method.verifiedBy.returning
    * @case   when the verifier throws an exception
    * @result will not match the call
    */
    @isTest
    private static void whenMethodVerifiedByReturning_whenTheVerifierThrowsAnException_willNotMatchAndReturnTheValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'verify' )
                .withParameter().setTo( 'expectedParameterValue' )
            .then().expects()
                .method( 'verify' )
                .withParameter().setTo( 1 )
                .throwing( new Amoss_Instance.Amoss_EqualsAssertionFailureException()
                                .setExpected( 'expectedValue' )
                                .setActual( 'actualValue' )
                                .setAssertionMessage( 'This parameter does not match' ) );

        Amoss_ValueVerifier customVerifierThatPasses = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().verifiedBy( customVerifierThatPasses )
                .thenParameter().verifiedBy( customVerifierThatPasses )
                .willReturn( 'not this value' )
            .also().when()
                .method( 'methodUnderDouble' )
                .willReturn( expectedReturn );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'expectedParameterValue', 1 );
        Test.stopTest();

        System.assertEquals( expectedReturn, returnFromDouble, 'when.method.verifiedBy.returning, when the verifier throws an exception (I.E. fails) will not match and return the specified value' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with an sobject via named syntax, and a different instance is passed with same properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenExpectsIsSetWithSobjectWithNamedSyntaxAndDifferentInstancePassed_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).setTo( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterNamedInstanceAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 'contactParam', objectExpected, objectPassed, 'expects.method.returning, when specified with an sobject via named syntax and the method is called with a different instance' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with different properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenExpectsIsSetWithSobjectAndDifferentInstancePassedWithDifferentProperties_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheExpected' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ThePassed' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.returning, when specified with an sobject and the method is called with a different instance that has different properties' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a list, and the same instance is passed
    * @result will pass
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAList_andSameInstanceIsPassed_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter( objectExpected )
                .returning( new List<Contact>() );

        Test.startTest();
            classToDouble.methodWithListOfObjects( objectExpected );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a list, and something that is not a list is passed
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAList_andSomethingNotAList_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'objectMethodUnderDouble' )
                .withParameter( objectExpected )
                .returning( new List<Contact>() );

        Contact objectPassed = new Contact( FirstName = 'Not a list' );

        Test.startTest();
            try {
                classToDouble.objectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is not what was expected - The types do not match',
                                                    CLASS_TO_DOUBLE + '.objectMethodUnderDouble',
                                                    0,
                                                    'List<Contact>', 'Contact',
                                                    'expects.method.returning, when the expectation is set with a list, and something that is not a list is passed' );
    }


    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing the same objects
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAList_andADifferentInstanceContainingSameObjects_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter( objectExpected )
                .returning( new List<Contact>() );

        List<Contact> objectPassed = new List<Contact>{ objectExpected[0], objectExpected[1] };

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is the same, but not the same instance as was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects',
                                                    0,
                                                    objectExpected, objectPassed,
                                                    'expects.method.returning, when the expectation is set with a list, and a different instance is passed, containing the same instances' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing different instances with the same values
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAList_andADifferentInstanceContainingDifferentObjectsWithTheSameValues() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter( objectExpected )
                .returning( new List<Contact>() );

        List<Contact> objectPassed = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is the same, but the list and some of its elements are not the same instances as was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    objectExpected, objectPassed,
                                                    'expects.method.returning, when the expectation is set with a list, and a different instance is passed, containing different instances with the same values' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing different instances with different values
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAList_andADifferentInstanceContainingDifferentObjectsWithDifferentValues() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter( objectExpected )
                .returning( new List<Contact>() );

        List<Contact> objectPassed = new List<Contact>{ new Contact( LastName = 'Diff-Contact1' ), new Contact( LastName = 'Diff-Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0, objectExpected, objectPassed, 'expects.method.returning, when the expectation is set with a list, and a different instance is passed, containing different instances with the same values' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a list, and the same instance is passed
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAList_andSameInstanceIsPassed_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new List<Contact>() );

        Test.startTest();
            classToDouble.methodWithListOfObjects( objectExpected );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing the same objects
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAList_andADifferentInstanceContainingSameObjects() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new List<Contact>() );

        List<Contact> objectPassed = new List<Contact>{ objectExpected[0], objectExpected[1] };

        Test.startTest();
            classToDouble.methodWithListOfObjects( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing different instances with the same values
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAList_andADifferentInstanceContainingDifferentObjectsWithTheSameValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new List<Contact>() );

        List<Contact> objectPassed = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            classToDouble.methodWithListOfObjects( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing different instances with different values
    * @result will fail
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAList_andADifferentInstanceContainingDifferentObjectsWithDifferentValues() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new List<Contact>() );

        List<Contact> objectPassed = new List<Contact>{ new Contact( LastName = 'Diff-Contact1' ), new Contact( LastName = 'Diff-Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0, objectExpected, objectPassed, 'expects.method.setToTheSameValueAs.returning, when the expectation is set with a list, and a different instance is passed, containing different instances with the same values' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing different instances, of different types with the same values
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAList_andADifferentInstancesOfDifferentTypesContainingDifferentObjectsWithTheSameValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Object> objectExpected = new List<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new List<Contact>() );

        List<Contact> objectPassed = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            classToDouble.methodWithListOfObjects( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a list, and a different instance is passed, containing different instances, of different types with the same values
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAList_andADifferentInstanceOfDifferentTypesContainingDifferentObjectsWithTheSameValues_2() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<Contact> objectExpected = new List<Contact>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new List<Contact>() );

        List<Object> objectPassed = new List<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            classToDouble.methodWithListOfObjects( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a Map, and the same instance is passed
    * @result will pass
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAMap_andSameInstanceIsPassed_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter( objectExpected )
                .returning( new Map<String,Sobject>() );

        Test.startTest();
            classToDouble.methodWithMapStringToObject( objectExpected );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing the same objects
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAMap_andADifferentInstanceContainingSameObjects_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter( objectExpected )
                .returning( new Map<String,Sobject>() );

        Map<String,Sobject> objectPassed = new Map<String,Sobject>{ 'one' => objectExpected.get( 'one' ), 'two' => objectExpected.get( 'two' ) };

        Test.startTest();
            try {
                classToDouble.methodWithMapStringToObject( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, 'The value is the same, but not the same instance as was expected', CLASS_TO_DOUBLE + '.methodWithMapStringToObject', 0, objectExpected, objectPassed, 'expects.method.returning, when the expectation is set with a map, and a different instance is passed, containing different instances with the same values' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing different instances with the same values
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAMap_andADifferentInstanceContainingDifferentObjectsWithTheSameValues() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter( objectExpected )
                .returning( new Map<String,Sobject>() );

        Map<String,Sobject> objectPassed = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithMapStringToObject( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is the same, but not the same instance as was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithMapStringToObject', 0,
                                                    objectExpected, objectPassed,
                                                    'expects.method.returning, when the expectation is set with a map, and a different instance is passed, containing different instances with the same values' );
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing different instances with different values
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAMap_andADifferentInstanceContainingDifferentObjectsWithDifferentValues() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter( objectExpected )
                .returning( new Map<String,Sobject>() );

        Map<String,Sobject> objectPassed = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Diff-Contact1' ), 'two' => new Contact( LastName = 'Diff-Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithMapStringToObject( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodWithMapStringToObject', 0, objectExpected, objectPassed, 'expects.method.returning, when the expectation is set with a map, and a different instance is passed, containing different instances with the same values' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing the same objects
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAMap_andADifferentInstanceContainingSameObjects() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Map<String,Sobject>() );

        Map<String,Sobject> objectPassed = new Map<String,Sobject>{ 'one' => objectExpected.get( 'one' ), 'two' => objectExpected.get( 'two' ) };

        Test.startTest();
            classToDouble.methodWithMapStringToObject( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing different instances with the same values
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAMap_andADifferentInstanceContainingDifferentObjectsWithTheSameValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Map<String,Sobject>() );

        Map<String,Sobject> objectPassed = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            classToDouble.methodWithMapStringToObject( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing different instances with different values
    * @result will fail
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAMap_andADifferentInstanceContainingDifferentObjectsWithDifferentValues() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Map<String,Sobject>() );

        Map<String,Sobject> objectPassed = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Diff-Contact1' ), 'two' => new Contact( LastName = 'Diff-Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithMapStringToObject( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodWithMapStringToObject', 0, objectExpected, objectPassed, 'expects.method.setToTheSameValueAs.returning, when the expectation is set with a map, and a different instance is passed, containing different instances with the different values' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing different instances with different keys
    * @result will fail
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAMap_andADifferentInstanceContainingDifferentObjectsWithDifferentKeys() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Sobject> objectExpected = new Map<String,Sobject>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Map<String,Sobject>() );

        Map<String,Sobject> objectPassed = new Map<String,Sobject>{ 'diff-one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithMapStringToObject( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodWithMapStringToObject', 0, objectExpected, objectPassed, 'expects.method.setToTheSameValueAs.returning, when the expectation is set with a map, and a different instance is passed, containing different instances with the different keys' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing different instances, of different types with the same values
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAMap_andADifferentInstancesOfDifferentTypesContainingDifferentObjectsWithTheSameValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Object> objectExpected = new Map<String,Object>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Map<String,Contact>() );

        Map<String,Contact> objectPassed = new Map<String,Contact>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            classToDouble.methodWithMapStringToObject( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with a map, and a different instance is passed, containing different instances, of different types with the same values
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithAMap_andADifferentInstanceOfDifferentTypesContainingDifferentObjectsWithTheSameValues_2() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<String,Contact> objectExpected = new Map<String,Contact>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapStringToObject' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Map<String,Object>() );

        Map<String,Object> objectPassed = new Map<String,Object>{ 'one' => new Contact( LastName = 'Contact1' ), 'two' => new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            classToDouble.methodWithMapStringToObject( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a Map (indexed by Id), and the same instance is passed
    * @result will pass
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAMapById_andSameInstanceIsPassed_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<Id,Sobject> objectExpected = new Map<Id,Sobject>{ '003000000000001' => new Contact( LastName = 'Contact1' ), '003000000000002' => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapIdToObject' )
                .withParameter( objectExpected )
                .returning( new Map<Id,Sobject>() );

        Test.startTest();
            classToDouble.methodWithMapIdToObject( objectExpected );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a Map (indexed by Date), and the same instance is passed
    * @result will pass
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithAMapByDate_andSameInstanceIsPassed_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Map<Date,Sobject> objectExpected = new Map<Date,Sobject>{ Date.newInstance( 2019, 01, 05 ) => new Contact( LastName = 'Contact1' ), Date.newInstance( 2019, 01, 06 ) => new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithMapDateToObject' )
                .withParameter( objectExpected )
                .returning( new Map<Date,Sobject>() );

        Test.startTest();
            classToDouble.methodWithMapDateToObject( objectExpected );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a Set, and the same instance is passed
    * @result will pass
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithASet_andSameInstanceIsPassed_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Set<Object> objectExpected = new Set<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithSetOfObjects' )
                .withParameter( objectExpected )
                .returning( new Set<Object>() );

        Test.startTest();
            classToDouble.methodWithSetOfObjects( objectExpected );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when the expectation is set with a Set, and the a different instance with the same values
    * @result will fail
    */
    @isTest
    private static void expectsMethodReturning_whenExpectationSetWithASet_andDifferentInstanceWithSameValuesIsPassed_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Set<Object> objectExpected = new Set<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithSetOfObjects' )
                .withParameter( objectExpected )
                .returning( new Set<Object>() );

        Set<Object> objectPassed = new Set<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithSetOfObjects( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionInstanceAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodWithSetOfObjects', 0, objectExpected, objectPassed, 'expects.method.returning, when the expectation is set with a Set, and a different instance is passed, containing same values' );
    }

    /**
    * @method expects.method.setToSameValueAs.returning
    * @case   when the expectation is set with a Set, and the a different instance with the same values
    * @result will pass
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithASet_andDifferentInstanceWithSameValuesIsPassed_willPass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Set<Object> objectExpected = new Set<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithSetOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Set<Object>() );

        Set<Object> objectPassed = new Set<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        Test.startTest();
            classToDouble.methodWithSetOfObjects( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAsreturning
    * @case   when the expectation is set with a Set, and the a different instance with different values
    * @result will fail
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectationSetWithASet_andDifferentInstanceWithSameValuesIsPassed_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Set<Object> objectExpected = new Set<Object>{ new Contact( LastName = 'Contact1' ), new Contact( LastName = 'Contact2' ) };

        classToDoubleController
            .expects()
                .method( 'methodWithSetOfObjects' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( new Set<Object>() );

        Set<Object> objectPassed = new Set<Object>{ new Contact( LastName = 'Diff-Contact1' ), new Contact( LastName = 'Diff-Contact2' ) };

        Test.startTest();
            try {
                classToDouble.methodWithSetOfObjects( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodWithSetOfObjects', 0, objectExpected, objectPassed, 'expects.method.setToTheSameValueAs.returning, when the expectation is set with a Set, and a different instance is passed, containing different values' );
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with an sobject via named syntax, and a different instance is passed with same properties
    * @result will not fail the test
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsIsSetWithSobjectWithNamedSyntaxAndDifferentInstancePassed_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheObject' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameterNamed( 'contactParam' ).setToTheSameValueAs( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'TheObject' );
        Test.startTest();
            String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.setToTheSameValueAs.returning
    * @case   when the expectation is set with an sobject, and a different instance is passed with different properties
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsIsSetWithSobjectAndDifferentInstancePassedWithDifferentProperties_willFail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Contact objectExpected = new Contact( LastName = 'TheExpected' );

        classToDoubleController
            .expects()
                .method( 'sobjectMethodUnderDouble' )
                .withParameter().setToTheSameValueAs( objectExpected )
                .returning( 'expectedReturn' );

        Contact objectPassed = new Contact( LastName = 'ThePassed' );
        Test.startTest();
            try {
                String returnFromDouble = classToDouble.sobjectMethodUnderDouble( objectPassed );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.sobjectMethodUnderDouble', 0, objectExpected, objectPassed, 'expects.method.setToTheSameValueAs.returning, when specified with an sobject and the method is called with a different instance that has different properties' );
    }

    /**
    * @method expects.method.returning
    * @case   when an overloaded method is called with the stated parameters
    * @result will not the test
    */
    @isTest
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithTheStatedParameters_willNotFailTheTest() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.overloadedMethodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning
    * @case   when an overloaded method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.overloadedMethodUnderDouble( 'ActualParam1', '1' );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'The value is not what was expected - The types do not match',
                                                    CLASS_TO_DOUBLE + '.overloadedMethodUnderDouble',
                                                    1,
                                                    'Integer', 'String',
                                                    'expects.method.returning, when an overloaded method is called with different parameters' );
    }

    /**
    * @method expects.method.returning
    * @case   when an overloaded method is called with more parameters
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithMoreParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.overloadedMethodUnderDouble( 'ActualParam1', '1' );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForEqualsAssertionFailure( assertsDoubleController, 'was called with an unexpected number of parameters', CLASS_TO_DOUBLE + '.overloadedMethodUnderDouble', 1, 2, 'expects.method.returning, when an overloaded method is called with more parameters' );
    }

    /**
    * @method expects.method.returning
    * @case   when an overloaded method is called with fewer parameters
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithFewerParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 'ActualParam2' )
                .thenParameter( 'ActualParam3' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.overloadedMethodUnderDouble( 'ActualParam1', 'ActualParam2' );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForEqualsAssertionFailure( assertsDoubleController, 'was called with an unexpected number of parameters', CLASS_TO_DOUBLE + '.overloadedMethodUnderDouble', 3, 2, 'expects.method.returning, when an overloaded method is called with fewer parameters' );
    }

    /**
    * @method expects.method.returning (positional)
    * @case   when an overloaded method is specified without all parameters
    * @result will match any appropriate version
    */
    @isTest
    private static void expectsMethodReturning_whenAnOverloadedMethodIsSpecifiedWithoutAllParametersInPositional_willMatchAnyApppriateVersion() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenAnyParameter()
                .returning( 'expectedReturn' )
            .then().expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenAnyParameter()
                .returning( 'expectedReturn' );

        Test.startTest();
            classToDouble.overloadedMethodUnderDouble( 'ActualParam1', '1' );
            classToDouble.overloadedMethodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning (named)
    * @case   when an overloaded method is specified without all parameters
    * @result will match any appropriate version
    */
    @isTest
    private static void expectsMethodReturning_whenAnOverloadedMethodIsSpecifiedWithoutAllParametersInNamed_willMatchAnyApppriateVersion() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .returning( 'expectedReturn' )
            .then().expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .returning( 'expectedReturn' );

        Test.startTest();
            classToDouble.overloadedMethodUnderDouble( 'ActualParam1', '1' );
            classToDouble.overloadedMethodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        classToDoubleController.verify();
    }

    /**
    * @method expects.method.returning, named parameters
    * @case   when the method is called with different parameters
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenUsingNamedParametersAndTheMethodIsCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter2' ).setTo( 1 )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterNamedAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodUnderDouble', 'parameter1', 'ActualParam1', 'OtherActualParam1', 'expects.method.returning, when the method defined using named parameters and is called with different parameters' );
    }

    /**
    * @method expects.method.returning, named parameters
    * @case   when the method is called fewer parameters than those specified
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenUsingNamedParametersAndTheMethodIsCalledWithFewerParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter2' ).setTo( 'ActualParam2' )
                .andParameterNamed( 'parameter3' ).setTo( 'ActualParam3' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.overloadedMethodUnderDouble( 'ActualParam1', 'ActualParam2' );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForEqualsAssertionFailure( assertsDoubleController, 'was called with different parameters to those specified', CLASS_TO_DOUBLE + '.overloadedMethodUnderDouble', new List<String>{ 'parameter1', 'parameter2', 'parameter3' }, new List<String>{ 'parameter1', 'parameter2' }, 'expects.method.returning, when the method defined using named parameters and is called with fewer parameters than were defined' );
    }

    /**
    * @method expects.method.returning, named parameters
    * @case   when the method is called fewer parameters than those specified
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodReturning_whenUsingNamedParametersAndTheMethodIsCalledWithDifferentlyNamedParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'overloadedMethodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter3' ).setTo( 'ActualParam3' )
                .returning( 'expectedReturn' );

        Test.startTest();
            try {
                String returnFromDouble = classToDouble.overloadedMethodUnderDouble( 'ActualParam1', 'ActualParam2' );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForEqualsAssertionFailure( assertsDoubleController, 'was called with different parameters to those specified', CLASS_TO_DOUBLE + '.overloadedMethodUnderDouble', new List<String>{ 'parameter1', 'parameter3' }, new List<String>{ 'parameter1', 'parameter2' }, 'expects.method.returning, when the method defined using named parameters and is called with fewer parameters than were defined' );
    }

    /**
    * @method expects.method.returning
    * @case   when multiple methods are defined and called in the stated order
    * @result will return the stated value for each method
    */
    @isTest
    private static void expectsMethodReturning_whenMultipleMethodsAreDefinedAndCalledInOrder_willReturnTheStatedValues() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @result will return the stated value in the call order they are specified
    */
    @isTest
    private static void expectsMethodReturning_whenMethodIsDefinedWithSameParametersAndCalledInOrder_willReturnTheResultsInOrder() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenParameter( 1 )
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
    * @method expects.method.returning using named parameters
    * @case   when the same method is defined with the same parameters, and called in order
    * @result will return the stated value in the call order they are specified
    */
    @isTest
    private static void expectsMethodReturning_usingNamedParameters_whenMethodIsDefinedWithSameParametersAndCalledInOrder_willReturnTheResultsInOrder() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1').setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter2').setTo( 1 )
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1').setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter2').setTo( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1').setTo( 'ActualParam1' )
                .andParameterNamed( 'parameter2').setTo( 1 )
                .returning( 'thirdReturn' );

        Test.startTest();
            String returnFromFirstCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromSecondCall = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromThirdCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'firstReturn' , returnFromFirstCall , 'expects.method.returning, using named notation, when method is defined with multiple overlapping parameters, will return the values stated, in the order they are called (1)' );
        System.assertEquals( 'secondReturn', returnFromSecondCall, 'expects.method.returning, using named notation, when method is defined with multiple overlapping parameters, will return the values stated, in the order they are called (2)' );
        System.assertEquals( 'thirdReturn' , returnFromThirdCall , 'expects.method.returning, using named notation, when method is defined with multiple overlapping parameters, will return the values stated, in the order they are called (3)' );
    }

    /**
    * @method expects.method.returning using named parameters, with some not specified
    * @case   when the same method is defined with the same parameters, and called in order
    * @result will return the stated value in the call order they are specified
    */
    @isTest
    private static void expectsMethodReturning_usingNamedParametersWithSomeNotSpecified_whenMethodIsDefinedWithSameParametersAndCalledInOrder_willReturnTheResultsInOrder() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1').setTo( 'ActualParam1' )
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter2').setTo( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter2').setTo( 1 )
                .andParameterNamed( 'parameter1').setTo( 'ActualParam1' )
                .returning( 'thirdReturn' );

        Test.startTest();
            String returnFromFirstCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromSecondCall = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            String returnFromThirdCall  = classToDouble.methodUnderDouble( 'ActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( 'firstReturn' , returnFromFirstCall , 'expects.method.returning, using named notation, when method is defined with multiple overlapping parameters with some not specified, will return the values stated, in the order they are called (1)' );
        System.assertEquals( 'secondReturn', returnFromSecondCall, 'expects.method.returning, using named notation, when method is defined with multiple overlapping parameters with some not specified, will return the values stated, in the order they are called (2)' );
        System.assertEquals( 'thirdReturn' , returnFromThirdCall , 'expects.method.returning, using named notation, when method is defined with multiple overlapping parameters with some not specified, will return the values stated, in the order they are called (3)' );
    }

    /**
    * @method expects.method.returning
    * @case   when the same method is defined with the any parameters methods, and called in order
    * @result will return the stated value in the call order they are specified
    */
    @isTest
    private static void expectsMethodReturning_whenMethodIsDefinedWithAnyParametersAndCalledInOrder_willReturnTheResultsInOrder() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'firstReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withAnyParameter()
                .thenParameter( 1 )
                .returning( 'secondReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ActualParam1' )
                .thenAnyParameter()
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            Contact passedContact = new Contact( FirstName = 'Person' );

            classToDouble.sobjectMethodUnderDouble( passedContact );
            List<Object> passedParameters = classToDoubleController.call( 0 ).of( 'sobjectMethodUnderDouble' ).parameters();
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method  call.of.parametersByName
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParametersByName_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Map<String,Object> passedParameters = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parametersByName();
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }

        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parametersByName, when given the details of a method that was never called, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was never called', exceptionMessage, 'call.of.parametersByName, when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter (Integer)
    * @case    when given the details of a method call that happened
    * @result  will return the stated parameter of that call
    */
    @isTest
    private static void callOfParameter_whenGivenACallThatHappened_willReturnTheStatedParameterOfThatCall() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam', 2 );
            Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( 0 );
        Test.stopTest();

        System.assertEquals( 'ActualParam', passedParameter, 'call.of.parameter, when given the details of a method call that happened, will return the stated parameter of that call' );
    }

    /**
    * @method  call.of.parameter (String)
    * @case    when given the details of a method call that happened
    * @result  will return the stated parameter of that call
    */
    @isTest
    private static void callOfParameterString_whenGivenACallThatHappened_willReturnTheStatedParameterOfThatCall() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam', 2 );
            Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( 'parameter1' );
        Test.stopTest();

        System.assertEquals( 'ActualParam', passedParameter, 'call.of.parameter (String), when given the details of a method call that happened, will return the stated parameter of that call' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method call that happened amongst many
    * @result  will return the parameter of that call
    */
    @isTest
    private static void callOfParameter_whenGivenACallThatHappenedAmongstMany_willReturnTheParameterOfThatCall() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        System.assertEquals( 3, passedParameter, 'call.of.parameter, when given the details of a method call that happened amongst many - index from 0, will return the stated parameter of that call' );
    }

    /**
    * @method  call.of.parameter (String)
    * @case    when given the details of a method call that happened amongst many
    * @result  will return the parameter of that call
    */
    @isTest
    private static void callOfParameterString_whenGivenACallThatHappenedAmongstMany_willReturnTheParameterOfThatCall() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'OtherActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam1', 1 );
            classToDouble.methodUnderDouble( 'ActualParam2', 2 );
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 2 );
            classToDouble.methodUnderDouble( 'ActualParam3', 3 ); // this is the one we're going to retrieve
            classToDouble.otherMethodUnderDouble( 'OtherActualParam2', 3 );
            classToDouble.methodUnderDouble( 'ActualParam4', 4 );

            Object passedParameter = classToDoubleController.call( 2 ).of( 'methodUnderDouble' ).parameter( 'parameter2' );
        Test.stopTest();

        System.assertEquals( 3, passedParameter, 'call.of.parameter (String), when given the details of a method call that happened amongst many - index from 0, will return the stated parameter of that call' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a call number that did not happen
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenACallNumberThatDidNotHappen_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method  call.of.parameter (String)
    * @case    when given the details of a call number that did not happen
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameterString_whenGivenACallNumberThatDidNotHappen_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();

            classToDouble.methodUnderDouble( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 1 ).of( 'methodUnderDouble' ).parameter( 'parameter1' );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }

        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter (String), when given the details of a call number that did not happen, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was not called 2 times', exceptionMessage, 'call.of.parameter (String), when given the details of a call number that did not happen, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method  call.of.parameter (String)
    * @case    when given the details of a method that was never called
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameterString_whenGivenAMethodThatWasNeverCalled_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( 'parameter1' );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }

        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter (String), when given the details of a method that was never called, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was never called', exceptionMessage, 'call.of.parameter (String), when given the details of method that was never called, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number that is out of range
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNumberThatIsOutOfRange_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method  call.of.parameter (String)
    * @case    when given the parameter name that does not exist
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterNameThatDoesNotExist_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();

            classToDouble.methodUnderDouble( 'ActualParam', 2 );

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 0 ).of( 'methodUnderDouble' ).parameter( 'doesNotExist' );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }

        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter (String), when given a parameter name that does not exist, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodUnderDouble was not called with parameter "doesNotExist"', exceptionMessage, 'call.of.parameter (String), when given a parameter name that does not exist, will throw an exception with a useful message' );
    }

    /**
    * @method  call.of.parameter
    * @case    when given the parameter number for a method that has no parameters
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameter_whenGivenAParameterForAMethodThatHasNoParameters_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    * @method  call.of.parameter (String)
    * @case    when given the parameter name for a method that has no parameters
    * @result  will throw an exception
    */
    @isTest
    private static void callOfParameterString_whenGivenAParameterForAMethodThatHasNoParameters_willThrowAnException() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();

            classToDouble.methodWithNoParametersUnderDouble();

            Boolean exceptionThrown = false;
            String  exceptionMessage;

            try {
                Object passedParameter = classToDoubleController.call( 0 ).of( 'methodWithNoParametersUnderDouble' ).parameter( 'noParametersExist' );
            } catch ( Exception e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }

        Test.stopTest();

        System.assert( exceptionThrown, 'call.of.parameter (String), when given a parameter name for a method that has no parameters, will throw an exception' );
        Amoss_Asserts.assertContains( 'methodWithNoParametersUnderDouble was not called with any parameters', exceptionMessage, 'call.of.parameter (String), when given a parameter name for a method that has no parameters, will throw an exception with a useful message' );
    }

    /**
    * @method  get.call.of.parameters
    * @case    when given the details of a method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void getCallOfParameters_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam', 2 );
            List<Object> passedParameters = classToDoubleController.get().call( 0 ).of( 'methodUnderDouble' ).parameters();
        Test.stopTest();

        System.assertEquals( new List<Object>{ 'ActualParam', 2 }, passedParameters, 'get.call.of.parameters, when given the details of a method call that happened, will return the parameters of that call' );
    }

    /**
    * @method  get.call.of.parameters
    * @case    when given the details of a method call with no parameters that happened
    * @result  will return an empty parameters list
    */
    @isTest
    private static void getCallOfParameters_whenGivenACallThatHappenedWithNoParameters_willReturnAnEmptyParametersList() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDouble.methodWithNoParametersUnderDouble();
            List<Object> passedParameters = classToDoubleController.get().call( 0 ).of( 'methodWithNoParametersUnderDouble' ).parameters();
        Test.stopTest();

        System.assertEquals( new List<Object>(), passedParameters, 'get.call.of.parameters, when given the details of a method call with no parameters that happened, will return an empty list of parameters' );
    }

    /**
    * @method  get.call.of.parametersByName
    * @case    when given the details of a method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void getCallOfParametersByName_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( 'ActualParam', 2 );
            Map<String,Object> passedParameters = classToDoubleController.get().call( 0 ).of( 'methodUnderDouble' ).parametersByName();
        Test.stopTest();

        Map<String,Object> expectedParameters = new Map<String,Object>{
            'parameter1' => 'ActualParam',
            'parameter2' => 2
        };

        System.assertEquals( expectedParameters, passedParameters, 'get.call.of.parametersByName, when given the details of a method call that happened, will return the parameters of that call indexed by name' );
    }

    /**
    * @method  get.call.of.parametersByName
    * @case    when given the details of a method call with no parameters that happened
    * @result  will return an empty parameters list
    */
    @isTest
    private static void getCallOfParametersByName_whenGivenACallThatHappenedWithNoParameters_willReturnAnEmptyParametersList() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDouble.methodWithNoParametersUnderDouble();
            Map<String,Object> passedParameters = classToDoubleController.get().call( 0 ).of( 'methodWithNoParametersUnderDouble' ).parametersByName();
        Test.stopTest();

        System.assertEquals( new Map<String,Object>(), passedParameters, 'get.call.of.parameters, when given the details of a method call with no parameters that happened, will return an empty map of parameters' );
    }

    /**
    * @method  get.latestCallOf.parameters
    * @case    when given the details of the last method call that happened
    * @result  will return the parameters of that call
    */
    @isTest
    private static void getLatestCallOfParameters_whenGivenACallThatHappened_willReturnTheParametersOfThatCall() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
    private static void parameter_whenAParameterIsAListOfObjects_willReturnTheParameter() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            List<Object> parameterPassed = new List<Object>{ 2, '3', new Account() };

            classToDouble.methodWithListOfObjects( parameterPassed );
            List<Object> parameterReturned = (List<Object>)classToDoubleController.call( 0 ).of( 'methodWithListOfObjects' ).parameter( 0 );
        Test.stopTest();

        System.assertEquals( parameterPassed, parameterReturned, 'parameters, when a parameter is a list of objects, will return the parameter' );
    }

    /**
    * @method  parameter (String)
    * @case    when a parameter is a list of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameterString_whenAParameterIsAListOfObjects_willReturnTheParameter() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            List<Object> parameterPassed = new List<Object>{ 2, '3', new Account() };

            classToDouble.methodWithListOfObjects( parameterPassed );
            List<Object> parameterReturned = (List<Object>)classToDoubleController.call( 0 ).of( 'methodWithListOfObjects' ).parameter( 'parameter1' );
        Test.stopTest();

        System.assertEquals( parameterPassed, parameterReturned, 'parameter (String), when a parameter is a list of objects, will return the parameter' );
    }

    /**
    * @method  parameter
    * @case    when a parameter is a set of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameter_whenAParameterIsASetOfObjects_willReturnTheParameter() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            Set<Object> parameterPassed = new Set<Object>{ 2, '3', new Account() };

            classToDouble.methodWithSetOfObjects( parameterPassed );
            Set<Object> parameterReturned = (Set<Object>)classToDoubleController.call( 0 ).of( 'methodWithSetOfObjects' ).parameter( 0 );
        Test.stopTest();

        System.assertEquals( parameterPassed, parameterReturned, 'parameters, when a parameter is a set of objects, will return the parameter' );
    }

    /**
    * @method  parameter (String)
    * @case    when a parameter is a set of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameterString_whenAParameterIsASetOfObjects_willReturnTheParameter() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            Set<Object> parameterPassed = new Set<Object>{ 2, '3', new Account() };

            classToDouble.methodWithSetOfObjects( parameterPassed );
            Set<Object> parameterReturned = (Set<Object>)classToDoubleController.call( 0 ).of( 'methodWithSetOfObjects' ).parameter( 'parameter1' );
        Test.stopTest();

        System.assertEquals( parameterPassed, parameterReturned, 'parameter (String), when a parameter is a set of objects, will return the parameter' );
    }

    /**
    * @method  parameter
    * @case    when a parameter is a map of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameter_whenAParameterIsAMapOfObjects_willReturnTheParameter() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            Map<String,Object> parameterPassed = new Map<String,Object>{ 'one' => 1, 'two' => '2', 'three' => new Contact() };

            classToDouble.methodWithMapStringToObject( parameterPassed );
            Map<String,Object> parameterReturned = (Map<String,Object>)classToDoubleController.call( 0 ).of( 'methodWithMapStringToObject' ).parameter( 0 );
        Test.stopTest();

        System.assertEquals( parameterPassed, parameterReturned, 'parameters, when a parameter is a map of objects, will return the parameter' );
    }

    /**
    * @method  parameter (String)
    * @case    when a parameter is a map of objects
    * @result  will return the parameter
    */
    @isTest
    private static void parameterString_whenAParameterIsAMapOfObjects_willReturnTheParameter() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            Map<String,Object> parameterPassed = new Map<String,Object>{ 'one' => 1, 'two' => '2', 'three' => new Contact() };

            classToDouble.methodWithMapStringToObject( parameterPassed );
            Map<String,Object> parameterReturned = (Map<String,Object>)classToDoubleController.call( 0 ).of( 'methodWithMapStringToObject' ).parameter( 'parameter1' );
        Test.stopTest();

        System.assertEquals( parameterPassed, parameterReturned, 'parameter (String), when a parameter is a map of objects, will return the parameter' );
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDoubleWithNoReturn' );

        Test.startTest();
            classToDouble.methodUnderDoubleWithNoReturn( 'this', 1 );

            try {
                classToDouble.methodUnderDoubleWithNoReturn( 'this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDoubleWithNoReturn was called more times than was expected';
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDoubleWithNoReturn' );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()                                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ 'methodUnderDoubleWithNoReturn( any )' }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method, multiple times
    * @case    when the methods are not called, and verify is
    * @result  will fail
    */
    @isTest
    private static void expectsMethodMultipleTimes_whenTheMethodsAreNotCalledAndVerifyIs_willFail() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDoubleWithNoReturn' )
            .then().expects()
                .method( 'methodUnderDouble' )
            .then().expects()
                .method( 'methodUnderDouble' );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        List<String> expectedMethodDescriptions = new List<String>{ 'methodUnderDoubleWithNoReturn( any )', 'methodUnderDouble( any )', 'methodUnderDouble( any )' };
        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method multiple time, when the methods are not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( expectedMethodDescriptions, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method multiple time, when the methods are not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method multiple time, when the methods are not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameter_whenTheMethodIsNotCalledAndVerifyIs_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ParamValue1' )
                .thenParameter( 2 );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()                                       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ 'methodUnderDouble( ParamValue1, 2 )' }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter
    * @case    when an 'any' parameter is defined, the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameter_whenTheMethodWithAnyParamDefinedIsNotCalledAndVerifyIs_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'ParamValue1' )
                .thenAnyParameter();

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()                                               , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter, when the method is not called, and an any parameter is defined, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ 'methodUnderDouble( ParamValue1, Any value )' }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter, when the method is not called, and an any parameter is defined, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                                                , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter, when the method is not called, and an any parameter is defined, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.setToTheSameValueAs
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterSetToTheSameValueAs_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().setToTheSameValueAs( 'expectedParameterValue' );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()                                              , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.setToTheSameValueAs, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ 'methodUnderDouble( expectedParameterValue )' }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.setToTheSameValueAs, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                                               , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.setToTheSameValueAs, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.setToTheSameValueAs (object)
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterSetToTheSameValueAsWithObject_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().setToTheSameValueAs( new AmossTest_ClassToDouble( 'expectedObjectParam' ) )
                .thenParameter().setToTheSameValueAs( new AmossTest_ClassToDouble( 'expectedObjectParam' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        // TODO: why does this not include the namespace?
        String expectedCall      = 'methodUnderDouble( AmossTest_ClassToDouble:[], AmossTest_ClassToDouble:[] )';

        System.assertEquals( new List<String>()              , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.setToTheSameValueAs, with an object, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCall }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.setToTheSameValueAs, with an object, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion               , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.setToTheSameValueAs, with an object, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.withFieldsSetTo
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterWithFieldsSetTo_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withFieldsSetTo( new Map<String,Object>{ 'Field' => 'expectedValue' } );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( SObject with at least the same fields set as {Field=expectedValue} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.withFieldsSetTo, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.withFieldsSetTo, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.withFieldsSetTo, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.withFieldsSetLike
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterWithFieldsSetLike_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.withFieldsSetLike, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.withFieldsSetLike, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.withFieldsSetLike, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.withAllElements
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterWithAllElements_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withAllElements().withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( All => SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.withAllElements, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.withAllElements, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.withAllElements, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.withAnyElement
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterWithAnyElement_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withAnyElement().withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( At least one => SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.withAnyElement, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.withAnyElement, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.withAnyElement, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.withElementAt
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterWithElementAt_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().withElementAt( 1 ).withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( 1 => SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamed_whenTheMethodIsNotCalledAndVerifyIs_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setTo( 'ParamValue1' )
                .andParameterNamed( 'parameter2' ).setTo( 2 );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        List<String> expectedCallDescriptions = new List<String>{ 'methodUnderDouble( parameter1 => ParamValue1, parameter2 => 2 )' };
        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()      , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( expectedCallDescriptions, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.setTo (List)
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterSetToSet_whenTheMethodIsNotCalledAndVerifyIs_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithSetOfObjects' )
                .withParameter().setTo( new Set<Contact>{ new Contact( LastName = 'expectedName' ) } );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        List<String> expectedCallDescriptions = new List<String>{ 'methodWithSetOfObjects( Same instance as {Contact:{LastName=expectedName}} )' };
        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()      , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.setTo (Set), when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( expectedCallDescriptions, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.setTo (Set), when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.setTo (Set), when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.setTo (list)
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterSetToList_whenTheMethodIsNotCalledAndVerifyIs_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().setTo( new List<Contact>{ new Contact( LastName = 'expectedName' ) } );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        List<String> expectedCallDescriptions = new List<String>{ 'methodWithListOfObjects( Same instance as (Contact:{LastName=expectedName}) )' };
        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()      , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.setTo (List), when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( expectedCallDescriptions, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.setTo (List), when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion       , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.setTo (List), when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.setToTheSameValueAs
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedSetToTheSameValueAs_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setToTheSameValueAs( 'expectedParameterValue' );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => expectedParameterValue )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.setToTheSameValueAs, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.setToTheSameValueAs, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.setToTheSameValueAs, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.setToTheSameValueAs (object)
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedSetToTheSameValueAsWithObject_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).setToTheSameValueAs( new AmossTest_ClassToDouble( 'expectedObjectParam' ) )
                .andParameterNamed( 'parameter2' ).setToTheSameValueAs( new AmossTest_ClassToDouble( 'expectedObjectParam' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => AmossTest_ClassToDouble:[], parameter2 => AmossTest_ClassToDouble:[] )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.setToTheSameValueAs, with an object, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.setToTheSameValueAs, with an object, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.setToTheSameValueAs, with an object, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.withFieldsSetTo
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedWithFieldsSetTo_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).withFieldsSetTo( new Map<String,Object>{ 'Field' => 'expectedValue' } )
                .andParameterNamed( 'parameter2' ).withFieldsSetTo( new Map<String,Object>{ 'Field2' => 'expectedValue2' });

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => SObject with at least the same fields set as {Field=expectedValue}, parameter2 => SObject with at least the same fields set as {Field2=expectedValue2} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.withFieldsSetTo, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.withFieldsSetTo, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.withFieldsSetTo, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.withFieldsSetLike
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedWithFieldsSetLike_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.withFieldsSetLike, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.withFieldsSetLike, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.withFieldsSetLike, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.withAllElements
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedWithAllElements_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).withAllElements().withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => All => SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.withAllElements, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.withAllElements, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.withAllElements, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.withAllElements.withAnyElement.withElementAt
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterWithElementsCombination_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'toString' )
                .returning( 'VerifiedBy' );
        Amoss_ValueVerifier customVerifier = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter()
                    .withAnyElement().setTo( 'anyElementSetTo1' )
                    .withAnyElement().setTo( 'anyElementSetTo2' )
                    .withAllElements().withFieldsSetLike( new Contact( FirstName = 'allSet' ) )
                    .withAllElements().withFieldsSetTo( new Map<String,Object>{ 'LastName' => 'allSet' } )
                    .withElementAt( 0 ).setToTheSameValueAs( 'setToValue' )
                    .withElementAt( 1 ).verifiedBy( customVerifier );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( Should match all of [ At least one => anyElementSetTo1, At least one => anyElementSetTo2, All => SObject with fields set like Contact:{FirstName=allSet}, All => SObject with at least the same fields set as {LastName=allSet}, 0 => setToValue, 1 => VerifiedBy ] )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.withAllElements.withAnyElement.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.withAllElements.withAnyElement.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.withAllElements.withAnyElement.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.withAllElements.withAnyElement.withElementAt
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedWithElementsCombination_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'toString' )
                .returning( 'VerifiedBy' );
        Amoss_ValueVerifier customVerifier = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' )
                    .withAnyElement().setTo( 'anyElementSetTo1' )
                    .withAnyElement().setTo( 'anyElementSetTo2' )
                    .withAllElements().withFieldsSetLike( new Contact( FirstName = 'allSet' ) )
                    .withAllElements().withFieldsSetTo( new Map<String,Object>{ 'LastName' => 'allSet' } )
                    .withElementAt( 0 ).setToTheSameValueAs( 'setToValue' )
                    .withElementAt( 1 ).verifiedBy( customVerifier );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => Should match all of [ At least one => anyElementSetTo1, At least one => anyElementSetTo2, All => SObject with fields set like Contact:{FirstName=allSet}, All => SObject with at least the same fields set as {LastName=allSet}, 0 => setToValue, 1 => VerifiedBy ] )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameter.withAllElements.withAnyElement.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameter.withAllElements.withAnyElement.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameter.withAllElements.withAnyElement.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.withAnyElement
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedWithAnyElement_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).withAnyElement().withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => At least one => SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.withAnyElement, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.withAnyElement, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.withAnyElement, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameterNamed.withElementAt
    * @case    when the method is not called, and verify is
    * @result  will fail and describe the parameters
    */
    @isTest
    private static void expectsMethodWithParameterNamedWithElementAt_whenTheMethodIsNotCalled_willFailDescribingTheParameters() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();
        assertsDoubleController
            .allows()
                .method( 'assertEquals' );

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).withElementAt( 1 ).withFieldsSetLike( new Contact( FirstName = 'expectedName' ) );

        Test.startTest();
            classToDoubleController.verify();
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCallStackEntry = 'methodUnderDouble( parameter1 => 1 => SObject with fields set like Contact:{FirstName=expectedName} )';

        System.assertEquals( new List<String>()                        , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCallStackEntry }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                         , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.withElementAt, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    //HERE

    /**
    * @method  expects.method.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was called more times than was expected';
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDoubleController.verify();
            } catch ( TestException e ) {
                // this is how the mock asserts object halts the test at the failed assertion...
            }
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()                            , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ 'methodUnderDouble( any )' }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                             , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is called
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithAnyParametersReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was called more times than was expected';
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

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withAnyParameters()
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDoubleController.verify();
            } catch ( TestException e ) {
                // this is how the mock asserts object halts the test at the failed assertion...
            }
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';

        System.assertEquals( new List<String>()                            , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ 'methodUnderDouble( any )' }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that describes the outstanding method calls' );
        System.assertEquals( expectedAssertion                             , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withAnyParameters.returning, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expects.method.verifiedBy.returning.verify
    * @case   when the specified method is not called
    * @result will fail the test using the toString to form the description
    */
    @isTest
    private static void expectsMethodVerifiedByReturning_whenTheMethodIsNotCalledAndVerifyIs_willFailAndUseToString() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'toString' )
                .returning( 'The custom description for parameter 1' )
            .then().expects()
                .method( 'toString' )
                .returning( 'The custom description for parameter 2' ); // since we use the verifier for two parameters, we expect 2 calls

        Amoss_ValueVerifier customVerifierFails = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter().verifiedBy( customVerifierFails )
                .thenParameter().verifiedBy( customVerifierFails )
                .returning( expectedReturn );

        Test.startTest();
            try {
                classToDoubleController.verify();
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCall      = 'methodUnderDouble( The custom description for parameter 1, The custom description for parameter 2 )';

        System.assertEquals( new List<String>()              , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.verifiedBy.returning.verify, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCall }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.verifiedBy.returning.verify, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that contains the return from the custom verifier toString method' );
        System.assertEquals( expectedAssertion               , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.verifiedBy.returning.verify, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method expects.method.withParameterNamed.verifiedBy.returning.verify
    * @case   when the specified method is not called
    * @result will fail the test using the toString to form the description
    */
    @isTest
    private static void expectsMethodWithParameterNamedVerifiedByReturning_whenTheMethodIsNotCalledAndVerifyIs_willFailAndUseToString() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance verifierToDoubleController = new Amoss_Instance( Amoss_ValueVerifier.class );
        verifierToDoubleController
            .expects()
                .method( 'toString' )
                .returning( 'The custom description for parameter 1' )
            .then().expects()
                .method( 'toString' )
                .returning( 'The custom description for parameter 2' ); // since we use the verifier for two parameters, we expect 2 calls

        Amoss_ValueVerifier customVerifierFails = (Amoss_ValueVerifier)verifierToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).verifiedBy( customVerifierFails )
                .andParameterNamed( 'parameter2' ).verifiedBy( customVerifierFails )
                .returning( expectedReturn );

        Test.startTest();
            try {
                classToDoubleController.verify();
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCall      = 'methodUnderDouble( parameter1 => The custom description for parameter 1, parameter2 => The custom description for parameter 2 )';

        System.assertEquals( new List<String>()              , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.verifiedBy.returning.verify, when the method is not called, and verify is, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCall }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.verifiedBy.returning.verify, when the method is not called, and verify is, will fail by calling assertEquals with a call stack description that contains the return from the custom verifier toString method' );
        System.assertEquals( expectedAssertion               , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.verifiedBy.returning.verify, when the method is not called, and verify is, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }


    /**
    * @method expects.method.withParameter.noVerifier.verify
    * @case   always
    * @result will fail the test
    */
    @isTest
    private static void expectsMethodWithParameterVerifiedNoVerifierVerify_willAlwaysFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        String expectedReturn = 'theReturn';
        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' );

        Test.startTest();
            try {
                classToDoubleController.verify();
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = 'Expected call stack for ' + CLASS_TO_DOUBLE + ' should be empty, and it is not';
        String expectedCall      = 'methodUnderDouble( parameter1 => ERROR: No specification of the parameter shape was made (e.g. setTo) )';

        System.assertEquals( new List<String>()              , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method.withParameterNamed.noVerifier.verify, when verify is called, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCall }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method.withParameterNamed.noVerifier.verify, when verify is called, will fail by calling assertEquals with a call stack description that contains a message stating the verifier was not set up' );
        System.assertEquals( expectedAssertion               , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'expects.method.withParameterNamed.noVerifier.verify, when verify is called, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withParameter.thenParameter.returning
    * @case    when the method is called with matching parameters
    * @result  will not fail, and will return the stated result
    */
    @isTest
    private static void expectsMethodWithParameterAndThenParameterReturning_whenTheMethodIsCalled_willNotFailAndWillReturnTheStatedResult() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            String actualReturn = classToDouble.methodUnderDouble( 'this', 1 );
        Test.stopTest();

        System.assertEquals( 'TheReturn', actualReturn, 'expects.method.withParameter.thenParameter.returning, when the method is called with matching parameters, will not fail, and will return the stated result' );
    }

    /**
    * @method  expects.method.withParameter.thenParameter.returning
    * @case    when the method is called with non-matching parameters
    * @result  will fail the test
    */
    @isTest
    private static void expectsMethodWithParameterAndThenParameterReturning_whenTheMethodIsCalledWithNonMatchingParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'not-this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodUnderDouble', 0, 'this', 'not-this', 'expects.method.withParameter.thenParameter.returning, when the method is called with non-matching parameters' );
    }

    //
    // Allow any call tests
    //

    /**
    * @method  allowsAnyCall
    * @case    when given false, no methods are defined, and a method is called
    * @result  will make the test fail
    */
    @isTest
    private static void allowsAnyCall_whenGivenFalseAndNoMethodsAreDefinedAndAMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDoubleController
                .allowsAnyCall( false );

            try {
                classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall
    * @case    when given true, no methods are defined, and a method is called
    * @result  will return null
    */
    @isTest
    private static void allowsAnyCall_whenGivenTrueAndAndNoMethodsAreDefinedAndAMethodIsCalled_willReturnNull() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            classToDoubleController
                .allowsAnyCall( true );
            String returnFromDouble = classToDouble.methodUnderDouble( 'OtherActualParam1', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when given true, when no methods are defined, and a method is called, will return null' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning
    * @case    when the method is called more than once
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledMoreThanOnce_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowsAnyCall is true, and the expected method is called too many times, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowsAnyCall is true, and the expected method is called too many times, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowsAnyCall.false.expects.method.returning
    * @case    when the method is called more than once
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_expectsMethodReturning_whenTheMethodIsCalledMoreThanOnce_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_expectsMethodReturning_whenADifferentMethodIsCalled_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowsAnyCall is true, and a method that is not expected is called, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowsAnyCall is true, and a method that is not expected is called, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning (shortcut)
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCallhortcut_true_expectsMethodReturning_whenADifferentMethodIsCalled_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall()
            .expects()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );
            classToDouble.otherMethodUnderDouble( 'this', 1 );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowsAnyCall, and a method that is not expected is called, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowsAnyCall, and a method that is not expected is called, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowsAnyCall.false.expects.method.returning
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_expectsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        String expectedAssertion = CLASS_TO_DOUBLE + '.otherMethodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowsAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowsAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning
    * @case    when the method is called again with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall()
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );
            classToDouble.methodUnderDouble( 'that', 1 );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowsAnyCall is true, and the expected method is called too many times, with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowsAnyCall is true, and the expected method is called too many times, with different parameters, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowsAnyCall.false.expects.method.returning
    * @case    when the method is called again with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_expectsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'this', 1 );

            try {
                classToDouble.methodUnderDouble( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was called more times than was expected';
        System.assertEquals( false            , assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with false' );
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning.verify
    * @case    when the method is called only with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_true_expectsMethodReturning_whenTheMethodIsCalledOnlyWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'that', 1 );

            try {
                classToDoubleController.verify();
            } catch ( TestException e ) {
                // this is how the mock asserts object halts the test at the failed assertion...
            }
        Test.stopTest();

        System.assertEquals( new List<String>()                                , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'expects.method, when allowsAnyCall is true, and the expected method only once, with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( new List<String>{ 'methodUnderDouble( this, 1 )' }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'expects.method, when allowsAnyCall is true, and the expected method only once, with different parameters, and verify is called, will call assertEquals with a non empty actual remaining call stack - and fail the test' );
    }

    /**
    * @method  allowsAnyCall.false.expects.method.returning
    * @case    when the method is only called with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_expectsMethodReturning_whenTheMethodIsOnlyCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .expects()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'not-this', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController, CLASS_TO_DOUBLE + '.methodUnderDouble', 0, 'this', 'not-this', 'expects.method.withParameter.thenParameter.returning, and allowsAnyCall with false, when the method is only called with non-matching parameters' );
    }

    /**
    * @method  allowsAnyCall.true.when.method.willReturn
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_whenMethodWillReturn_whenADifferentMethodIsCalled_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .when()
                .method( 'methodUnderDouble' )
                .willReturn( 'TheReturn' );

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'this', 1 );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'when.method, when allowsAnyCall is true, and a method that is not set up as a when is called, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'when.method, when allowsAnyCall is true, and a method that is not set up as a when is called, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowsAnyCall.false.when.method.willReturn
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_whenMethodWillReturn_whenADifferentMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        String expectedAssertion = CLASS_TO_DOUBLE + '.otherMethodUnderDouble was called more times than was expected, and no matching "when" or "allows" exists';
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'when.method, when allowsAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'when.method, when allowsAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.when.method.willReturn
    * @case    when the method is called again with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_whenMethodWillReturn_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .willReturn( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'that', 1 );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'when.method, when allowsAnyCall is true, and the when method is called with different parameters, and verify is called, will call assertEquals with an empty expected remaining call stack' );
        System.assertEquals( new List<String>(), assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'when.method, when allowsAnyCall is true, and the when method is called with different parameters, and verify is called, will call assertEquals with an empty actual remaining call stack' );
    }

    /**
    * @method  allowsAnyCall.false.when.method.willReturn
    * @case    when the method is called again with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_whenMethodWillReturn_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .when()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .willReturn( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was called more times than was expected, and no matching "when" or "allows" exists';
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'when.method, when allowsAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'when.method, when allowsAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.allows.method.returning
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_allowsMethodReturning_whenADifferentMethodIsCalled_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .allows()
                .method( 'methodUnderDouble' )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.otherMethodUnderDouble( 'this', 1 );
        Test.stopTest();

        System.assertEquals( 0, assertsDoubleController.countOf( 'assert'       ), 'allows.method, when allowsAnyCall is true, and a method that is not explicitly allowed is called, will not fail the tests (no assert called)' );
        System.assertEquals( 0, assertsDoubleController.countOf( 'assertEquals' ), 'allows.method, when allowsAnyCall is true, and a method that is not explicitly allowed is called, will not fail the tests (no assert equals called)' );
    }

    /**
    * @method  allowsAnyCall.false.allows.method.returning
    * @case    when a different method is called
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_allowsMethodReturning_whenADifferentMethodIsCalled_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

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

        String expectedAssertion = CLASS_TO_DOUBLE + '.otherMethodUnderDouble was called more times than was expected, and no matching "when" or "allows" exists';
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method, when allowsAnyCall is called with false, and a method that is not explictly allowed is called, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method, when allowsAnyCall is called with false, and a method that is not explictly allowed is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.allows.method.returning
    * @case    when the method is called with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willNotFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( true )
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            classToDouble.methodUnderDouble( 'that', 1 );
        Test.stopTest();

        System.assertEquals( 0, assertsDoubleController.countOf( 'assert'       ), 'allows.method, when allowsAnyCall is true, and the allowed method is called with different parameters, will not fail the test (no assert called)' );
        System.assertEquals( 0, assertsDoubleController.countOf( 'assertEquals' ), 'allows.method, when allowsAnyCall is true, and the allowed method is called with different parameters, will not fail the test (no assert equals called)' );
    }

    /**
    * @method  allowsAnyCall.false.allows.method.returning
    * @case    when the method is called with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_false_allowsMethodReturning_whenTheMethodIsCalledWithDifferentParameters_willFailTheTest() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .allowsAnyCall( false )
            .allows()
                .method( 'methodUnderDouble' )
                .withParameter( 'this' )
                .thenParameter( 1 )
                .returning( 'TheReturn' );

        Test.startTest();
            try {
                classToDouble.methodUnderDouble( 'that', 1 );
            } catch ( TestException e ) {}
        Test.stopTest();

        String expectedAssertion = CLASS_TO_DOUBLE + '.methodUnderDouble was called more times than was expected, and no matching "when" or "allows" exists';
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allows.method, when allowsAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allows.method, when allowsAnyCall is called with false, and the method is called with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expectsNoCalls
    * @case    when already configured with an expects
    * @result  will throw an exception
    */
    @isTest
    private static void expectsNoCalls_whenAlreadyConfiguredWithExpects_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expects()
                    .method( 'methodUnderDouble' )
                .also()
                    .expectsNoCalls();

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'expectsNoCalls, when already configured with an expects, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the double expectsNoCalls when expectations or whens have been defined', exceptionMessage, 'expectsNoCalls, when already configured with an expects, will throw an exception with a useful message' );
    }

    /**
    * @method  expectsNoCalls
    * @case    when already configured with an allows
    * @result  will throw an exception
    */
    @isTest
    private static void expectsNoCalls_whenAlreadyConfiguredWithAllows_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .allows()
                    .method( 'methodUnderDouble' )
                .also()
                    .expectsNoCalls();

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'expectsNoCalls, when already configured with an allows, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the double expectsNoCalls when expectations or whens have been defined', exceptionMessage, 'expectsNoCalls, when already configured with an allows, will throw an exception with a useful message' );
    }

    /**
    * @method  expectsNoCalls
    * @case    when already configured with a when
    * @result  will throw an exception
    */
    @isTest
    private static void expectsNoCalls_whenAlreadyConfiguredWithWhen_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .when()
                    .method( 'methodUnderDouble' )
                .also()
                    .expectsNoCalls();

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'expectsNoCalls, when already configured with a when, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the double expectsNoCalls when expectations or whens have been defined', exceptionMessage, 'expectsNoCalls, when already configured with a when, will throw an exception with a useful message' );
    }

    /**
    * @method  expectsNoCalls
    * @case    when already configured with allowsAnyCall
    * @result  will throw an exception
    */
    @isTest
    private static void expectsNoCalls_whenAlreadyConfiguredWithAllowsAnyCall_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .allowsAnyCall( true )
                .expectsNoCalls();

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'expectsNoCalls, when already configured with allows any call, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the double expectsNoCalls when allowsAnyCall has been set to true', exceptionMessage, 'expectsNoCalls, when already configured with allows any call, will throw an exception with a useful message' );
    }

    /**
    * @method  expects
    * @case    when already configured as expectsNoCalls
    * @result  will throw an exception
    */
    @isTest
    private static void expects_whenAlreadyConfiguredAsExpectsNoCalls_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls()
                .expects();

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'expects, when already configured as expectsNoCalls, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the double expects a call when it has been stated that it expectsNoCalls', exceptionMessage, 'expects, when already configured as expectsNoCalls, will throw an exception with a useful message' );
    }

    /**
    * @method  allows
    * @case    when already configured as expectsNoCalls
    * @result  will throw an exception
    */
    @isTest
    private static void allows_whenAlreadyConfiguredAsExpectsNoCalls_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls()
                .allows();

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'allows, when already configured as expectsNoCalls, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the double allows a call when it has been stated that it expectsNoCalls', exceptionMessage, 'allows, when already configured as expectsNoCalls, will throw an exception with a useful message' );
    }

    /**
    * @method  when
    * @case    when already configured as expectsNoCalls
    * @result  will throw an exception
    */
    @isTest
    private static void when_whenAlreadyConfiguredAsExpectsNoCalls_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls()
                .when();

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'when, when already configured as expectsNoCalls, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the when on a double when it has been stated that it expectsNoCalls', exceptionMessage, 'when, when already configured as expectsNoCalls, will throw an exception with a useful message' );
    }

    /**
    * @method  allowsAnyCall
    * @case    when already configured as expectsNoCalls
    * @result  will throw an exception
    */
    @isTest
    private static void allowsAnyCall_whenAlreadyConfiguredAsExpectsNoCalls_willThrowAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls()
                .allowsAnyCall( true );

        } catch ( Amoss_Instance.Amoss_ExpectsNoCallsAndCallsConfiguredException e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'allowsAnyCall, when already configured as expectsNoCalls, will throw an exception' );
        Amoss_Asserts.assertContains( 'Cannot state the double allowsAnyCall when it has been stated that it expectsNoCalls', exceptionMessage, 'allowsAnyCall, when already configured as expectsNoCalls, will throw an exception with a useful message' );
    }

    //
    // getDouble and generateDouble behaviours
    //
    /**
    * @method getDouble
    * @case   when called multiple times
    * @result will return the same instance
    */
    @isTest
    private static void getDouble_whenCalledMultipleTimes_willReturnTheSameInstance() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );

        Test.startTest();
            AmossTest_ClassToDouble classToDouble1 = (AmossTest_ClassToDouble)classToDoubleController.getDouble();
            AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController.getDouble();
        Test.stopTest();

        System.assertEquals( classToDouble1, classToDouble2, 'getDouble, when called multiple times, will return the same instance' );
    }

    /**
    * @method generateDouble
    * @result will return a different instance to getDouble
    */
    @isTest
    private static void generateDouble_willReturnADifferentInstanceToGetDouble() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );

        Test.startTest();
            AmossTest_ClassToDouble classToDouble1 = (AmossTest_ClassToDouble)classToDoubleController.getDouble();
            AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController.generateDouble();
        Test.stopTest();

        System.assertNotEquals( classToDouble1, classToDouble2, 'generateDouble, will return a different instance to getDouble' );
    }

    /**
    * @method generateDouble
    * @case   when isFluent has been called
    * @result will return a different instance to getDouble, where the double's methods return differentt instances too
    */
    @isTest
    private static void generateDouble_onAnIsFluent_returnsDifferentInstancesFromMethods() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController
            .isFluent();

        AmossTest_ClassToDouble classToDouble1 = (AmossTest_ClassToDouble)classToDoubleController.getDouble();
        AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            AmossTest_ClassToDouble returnFromDouble1 = classToDouble1.fluentMethod();
            AmossTest_ClassToDouble returnFromDouble2 = classToDouble2.fluentMethod();
        Test.stopTest();

        System.assertEquals( classToDouble1, returnFromDouble1, 'generateDouble, against an isFluent double, will return a double that responds to method calls as per the original - the original will still behave as per normal' );
        System.assertEquals( classToDouble2, returnFromDouble2, 'generateDouble, against an isFluent double, will return a double that responds to method calls as per the original' );
        System.assertNotEquals( returnFromDouble1, returnFromDouble2, 'generateDouble, against an isFluent double, will return a double that responds to method calls with a different instance to the orignal one' );
    }

    /**
    * @method when.returns.generateDouble
    * @case   when the method is called
    * @result will return the stated value
    */
    @isTest
    private static void generateDouble_whenReturnsGenerateDouble_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController
            .when( 'methodUnderDouble' )
            .returns( 'specifiedValue' );

        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( '1', 2 );
        Test.stopTest();

        System.assertEquals( 'specifiedValue', returnFromDouble, 'when.returns.generateDouble, when the method is called, will return the stated value' );
    }

    /**
    * @method getDouble.generateDouble.countOf
    * @case   when the methods are called on the different instances
    * @result will consolidate the calls into the one controller
    */
    @isTest
    private static void getDoubleGenerateDoubleGetCount_whenMethodsCalledOnEachInstanceAsSpecified_willConsolidateThem() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );

        AmossTest_ClassToDouble classToDouble  = (AmossTest_ClassToDouble)classToDoubleController.getDouble();
        AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            classToDouble.methodUnderDouble( '1', 2 );
            classToDouble2.methodUnderDouble( '1', 2 );
        Test.stopTest();

        System.assertEquals( 2, classToDoubleController.countOf( 'methodUnderDouble' ), 'getDouble.generateDouble.countOf, when the methods are called on the different instances,  will consolidate the calls into the one controller' );
    }

    /**
    * @method expects.getDouble.generateDouble.verify
    * @case   when the methods are called on the different instances
    * @result will consolidate the calls into the one controller
    */
    @isTest
    private static void expectsGetDoubleGenerateDoubleVerify_whenMethodsCalledOnEachInstanceAsSpecified_willConsolidateThemAndNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController
            .expects( 'methodUnderDouble' )
            .then().expects( 'methodUnderDouble' );

        AmossTest_ClassToDouble classToDouble  = (AmossTest_ClassToDouble)classToDoubleController.getDouble();
        AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            String returnFromDouble  = classToDouble.methodUnderDouble( '1', 2 );
            String returnFromDouble2 = classToDouble2.methodUnderDouble( '1', 2 );
        Test.stopTest();

        classToDoubleController.verify(); // both calls are registered against the same controller, and so this will pass
    }

    /**
    * @method createClone.when.countOf
    * @case   when the methods are called on the different instances
    * @result will split the calls between the appropriate controllers
    */
    @isTest
    private static void createCloneWhenCountOf_whenTheMethodsAreCalledOnTheDifferentInstances_willRouteToTheDifferentControllers() {

        Amoss_Instance classToDoubleController1 = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble1  = (AmossTest_ClassToDouble)classToDoubleController1.getDouble();

        Amoss_Instance classToDoubleController2 = classToDoubleController1.createClone();
        AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController2.generateDouble();

        Test.startTest();
            classToDouble1.methodUnderDouble( '1', 1 );
            classToDouble1.methodUnderDouble( '1', 2 );
            classToDouble1.methodUnderDouble( '1', 3 );

            classToDouble2.methodUnderDouble( '1', 11 );
            classToDouble2.methodUnderDouble( '1', 12 );
        Test.stopTest();

        System.assertEquals( 3, classToDoubleController1.countOf( 'methodUnderDouble' ), 'createClone.when.countOf, when the methods are called on the different instances, will split the calls between the appropriate controllers - including the call count on the original' );
        System.assertEquals( 2, classToDoubleController2.countOf( 'methodUnderDouble' ), 'createClone.when.countOf, when the methods are called on the different instances, will split the calls between the appropriate controllers - including the call count on the new controller' );

        System.assertEquals(  1, classToDoubleController1.get().call(0).of( 'methodUnderDouble' ).parameter( 1 ), 'createClone.when.countOf, when the methods are called on the different instances, will split the calls between the appropriate controllers - including the parameter log on the original' );
        System.assertEquals( 12, classToDoubleController2.get().call(1).of( 'methodUnderDouble' ).parameter( 1 ), 'createClone.when.countOf, when the methods are called on the different instances, will split the calls between the appropriate controllers - including the parameter log on the new controller' );
    }

    /**
    * @method createClone.expects.verify
    * @case   when the method is called as expected on the objects
    * @result will not fail
    */
    @isTest
    private static void createCloneExpectsVerify_whenMethodsCalledAsExpected_willNotFail() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController
            .expects( 'methodUnderDouble' );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Amoss_Instance newClassToDoubleController = classToDoubleController.createClone();
        AmossTest_ClassToDouble newClassToDouble = (AmossTest_ClassToDouble)newClassToDoubleController.getDouble();

        Test.startTest();
            String returnFromDouble  = classToDouble.methodUnderDouble( '1', 2 );
            String returnFromDouble2 = newClassToDouble.methodUnderDouble( '1', 2 );
        Test.stopTest();

        classToDoubleController.verify();
        newClassToDoubleController.verify();
    }

    /**
    * @method createClone
    * @case   when additional config is added to one of the controllers
    * @result will not affect the other
    */
    @isTest
    private static void createClone_whenAdditionalConfigIsAdded_willNotAffectTheOther() {

        Amoss_Instance classToDoubleController1 = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble1  = (AmossTest_ClassToDouble)classToDoubleController1.getDouble();

        Amoss_Instance classToDoubleController2 = classToDoubleController1.createClone();
        classToDoubleController2.expectsNoCalls();
        AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController2.getDouble();

        Test.startTest();
            classToDouble1.methodUnderDouble( '1', 1 );
        Test.stopTest();

        System.assertEquals( 1, classToDoubleController1.countOf( 'methodUnderDouble' ), 'createClone, when when additional config is added to the new, will not affect the original' );
    }

    /**
    * @method createClone
    * @case   when additional config is added to one of the controllers
    * @result will not affect the other
    */
    @isTest
    private static void createClone_whenAdditionalConfigIsAdded_willNotAffectTheOther2() {

        Amoss_Instance classToDoubleController1 = new Amoss_Instance( AmossTest_ClassToDouble.class );
        Amoss_Instance classToDoubleController2 = classToDoubleController1.createClone();

        classToDoubleController1
            .when( 'methodUnderDouble' )
            .returns( 'ReturnFrom1' );
        AmossTest_ClassToDouble classToDouble1 = (AmossTest_ClassToDouble)classToDoubleController1.getDouble();

        classToDoubleController2
            .when( 'methodUnderDouble' )
            .returns( 'ReturnFrom2' );
        AmossTest_ClassToDouble classToDouble2 = (AmossTest_ClassToDouble)classToDoubleController2.getDouble();

        Test.startTest();
            String returnFrom1 = classToDouble1.methodUnderDouble( '1', 1 );
            String returnFrom2 = classToDouble2.methodUnderDouble( '1', 1 );
        Test.stopTest();

        System.assertEquals( 'ReturnFrom1', returnFrom1, 'createClone, when when additional config is added to the new, will not affect the original' );
        System.assertEquals( 'ReturnFrom2', returnFrom2, 'createClone, when when additional config is added to the original, will not affect the new' );
    }

    /**
    * @method isFluent.when.returns.generateDouble
    * @case   when the method is called
    * @result will return the stated value
    */
    @isTest
    private static void generateDouble_isFluentWhenReturnsGenerateDouble_willReturnTheStatedValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController
            .isFluent()
            .when( 'methodUnderDouble' )
            .returns( 'specifiedValue' );

        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.generateDouble();

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( '1', 2 );
        Test.stopTest();

        System.assertEquals( 'specifiedValue', returnFromDouble, 'isFluent.when.returns.generateDouble, when the method is called, will return the stated value' );
    }

    //
    // Limitation tests - If any of these tests begin to fail, then an important limitation
    // has been removed and we may consider changing the functionality / documentation a little
    //
    /**
    * @method getDouble
    * @case   when given an Sobject to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void getDouble_whenGivenAnSobjectToCreateATestDoubleFor_willThrowAnException() {

        Amoss_Instance sobjectToDoubleController = new Amoss_Instance( Contact.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            Contact classUnderDouble = (Contact)sobjectToDoubleController.getDouble();
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'getDouble, when given an Sobject to create a test double for, will throw an exception' );
    }

    /**
    * @method getDouble
    * @case   when given an inner class to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void getDouble_whenGivenAnInnerClassToCreateATestDoubleFor_willThrowAnException() {

        Amoss_Instance innerClassToDoubleController = new Amoss_Instance( AmossTest_InstanceTest.InnerClassToDouble.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            AmossTest_InstanceTest.InnerClassToDouble classUnderDouble = (AmossTest_InstanceTest.InnerClassToDouble)innerClassToDoubleController.getDouble();
            classUnderDouble.publicMethod( 'StringParameter' );
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'getDouble, when given an inner class to create a test double for, will throw an exception' );
    }

    /**
    * @method getDouble
    * @case   when given a System Type to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void getDouble_whenGivenASystemTypeToCreateATestDoubleFor_willThrowAnException() {

        Amoss_Instance systemTypeToDoubleController = new Amoss_Instance( HttpRequest.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            HttpRequest classUnderDouble = (HttpRequest)systemTypeToDoubleController.getDouble();
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'getDouble, when given an system type to create a test double for, will throw an exception' );
    }

    /**
    * @method getDouble
    * @case   when given a class with no public constructors to create a test double for
    * @result will throw an exception
    */
    @isTest
    private static void getDouble_whenGivenAClassWithNoPublicConstructorToCreateATestDoubleFor_willThrowAnException() {

        Amoss_Instance singletonToDouble = new Amoss_Instance( AmossTest_SingletonToDouble.class );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        try {
            AmossTest_SingletonToDouble classUnderDouble = (AmossTest_SingletonToDouble)singletonToDouble.getDouble();
        } catch ( Exception e ) {
            exceptionThrown = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'getDouble, when given a class with no public constructor to create a test double for, will throw an exception' );
    }

    class InnerClassToDouble {
        public String publicMethod( String parameterOne ) {
            return 'returnString';
        }
    }

    private static Amoss_Instance buildMockAssertionController() {

        Amoss_Instance assertsDoubleController = new Amoss_Instance( Amoss_Asserts.class );
        assertsDoubleController
            .allows()
                .method( 'assertEquals' )
                .handledBy( new MockAssertEqualsHandler() )
            .also().allows()
                .method( 'assert' )
                .withParameter( true )
                .thenAnyParameter()
            .also().allows()
                .method( 'assert' )
                .withParameter( false )
                .thenAnyParameter()
                .handledBy( new MockAssertHandler() );
        return assertsDoubleController;
    }

    class MockAssertEqualsHandler implements Amoss_MethodHandler {
        public Object handleMethodCall( List<Object> parameters ) {
            if ( parameters[0] != parameters[1] ) {
                throw new TestException( 'Unequal expected and actual in an assertion would normally halt the test, so we will too - ' + String.valueOf( parameters[0] ) + ' != ' + String.valueOf( parameters[1] ) + ', for: '  + String.valueOf( parameters[2] ) );
            }
            return null;
        }
    }

    class MockAssertHandler implements Amoss_MethodHandler {
        public Object handleMethodCall( List<Object> parameters ) {
            if ( parameters[0] == false ) {
                throw new TestException( 'False assertion would normally halt the test, so we will too, for: '  + String.valueOf( parameters[1] ) );
            }
            return null;
        }
    }

    private static void checkForWrongParameterInPositionAssertion( Amoss_Instance assertsDoubleController, String method, Integer parameterPosition, Object expected, Object actual, String message ) {
        checkForWrongParameterInPositionAssertion( assertsDoubleController, 'The value is not what was expected', method, parameterPosition, expected, actual, message );
    }

    private static void checkForWrongParameterFieldsInPositionAssertion( Amoss_Instance assertsDoubleController, String method, Integer parameterPosition, Object expected, Object actual, String message ) {
        checkForWrongParameterInPositionAssertion( assertsDoubleController, 'The following fields were not set as expected', method, parameterPosition, expected, actual, message );
    }

    private static void checkForWrongParameterInPositionInstanceAssertion( Amoss_Instance assertsDoubleController, String method, Integer parameterPosition, Object expected, Object actual, String message ) {
        checkForWrongParameterInPositionAssertion( assertsDoubleController, 'The value is the same, but not the same instance as was expected', method, parameterPosition, expected, actual, message );
    }

    private static void checkForNullSObjectInPositionInstanceAssertion( Amoss_Instance assertsDoubleController, String method, Integer parameterPosition, Object expected, Object actual, String message ) {
        checkForWrongParameterInPositionAssertion( assertsDoubleController, 'Expected an sObject, and got NULL', method, parameterPosition, expected, actual, message );
    }

    private static void checkForWrongParameterNamedAssertion( Amoss_Instance assertsDoubleController, String method, String parameterName, Object expected, Object actual, String message ) {
        checkForWrongParameterNamedAssertion( assertsDoubleController, 'The value is not what was expected', method, parameterName, expected, actual, message );
    }

    private static void checkForWrongParameterNamedInstanceAssertion( Amoss_Instance assertsDoubleController, String method, String parameterName, Object expected, Object actual, String message ) {
        checkForWrongParameterNamedAssertion( assertsDoubleController, 'The value is the same, but not the same instance as was expected', method, parameterName, expected, actual, message );
    }

    private static void checkForWrongParameterInPositionAssertion( Amoss_Instance assertsDoubleController, String expectedDetailAssertion, String method, Integer parameterPosition, String message ) {

        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), message + ', will fail, by calling assert with false' );

        String expectedAssertion = method + ' had a problem with the parameter value in position ' + String.valueOf( parameterPosition );
        String actualAssertion = (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 );

        Amoss_Asserts.assertContains( expectedAssertion, actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly describes the issue' );
        Amoss_Asserts.assertContains( expectedDetailAssertion, actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly describes the issue in detail' );
    }

    // TODO: tidy the code duplication
    private static void checkForWrongParameterInPositionAssertion( Amoss_Instance assertsDoubleController, String expectedDetailAssertion, String method, Integer parameterPosition, Object expected, Object actual, String message ) {

        checkForWrongParameterInPositionAssertion( assertsDoubleController, expectedDetailAssertion, method, parameterPosition, message );

        String actualAssertion = (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 );

        Amoss_Asserts.assertContains( 'Expected: ' + expected, actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly stating the expected parameter value' );
        Amoss_Asserts.assertContains( 'Actual: '   + actual  , actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly stating the actual parameter value' );
    }

    private static void checkForWrongParameterNamedAssertion( Amoss_Instance assertsDoubleController, String expectedDetailAssertion, String method, String parameterName, Object expected, Object actual, String message ) {

        String expectedAssertion = method + ' had a problem with the parameter value for "' + String.valueOf( parameterName ) + '"';
        checkForEqualsAssertionFailure( assertsDoubleController, expectedDetailAssertion, expectedAssertion, expected, actual, message );
    }

    private static void checkForEqualsAssertionFailure( Amoss_Instance assertsDoubleController, String expectedDetailAssertion, String expectedAssertion, Object expected, Object actual, String message ) {

        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), message + ', will fail, by calling assert with false' );

        String actualAssertion = (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 );

        Amoss_Asserts.assertContains( expectedAssertion, actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly describes the issue' );
        Amoss_Asserts.assertContains( expectedDetailAssertion, actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly describes the issue in detail' );
        Amoss_Asserts.assertContains( 'Expected: ' + expected, actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly stating the expected parameter value' );
        Amoss_Asserts.assertContains( 'Actual: '   + actual  , actualAssertion, message + ', will fail, by calling assert with an assertion message that clearly stating the actual parameter value' );
    }
}