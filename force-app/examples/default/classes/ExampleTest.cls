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
}