@isTest
public with sharing class ExampleTest {

    final static String TALISKER = 'talisker';

    @isTest
    public static void fillingRemovesInventoryIfInStock() {

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
        warehouseController
            .expects()
                .method( 'hasInventory' )
                .withParameters( new Object[]{ TALISKER, 50 } )
                .returning( true )
            .then().expects()
                .method( 'remove' )
                .withParameter( TALISKER ).andThenParameter( 50 )
                .returning( true );

        Order order = new Order( TALISKER, 50 );
        
        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify();
        System.assert( order.isFilled(), 'filling, when the warehouse has stock, will state that the order is filled' );
    }

    @isTest
    public static void fillingRemovesInventoryIfInStock_usingASpy() {

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
        warehouseController
            .when()
                .method( 'hasInventory' )
                .willReturn( true )
            .also().when()
                .method( 'remove' )
                .willReturn( true );

        Order order = new Order( TALISKER, 50 );
        
        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        System.assert( order.isFilled(), 'filling, when the warehouse has stock, will state that the order is filled' );

        System.assertEquals( TALISKER, warehouseController.latestCallOf( 'hasInventory' ).parameter( 0 )
                            , 'filling, will call hasInventory against the warehouse, passing the product required, to find out if there is stock' );

        System.assertEquals( 50, warehouseController.latestCallOf( 'hasInventory' ).parameter( 1 )
                            , 'filling, will call hasInventory against the warehouse, passing the number required, to find out if there is stock' );

        System.assertEquals( new List<Object>{ TALISKER, 50 }, warehouseController.call( 0 ).of( 'remove' ).parameters()
                            , 'filling, when the warehouse has stock, will call remove against the warehouse, passing the product and number required' );
    }

    @isTest
    public static void fillingRemovesInventoryIfInStock_usingASpyThatStatesGet() {

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
        warehouseController
            .when()
                .method( 'hasInventory' )
                .willReturn( true )
            .also().when()
                .method( 'remove' )
                .willReturn( true );

        Order order = new Order( TALISKER, 50 );
        
        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        System.assert( order.isFilled(), 'filling, when the warehouse has stock, will state that the order is filled' );

        System.assertEquals( TALISKER, warehouseController.get().latestCallOf( 'hasInventory' ).parameter( 0 )
                            , 'filling, will call hasInventory against the warehouse, passing the product required, to find out if there is stock' );

        System.assertEquals( 50, warehouseController.get().latestCallOf( 'hasInventory' ).parameter( 1 )
                            , 'filling, will call hasInventory against the warehouse, passing the number required, to find out if there is stock' );

        System.assertEquals( new List<Object>{ TALISKER, 50 }, warehouseController.get().call( 0 ).of( 'remove' ).parameters()
                            , 'filling, when the warehouse has stock, will call remove against the warehouse, passing the product and number required' );
    }

    @isTest
    public static void fillingRemovesInventoryIfInStock_whenAMethodHasNoReturns() {

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
        warehouseController
            .expects()
                .method( 'hasInventory' )
                .withParameters( new Object[]{ TALISKER, 50 } )
                .returning( true )
            .then().expects()
                .method( 'removeWithoutReturn' )
                .withParameter( TALISKER ).andThenParameter( 50 );

        Order order = new Order( TALISKER, 50 );
        
        Test.startTest();
            order.fillWithoutReturn( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify();
        // there's nothing to assert here because there's no effect that is visible except in Warehouse
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock() {

        Order order = new Order(TALISKER, 51);

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
            
        warehouseController.expects()
            .method( 'hasInventory' )
            .withAnyParameters()
            .returning( false );

        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify();
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock_usingWhenAnyParametersInstead() {

        Order order = new Order(TALISKER, 51);

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
            
        // If you didn't care which methods get called, you just want them to return
        // certain values, you can use 'when'.  These are examined before the expects
        // so you can mix them, as long as the whens don't overlap with the expects.

        warehouseController.when()
            .method( 'hasInventory' )
            .withAnyParameters()
            .willReturn( false );

        warehouseController.when()
            .method( 'remove' )
            .withAnyParameters()
            .willReturn( false );

        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify(); // this will always pass, as we have no expectations
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock_usingWhenWithSpecificParametersChainedTogether() {

        Order order = new Order(TALISKER, 51);

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
            
        // We can set up conditional responses - they are looked at in order - if 51 is sent
        // we'll get a false, otherwise we'll get true

        warehouseController.when()
            .method( 'hasInventory' )
            .withParameter( TALISKER )
            .andThenParameter( 51 )
            .willReturn( false )
        .also().when()
            .method( 'hasInventory' )
            .withAnyParameters()
            .willReturn( true );

        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify(); // this will always pass, as we have no expectations
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock_usingWhenSpecificParametersInstead() {

        Order order = new Order(TALISKER, 51);

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
            
        // We can set up conditional responses - they are looked at in order - if 51 is sent
        // we'll get a false, otherwise we'll get true

        warehouseController.when()
            .method( 'hasInventory' )
            .withParameter( TALISKER )
            .andThenParameter( 51 )
            .willReturn( false );

        warehouseController.when()
            .method( 'hasInventory' )
            .withAnyParameters()
            .willReturn( true );

        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify(); // this will always pass, as we have no expectations
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfTheWarehouseThrowsAnException() {

        Order order = new Order(TALISKER, 51);

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
            
        warehouseController.expects()
            .method( 'hasInventory' )
            .withParameter( TALISKER )
            .andThenParameter( 51 )
            .throwing( new Warehouse.WarehouseException( 'Some error happened' ) );

        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify();
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse throws an exception, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfTheWarehouseThrowsAnException_canUseStandardExceptions() {

        Order order = new Order(TALISKER, 51);

        Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
            
        warehouseController.expects()
            .method( 'hasInventory' )
            .withParameter( TALISKER )
            .andThenParameter( 51 )
            .throwing( new DmlException( 'Some error happened' ) );

        Test.startTest();
            order.fill( (Warehouse)warehouseController.generateMock() );
        Test.stopTest();

        warehouseController.verify();
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse throws an exception, will state that the order is not filled' );
    }   
}