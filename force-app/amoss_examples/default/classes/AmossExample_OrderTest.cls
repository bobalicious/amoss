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

/**
* This test class contains examples of the different ways Amoss may be used to test a particular method on the class
* AmossExample_Order.
*
* It attempts to highlight the pros and cons of the different techniques that are possible with Amoss, as well
* as providing concrete examples of the syntax and advised indentation patterns for use of the framework.
*
* It is essentially forms part of the documentation, and should not be needed in a production
* system.
*
*/
@isTest
public with sharing class AmossExample_OrderTest {

    // Because the 'Order' class's methods never look at the values of these parameters, we should never
    // need to change them in our tests, no matter what mechanism we use.
    //
    // It is 'DeliveryProvider' that would change its behaviour based on these values, and we're driving that
    // through the Test Doubles that we are creating.
    //
    final static String deliveryPostcode = 'AB1 2DE';
    final static Date   deliveryDate     = Date.newInstance( 1987, 04, 10 );

    /**
     * An example of a simple 'Test Spy' style test.
     *
     * When the methods on the Test Double are called, they do not care what the parameters are - they simply respond with true.
     *
     * The behaviour is checked by 'spying' on the parameters that were passed after the event using explicit assertions.
     *
     * This means that the test is only loosely tied to the implementation of the delivery provider.  If a new parameter
     * is added to the end of the methods, the test will still run and pass.
     * Although, if the shape of the parameters referenced in the assertions change, then the test will start to fail.
     *
     * It is also loosely tied to the implementation.  If, for example, 'scheduleDelivery' was called before 'canDeliver', this
     * test would still pass.  In some circumstances, this may be an advantage.  In this case it's a shortcoming.
     *
     * In addition, if other methods exist and are called against the DeliveryProvider, this will also allow the test to pass.
     *
     * Finally, it should be noted that this test doesn't check we loop over the list of providers and only call when the
     * delivery can be fulfilled by the provider.
     *
     */
    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_simpleSingleTestSpy() {

        // Configure a Test Double for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .when()
                .method( 'canDeliver' )
                .willReturn( true )
            .also().when()
                .method( 'scheduleDelivery' )
                .willReturn( true );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.getDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        Assert.areEqual( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

        //
        // Check that the delivery provider was called with the parameters that we expected
        //
        Assert.areEqual( deliveryPostcode, deliveryProviderController.get().latestCallOf( 'canDeliver' ).parameter( 'postcode' )    , 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , deliveryProviderController.get().latestCallOf( 'canDeliver' ).parameter( 'deliveryDate' ), 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the delivery date' );

        Assert.areEqual( deliveryPostcode, deliveryProviderController.get().latestCallOf( 'scheduleDelivery' ).parameter( 'postcode' )    , 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , deliveryProviderController.get().latestCallOf( 'scheduleDelivery' ).parameter( 'deliveryDate' ), 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the delivery date' );
    }

    /**
     * An example of a full blown 'Mock' style test.
     *
     * When the methods on the Test Double are called, the parameters are checked, if they match what is expected then the configured value is returned.
     * Otherwise, an assertion fails and the test stops.
     *
     * The strict parameter checking means that the test is strongly tied to the implementation of the delivery provider.  If any of the parameters
     * in the methods being mocked change, or new parameters are added, then the test will fail.
     *
     * The behaviour is checked by stating that methods are 'expected' to be called, then verifying that they are.
     *
     * The framework checks that the methods are called in the order that they are expected, strongly tying the test to the method's implementation.
     *
     * In some circumstances, this may not be desired, however in this case it is an advantage.  We are checking that 'canDelivery'
     * is called BEFORE 'scheduleDelivery' is.
     *
     * In addition, if other methods exist and are called against the DeliveryProvider, this will fail the test.  Anything that is not 'expected'
     * is a failure.
     *
     * Finally, it should be noted that this test doesn't check we loop over the list of providers and only call when the
     * delivery can be fulfilled by the provider.
     *
     */
    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_strictSingleMock() {

        // Configure a Test Double for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .expects()
                .method( 'canDeliver' )
                .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
                .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
                .returning( true )
            .then().expects()
                .method( 'scheduleDelivery' )
                .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
                .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
                .returning( true );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.getDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        // Check that the methods were all called against the mock, with the right parameters.
        deliveryProviderController.verify();

        Assert.areEqual( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }

    /**
     * An example of a simple 'Mock' style test, which utilises 'Spy' capabilities.
     *
     * This setup isn't particularly recommended, though may be of interest to see that it is possible.
     *
     * When the methods on the Test Double are called, they do not care what the parameters are - they simply respond with true.
     *
     * The lack of parameter checking means that the test is only loosely tied to the implementation of the delivery provider.  If a new parameter
     * is added to the end of the methods, the test will still run and pass.
     * Although, if the shape of the parameters referenced in the assertions change, then the test will start to fail.
     *
     * The behaviour is checked by stating that methods are 'expected' to be called, then verifying that they are.
     *
     * The framework checks that the methods are called in the order that they are expected, strongly tying the test to the method's implementation.
     *
     * In some circumstances, this may not be desired, however in this case it is an advantage.  We are checking that 'canDelivery'
     * is called BEFORE 'scheduleDelivery' is.
     *
     * In addition, if other methods exist and are called against the DeliveryProvider, this will fail the test.  Anything that is not 'expected'
     * is a failure.
     *
     * Finally, it should be noted that this test doesn't check we loop over the list of providers and only call when the
     * delivery can be fulfilled by the provider.
     *
     */
    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_simpleSingleMock() {

        // Configure a Test Double for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .expects()
                .method( 'canDeliver' )
                .returning( true )
            .then().expects()
                .method( 'scheduleDelivery' )
                .returning( true );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.getDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        // Check that the methods were all called against the mock.
        //
        // This is ultimately redundant in this case, as we use the Spy methods to check that
        // the correct parameters are called.
        deliveryProviderController.verify();

        Assert.areEqual( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

        //
        // Check that the delivery provider was called with the parameters that we expected
        //
        Assert.areEqual( deliveryPostcode, deliveryProviderController.get().latestCallOf( 'canDeliver' ).parameter( 'postcode' )    , 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , deliveryProviderController.get().latestCallOf( 'canDeliver' ).parameter( 'deliveryDate' ), 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the delivery date' );

        Assert.areEqual( deliveryPostcode, deliveryProviderController.get().latestCallOf( 'scheduleDelivery' ).parameter( 'postcode' )    , 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , deliveryProviderController.get().latestCallOf( 'scheduleDelivery' ).parameter( 'deliveryDate' ), 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the delivery date' );
    }

    /**
     * An example of a strict 'Test Spy' style test
     *
     * When the methods on the Test Double are called, the parameters are checked, if they match what is allowed then the configured value is returned.
     * Otherwise, an assertion fails and the test stops.
     *
     * The strict parameter checking means that the test is strongly tied to the implementation of the delivery provider.  If any of the parameters
     * in the methods being mocked change, or new parameters are added, then the test will fail.
     *
     * The behaviour is checked by stating that methods are 'allowed' to be called, then checking that they are by spying the values
     *
     * However, the order of method calls are not checked, and the methods could be called in any order without causing failures.
     *
     * In some circumstances, this may be an advantage, however in this case it is a shortcoming.  We are NOT checking that 'canDelivery'
     * is called before 'scheduleDelivery' is.
     *
     * That said, if other methods exist and are called against the DeliveryProvider, this will fail the test.  Anything that is not 'allowed'
     * is a failure.
     *
     * Finally, it should be noted that this test doesn't check we loop over the list of providers and only call when the
     * delivery can be fulfilled by the provider.
     *
     */
    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_strictSingleTestSpy() {

        // Configure a Test Double for a single Delivery Provider
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .allows()
                .method( 'canDeliver' )
                .withParameter( deliveryPostcode )
                .thenParameter( deliveryDate )
                .returning( true )
            .then().allows()
                .method( 'scheduleDelivery' )
                .withParameter( deliveryPostcode )
                .thenParameter( deliveryDate )
                .returning( true );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.getDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        Assert.areEqual( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

        //
        // Check that the delivery provider was called with the parameters that we expected (this time using positional notation to retrieve the values)
        //
        Assert.areEqual( deliveryPostcode, deliveryProviderController.get().latestCallOf( 'canDeliver' ).parameter( 0 ), 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , deliveryProviderController.get().latestCallOf( 'canDeliver' ).parameter( 1 ), 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the delivery date' );

        Assert.areEqual( deliveryPostcode, deliveryProviderController.get().latestCallOf( 'scheduleDelivery' ).parameter( 0 ), 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , deliveryProviderController.get().latestCallOf( 'scheduleDelivery' ).parameter( 1 ), 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against that delivery providers, passing the delivery date' );
    }

    //
    // Creating multiple Test Doubles
    //

    /**
     * An example of a simple 'Test Spy' style test with multiple Test Doubles.
     *
     * More than one Test Double can be created, although each requires its own Amoss_Instance to be created.
     *
     * We can test that the looping in this particular test method works by creating multiple doubles and checking that the
     * right calls are made (or not made) against each method.
     *
     */
    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_multipleTestSpies() {

        // Configure a Test Double that cannot deliver
        //
        Amoss_Instance cannotDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        cannotDeliverController
            .when()
                .method( 'canDeliver' )
                .willReturn( false );
        AmossExample_DeliveryProvider cannotDeliverProvider = (AmossExample_DeliveryProvider)cannotDeliverController.getDouble();

        // Configure a Test Double that can deliver
        //
        Amoss_Instance canDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        canDeliverController
            .when()
                .method( 'canDeliver' )
                .willReturn( true )
            .also().when()
                .method( 'scheduleDelivery' )
                .willReturn( true );
        AmossExample_DeliveryProvider canDeliverProvider = (AmossExample_DeliveryProvider)canDeliverController.getDouble();

        // Configure a Test Double that shouldn't be called
        //
        Amoss_Instance shouldntBeCalledController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        AmossExample_DeliveryProvider shouldntBeCalledProvider = (AmossExample_DeliveryProvider)shouldntBeCalledController.getDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ cannotDeliverProvider, canDeliverProvider, shouldntBeCalledProvider } );

        Test.stopTest();

        Assert.areEqual( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );

        //
        // Check that the delivery providers was called with the parameters that we expected
        //
        Assert.areEqual( deliveryPostcode, cannotDeliverController.get().latestCallOf( 'canDeliver' ).parameter( 'postcode' )    , 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , cannotDeliverController.get().latestCallOf( 'canDeliver' ).parameter( 'deliveryDate' ), 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the delivery date' );

        Assert.areEqual( 0, cannotDeliverController.countOf( 'scheduleDelivery' ), 'scheduleDelivery, will not call scheduleDelivery against a deliveryProvider that cannot deliver' );

        //
        // Check that the delivery providers was called with the parameters that we expected
        //
        Assert.areEqual( deliveryPostcode, canDeliverController.get().latestCallOf( 'canDeliver' ).parameter( 'postcode' )    , 'scheduleDelivery will call canDeliver against the passed in delivery providers, passing the postcode' );
        Assert.areEqual( deliveryDate    , canDeliverController.get().latestCallOf( 'canDeliver' ).parameter( 'deliveryDate' ), 'scheduleDelivery will call canDeliver against the passed in delivery provider , passing the delivery date' );

        Assert.areEqual( deliveryPostcode, canDeliverController.get().latestCallOf( 'scheduleDelivery' ).parameter( 'postcode' )    , 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against the first delivery provider that can perform the delivery, passing the postcode' );
        Assert.areEqual( deliveryDate    , canDeliverController.get().latestCallOf( 'scheduleDelivery' ).parameter( 'deliveryDate' ), 'scheduleDelivery, when a provider can deliver, will call scheduleDelivery against the first delivery provider that can perform the delivery, passing the delivery date' );

        //
        // Check that the delivery providers was called with the parameters that we expected
        //
        Assert.areEqual( 0, shouldntBeCalledController.countOf( 'canDeliver'       ), 'scheduleDelivery, will not call canDeliver against a deliveryProvider further down the list than one that can provide the delivery' );
        Assert.areEqual( 0, shouldntBeCalledController.countOf( 'scheduleDelivery' ), 'scheduleDelivery, will not call canDeliver against a deliveryProvider further down the list than one that can provide the delivery' );
    }

    /**
     * An example of a 'Mock' style test with multiple Test Doubles.
     *
     * More than one Test Double can be created, although each requires its own Amoss_Instance to be created.
     *
     * We can test that the looping in this particular test method works by creating multiple doubles and expecting the appropriate methods
     * to be called.
     *
     * Note that this test has significantly fewer assertions than the Test Spy version.
     *
     */
    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_multipleMocks() {

        // Configure a Test Double that cannot deliver
        //
        Amoss_Instance cannotDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        cannotDeliverController
            .expects()
                .method( 'canDeliver' )
                .withParameter( deliveryPostcode )
                .thenParameter( deliveryDate )
                .willReturn( false );
        AmossExample_DeliveryProvider cannotDeliverProvider = (AmossExample_DeliveryProvider)cannotDeliverController.getDouble();

        // Configure a Test Double that can deliver
        //
        Amoss_Instance canDeliverController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        canDeliverController
            .when()
                .method( 'canDeliver' )
                .withParameter( deliveryPostcode )
                .thenParameter( deliveryDate )
                .willReturn( true )
            .also().when()
                .method( 'scheduleDelivery' )
                .withParameter( deliveryPostcode )
                .thenParameter( deliveryDate )
                .willReturn( true );
        AmossExample_DeliveryProvider canDeliverProvider = (AmossExample_DeliveryProvider)canDeliverController.getDouble();

        // Configure a Test Double that shouldn't be called
        //
        Amoss_Instance shouldntBeCalledController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        shouldntBeCalledController
            .allowsAnyCall( false );    // This switches off the behaviour that means that any call to a valid method is allowed.
                                        // With the lack of any when, allows or expects defined, this means that any call to any method
                                        // will result in a test failure
        AmossExample_DeliveryProvider shouldntBeCalledProvider = (AmossExample_DeliveryProvider)shouldntBeCalledController.getDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ cannotDeliverProvider, canDeliverProvider, shouldntBeCalledProvider } );

        Test.stopTest();

        // check that all the expected methods were called against all the mocks
        cannotDeliverController.verify();
        canDeliverController.verify();
        shouldntBeCalledController.verify();

        Assert.areEqual( true, scheduleDeliveryResponse, 'scheduleDelivery, when the delivery can be scheduled, will return true' );
    }

    /**
     * An example of a Test Double that throws an exception.
     *
     * Note that any expects / allows or when can be configured to throw an exception.
     *
     * Of particular interest is that, as long as that exception is caught, the spy and verify methods
     * can continue to be used as in any other test.  The state is still kept and is assertable.
     *
     */
    @isTest
    public static void ifDeliveryCanBeMadeItIsBooked_mockThatThrowsAnException() {

        // Configure a Test Double that throws an Exception
        //
        Amoss_Instance deliveryProviderController = new Amoss_Instance( AmossExample_DeliveryProvider.class );
        deliveryProviderController
            .expects()
                .method( 'canDeliver' )
                .withParameter( deliveryPostcode )
                .thenParameter( deliveryDate )
                .throws( new AmossExample_DeliveryProvider.DeliveryProviderException( 'This is the exception thrown' ) );

        AmossExample_DeliveryProvider deliveryProvider = (AmossExample_DeliveryProvider)deliveryProviderController.getDouble();

        Test.startTest();

            AmossExample_Order order = new AmossExample_Order()
                                            .setDeliveryDate( deliveryDate )
                                            .setPostcode( deliveryPostcode );

            Boolean scheduleDeliveryResponse = order.scheduleDelivery( new List<AmossExample_DeliveryProvider>{ deliveryProvider } );

        Test.stopTest();

        deliveryProviderController.verify();

        Assert.areEqual( false, scheduleDeliveryResponse, 'scheduleDelivery, when a delivery provider throws an exception, returns false' );
    }
}