@isTest
public with sharing class ExampleTest {

    final static String TALISKER = 'talisker';

    @isTest
    public static void fillingRemovesInventoryIfInStock() {

        TestMock warehouse = new TestMock( Warehouse.class );
        warehouse
            .expects()
                .method( 'hasInventory' )
                .withParameters( new Object[]{ TALISKER, 50 } )
                .returning( true )
            .then().expects()
                .method( 'remove' )
                .withParameter( TALISKER ).andParameter( 50 )
                .returning( true );

        Order order = new Order( TALISKER, 50 );
        
        Test.startTest();
            order.fill( (Warehouse)warehouse.proxy() );
        Test.stopTest();

        warehouse.verify();
        System.assert( order.isFilled(), 'filling, when the warehouse has stock, will state that the order is filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock() {

        Order order = new Order(TALISKER, 51);

        TestMock warehouse = new TestMock( Warehouse.class );
            
        warehouse.expects()
            .method( 'hasInventory' )
            .withAnyParameters()
            .returning( false );

        Test.startTest();
            order.fill( (Warehouse)warehouse.proxy() );
        Test.stopTest();

        warehouse.verify();
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock_usingWhenAnyParametersInstead() {

        Order order = new Order(TALISKER, 51);

        TestMock warehouse = new TestMock( Warehouse.class );
            
        // If you didn't care which methods get called, you just want them to return
        // certain values, you can use 'when'.  These are examined before the expects
        // so you can mix them, as long as the whens don't overlap with the expects.

        warehouse.when()
            .method( 'hasInventory' )
            .withAnyParameters()
            .returns( false );

        warehouse.when()
            .method( 'remove' )
            .withAnyParameters()
            .returns( false );

        Test.startTest();
            order.fill( (Warehouse)warehouse.proxy() );
        Test.stopTest();

        warehouse.verify(); // this will always pass, as we have no expectations
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock_usingWhenWithSpecificParametersChainedTogether() {

        Order order = new Order(TALISKER, 51);

        TestMock warehouse = new TestMock( Warehouse.class );
            
        // We can set up conditional responses - they are looked at in order - if 51 is sent
        // we'll get a false, otherwise we'll get true

        warehouse.when()
            .method( 'hasInventory' )
            .withParameter( TALISKER )
            .andParameter( 51 )
            .returns( false )
        .also().when()
            .method( 'hasInventory' )
            .withAnyParameters()
            .returns( true );

        Test.startTest();
            order.fill( (Warehouse)warehouse.proxy() );
        Test.stopTest();

        warehouse.verify(); // this will always pass, as we have no expectations
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }

    @isTest
    public static void fillingDoesNotRemoveIfNotEnoughInStock_usingWhenSpecificParametersInstead() {

        Order order = new Order(TALISKER, 51);

        TestMock warehouse = new TestMock( Warehouse.class );
            
        // We can set up conditional responses - they are looked at in order - if 51 is sent
        // we'll get a false, otherwise we'll get true

        warehouse.when()
            .method( 'hasInventory' )
            .withParameter( TALISKER )
            .andParameter( 51 )
            .returns( false );

        warehouse.when()
            .method( 'hasInventory' )
            .withAnyParameters()
            .returns( true );

        Test.startTest();
            order.fill( (Warehouse)warehouse.proxy() );
        Test.stopTest();

        warehouse.verify(); // this will always pass, as we have no expectations
        System.assertEquals( false, order.isFilled(), 'filling, when the warehouse does not have stock, will state that the order is not filled' );
    }
}