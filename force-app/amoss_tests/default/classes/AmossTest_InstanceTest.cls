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
    private static final String HTTP_CALLOUT_MOCK_UNEXPECTED_EXCEPTION_TEXT = 'More HTTP Callouts were made than expected, and no matching "when" or "allows" exists.';

    //
    // Method definition tests
    //
    /**
    * @case   when no methods are defined, and a method is called
    * @result will return null
    */
    @isTest
    private static void whenNoMethodsAreDefinedAndAMethodIsCalled_returnNull() {

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
    private static void forAnInterface_whenNoMethodsAreDefinedAndAMethodIsCalled_returnNull() {

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
    private static void whenMethodWillReturn_whenCalled_returnSetUpValue() {

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
    private static void whenMethodWillReturnShortcut_whenCalled_returnSetUpValue() {

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
    private static void whenMethodReturns_whenCalled_returnSetUpValue() {

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
    private static void whenMethodReturning_whenCalled_returnSetUpValue() {

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
    private static void isFluent_whenAnUnspecifiedFluentMethodIsCalled_returnTheGeneratedDouble() {

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
    private static void isFluent_whenAnUnspecifiedNonFluentMethodIsCalled_throwAnException() {

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
        System.assertEquals( 'Invalid conversion from runtime type ' + CLASS_TO_DOUBLE + ' to String', exceptionMessage, 'isFluent, when an unspecified, non fluent method is called, will throw an exception' );
    }

    /**
    * @method isFluent
    * @case   when an unspecified, method with no return is called
    * @result will not throw an exception
    */
    @isTest
    private static void isFluent_whenAnUnspecifiedMethodWithNoReturnIsCalled_notThrowAnException() {

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
    private static void isFluent_whenAnSpecifiedMethodWithNoDefinedReturnIsCalled_returnNull() {

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
    private static void isFluent_whenAnSpecifiedMethodWithADefinedReturnIsCalled_returnTheDefinedReturn() {

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
    private static void isFluent_whenAnUnspecifiedMethodIsCalled_returnTheSpecifiedValue() {

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
    private static void byDefaultMethodsReturn_whenAnUnspecifiedMethodWithADiffReturnTypeIsCalled_throwAnException() {

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
    private static void byDefaultMethodsReturn_whenAnUnspecifiedMethodWithNoReturnIsCalled_notThrowAnException() {

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
    private static void whenMethodHandledByStubProvider_whenCalled_CallTheHandlerAndReturnTheResult() {

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
    private static void whenMethodHandledByAmossMethodHandler_whenCalled_CallTheHandlerAndReturnTheResult() {

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
    private static void whenMethodThrows_whenCalled_throwTheStatedException() {

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
    private static void whenMethodThrowing_whenCalled_throwTheStatedException() {

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
    private static void whenMethodWillThrow_whenCalled_throwTheStatedException() {

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
    private static void whenMethodWillReturn_forAnInterface_whenCalled_returnSetUpValue() {

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
    private static void whenMethodWillReturn_whenADiffMethodIsCalled_returnNull() {

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
    private static void whenWithParameterWillReturn_whenCallWithParams_returnSetUpValue() {

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
    private static void whenWithParameterSetToWillReturn_whenCallWithParams_returnSetUpValue() {

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
    * @method when.method.withParameter.set.willReturn
    * @case   when that method is called with the parameter set (not null)
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterSet_whenCallWithParamSet_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().set()
                .thenParameter().set()
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'SetValue', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameter.set.willReturn, and the method called with parameter set to not null, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.set.willReturn
    * @case   when that method is called with the parameter set to null
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterSet_whenCallWithParamSetToNull_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().set()
                .thenParameter().set()
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( null, 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.set.willReturn, and the method called with the parameter set to null, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.containing.willReturn
    * @case   when that method is called with the parameter set to a String that contains the given one
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterContaining_whenCallWithParamSetToAStringThatContainsTheGiven_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().containing( 'match' )
                .thenAnyParameter()
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this matches', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameter.containing.willReturn, and the method called with parameter set to a string containing the given value, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.containing.willReturn
    * @case   when that method is called with the parameter set to a String that contains the given one, but in the wrong case
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterContaining_whenCallWithParamSetToAStringThatContainsTheGivenInWrongCase_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().containing( 'NoMatch' )
                .thenAnyParameter()
                .willReturn( 'notExpectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this nomatches', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.containing.willReturn, and the method called with parameter set to a string containing the given value in the wrong case, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.containing.willReturn
    * @case   when that method is called with the parameter set to an empty string
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterContaining_whenCallWithParamSetToAnEmptyString_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().containing( 'NoMatch' )
                .thenAnyParameter()
                .willReturn( 'notExpectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( '', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.containing.willReturn, and the method called with parameter set to an empty string, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.containing.willReturn
    * @case   when that method is called with the parameter set to null
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterContaining_whenCallWithParamSetToNull_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().containing( 'NoMatch' )
                .thenAnyParameter()
                .willReturn( 'notExpectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( null, 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.containing.willReturn, and the method called with parameter set to null, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.matching.willReturn
    * @case   when that method is called with the parameter set to a String that matches the given one
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterMatching_whenCallWithParamSetToAStringThatMatchesTheGiven_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().matching( 't.*m.*s' )
                .thenAnyParameter()
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this matches', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameter.matching.willReturn, and the method called with parameter set to a string matching the given value, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.matching.willReturn
    * @case   when that method is called with the parameter set to a String that does not all match the expression
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterMatching_whenCallWithParamSetToAStringDoesNotWhileMatch_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().matching( 'm.*s' )
                .thenAnyParameter()
                .willReturn( 'notExpectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this nomatches', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.matching.willReturn, and the method called with parameter set to a string that does not all match the given expression will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.matching.willReturn
    * @case   when that method is called with the parameter set to a String that does not match the given one
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterMatchingwhenTheMethodIsCalledWithParamSetToAStringDoesNotMatch_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().matching( 'Ma.*s' )
                .thenAnyParameter()
                .willReturn( 'notExpectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this nomatches', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.matching.willReturn, and the method called with parameter set to a string not matching the given value will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.matching.willReturn
    * @case   when that method is called with the parameter set to null
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterMatching_whenCallWithParamSetToNull_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().matching( 'a*b' )
                .thenAnyParameter()
                .willReturn( 'notExpectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( null, 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.matching.willReturn, and the method called with parameter set to null, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.matching.willReturn
    * @case   when the stated regular expression is not valid
    * @result will fail the test
    */
    @isTest
    private static void whenWithParameterMatching_whenTheRegExpIsNotValid_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        Test.startTest();
            try {
                classToDoubleController
                    .when()
                        .method( 'methodUnderDouble' )
                        .withParameter().matching( '*' );
                } catch( TestException e ) {}
        Test.stopTest();

        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'when.method.withParameter.matching.willReturn, and the RegExp is not valid will fail, by calling assert with false' );

        String expectedAssertion = 'The regular expression "*" does not appear to be valid: Invalid regex: Dangling meta character \'*\' near index 0';
        String actualAssertion = (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 );

        Amoss_Asserts.assertContains( expectedAssertion, actualAssertion, 'when.method.withParameter.matching.willReturn, and the RegExp is not valid will fail, will fail, by calling assert with an assertion message that clearly describes the issue' );

        String expectedExpected = 'Expected: A valid regular expression as per https://docs.oracle.com/javase/1.5.0/docs/api/index.html?java/util/regex/Pattern.html';

        Amoss_Asserts.assertContains( expectedExpected, actualAssertion, 'when.method.withParameter.matching.willReturn, and the RegExp is not valid will fail, will fail, by calling assert with an expected that clearly describes what was expected' );

        String expectedActual = 'Actual: *';

        Amoss_Asserts.assertContains( expectedActual, actualAssertion, 'when.method.withParameter.matching.willReturn, and the RegExp is not valid will fail, will fail, by calling assert with an actual that contains the regular expression that was set' );
    }

    /**
    * @method when.method.withParameter.aListOfLength.willReturn
    * @case   when that method is called with the parameter set to a List that is the stated length
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterAListOfLength_whenCallWithParamListOfGivenLength_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameter().aListOfLength( 3 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( new List<String>{ 'return' }, returnFromDouble, 'when.method.withParameter.aListOfLength.willReturn, when that method is called with the parameter set to a List that is the stated length, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.aListOfLength.willReturn
    * @case   when that method is called with the parameter set to a List that is a different length
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterAListOfLength_whenCallWithParamListOfDiffLength_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameter().aListOfLength( 10 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.aListOfLength.willReturn, when that method is called with the parameter set to a List that is not the stated length, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.aListOfLength.willReturn
    * @case   when that method is called with the parameter set to something that is not a list
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterAListOfLength_whenCallWithParamNotAList_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameter().aListOfLength( 10 )
                .thenAnyParameter()
                .willReturn( 'return' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'Thing', 2 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.aListOfLength.willReturn, when that method is called with the parameter that is not a list, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.aListOfLength.withElementAt.willReturn
    * @case   when that method is called with the parameter set to a List that is the stated length, and other criteria met
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterAListOfLengthWithElementAt_whenAllMet_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameter().aListOfLength( 3 )
                    .withElementAt( 0 ).setTo( 1 )
                    .withElementAt( 1 ).setTo( 2 )
                    .withElementAt( 2 ).setTo( 3 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( new List<String>{ 'return' }, returnFromDouble, 'when.method.withParameter.aListOfLength.withElementAt.willReturn, when that method is called with all criteria met, will return the stated value' );
    }

    /**
    * @method when.method.withParameter.aListOfLength.withElementAt.willReturn
    * @case   when not all criteria met
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterAListOfLengthWithElementAt_whenNotAllMet_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameter().aListOfLength( 3 )
                    .withElementAt( 0 ).setTo( 1 )
                    .withElementAt( 1 ).setTo( 99 )
                    .withElementAt( 2 ).setTo( 3 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameter.aListOfLength.withElementAt.willReturn, when that method is called with not all criteria met, will not return the stated value' );
    }

    /**
    * @method when.method.withParameter.noVerificationSet
    * @case   when that method is called
    * @result will fail
    */
    @isTest
    private static void whenWithParameterNoVerificationSet_whenCalled_fail() {

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
    private static void whenWithParametersWillReturn_whenCallWithParams_returnSetUpValue() {

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
    private static void whenWithParameterNamedSetToWillReturn_whenCallWithParams_returnSetUpValue() {

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
    private static void whenWithParameterNamedSetToWillReturn_whenNotAllSetAndTheMethodIsCalledWithParams_returnSetUpValue() {

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
    private static void whenWithParametersNamedWillReturn_whenCallWithParams_returnSetUpValue() {

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
    private static void whenWithParametersNamedWillReturn_whenNotAllSpecifiedAndTheMethodIsCalledWithParams_returnSetUpValue() {

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
    private static void whenWithParameterWillReturn_forAnInterface_whenCallWithParams_returnSetUpValue() {

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
    private static void whenWithParameterWillReturn_whenCallWithDiffParams_returnNull() {

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
    private static void whenWithParametersWillReturn_whenCallWithDiffParams_returnNull() {

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
    private static void whenWithParameterSetToWillReturn_whenCallWithDiffParams_returnNull() {

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
    private static void whenWithParameterNamedSetToWillReturn_whenCallWithDiffParams_returnNull() {

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
    * @method when.method.withParameterNamed.set.willReturn
    * @case   when that method is called with the parameter set (not null)
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterNamedSet_whenCallWithParamSet_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).set()
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'SetValue', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameterNamed.set.willReturn, and the method called with parameter set to not null, will return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.set.willReturn
    * @case   when that method is called with the parameter set to null
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterNamedSet_whenCallWithParamSetToNull_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).set()
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( null, 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.set.willReturn, and the method called with the parameter set to null, will not return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.containing.willReturn
    * @case   when that method is called with the parameter containing
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterNamedContaining_whenCallWithParamContaining_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).containing( 'will match' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this will match the config', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameterNamed.containing.willReturn, and the method called with parameter set to a String containing, will return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.containing.willReturn
    * @case   when that method is called with the parameter not containing
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterNamedContaining_whenCallWithParamNotContaining_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).containing( 'will not match' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this will no match the config', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.containing.willReturn, and the method called with parameter set to a String not containing, will not return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.matching.willReturn
    * @case   when that method is called with the parameter set to a String that matches the given one
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterNamedMatching_whenCallWithParamSetToAStringThatMatchesTheGiven_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).matching( 't.*m.*s' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'this matches', 1 );
        Test.stopTest();

        System.assertEquals( 'expectedReturn', returnFromDouble, 'when.method.withParameterNamed.matching.willReturn, and the method called with parameter set to a string matching the given value, will return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.matching.willReturn
    * @case   when that method is called with the parameter set to a String that does not match the given one
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterNamedMatching_whenCallWithParamSetToAStringThatNotMatchesTheGiven_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).matching( 't.*m.*s' )
                .willReturn( 'expectedReturn' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'does not match', 1 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.matching.willReturn, and the method called with parameter set to a string that does not match the given value, will not return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.aListOfLength.willReturn
    * @case   when that method is called with the parameter set to a List that is the stated length
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterNamedAListOfLength_whenCallWithParamListOfGivenLength_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameterNamed( 'parameter1' ).aListOfLength( 3 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( new List<String>{ 'return' }, returnFromDouble, 'when.method.withParameterNamed.aListOfLength.willReturn, when that method is called with the parameter set to a List that is the stated length, will return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.aListOfLength.willReturn
    * @case   when that method is called with the parameter set to a List that is a different length
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterNamedAListOfLength_whenCallWithParamListOfDiffLength_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameterNamed( 'parameter1' ).aListOfLength( 10 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.aListOfLength.willReturn, when that method is called with the parameter set to a List that is not the stated length, will not return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.aListOfLength.willReturn
    * @case   when that method is called with the parameter set to something that is not a list
    * @result will not return the stated value
    */
    @isTest
    private static void whenWithParameterNamedAListOfLength_whenCallWithParamNotAList_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodUnderDouble' )
                .withParameterNamed( 'parameter1' ).aListOfLength( 10 )
                .willReturn( 'return' );

        Test.startTest();
            String returnFromDouble = classToDouble.methodUnderDouble( 'Thing', 2 );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.aListOfLength.willReturn, when that method is called with the parameter that is not a list, will not return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.aListOfLength.withElementAt.willReturn
    * @case   when that method is called with the parameter set to a List that is the stated length, and other criteria met
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterNamedAListOfLengthWithElementAt_whenAllMet_returnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameterNamed( 'parameter1' ).aListOfLength( 3 )
                    .withElementAt( 0 ).setTo( 1 )
                    .withElementAt( 1 ).setTo( 2 )
                    .withElementAt( 2 ).setTo( 3 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( new List<String>{ 'return' }, returnFromDouble, 'when.method.withParameterNamed.aListOfLength.withElementAt.willReturn, when that method is called with all criteria met, will return the stated value' );
    }

    /**
    * @method when.method.withParameterNamed.aListOfLength.withElementAt.willReturn
    * @case   when not all criteria met
    * @result will return the stated value
    */
    @isTest
    private static void whenWithParameterNamedAListOfLengthWithElementAt_whenNotAllMet_notReturnSetUpValue() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .when()
                .method( 'methodWithListOfObjects' )
                .withParameterNamed( 'parameter1' ).aListOfLength( 3 )
                    .withElementAt( 0 ).setTo( 1 )
                    .withElementAt( 1 ).setTo( 99 )
                    .withElementAt( 2 ).setTo( 3 )
                .willReturn( new List<String>{ 'return' } );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Integer>{ 1, 2, 3 } );
        Test.stopTest();

        System.assertEquals( null, returnFromDouble, 'when.method.withParameterNamed.aListOfLength.withElementAt.willReturn, when that method is called with not all criteria met, will not return the stated value' );
    }

    /**
    * @method when.method.withParameters.setTo.willReturn (named)
    * @case   when that method is called with different parameters
    * @result will return null
    */
    @isTest
    private static void whenWithParametersNamedSetToWillReturn_whenCallWithDiffParams_returnNull() {

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
    private static void whenMethodWillReturn_whenSetWithObjAndPassed_returnThatValue() {

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
    private static void whenMethodWillReturn_whenSetWithObjAndDiffInstPassed_returnNull() {

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
    private static void whenMethodSetToTheSameValueAsWillReturn_whenSetWithObjAndPassed_returnThatValue() {

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
    private static void whenMethodSetToTheSameValueAsWillReturn_whenSetWithObjAndDiffInstPassed_returnSetUpValue() {

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
    private static void whenMethodSetToTheSameValueAsWillReturn_whenSetWithObjAndDiffInstPassedWithDiffProps_returnNull() {

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
    private static void whenWithParameterNamedWillReturn_whenSetWithObjAndPassed_returnThatValue() {

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
    private static void whenWithParameterNamedWillReturn_whenSetWithObjAndDiffInstPassed_returnNull() {

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
    private static void whenWithParameterNamedSetToTheSameValueAsWillReturn_whenSetWithObjAndPassed_returnThatValue() {

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
    private static void whenWithParameterNamedSetToTheSameValueAsWillReturn_whenSetWithObjAndDiffInstPassed_returnSetUpValue() {

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
    private static void whenWithParameterNamedSetToTheSameValueAsWillReturn_whenSetWithObjAndDiffInstPassedWithDiffProps_returnNull() {

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
    private static void whenMethodWillReturn_whenIsSetWithSobjectAndPassed_returnSetUpValue() {

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
    private static void whenMethodWillReturn_whenIsSetWithSobjectAndDiffInstPassed_returnNull() {

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
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndPassed_returnSetUpValue() {

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
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDiffInstPassed_returnSetUpValue() {

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
    private static void whenMethodSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDiffInstPassedWithDiffValues_returnNull() {

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
    private static void whenWithParameterNamedWillReturn_whenIsSetWithSobjectAndPassed_returnSetUpValue() {

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
    private static void whenWithParameterNamedWillReturn_whenIsSetWithSobjectAndDiffInstPassed_returnNull() {

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
    private static void whenWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndPassed_returnSetUpValue() {

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
    private static void whenWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDiffInstPassed_returnSetUpValue() {

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
    private static void whenWithParameterNamedSetToTheSameValueAsWillReturn_whenIsSetWithSobjectAndDiffInstPassedWithDiffValues_returnNull() {

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
    private static void whenWithParameterWillReturnMultiple_whenCallWithParams_returnSetUpValues() {

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
    private static void whenWithParameterWillReturnMultiple_whenSameParamsUsed_alwaysReturnTheFirstMatch() {

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
    private static void whenWithParameterWillReturnMultiplePositionFirstThenNamed_whenSameParamsUsed_alwaysReturnTheFirstMatch() {

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
    private static void whenWithParameterWillReturnMultipleNamedFirstThenPosition_whenSameParamsUsed_alwaysReturnTheFirstMatch() {

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
    private static void whenWithParameterWillReturnMultiple_whenDiffMethodsDefined_returnSetUpValues() {

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
    private static void whenWithAnyParameterWillReturnMultiple_whenCallWithParams_returnTheFirstMatching() {

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
    private static void allowsMethodReturning_whenCalled_returnSetUpValue() {

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
    private static void allowsMethodReturningShortcut_whenCalled_returnSetUpValue() {

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
    private static void allowsMethodReturning_whenADiffMethodIsCalled_fail() {

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
    private static void allowsMethodReturning_whenCallWithDiffParams_fail() {

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
    private static void allowsMethodReturning_whenMultipleMethodsAreDefinedAndCalled_returnSetUpValues() {

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
    private static void allowsMethodReturning_whenMethodIsDefinedWithMultipleParams_returnTheFirstThatMatches() {

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
    private static void expectsNoCalls_whenAMethodIsCalled_fail() {

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
    private static void expectsNoCalls_whenAMethodIsNotCalled_passTheTest() {

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
    private static void expectsMethodReturning_whenCalledOnce_returnSetUpValue() {

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
    private static void expectsMethodReturningShortcut_whenCalledOnce_returnSetUpValue() {

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
    private static void expectsMethodReturning_whenADiffMethodIsCalled_fail() {

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
    private static void expectsMethodReturning_whenCallWithDiffParams_fail() {

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
    private static void expectsMethodReturning_whenExpectsObject_andPassed_pass() {

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
    private static void expectsMethodReturning_whenExpectsObject_andDiffInstPassed_fail() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsObject_andDiffInstPassed_pass() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsObject_andDiffInstPassedWithDiffProps_fail() {

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
    private static void expectsMethodReturning_whenExpectsSobject_andPassed_pass() {

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
    private static void expectsMethodReturning_whenExpectsSobject_andDiffInstPassed_fail() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsSobject_andDiffInstPassed_pass() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsSobject_andDiffInstPassedWithDiffValues_fail() {

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
    private static void expectsWithFieldsSetLikeReturning_whenExpectsSobject_andPassed_pass() {

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
    private static void expectsWithFieldsSetLikeReturning_whenDiffInstPassedWithSameProps_pass() {

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
    private static void expectsWithFieldsSetLikeReturning_whenDiffInstPassedWithExtraProps_pass() {

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
    private static void expectsWithFieldsSetLikeReturning_whenDiffInstPassedWithDiffProps_fail() {

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
    private static void expectsWithFieldsSetLikeReturning_whenDiffInstPassedWithFewerProps_fail() {

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
    private static void expectsWithFieldsSetLikeReturning_whenExpectsSobject_andNullIsPassed_fail() {

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
    private static void expectsWithFieldsSetLikeReturning_whenParameterPassedIsNotAnSobject_fail() {

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
    private static void expectsWithFieldsSetLikeReturning_whenExpectsIsSetWithNull_fail() {

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
    private static void expectsWithFieldsSetToReturning_whenSobjectPassedWithSameProps_pass() {

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
    private static void expectsWithParameterNamedWithFieldsSetToReturning_whenSobjectPassedWithSameProps_pass() {

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
    private static void expectsWithFieldsSetToReturning_whenSobjectPassedWithExtraProps_pass() {

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
    private static void expectsWithFieldsSetToReturning_whenSobjectWithDiffProps_fail() {

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
    private static void expectsWithFieldsSetToReturning_whenSobjectPassedWithFewerProps_fail() {

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
    private static void expectsWithFieldsSetToReturning_whenExpectsIsSetAndNullIsPassed_fail() {

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
    private static void expectsWithFieldsSetToReturning_whenExpectsIsSetWithNull_fail() {

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
    private static void expectsWithFieldsSetToReturning_whenExpectIsSetWithAnInvalidField_fail() {

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
    private static void expectsWithFieldsSetToReturning_whenParameterPassedIsNotAnSobject_fail() {

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
    private static void expectsWithAllElementsSetToReturning_whenAllElementsInTheParameterMatch_pass() {

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
    private static void expectsWithAllElementsSetToReturning_whenNotAllElementsInTheParameterMatch_fail() {

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
    private static void expectsWithAllElementsSetToReturning_whenTheParameterPassedIsNotAList_fail() {

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
    private static void expectsWithAnyElementSetToReturning_whenAnyElementsInTheParameterMatch_pass() {

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
    private static void expectsWithAnyElementSetToReturning_whenNoElementsInTheParameterMatch_fail() {

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
    private static void expectsWithAnyElementSetToReturning_whenTheParameterPassedIsNotAList_fail() {

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
    private static void expectsWithElementAtSetToReturning_whenElementInTheParameterMatches_pass() {

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
    private static void expectsWithElementAtSetToReturningMultipleTimes_whenElementInTheParameterMatches_pass() {

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
    private static void expectsWithElementAtSetToReturning_whenSpecifiedElementDoesNotMatch_fail() {

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
    private static void expectsWithElementAtSetToReturningMultipleTimes_whenSpecifiedElementDoesNotMatch_fail() {

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
    private static void expectsWithElementAtSetToReturning_whenSpecifiedElementDoesNotExist_fail() {

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
    private static void expectsWithElementAtSetToReturning_whenParameterIsNotAList_fail() {

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
    private static void expectsWithElementAtSetToReturning_whenParameterIsNull_fail() {

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
    * @method expects.method.withElementAt.set.returning
    * @case   when the list parameter passed has the element set to not null
    * @result will pass the test
    */
    @isTest
    private static void expectsWithElementAtSetReturning_whenElementInTheParameterIsSet_pass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 1 ).set()
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'set', 'set' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withElementAt.set.returning, when the list parameter contains the element set to not null, will return the specified value' );
    }

    /**
    * @method expects.method.withElementAt.set.returning
    * @case   when the element is null
    * @result will fail the test
    */
    @isTest
    private static void expectsWithElementAtSetReturning_whenElementIsNull_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 1 ).set();

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'set', null } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'Not Null', 'null',
                                                    'expects.method.withElementAt.set returning, when the element is null' );
    }

    /**
    * @method expects.method.withAllElements.set.returning
    * @case   when the list parameter passed has the element set to not null
    * @result will pass the test
    */
    @isTest
    private static void expectsWithAllElementsSetReturning_whenElementInTheParameterIsSet_pass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().set()
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'set', 'set' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withAllElements.set.returning, when the list parameter contains the elements set to not null, will return the specified value' );
    }

    /**
    * @method expects.method.withAllElements.set.returning
    * @case   when an element is null
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsSetReturning_whenElementIsNull_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().set();

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'set', null } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'Not Null', 'null',
                                                    'expects.method.withAllElements.set returning, when an element is null' );
    }

    /**
    * @method expects.method.withAnyElement.set.returning
    * @case   when the list parameter passed has an element set to not null
    * @result will pass the test
    */
    @isTest
    private static void expectsWithAnyElementSetReturning_whenElementInTheParameterIsSet_pass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().set()
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'set', null } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withAnyElement.set.returning, when the list parameter contains an elements set to not null, will return the specified value' );
    }

    /**
    * @method expects.method.withAnyElement.set.returning
    * @case   when all elements are null
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAnyElementSetReturning_whenAllElementsAreNull_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().set();

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ null, null } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'At least one element in the list should pass the described verification',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'Any value', '(null, null)',
                                                    'expects.method.withAnyElement.set returning, when the element is null' );
    }

    /**
    * @method expects.method.withAnyElement.set.returning
    * @case   when the list is empty
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAnyElementSetReturning_whenNoElementsExist_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().set();

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>() );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'At least one element in the list should pass the described verification',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'Any value', '()',
                                                    'expects.method.withAnyElement.set returning, when the element is null' );
    }

    /**
    * @method expects.method.withElementAt.containing.returning
    * @case   when the list parameter passed has the element set contain the value
    * @result will pass the test
    */
    @isTest
    private static void expectsWithElementAtContainingReturning_whenElementInTheParameterContains_pass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 1 ).containing( 'match' )
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'unimportant', 'match' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withElementAt.containing.returning, when the list parameter contains the element set to contain, will return the specified value' );
    }

    /**
    * @method expects.method.withAllElements.containing.returning
    * @case   when an element does not contain
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsContainingReturning_whenElementDoesNotContain_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().containing( 'match' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'a match', 'different', 'another match' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'match', 'different',
                                                    'expects.method.withAllElements.containing returning, when an element does not contain' );
    }

    /**
    * @method expects.method.withAllElements.containing.returning
    * @case   when an element is not a String
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsContainingReturning_whenElementIsNotAString_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().containing( 'match' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'a match', 12, 'another match' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'String', 'Integer',
                                                    'expects.method.withAllElements.containing returning, when an element is not a String' );
    }

    /**
    * @method expects.method.withAllElements.containing.returning
    * @case   when an element is null
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsContainingReturning_whenElementIsNull_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().containing( 'match' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'a match', null, 'another match' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'String', 'Unknown (null)',
                                                    'expects.method.withAllElements.containing returning, when an element is not a String' );
    }

    /**
    * @method expects.method.withAnyElement.containing.returning
    * @case   when no elements match
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAnyElementSetContaining_whenNoElementsMatch_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().containing( 'match' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'not the same', null } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'At least one element in the list should pass the described verification',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'String value containing "match"', '(not the same, null)',
                                                    'expects.method.withAnyElement.containing returning, when no elements match' );
    }

    /**
    * @method expects.method.withElementAt.matching.returning
    * @case   when the list parameter passed has the element set matches the value
    * @result will pass the test
    */
    @isTest
    private static void expectsWithElementAtMatchingReturning_whenElementInTheParameterMatches_pass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 1 ).matching( 'm.*h' )
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<String>{ 'unimportant', 'match' } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withElementAt.matching.returning, when the list parameter contains the element set to match, will return the specified value' );
    }

    /**
    * @method expects.method.withAllElements.matching.returning
    * @case   when an element does not match
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsMatchingReturning_whenAnElementDoesNotMatch_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().matching( 'm.*h' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'match', 'different', 'match' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'm.*h', 'different',
                                                    'expects.method.withAllElements.matching returning, when an element does not match' );
    }

    /**
    * @method expects.method.withAllElements.matching.returning
    * @case   when an element is not a String
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsMatchingReturning_whenElementIsNotAString_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().matching( 'm.*h' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'match', 12, 'match' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'String', 'Integer',
                                                    'expects.method.withAllElements.matching returning, when an element is not a String' );
    }

    /**
    * @method expects.method.withAllElements.matching.returning
    * @case   when an element is null
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsMatchingReturning_whenElementIsNull_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().matching( 'm.*h' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'match', null, 'match' } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'String', 'Unknown (null)',
                                                    'expects.method.withAllElements.matching returning, when an element is not a String' );
    }

    /**
    * @method expects.method.withAnyElement.matching.returning
    * @case   when no elements match
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAnyElementSetMatching_whenNoElementsMatch_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().matching( 'm.*h' );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'not the same', null } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'At least one element in the list should pass the described verification',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'String value matching "m.*h"', '(not the same, null)',
                                                    'expects.method.withAnyElement.matching returning, when no elements match' );
    }

    /**
    * @method expects.method.withElementAt.aListOfLength.returning
    * @case   when the list parameter passed has the element set matches the value
    * @result will pass the test
    */
    @isTest
    private static void expectsWithElementAtAListOfLengthReturning_whenElementInTheParameterMatches_pass() {

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        List<String> expectedReturn = new List<String>{ 'expectedReturn' };

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withElementAt( 1 ).aListOfLength( 2 )
                .returning( expectedReturn );

        Test.startTest();
            List<Object> returnFromDouble = classToDouble.methodWithListOfObjects( new List<Object>{ new List<Integer>{ 0, 1, 2 }, new List<Integer>{ 0, 1 } } );
        Test.stopTest();

        classToDoubleController.verify();

        System.assertEquals( expectedReturn, returnFromDouble, 'expects.method.withElementAt.aListOfLength.returning, when the list parameter contains the element set to match, will return the specified value' );
    }

    /**
    * @method expects.method.withAllElements.aListOfLength.returning
    * @case   when an element does not match
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsAListOfLengthReturning_whenAnElementDoesNotMatch_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().aListOfLength( 2 );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ new List<Integer>{ 0, 1 }, new List<Integer>{ 0 }, new List<Integer>{ 0, 1 } } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    '2', '1',
                                                    'expects.method.withAllElements.aListOfLength returning, when an element does not match' );
    }

    /**
    * @method expects.method.withAllElements.aListOfLength.returning
    * @case   when an element is not a List
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsAListOfLengthReturning_whenElementIsNotAList_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().aListOfLength( 2 );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ new List<Integer>{ 0, 1 }, 'no match', new List<Integer>{ 0, 1 } } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'List', 'String',
                                                    'expects.method.withAllElements.aListOfLength returning, when an element is not a List' );
    }

    /**
    * @method expects.method.withAllElements.aListOfLength.returning
    * @case   when an element is null
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAllElementsAListOfLengthReturning_whenElementIsNull_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAllElements().aListOfLength( 2 );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ new List<Integer>{ 0, 1 }, null, new List<Integer>{ 0, 1 }} );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'List element 1 does not match what was expected',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'List', 'Unknown (null)',
                                                    'expects.method.withAllElements.aListOfLength returning, when an element is not a List' );
    }

    /**
    * @method expects.method.withAnyElement.aListOfLength.returning
    * @case   when no elements match
    * @result will fail the test
    */
    @isTest
    private static void expectsWithAnyElementAListOfLength_whenNoElementsMatch_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameter().withAnyElement().aListOfLength( 2 );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'not the same', null } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterInPositionAssertion( assertsDoubleController,
                                                    'At least one element in the list should pass the described verification',
                                                    CLASS_TO_DOUBLE + '.methodWithListOfObjects', 0,
                                                    'List of length 2', '(not the same, null)',
                                                    'expects.method.withAnyElement.aListOfLength returning, when no elements match' );
    }

    /**
    * @method expects.method.withParameterNamed.withAnyElement.aListOfLength.returning
    * @case   when no elements match
    * @result will fail the test
    */
    @isTest
    private static void expectsWithNamedAnyElementAListOfLength_whenNoElementsMatch_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
        classToDoubleController.setAsserts( assertsDouble );
        AmossTest_ClassToDouble classToDouble = (AmossTest_ClassToDouble)classToDoubleController.getDouble();

        classToDoubleController
            .expects()
                .method( 'methodWithListOfObjects' )
                .withParameterNamed( 'parameter1' ).withAnyElement().aListOfLength( 2 );

        Test.startTest();
            try {
                classToDouble.methodWithListOfObjects( new List<Object>{ 'not the same', null } );
            } catch( TestException e ) {}
        Test.stopTest();

        checkForWrongParameterNamedAssertion( assertsDoubleController,
                                                'At least one element in the list should pass the described verification',
                                                CLASS_TO_DOUBLE + '.methodWithListOfObjects', 'parameter1',
                                                'List of length 2', '(not the same, null)',
                                                'expects.method.withParmeterNamed.withAnyElement.aListOfLength returning, when no elements match' );
    }

    /**
    * @method expects.method.verifiedBy.returning
    * @case   when the verifier does not throw an exception
    * @result will pass the test
    */
    @isTest
    private static void expectsMethodVerifiedByReturning_whenTheVerifierDoesNotThrowAnException_pass() {

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
    private static void expectsWithParameterNamedVerifiedByReturning_whenTheVerifierDoesNotThrowAnException_pass() {

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
    private static void expectsMethodVerifiedByReturning_whenTheVerifierThrowsAnAssertException_fail() {

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
    private static void whenMethodVerifiedByReturning_whenTheVerifierDoesNotThrowAnException_matchAndReturnTheValue() {

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
    private static void whenMethodVerifiedByReturning_whenTheVerifierThrowsAnException_notMatchAndReturnTheValue() {

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
    private static void expectsMethodReturning_whenExpectsIsSetWithSobjectWithNamedSyntaxAndDiffInstPassed_fail() {

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
    private static void expectsMethodReturning_whenExpectsSobject_andDiffInstPassedWithDiffProps_fail() {

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
    private static void expectsMethodReturning_whenExpectList_andSameInstanceIsPassed_pass() {

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
    private static void expectsMethodReturning_whenExpectList_andSomethingNotAList_fail() {

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
    private static void expectsMethodReturning_whenExpectList_andADiffInstContainingSameObjects_fail() {

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
    private static void expectsMethodReturning_whenExpectList_andADiffInstContainingDiffObjectsWithTheSameValues() {

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
    private static void expectsMethodReturning_whenExpectList_andADiffInstContainingDiffObjectsWithDiffValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectList_andSameInstanceIsPassed_pass() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectList_andADiffInstContainingSameObjects() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectList_andADiffInstContainingDiffObjectsWithTheSameValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectList_andADiffInstContainingDiffObjectsWithDiffValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectList_andADiffInstsOfDiffTypesContainingDiffObjectsWithTheSameValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectList_andADiffInstOfDiffTypesContainingDiffObjectsWithTheSameValues_2() {

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
    private static void expectsMethodReturning_whenExpectMap_andSameInstanceIsPassed_pass() {

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
    private static void expectsMethodReturning_whenExpectMap_andADiffInstContainingSameObjects_fail() {

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
    private static void expectsMethodReturning_whenExpectMap_andADiffInstContainingDiffObjectsWithTheSameValues() {

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
    private static void expectsMethodReturning_whenExpectMap_andADiffInstContainingDiffObjectsWithDiffValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectMap_andADiffInstContainingSameObjects() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectMap_andADiffInstContainingDiffObjectsWithTheSameValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectMap_andADiffInstContainingDiffObjectsWithDiffValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectMap_andADiffInstContainingDiffObjectsWithDiffKeys() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectMap_andADiffInstsOfDiffTypesContainingDiffObjectsWithTheSameValues() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectMap_andADiffInstOfDiffTypesContainingDiffObjectsWithTheSameValues_2() {

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
    private static void expectsMethodReturning_whenExpectMapById_andSameInstanceIsPassed_pass() {

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
    private static void expectsMethodReturning_whenExpectMapByDate_andSameInstanceIsPassed_pass() {

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
    private static void expectsMethodReturning_whenExpectSetWithASet_andSameInstanceIsPassed_pass() {

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
    private static void expectsMethodReturning_whenExpectSetWithASet_andDiffInstWithSameValuesIsPassed_fail() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectSetWithASet_andDiffInstWithSameValuesIsPassed_pass() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectSetWithASet_andDiffInstWithSameValuesIsPassed_fail() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsIsSetWithSobjectWithNamedSyntaxAndDiffInstPassed_pass() {

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
    private static void expectsMethodSetToTheSameValueAsReturning_whenExpectsSobject_andDiffInstPassedWithDiffProps_fail() {

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
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithTheStatedParams_pass() {

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
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithDiffParams_fail() {

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
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithMoreParams_fail() {

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
    private static void expectsMethodReturning_whenAnOverloadedMethodIsCalledWithFewerParams_fail() {

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
    private static void expectsMethodReturning_whenAnOverloadedMethodIsSpecifiedWithoutAllParametersInPositional_matchAnyApppriateVersion() {

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
    private static void expectsMethodReturning_whenAnOverloadedMethodIsSpecifiedWithoutAllParametersInNamed_matchAnyApppriateVersion() {

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
    private static void expectsMethodReturning_whenUsingNamedParametersAndTheMethodIsCalledWithDiffParams_fail() {

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
    private static void expectsMethodReturning_whenUsingNamedParametersAndTheMethodIsCalledWithFewerParams_fail() {

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
    private static void expectsMethodReturning_whenUsingNamedParametersAndTheMethodIsCalledWithDifflyNamedParams_fail() {

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
    private static void expectsMethodReturning_whenMultipleMethodsAreDefinedAndCalledInOrder_returnSetUpValues() {

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
    private static void expectsMethodReturning_whenMethodIsDefinedAndCalledInOrder_returnTheResultsInOrder() {

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
    private static void expectsMethodReturning_usingNamed_whenMethodIsDefinedAndCalledInOrder_returnTheResultsInOrder() {

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
    private static void expectsMethodReturning_usingNamedSomeNotSpecified_whenMethodIsDefinedAndCalledInOrder_returnTheResultsInOrder() {

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
    private static void expectsMethodReturning_whenMethodIsDefinedWithAnyParamsAndCalledInOrder_returnTheResultsInOrder() {

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
    private static void callCount_whenGivenAMethodCallThatHappened_returnTheNumberOfCalls() {

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
    private static void callCount_whenGivenAMethodCallThatDidNotHappen_returnZero() {

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
    private static void callOfParams_whenGivenACallThatHappened_returnTheParamsOfThatCall() {

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
    private static void callOfParams_whenGivenACallOfMethodWithNoReturnThatHappened_returnTheParamsOfThatCall() {

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
    private static void callOfParams_whenGivenACallThatHappenedAmongstMany_returnTheParamsOfThatCall() {

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
    private static void callOfParams_whenGivenAMinusOneCallNumber_returnTheParamsOfTheLastCall() {

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
    private static void latestCallOfParams_whenTheMethodHasBeenCalled_returnTheParamsOfTheLastCall() {

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
    private static void callOfParams_whenGivenANegativeCallNumber_returnTheParamsOfTheCallThatManyFromTheEnd() {

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
    private static void callOfParams_whenGivenACallThatHappenedWithAnSobject_returnTheParamsOfThatCall() {

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
    private static void callOfParams_whenGivenACallThatHappenedWithNoParams_returnAnEmptyList() {

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
    private static void callOfParams_whenGivenACallNumberThatDidNotHappen_throwAnException() {

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
    private static void callOfParams_whenGivenANegativeCallNumberThatDidNotHappen_throwAnException() {

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
    private static void callOfParams_whenGivenAMethodThatWasNeverCalled_throwAnException() {

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
    private static void callOfParametersByName_whenGivenAMethodThatWasNeverCalled_throwAnException() {

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
    private static void callOfParameter_whenGivenACallThatHappened_returnTheStatedParameterOfThatCall() {

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
    private static void callOfParameterString_whenGivenACallThatHappened_returnTheStatedParameterOfThatCall() {

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
    private static void callOfParameter_whenGivenACallThatHappenedAmongstMany_returnTheParameterOfThatCall() {

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
    private static void callOfParameterString_whenGivenACallThatHappenedAmongstMany_returnTheParameterOfThatCall() {

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
    private static void callOfParameter_whenGivenACallNumberThatDidNotHappen_throwAnException() {

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
    private static void callOfParameterString_whenGivenACallNumberThatDidNotHappen_throwAnException() {

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
    private static void callOfParameter_whenGivenAMethodThatWasNeverCalled_throwAnException() {

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
    private static void callOfParameterString_whenGivenAMethodThatWasNeverCalled_throwAnException() {

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
    private static void callOfParameter_whenGivenAParameterNumberThatIsOutOfRange_throwAnException() {

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
    private static void callOfParameter_whenGivenAParameterNumberThatIsNegative_throwAnException() {

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
    private static void callOfParameter_whenGivenAParameterNameThatDoesNotExist_throwAnException() {

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
    private static void callOfParameter_whenGivenAParameterForAMethodThatHasNoParams_throwAnException() {

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
    private static void callOfParameterString_whenGivenAParameterForAMethodThatHasNoParams_throwAnException() {

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
    private static void getCallOfParams_whenGivenACallThatHappened_returnTheParamsOfThatCall() {

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
    private static void getCallOfParams_whenGivenACallThatHappenedWithNoParams_returnAnEmptyParametersList() {

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
    private static void getCallOfParametersByName_whenGivenACallThatHappened_returnTheParamsOfThatCall() {

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
    private static void getCallOfParametersByName_whenGivenACallThatHappenedWithNoParams_returnAnEmptyParametersList() {

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
    private static void getLatestCallOfParams_whenGivenACallThatHappened_returnTheParamsOfThatCall() {

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
    private static void parameter_whenAParameterIsAListOfObjects_returnTheParameter() {

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
    private static void parameterString_whenAParameterIsAListOfObjects_returnTheParameter() {

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
    private static void parameter_whenAParameterIsASetOfObjects_returnTheParameter() {

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
    private static void parameterString_whenAParameterIsASetOfObjects_returnTheParameter() {

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
    private static void parameter_whenAParameterIsAMapOfObjects_returnTheParameter() {

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
    private static void parameterString_whenAParameterIsAMapOfObjects_returnTheParameter() {

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
    private static void expectsMethod_whenCalled_pass() {

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
    private static void expectsMethod_whenCalledMoreThanOnce_fail() {

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
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when the method is called more times than expected, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when the method is called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethod_whenTheMethodIsNotCalledButNeitherIsVerify_pass() {

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
    private static void expectsMethod_whenTheMethodIsNotCalledAndVerifyIs_fail() {

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
    private static void expectsMethodMultipleTimes_whenTheMethodsAreNotCalledAndVerifyIs_fail() {

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
    private static void expectsWithParameter_whenTheMethodIsNotCalledAndVerifyIs_failDescribingTheParams() {

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
    private static void expectsWithParameter_whenTheMethodWithAnyParamDefinedIsNotCalledAndVerifyIs_failDescribingTheParams() {

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
    private static void expectsWithParameterSetToTheSameValueAs_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterSetToTheSameValueAsWithObject_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterWithFieldsSetTo_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterWithFieldsSetLike_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterWithAllElements_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterWithAnyElement_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterWithElementAt_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamed_whenTheMethodIsNotCalledAndVerifyIs_failDescribingTheParams() {

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
    private static void expectsWithParameterSetToSet_whenTheMethodIsNotCalledAndVerifyIs_failDescribingTheParams() {

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
    private static void expectsWithParameterSetToList_whenTheMethodIsNotCalledAndVerifyIs_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedSetToTheSameValueAs_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedSetToTheSameValueAsWithObject_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedWithFieldsSetTo_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedWithFieldsSetLike_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedWithAllElements_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterWithElementsCombination_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedWithElementsCombination_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedWithAnyElement_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsWithParameterNamedWithElementAt_whenTheMethodIsNotCalled_failDescribingTheParams() {

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
    private static void expectsMethodReturning_whenCalled_passAndWillReturnTheStatedResult() {

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
    private static void expectsMethodReturning_whenCalledMoreThanOnce_fail() {

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
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsMethodReturning_whenTheMethodIsNotCalledButNeitherIsVerify_pass() {

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
    private static void expectsMethodReturning_whenTheMethodIsNotCalledAndVerifyIs_fail() {

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
    private static void expectsWithAnyParametersReturning_whenCalled_passAndWillReturnTheStatedResult() {

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
    private static void expectsWithAnyParametersReturning_whenCalledMoreThanOnce_fail() {

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
        Amoss_Asserts.assertContains( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method.withAnyParameters.returning, when the method is not called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  expects.method.withAnyParameters.returning
    * @case    when the method is not called, but neither is verify
    * @result  will not fail
    */
    @isTest
    private static void expectsWithAnyParametersReturning_whenTheMethodIsNotCalledButNeitherIsVerify_pass() {

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
    private static void expectsWithAnyParametersReturning_whenTheMethodIsNotCalledAndVerifyIs_fail() {

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
    private static void expectsMethodVerifiedByReturning_whenTheMethodIsNotCalledAndVerifyIs_failAndUseToString() {

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
    private static void expectsWithParameterNamedVerifiedByReturning_whenTheMethodIsNotCalledAndVerifyIs_failAndUseToString() {

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
    private static void expectsWithParameterVerifiedNoVerifierVerify_alwaysFail() {

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
    private static void expectsWithParameterAndThenParameterReturning_whenCalled_passAndWillReturnTheStatedResult() {

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
    private static void expectsWithParameterAndThenParameterReturning_whenCallWithNonMatchingParams_fail() {

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
    private static void allowsAnyCall_whenGivenFalseAndNoMethodsAreDefinedAndAMethodIsCalled_fail() {

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
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'allowsAnyCall, when given false, no methods are defined and a method is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall
    * @case    when given true, no methods are defined, and a method is called
    * @result  will return null
    */
    @isTest
    private static void allowsAnyCall_whenGivenTrueAndAndNoMethodsAreDefinedAndAMethodIsCalled_returnNull() {

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
    private static void allowsAnyCall_true_expectsMethodReturning_whenCalledMoreThanOnce_pass() {

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
    private static void allowsAnyCall_false_expectsMethodReturning_whenCalledMoreThanOnce_fail() {

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
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times than expected, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning
    * @case    when a different method is called
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_expectsMethodReturning_whenADiffMethodIsCalled_pass() {

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
    private static void allowsAnyCallhortcut_true_expectsMethodReturning_whenADiffMethodIsCalled_pass() {

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
    private static void allowsAnyCall_false_expectsMethodReturning_whenADiffMethodIsCalled_fail() {

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
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowsAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowsAnyCall is called with false, and a method that is not expected is called, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning
    * @case    when the method is called again with different parameters
    * @result  will not fail the test
    */
    @isTest
    private static void allowsAnyCall_true_expectsMethodReturning_whenCallWithDiffParams_pass() {

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
    private static void allowsAnyCall_false_expectsMethodReturning_whenCallWithDiffParams_fail() {

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
        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with false' );
        Amoss_Asserts.assertContains( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'expects.method, when allowsAnyCall is called with false, and the method is called more times with different parameters, will fail by calling assert with an assertion message that clearly describes the issue' );
    }

    /**
    * @method  allowsAnyCall.true.expects.method.returning.verify
    * @case    when the method is called only with different parameters
    * @result  will fail the test
    */
    @isTest
    private static void allowsAnyCall_true_expectsMethodReturning_whenCalledOnlyWithDiffParams_fail() {

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
    private static void allowsAnyCall_false_expectsMethodReturning_whenTheMethodIsOnlyCalledWithDiffParams_fail() {

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
    private static void allowsAnyCall_true_whenMethodWillReturn_whenADiffMethodIsCalled_pass() {

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
    private static void allowsAnyCall_false_whenMethodWillReturn_whenADiffMethodIsCalled_fail() {

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
    private static void allowsAnyCall_true_whenMethodWillReturn_whenCallWithDiffParams_pass() {

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
    private static void allowsAnyCall_false_whenMethodWillReturn_whenCallWithDiffParams_fail() {

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
    private static void allowsAnyCall_true_allowsMethodReturning_whenADiffMethodIsCalled_pass() {

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
    private static void allowsAnyCall_false_allowsMethodReturning_whenADiffMethodIsCalled_fail() {

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
    private static void allowsAnyCall_true_allowsMethodReturning_whenCallWithDiffParams_pass() {

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
    private static void allowsAnyCall_false_allowsMethodReturning_whenCallWithDiffParams_fail() {

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
    private static void expectsNoCalls_whenAlreadyConfiguredWithExpects_throwAnException() {

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
    private static void expectsNoCalls_whenAlreadyConfiguredWithAllows_throwAnException() {

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
    private static void expectsNoCalls_whenAlreadyConfiguredWithWhen_throwAnException() {

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
    private static void expectsNoCalls_whenAlreadyConfiguredWithAllowsAnyCall_throwAnException() {

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
    private static void expects_whenAlreadyConfiguredAsExpectsNoCalls_throwAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls();

            classToDoubleController
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
    private static void allows_whenAlreadyConfiguredAsExpectsNoCalls_throwAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls();

            classToDoubleController
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
    private static void when_whenAlreadyConfiguredAsExpectsNoCalls_throwAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls();

            classToDoubleController
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
    private static void allowsAnyCall_whenAlreadyConfiguredAsExpectsNoCalls_throwAnException() {

        Boolean exceptionThrown = false;
        String  exceptionMessage;
        try {

            Amoss_Instance classToDoubleController = new Amoss_Instance( AmossTest_ClassToDouble.class );
            classToDoubleController
                .expectsNoCalls();

            classToDoubleController
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
    private static void getDouble_whenCalledMultipleTimes_returnTheSameInstance() {

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
    private static void generateDouble_returnADiffInstToGetDouble() {

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
    private static void generateDouble_onAnIsFluent_returnsDiffInstsFromMethods() {

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
    private static void generateDouble_whenReturnsGenerateDouble_returnSetUpValue() {

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
    private static void getDoubleGenerateDoubleGetCount_whenMethodsCalledOnEachInstanceAsSpecified_consolidateThem() {

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
    private static void expectsGetDoubleGenerateDoubleVerify_whenMethodsCalledOnEachInstanceAsSpecified_consolidateThemAndNotFail() {

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
    private static void createCloneWhenCountOf_whenTheMethodsAreCalledOnTheDiffInsts_RouteToTheDiffControllers() {

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
    private static void createCloneExpectsVerify_whenMethodsCalledAsExpected_pass() {

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
    private static void createClone_whenAdditionalConfigIsAdded_notAffectTheOther() {

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
    private static void createClone_whenAdditionalConfigIsAdded_notAffectTheOther2() {

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
    private static void generateDouble_isFluentWhenReturnsGenerateDouble_returnSetUpValue() {

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
    private static void getDouble_whenGivenAnSobjectToCreateATestDoubleFor_throwAnException() {

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
    private static void getDouble_whenGivenAnInnerClassToCreateATestDoubleFor_throwAnException() {

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
    private static void getDouble_whenGivenASystemTypeToCreateATestDoubleFor_throwAnException() {

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
    private static void getDouble_whenGivenAClassWithNoPublicConstructorToCreateATestDoubleFor_throwAnException() {

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

    //
    //
    // HttpCalloutMock tests
    //
    //
    /**
    * @method isACalloutMock
    * @case   when called
    * @result will generate an HttpCalloutMock and register it
    */
    @isTest
    private static void isACalloutMock_willGenerateAnHttpCalloutMockAndRegisterIt() {

        new Amoss_Instance()
            .isACalloutMock();

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assert( true, 'isACalloutMock will generate an HttpCalloutMock and register it, meaning HTTP requests can be made in the test without exceptions' );
    }

    /**
    * @method isACalloutMock.respondsWith.statusCode
    * @case   when called
    * @result will set the status code that is returned
    */
    @isTest
    private static void isACalloutMockRespondsWithStatusCode_willSetTheStatusCodeThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .respondsWith()
                    .statusCode( 404 );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 404, response.getStatusCode(), 'isACalloutMock.respondsWith.statusCode, will set the status code that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith.status
    * @case   when called
    * @result will set the status that is returned
    */
    @isTest
    private static void isACalloutMockRespondsWithStatus_willSetTheStatusThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .respondsWith()
                    .status( 'Complete' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'Complete', response.getStatus(), 'isACalloutMock.respondsWith.status, will set the status that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith.body (string)
    * @case   when called
    * @result will set the body that is returned
    */
    @isTest
    private static void isACalloutMockRespondsWithBodyString_willSetTheBodyThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .respondsWith()
                    .body( 'The body' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'The body', response.getBody(), 'isACalloutMock.respondsWith.body( String ), will set the body that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith.body (Object)
    * @case   when called
    * @result will serialise the object and set the body that is returned
    */
    @isTest
    private static void isACalloutMockRespondsWithBodyObject_willSerialiseAndSetTheBodyThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .respondsWith()
                    .body( new Map<String,Object>{ 'parameter' => 'value' } );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( '{"parameter":"value"}', response.getBody(), 'isACalloutMock.respondsWith.body( Object ), will serialise the object and set the body that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith.body (blob)
    * @case   when called
    * @result will set the body that is returned
    */
    @isTest
    private static void isACalloutMockRespondsWithBodyBlob_willSetTheBodyThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .respondsWith()
                    .body( Blob.valueOf( 'The body' ) );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'The body', response.getBody(), 'isACalloutMock.respondsWith.body( Blob ), will set the body that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith.header.setTo
    * @case   when called
    * @result will set the headers that are returned
    */
    @isTest
    private static void isACalloutMockRespondsWithHeaderSetTo_willSetTheHeadersThatAreReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .respondsWith()
                    .header( 'one' ).setTo( 'oneValue' )
                    .header( 'two' ).setTo( 'twoValue' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'oneValue', response.getHeader( 'one' ), 'isACalloutMock.respondsWith.header.setTo, will set the headers that are returned on the generated HttpResponse' );
        System.assertEquals( 'twoValue', response.getHeader( 'two' ), 'isACalloutMock.respondsWith.header.setTo, will set the headers that are returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith
    * @case   when multiple properties are set
    * @result will set all of them on the response that is returned
    */
    @isTest
    private static void isACalloutMockRespondsWith_whenMultipleProperties_willSetThemAll() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .respondsWith()
                    .statusCode( 200 )
                    .status( 'Complete' )
                    .body( 'A body' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 200       , response.getStatusCode(), 'isACalloutMock.respondsWith, when multiple properties are set, will set them all on the generated HttpResponse' );
        System.assertEquals( 'Complete', response.getStatus()    , 'isACalloutMock.respondsWith, when multiple properties are set, will set them all on the generated HttpResponse' );
        System.assertEquals( 'A body'  , response.getBody()      , 'isACalloutMock.respondsWith, when multiple properties are set, will set them all on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.byDefault.respondsWith.status
    * @case   when called and doesn't match anything else
    * @result will set the status that is returned
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWithStatusCode_willSetTheStatusCodeThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .statusCode( 200 )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 404 );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.byDefault.respondsWith.statusCode, and does not match a defined call, will set the status that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.byDefault.respondsWith.status
    * @case   when called and doesn't match anything else
    * @result will set the status that is returned
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWithStatus_willSetTheStatusThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .status( 'Complete' )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                    .status( 'Not Found' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'Complete', response.getStatus(), 'isACalloutMock.byDefault.respondsWith.status, and does not match a defined call, will set the status that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.byDefault.respondsWith.body (string)
    * @case   when called and doesn't match anything else
    * @result will set the body that is returned
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWithBodyString_willSetTheBodyThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .body( 'The body' )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                    .body( 'The non default body' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'The body', response.getBody(), 'isACalloutMock.byDefault.respondsWith.body( String ), and does not match a defined call, will set the body that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.byDefault.respondsWith.body (Object)
    * @case   when called and doesn't match anything else
    * @result will serialise the object and set the body that is returned
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWithBodyObject_willSerialiseAndSetTheBodyThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .body( new Map<String,Object>{ 'parameter' => 'value' } )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                    .body( new Map<String,Object>{ 'parameter' => 'non default value' } );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( '{"parameter":"value"}', response.getBody(), 'isACalloutMock.byDefault.respondsWith.body( Object ), and does not match a defined call, will serialise the object and set the body that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.byDefault.respondsWith.body (blob)
    * @case   when called and doesn't match anything else
    * @result will set the body that is returned
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWithBodyBlob_willSetTheBodyThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .body( Blob.valueOf( 'The body' ) )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                    .body( Blob.valueOf( 'The non default body' ) );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'The body', response.getBody(), 'isACalloutMock.byDefault.respondsWith.body( Blob ), and does not match a defined call, will set the body that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.byDefault.respondsWith.header.setTo
    * @case   when called and doesn't match anything else
    * @result will set the header that is returned
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWithHeaderSetTo_willSetTheHeaderThatIsReturned() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .header( 'Authorised' ).setTo( 'default' )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                .header( 'Authorised' ).setTo( 'non-default' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'default', response.getHeader( 'Authorised' ), 'isACalloutMock.byDefault.respondsWith.header.setTo, and does not match a defined call, will set the header that is returned on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith
    * @case   when multiple properties are set, is called and doesn't match anything else
    * @result will set all of them on the response that is returned
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWith_whenMultipleProperties_willSetThemAll() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .statusCode( 200 )
                    .status( 'Complete' )
                    .body( 'A body' )
                    .header( 'Authorised' ).setTo( 'true' )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 404 )
                    .status( 'Not Found' )
                    .body( 'No body' )
                    .header( 'Authorised' ).setTo( 'false' );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 200       , response.getStatusCode()          , 'isACalloutMock.byDefault.respondsWith, when multiple properties are set, and does not match a defined call, will set them all on the generated HttpResponse' );
        System.assertEquals( 'Complete', response.getStatus()              , 'isACalloutMock.byDefault.respondsWith, when multiple properties are set, and does not match a defined call, will set them all on the generated HttpResponse' );
        System.assertEquals( 'A body'  , response.getBody()                , 'isACalloutMock.byDefault.respondsWith, when multiple properties are set, and does not match a defined call, will set them all on the generated HttpResponse' );
        System.assertEquals( 'true'    , response.getHeader( 'Authorised' ), 'isACalloutMock.byDefault.respondsWith, when multiple properties are set, and does not match a defined call, will set them all on the generated HttpResponse' );
    }

    /**
    * @method isACalloutMock.respondsWith
    * @case   when multiple properties are set, is called and matches a definition
    * @result will return the defined one instead
    */
    @isTest
    private static void isACalloutMockByDefaultRespondsWith_whenCallMatchesADefined_willReturnTheDefined() {

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .statusCode( 200 )
                    .status( 'Complete' )
                    .body( 'A body' )
                    .header( 'Authorised' ).setTo( 'true' )
            .also().when()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 404 )
                    .status( 'Not Found' )
                    .body( 'No body' )
                    .header( 'Authorised' ).setTo( 'false' );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'GET' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 404        , response.getStatusCode()          , 'isACalloutMock.byDefault.respondsWith, when the call matches a defined one, will return the defined response instead' );
        System.assertEquals( 'Not Found', response.getStatus()              , 'isACalloutMock.byDefault.respondsWith, when the call matches a defined one, will return the defined response instead' );
        System.assertEquals( 'No body'  , response.getBody()                , 'isACalloutMock.byDefault.respondsWith, when the call matches a defined one, will return the defined response instead' );
        System.assertEquals( 'false'    , response.getHeader( 'Authorised' ), 'isACalloutMock.byDefault.respondsWith, when the call matches a defined one, will return the defined response instead' );
    }

    /**
    * @method isACalloutMock.handledBy (Amoss_MethodHandler)
    * @case   when call is made
    * @result will be handled by the object specified
    */
    @isTest
    private static void isACalloutMockHandledByMethodHandler_whenHandledByAndCallIsMade_willBeHandledByObject() {

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody( 'FromTheHandler' );

        Amoss_Instance methodHandlerController = new Amoss_Instance( Amoss_MethodHandler.class );
        methodHandlerController
            .expects()
                .method( 'handleMethodCall' )
                .returning( mockResponse );

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .handledBy( (Amoss_MethodHandler)methodHandlerController.generateDouble() );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'FromTheHandler', response.getBody(), 'isACalloutMock.handledBy (Amoss_MethodHandler), when a call is made, will be handled by the object specified' );
    }

    /**
    * @method isACalloutMock.handledBy (StubProvider)
    * @case   when call is made
    * @result will be handled by the object specified
    */
    @isTest
    private static void isACalloutMockHandledByStubProvider_whenHandledByAndCallIsMade_willBeHandledByObject() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .handledBy( new MockHttpMethodHandlerUsingStubProvider() );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'FromTheHandler', response.getBody(), 'isACalloutMock.handledBy (StubProvider), when a call is made, will be handled by the object specified' );
    }

    class MockHttpMethodHandlerUsingStubProvider implements StubProvider {
        public Object handleMethodCall( Object       mockedObject,
                                        String       mockedMethod,
                                        Type         returnType,
                                        List<Type>   parameterTypes,
                                        List<String> parameterNames,
                                        List<Object> parameters ) {
            HttpResponse response = new HttpResponse();
            response.setBody( 'FromTheHandler' );
            return response;
        }
    }

    /**
    * @method isACalloutMock.handledBy (HttpCalloutMock)
    * @case   when call is made
    * @result will be handled by the object specified
    */
    @isTest
    private static void isACalloutMockHandledByHttpCalloutMock_whenHandledByAndCallIsMade_willBeHandledByObject() {

        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setBody( 'FromTheHandler' );

        Amoss_Instance methodHandlerController = new Amoss_Instance( Amoss_HttpCalloutMock.class );
        methodHandlerController
            .expects()
                .method( 'respond' )
                .returning( mockResponse );

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .handledBy( (HttpCalloutMock)methodHandlerController.generateDouble() );

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 'FromTheHandler', response.getBody(), 'isACalloutMock.handledBy (HttpCalloutMock), when a call is made, will be handled by the object specified' );
    }

    /**
    * @method isACalloutMock.throws
    * @case   when called
    * @result will throw the stated exception
    */
    @isTest
    private static void isACalloutMockThrows_whenCalled_willThrow() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .throws( new CalloutException( 'An Exception' ) );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                HttpResponse response  = new Http().send( new HttpRequest() );
            } catch( CalloutException e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'isACalloutMock.throws, when called, will throw the stated exception' );
        System.assertEquals( 'An Exception', exceptionMessage, 'isACalloutMock.throws, when called, will throw the stated exception' );
    }

    /**
    * @method isACalloutMock.throwing
    * @case   when called
    * @result will throw the stated exception
    */
    @isTest
    private static void isACalloutMockThrowing_whenCalled_willThrow() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .throwing( new CalloutException( 'An Exception' ) );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                HttpResponse response  = new Http().send( new HttpRequest() );
            } catch( CalloutException e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'isACalloutMock.throwing, when called, will throw the stated exception' );
        System.assertEquals( 'An Exception', exceptionMessage, 'isACalloutMock.throwing, when called, will throw the stated exception' );
    }

    /**
    * @method isACalloutMock.willThrow
    * @case   when called
    * @result will throw the stated exception
    */
    @isTest
    private static void isACalloutMockWillThrow_whenCalled_willThrow() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .willThrow( new CalloutException( 'An Exception' ) );

        Boolean exceptionThrown = false;
        String  exceptionMessage;

        Test.startTest();
            try {
                HttpResponse response  = new Http().send( new HttpRequest() );
            } catch( CalloutException e ) {
                exceptionThrown = true;
                exceptionMessage = e.getMessage();
            }
        Test.stopTest();

        System.assertEquals( true, exceptionThrown, 'isACalloutMock.willThrow, when called, will throw the stated exception' );
        System.assertEquals( 'An Exception', exceptionMessage, 'isACalloutMock.willThrow, when called, will throw the stated exception' );
    }

    /**
    * @method isACalloutMock
    * @case   when no calls specified and a call is made
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMock_whenNoCallsSpecifiedAndCallMade_returnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock();

        Test.startTest();
            HttpResponse response  = new Http().send( new HttpRequest() );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock, when no calls specified and call made, will return an empty response' );
    }

    /**
    * @method allowsAnyCallFalse.isACalloutMock
    * @case   when no calls specified and a call is made
    * @result will fail the test
    */
    @isTest
    private static void allowsAnyCallFalseIsACalloutMock_whenNoCallsSpecifiedAndCallMade_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();

        new Amoss_Instance()
            .setAsserts( (Amoss_Asserts)assertsDoubleController.getDouble() )
            .allowsAnyCall( false )
            .isACalloutMock();

        Test.startTest();
            try {
                HttpResponse response  = new Http().send( new HttpRequest() );
            } catch ( TestException e ) {}
        Test.stopTest();

        String exceptionMessage = (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 );

        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'allowsAnyCallFalse.isACalloutMock, when no calls specified and a call is made, will fail the test' );
        Amoss_Asserts.assertContains( HTTP_CALLOUT_MOCK_UNEXPECTED_EXCEPTION_TEXT, exceptionMessage,  'allowsAnyCallFalse.isACalloutMock, when no calls specified and a call is made, will fail the test, with a message that explains the issue' );
    }

    /**
    * @method isACalloutMock.allowsAnyCallFalse
    * @case   when no calls specified and a call is made
    * @result will fail the test
    */
    @isTest
    private static void isACalloutMockAllowsAnyCallFalse_whenNoCallsSpecifiedAndCallMade_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();

        new Amoss_Instance()
            .setAsserts( (Amoss_Asserts)assertsDoubleController.getDouble() )
            .isACalloutMock()
            .allowsAnyCall( false );

        Test.startTest();
            try {
                HttpResponse response  = new Http().send( new HttpRequest() );
            } catch ( TestException e ) {}
        Test.stopTest();

        String exceptionMessage = (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 );

        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'isACalloutMock.allowsAnyCallFalse, when no calls specified and a call is made, will fail the test' );
        Amoss_Asserts.assertContains( HTTP_CALLOUT_MOCK_UNEXPECTED_EXCEPTION_TEXT, exceptionMessage,  'isACalloutMock.allowsAnyCallFalse, when no calls specified and a call is made, will fail the test, with a message that explains the issue' );
    }

    /**
    * @method isACalloutMock.when.method
    * @case   when called with matching method
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenMethod_whenTheMethodMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'GET' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.method, when the method matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.allowsAnyCallFalse.when.method
    * @case   when called without matching method
    * @result will fail the test
    */
    @isTest
    private static void isACalloutMockWhenMethod_whenCalledWithoutMatchingMethod_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();

        new Amoss_Instance()
            .setAsserts( (Amoss_Asserts)assertsDoubleController.getDouble() )
            .allowsAnyCall( false )
            .isACalloutMock()
            .when()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            try {
                HttpRequest request = new HttpRequest();
                request.setMethod( 'POST' );
                HttpResponse response  = new Http().send( request );
            } catch ( TestException e ) {}
        Test.stopTest();

        String exceptionMessage = (String)assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 );

        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'isACalloutMock.allowsAnyCallFalse.when.method, when called without matching method, will fail the test' );
        Amoss_Asserts.assertContains( HTTP_CALLOUT_MOCK_UNEXPECTED_EXCEPTION_TEXT     , exceptionMessage, 'isACalloutMock.allowsAnyCallFalse.when.method, when called without matching method, will fail the test, with a message that explains the issue' );
        Amoss_Asserts.assertContains( 'System.HttpRequest[Endpoint=null, Method=POST]', exceptionMessage, 'isACalloutMock.allowsAnyCallFalse.when.method, when called without matching method, will fail the test, with a message that contains the request' );
    }

    /**
    * @method isACalloutMock.when.method
    * @case   when called without matching method
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenMethod_whenCalledWithoutMatchingMethod_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'POST' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.method, when called without matching method, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.endpoint
    * @case   when called with matching endpoint
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenEndpoint_whenTheEndpointMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint( 'http://www.example.com' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'http://www.example.com' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.endpoint, when the endpoint matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.endpoint
    * @case   when called without matching endpoint
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenEndpoint_whenCalledWithoutMatchingEndpoint_willReturnEmptyResponse() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint( 'http://www.example.com' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.endpoint, when called without matching endpoint, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.endpoint.setTo
    * @case   when called with matching endpoint.setTo
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenEndpointSetTo_whenTheEndpointMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().setTo( 'http://www.example.com' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'http://www.example.com' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.endpoint.setTo, when the endpoint matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.endpoint.setTo
    * @case   when called without matching endpoint
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenEndpointSetTo_whenCalledWithoutMatchingEndpoint_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().setTo( 'http://www.example.com' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.endpoint.setTo, when called without matching endpoint, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.endpoint.set
    * @case   when called with matching endpoint.set
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenEndpointSet_whenTheEndpointIsSet_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().set()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'http://www.example.com' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.endpoint.set, when the endpoint set, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.endpoint.set
    * @case   when called without endpoint
    * @result will fail the test
    */
    @isTest
    private static void isACalloutMockWhenEndpointSet_whenCalledWithoutEndpoint_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().set()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.endpoint.set, when called without matching endpoint, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.endpoint.containing
    * @case   when called with matching endpoint.containing
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenEndpointContaining_whenTheEndpointMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().containing( 'example' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'http://www.example.com' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.endpoint.containing, when the endpoint matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.endpoint.containing
    * @case   when called without matching endpoint
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenEndpointContaining_whenCalledWithoutMatchingEndpoint_wilLReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().containing( 'example' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.endpoint.containing, when called without matching endpoint, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.endpoint.matching
    * @case   when called with matching endpoint.matching
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenEndpointMatching_whenTheEndpointMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().matching( 'http.*com' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'http://www.example.com' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.endpoint.matching, when the endpoint matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.endpoint.matching
    * @case   when called without matching endpoint
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenEndpointMatching_whenCalledWithoutMatchingEndpoint_wilLReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().matching( 'http.*com' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.endpoint.matching, when called without matching endpoint, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.body
    * @case   when called with matching body
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenBody_whenTheBodyMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body( 'The body text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'The body text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.body, when the body matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.body
    * @case   when called without matching body
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenBody_whenCalledWithoutMatchingBody_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body( 'The body text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.body, when called without matching body, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.body.setTo
    * @case   when called with matching body.setTo
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenBodySetTo_whenTheBodyMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().setTo( 'The body text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'The body text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.body.setTo, when the body matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.body.setTo
    * @case   when called without matching body
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenBodySetTo_whenCalledWithoutMatchingBody_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().setTo( 'The body text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.body.setTo, when called without matching body, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.body.set
    * @case   when called with matching body.set
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenBodySet_whenTheBodyIsSet_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().set()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'The body text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.body.set, when the body set, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.body.set
    * @case   when called without body
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenBodySet_whenCalledWithoutBody_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().set()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.body.set, when called without matching body, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.body.containing
    * @case   when called with matching body.containing
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenBodyContaining_whenTheBodyMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().containing( 'text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'The body text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.body.containing, when the body matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.body.containing
    * @case   when called without matching body
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenBodyContaining_whenCalledWithoutMatchingBody_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().containing( 'example' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.body.containing, when called without matching body, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.body.matching
    * @case   when called with matching body.matching
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenBodyMatching_whenTheBodyMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().matching( 'T.*t' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'The body text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.body.matching, when the body matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.body.matching
    * @case   when called without matching body
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenBodyMatching_whenCalledWithoutMatchingBody_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .body().matching( 'The.*text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setBody( 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.body.matching, when called without matching body, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.header.setTo
    * @case   when called with matching header.setTo
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenHeaderSetTo_whenTheHeaderMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).setTo( 'The header text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Header', 'The header text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.header.setTo, when the header matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.header.setTo
    * @case   when called without matching header
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenHeaderSetTo_whenCalledWithoutMatchingHeader_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).setTo( 'The header text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Header', 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.header.setTo, when called without matching header, will return an empty response' );
    }


    /**
    * @method isACalloutMock.when.header.setTo
    * @case   when called without matching header set at all
    * @result will return en empty response
    */
    @isTest
    private static void isACalloutMockWhenHeaderSetTo_whenCalledWithoutMatchingHeaderSetAtAll_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).setTo( 'The header text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Authorization', 'The header text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.header.setTo, when called without matching header set at all, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.header.set
    * @case   when called with matching header.set
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenHeaderSet_whenTheHeaderIsSet_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).set()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Header', 'The header text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.header.set, when the header set, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.header.set
    * @case   when called without header
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenHeaderSet_whenCalledWithoutHeader_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).set()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'iisACalloutMock.when.header.set, when called without matching header, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.header.containing
    * @case   when called with matching header.containing
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenHeaderContaining_whenTheHeaderMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).containing( 'text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Header', 'The header text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.header.containing, when the header matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.header.containing
    * @case   when called without matching header
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenHeaderContaining_whenCalledWithoutMatchingHeader_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).containing( 'example' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Header', 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.header.containing, when called without matching header, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.header.matching
    * @case   when called with matching header.matching
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenHeaderMatching_whenTheHeaderMatches_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).matching( 'T.*t' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Header', 'The header text' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.header.matching, when the header matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.header.matching
    * @case   when called without matching header
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenHeaderMatching_whenCalledWithoutMatchingHeader_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .header( 'Header' ).matching( 'The.*text' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setHeader( 'Header', 'different' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.header.matching, when called without matching header, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.compressed
    * @case   when called with compressed request
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenCompressed_whenCompressed_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .compressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setCompressed( true );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.compressed, when the request is compressed, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.compressed
    * @case   when called with a non compressed request
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenCompressed_whenNotCompressed_returnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .compressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setCompressed( false );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.compressed, when called with request that is not compressed, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.compressed
    * @case   when called with a request with compression not set
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenCompressed_whenCompressedNotSet_willReturnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .compressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.compressed, when called with request with compressed not set, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.notCompressed
    * @case   when called with non compressed request
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenNotCompressed_whenNotCompressed_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .notCompressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setCompressed( false );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.notCompressed, when the request is not compressed, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.notCompressed
    * @case   when called with a compressed request
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhenNotCompressed_whenCompressed_returnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .notCompressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setCompressed( true );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when.notCompressed, when called with request that is compressed, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when.notCompressed
    * @case   when called with request with compressed not set
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenNotCompressed_whenCompressedNotSet_returnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .notCompressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.notCompressed, when the request does not have compressed set, will return as specified' );
    }

    /**
    * @method isACalloutMock.when
    * @case   when multiple properties set, and the call matches
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhen_multiplePropertiesAndCallMatches_willReturnAsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().setTo( 'end' )
                .body().setTo( 'The Body' )
                .header( 'Header' ).setTo( 'The Header' )
                .compressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'end' );
            request.setBody( 'The Body' );
            request.setHeader( 'Header', 'The Header' );
            request.setCompressed( true );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when, when multiple properties set, and the call matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when
    * @case   when multiple properties set, and the call does not match
    * @result will return an empty response
    */
    @isTest
    private static void isACalloutMockWhen_multiplePropertiesAndCallDoesNotMatch_returnEmptyResponse() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .method( 'GET' )
                .endpoint().setTo( 'end' )
                .body().setTo( 'The Body' )
                .header( 'Header' ).setTo( 'The Header' )
                .compressed()
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'GET' );
            request.setEndpoint( 'end' );
            request.setBody( 'Different Body' );
            request.setHeader( 'Header', 'The Header' );
            request.setCompressed( true );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 0, response.getStatusCode(), 'isACalloutMock.when, when multiple properties set, and the call does not match, will return an empty response' );
    }

    /**
    * @method isACalloutMock.when
    * @case   when multiple definitions set, and call matches one
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhen_multipleDefinitionsAndCallMatchesOne_returnsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().setTo( 'return200' )
                .respondsWith()
                    .statusCode( 200 )
            .also().when()
                .endpoint().setTo( 'return404' )
                .respondsWith()
                    .statusCode( 404 )
            .also().when()
                .endpoint().setTo( 'return500' )
                .respondsWith()
                    .statusCode( 500 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setEndpoint( 'return404' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 404, response.getStatusCode(), 'isACalloutMock.when, when multiple definitions set, and a call matches one, will return as specified' );
    }

    /**
    * @method isACalloutMock.when
    * @case   when multiple definitions set, and multiple calls match
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhen_multipleDefinitionsAndMultipleCallsMatch_returnsSpecified() {

        new Amoss_Instance()
            .isACalloutMock()
            .when()
                .endpoint().setTo( 'return200' )
                .respondsWith()
                    .statusCode( 200 )
            .also().when()
                .endpoint().setTo( 'return404' )
                .respondsWith()
                    .statusCode( 404 )
            .also().when()
                .endpoint().setTo( 'return500' )
                .respondsWith()
                    .statusCode( 500 );

        Test.startTest();
            HttpRequest request = new HttpRequest();

            request.setEndpoint( 'return404' );
            HttpResponse response404  = new Http().send( request );

            request.setEndpoint( 'return500' );
            HttpResponse response500  = new Http().send( request );

            request.setEndpoint( 'return200' );
            HttpResponse response200  = new Http().send( request );

        Test.stopTest();

        System.assertEquals( 404, response404.getStatusCode(), 'isACalloutMock.when, when multiple definitions set, and multiple calls made, will return as specified - 0' );
        System.assertEquals( 500, response500.getStatusCode(), 'isACalloutMock.when, when multiple definitions set, and multiple calls made, will return as specified - 1' );
        System.assertEquals( 200, response200.getStatusCode(), 'isACalloutMock.when, when multiple definitions set, and multiple calls made, will return as specified - 2' );
    }

    /**
    * @method isACalloutMock.when.verifiedBy (Amoss_ValueVerifier)
    * @case   when called with request that matches the verification
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenVerifiedByValueVerifier_whenMatchesVerification_returnAsSpecified() {

        HttpRequest request = new HttpRequest();

        Amoss_Instance customVerifierController = new Amoss_Instance( Amoss_ValueVerifier.class );
        customVerifierController
            .expects( 'verify' )
                .withParameter().setTo( request );

        Amoss_ValueVerifier customVerifier = (Amoss_ValueVerifier)customVerifierController.getDouble();

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .statusCode( 404 )
            .also().when()
                .verifiedBy( customVerifier )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        customVerifierController.verify();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.verifiedBy (Amoss_ValueVerifier), when the verifier matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.verifiedBy (Amoss_ValueVerifier)
    * @case   when called with request that does not match the verification
    * @result will not return that specification
    */
    @isTest
    private static void isACalloutMockWhenVerifiedByValueVerifier_whenDoesNotMatch_returnOther() {

        HttpRequest request = new HttpRequest();

        Amoss_Instance customVerifierController = new Amoss_Instance( Amoss_ValueVerifier.class );
        customVerifierController
            .expects( 'verify' )
                .withParameter().setTo( request )
                .throws( new Amoss_Instance.Amoss_EqualsAssertionFailureException()
                                .setExpected( 'expectedValue' )
                                .setActual( 'actualValue' )
                                .setAssertionMessage( 'Not the same value' ) );

        Amoss_ValueVerifier customVerifier = (Amoss_ValueVerifier)customVerifierController.getDouble();

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .statusCode( 404 )
            .also().when()
                .verifiedBy( customVerifier )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        customVerifierController.verify();

        System.assertEquals( 404, response.getStatusCode(), 'isACalloutMock.when.verifiedBy (Amoss_ValueVerifier), when the verifier does not match, will not return what was specified for that call' );
    }


    /**
    * @method isACalloutMock.when.verifiedBy (Amoss_HttpRequestVerifier)
    * @case   when called with request that matches the verification
    * @result will return as specified
    */
    @isTest
    private static void isACalloutMockWhenVerifiedByHttpRequestVerifier_whenMatchesVerification_returnAsSpecified() {

        HttpRequest request = new HttpRequest();

        Amoss_Instance customVerifierController = new Amoss_Instance( Amoss_HttpRequestVerifier.class );
        customVerifierController
            .expects( 'verify' )
                .withParameter().setTo( request );

        Amoss_HttpRequestVerifier customVerifier = (Amoss_HttpRequestVerifier)customVerifierController.getDouble();

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .statusCode( 404 )
            .also().when()
                .verifiedBy( customVerifier )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        customVerifierController.verify();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.when.verifiedBy (Amoss_HttpRequestVerifier), when the verifier matches, will return as specified' );
    }

    /**
    * @method isACalloutMock.when.verifiedBy (Amoss_HttpRequestVerifier)
    * @case   when called with request that does not match the verification
    * @result will not return that specification
    */
    @isTest
    private static void isACalloutMockWhenVerifiedByHttpRequestVerifier_whenDoesNotMatch_returnOther() {

        HttpRequest request = new HttpRequest();

        Amoss_Instance customVerifierController = new Amoss_Instance( Amoss_HttpRequestVerifier.class );
        customVerifierController
            .expects( 'verify' )
                .withParameter().setTo( request )
                .throws( new Amoss_Instance.Amoss_EqualsAssertionFailureException()
                                .setExpected( 'expectedValue' )
                                .setActual( 'actualValue' )
                                .setAssertionMessage( 'Not the same value' ) );

        Amoss_HttpRequestVerifier customVerifier = (Amoss_HttpRequestVerifier)customVerifierController.getDouble();

        new Amoss_Instance()
            .isACalloutMock()
            .byDefault()
                .respondsWith()
                    .statusCode( 404 )
            .also().when()
                .verifiedBy( customVerifier )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        customVerifierController.verify();

        System.assertEquals( 404, response.getStatusCode(), 'isACalloutMock.when.verifiedBy (Amoss_HttpRequestVerifier), when the verifier does not match, will not return what was specified for that call' );
    }

    /**
    * @method isACalloutMock.expectsNoCalls
    * @case   when a callout is made is called
    * @result will fail the test
    */
    @isTest
    private static void isACalloutMockExpectsNoCalls_whenACalloutIsMade_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance mockHttpController = new Amoss_Instance();
        mockHttpController.setAsserts( assertsDouble );

        mockHttpController
            .isACalloutMock()
            .expectsNoCalls();

        Test.startTest();
            try {
                HttpResponse response  = new Http().send( new HttpRequest() );
            } catch( TestException e ) {}
        Test.stopTest();

        System.assertEquals( '' , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'isACalloutMock.expectsNoCalls, when a callout is made, will fail by calling assertEquals with an empty string as expected' );

        String expectedMethodCall = 'respond(System.HttpRequest[Endpoint=null, Method=null])';
        System.assertEquals( expectedMethodCall, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'isACalloutMock.expectsNoCalls, when a callout is made, will fail by calling assertEquals with the method called as actual' );

        String expectedAssertion = 'Did not expect any HTTP Callouts to be made';
        System.assertEquals( expectedAssertion, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'isACalloutMock.expectsNoCalls, when a callout is made, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method isACalloutMock.expects
    * @case   when request made that matches
    * @result will return the specified
    */
    @isTest
    private static void isACalloutMockExpectsVerify_whenMatches_returns() {

        Amoss_Instance customVerifierController = new Amoss_Instance();

        customVerifierController
            .isACalloutMock()
            .expects()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'GET' );
            HttpResponse response  = new Http().send( request );
        Test.stopTest();

        customVerifierController.verify();

        System.assertEquals( 200, response.getStatusCode(), 'isACalloutMock.expects.verify, when a call matches, returns' );
    }

    /**
    * @method isACalloutMock.expects
    * @case   when request made that does not match
    * @result will fail the test
    */
    @isTest
    private static void isACalloutMockExpects_whenDoesNoMatch_fails() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance customVerifierController = new Amoss_Instance();

        customVerifierController
            .setAsserts( assertsDouble )
            .isACalloutMock()
            .expects()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'POST' );

            try {
                HttpResponse response  = new Http().send( request );
            } catch ( Exception e ) {} // NOPMD: catching the exception thrown by the mock assert
        Test.stopTest();

        checkForWrongParameterNamedAssertion( assertsDoubleController, 'respond', 'request', 'GET', 'POST',
                                            'isACalloutMock.expects, when a request made that does not match' );
    }

    /**
    * @method isACalloutMock.expects.expects.verify
    * @case   when requests made in line with the expectations
    * @result will pass
    */
    @isTest
    private static void isACalloutMockExpectsExpectsVerify_whenMultipleCallsAndMatches_passes() {

        Amoss_Instance customVerifierController = new Amoss_Instance();

        customVerifierController
            .isACalloutMock()
            .expects()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 )
            .then().expects()
                .method( 'POST' )
                .respondsWith()
                    .statusCode( 404 );

        Test.startTest();
            HttpRequest request1 = new HttpRequest();
            request1.setMethod( 'GET' );
            HttpResponse response1  = new Http().send( request1 );

            HttpRequest request2 = new HttpRequest();
            request2.setMethod( 'POST' );
            HttpResponse response2  = new Http().send( request2 );
        Test.stopTest();

        customVerifierController.verify();

        System.assertEquals( 200, response1.getStatusCode(), 'isACalloutMock.expects.verify, when the calls match, returns - call 1' );
        System.assertEquals( 404, response2.getStatusCode(), 'isACalloutMock.expects.verify, when the calls match, returns - call 2' );
    }

    /**
    * @method isACalloutMock.expects.expects.verify
    * @case   when only one call made
    * @result will fail
    */
    @isTest
    private static void isACalloutMockExpectsExpectsVerify_whenOneCallMade_fail() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance customVerifierController = new Amoss_Instance();

        customVerifierController
            .setAsserts( assertsDouble )
            .isACalloutMock()
            .expects()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 )
            .then().expects()
                .method( 'POST' )
                .respondsWith()
                    .statusCode( 404 );

        Test.startTest();

            HttpRequest request = new HttpRequest();
            request.setMethod( 'GET' );
            HttpResponse response  = new Http().send( request );

            try {
                customVerifierController.verify();
            } catch ( Exception e ) {} // NOPMD: catching the exception thrown by the mock assert

        Test.stopTest();

        String expectedAssertion = 'Expected more HTTP Callouts to be made';
        String expectedCall      = 'respond( request => HttpRequest with the method POST )';

        System.assertEquals( new List<String>()              , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 0 ), 'isACalloutMock.expects.expects.verify, when few calls were made than specified, will fail by calling assertEquals with an expected empty call stack' );
        System.assertEquals( new List<String>{ expectedCall }, assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 1 ), 'isACalloutMock.expects.expects.verify, when few calls were made than specified, will fail by calling assertEquals with a call stack description that contains a message stating the calls that were expected' );
        System.assertEquals( expectedAssertion               , assertsDoubleController.get().latestCallOf( 'assertEquals' ).parameter( 2 ), 'isACalloutMock.expects.expects.verify, when few calls were made than specified, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
    }

    /**
    * @method isACalloutMock.allows
    * @case   when multple requests made that match
    * @result will return the specified
    */
    @isTest
    private static void isACalloutMockAllows_whenMultipleCallsThatMatch_returns() {

        Amoss_Instance customVerifierController = new Amoss_Instance();

        customVerifierController
            .isACalloutMock()
            .allows()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'GET' );
            HttpResponse response1  = new Http().send( request );
            HttpResponse response2  = new Http().send( request );
            HttpResponse response3  = new Http().send( request );
        Test.stopTest();

        System.assertEquals( 200, response1.getStatusCode(), 'isACalloutMock.allows, when multiple calls made that match, returns (1)' );
        System.assertEquals( 200, response2.getStatusCode(), 'isACalloutMock.allows, when multiple calls made that match, returns (2)' );
        System.assertEquals( 200, response3.getStatusCode(), 'isACalloutMock.allows, when multiple calls made that match, returns (3)' );
    }

    /**
    * @method isACalloutMock.allows
    * @case   when request made that does not match
    * @result will fail the test
    */
    @isTest
    private static void isACalloutMockAllows_whenDoesNotMatch_fails() {

        Amoss_Instance assertsDoubleController = buildMockAssertionController();
        Amoss_Asserts assertsDouble = (Amoss_Asserts)assertsDoubleController.getDouble();

        Amoss_Instance customVerifierController = new Amoss_Instance();

        customVerifierController
            .setAsserts( assertsDouble )
            .isACalloutMock()
            .allows()
                .method( 'GET' )
                .respondsWith()
                    .statusCode( 200 );

        Test.startTest();
            HttpRequest request = new HttpRequest();
            request.setMethod( 'POST' );

            try {
                HttpResponse response  = new Http().send( request );
            } catch ( Exception e ) {} // NOPMD: catching the exception thrown by the mock assert
        Test.stopTest();

        System.assertEquals( false, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 0 ), 'isACalloutMock.allows, when request made that does not match, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
        Amoss_Asserts.assertContains( HTTP_CALLOUT_MOCK_UNEXPECTED_EXCEPTION_TEXT, assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'isACalloutMock.allows, when request made that does not match, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
        Amoss_Asserts.assertContains( 'respond(System.HttpRequest[Endpoint=null, Method=POST])', assertsDoubleController.get().latestCallOf( 'assert' ).parameter( 1 ), 'isACalloutMock.allows, when request made that does not match, will fail by calling assertEquals with an assertion message that clearly describes the issue' );
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

    @isTest
    private static void test() {

        Amoss_Instance mockHttp = new Amoss_Instance();
        mockHttp
            .isACalloutMock()
                .expects()
                    .method( 'GET' )
                    .endpoint().containing( 'accounts' )
                    .header( 'Authorization' ).set()
                    .notCompressed()
                .respondsWith()
                    .statusCode( 200 )
                    .status( 'Complete' )
                    .body( '[{"Name":"sForceTest1"}]' )
                .then().expects()
                    .method( 'GET' )
                    .endpoint( 'http://api.example.com/accounts' )
                    .header( 'Authorization' ).setTo( 'value' )
                .respondsWith()
                    .statusCode( 500 )
                    .status( 'Error' )
                    .body( '[{"Name":"sForceTest1"}]' );

        HttpRequest request = new HttpRequest();
        request.setMethod( 'GET' );
        request.setEndpoint( 'http://api.example.com/accounts' );
        request.setHeader( 'Authorization', 'value' );

        Http transport = new Http();
        HttpResponse response = transport.send( request );

        System.assertEquals( 200, response.getStatusCode() );
        System.assertEquals( 'Complete', response.getStatus() );

        response = transport.send( request );

        System.assertEquals( 500, response.getStatusCode() );
        System.assertEquals( 'Error', response.getStatus() );

    }

}