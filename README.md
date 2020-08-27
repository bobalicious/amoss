# Amoss
Apex Mock Objects, Spies and Stubs - A Simple Mocking framework for Apex (Salesforce)

## Disclaimer

This is an ALPHA state project and should not be used for anything other than exploring the possbilities and limitations of using such a framework.

No warranty is given and no liability is offered, this is experimental code and should be treated as such.

The code may be downloaded and used for experimental purposes only and cannot be used in any context other than that until such time as a proper licence is selected an described in this file.

** NOTE THAT THIS DOCUMENTATION IS CURRENTLY INACCURATE AND DESCRIBES THE DESIRED BEHAVIOUR, RATHER THAN THE IMPLEMENTED **

Particularly:
* The Test Double will **only** allow methods to be called if they have been configured, whereas the documentation states that any method can be called unless `allows` has been specified.  This behaviour change is the next thing that will be implemented.
* The method to generate the test double is currently `generateMock`.  It will be changed to be `generateDouble`.

## Why use Amoss?

Amoss provides a simple interface for implementing Mock, Test Spy and Stub objects (Test Doubles) for use in Unit Testing.

It's intended to be very straightforward to use, and to result in code that's even more straightforward to read.

** NOTE: will probably replace the example code so it's not the same as Martin Fowler's **

** NOTE: may also flesh out the documenation on Mocks **

## How?

### Constructing and using a Test Double

Amoss can be used to build simple stub objects - AKA Configurable Test Doubles, by:
* Constructing an `Amoss_Instance`, passing it the type of the class you want to 'stub out'.
* Asking the resulting 'controller' to generate a mock for you.

```java
    Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
    Warehouse warehouseDouble = warehouseController.generateDouble();
```

The result is an object that can be used in place of the object being stubbed.

Every non-static public method on the class is available, and when called, will do nothing.

If a method has a return value, then `null` will be returned.

You then use the Test Double as you would any other instance of the object.

In this example, we're testing `fill` on the class `Order`.

The method takes a `Warehouse` as a parameter, calls methods against it and then returns `true` when the stock is successfully reserved:

```java

Test.startTest();
    Order order = new Order( TALISKER, 50 );
    Boolean filled = order.fill( warehouseDouble );
Test.stopTest();

System.assert( filled, 'fill, when called for an order that can be filled, will check the passed warehouse for stock and return true if the order can be filled' );

```

What we need to do, is configure our Test Double version of `Warehouse` so that tells the order that there's stock available, and then allows the order to claim it.

### Configuring return values

We can configure the Test Double, so that certain methods return certain values by calling `when`, `method` and`willReturn` against the controller.

```java
Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
warehouseController
    .when()
        .method( 'hasInventory' )
        .willReturn( true )
    .also().when()
        .method( 'remove' )
        .willReturn( true );

Warehouse warehouseDouble = warehouseController.generateDouble();

...
```

If we want our Test Double to be a little more strict about the parameters it recieves, we can also specify that methods should return particular values *only when certain parameters are passed* by using methods like `withParameter` and `andThenParameter`:

```java
Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
warehouseController
    .when()
        .method( 'hasInventory' )
        .withParameter( TALISKER )
        .andThenParameter( 50 )
        .willReturn( true )
    .also().when()
        .method( 'hasInventory' )
        .willReturn( false );

Warehouse warehouseDouble = warehouseController.generateDouble();

...
```

If we want to be strict about some parameters, but don't care about others we can also be flexible about the contents of particular parameters, using `withAnyParameter`, and `andThenAnyParameter`:

```java
Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
warehouseController
    .when()
        .method( 'hasInventory' )
        .withParameter( TALISKER )
        .andThenAnyParameter()
        .willReturn( true );

Warehouse warehouseDouble = warehouseController.generateDouble();

...
```

This is very useful for making sure that our tests only configure the Test Doubles to care about the parameters that are important for the tests we are running, making them less brittle.

### Using the Test Double as a Spy

The controller can then be used as a Test Spy, allowing us to find out what values where passed into methods by using `latestCallOf` and `call` and `get().call()`:

```java

System.assertEquals( TALISKER, warehouseController.latestCallOf( 'hasInventory' ).parameter( 0 )
                    , 'filling, will call hasInventory against the warehouse, passing the product required, to find out if there is stock' );

System.assertEquals( 50, warehouseController.call( 0 ).of( 'hasInventory' ).parameter( 1 )
                    , 'filling, will call hasInventory against the warehouse, passing the number required, to find out if there is stock' );

```

This allows us to check that the correct parameters are passed into methods when there are no visible effects of those parameters, and to do so in a way that follows the standard format of a unit test.

### Using the Test Double as a Mock Object

A very similar configuraiton syntax can be used to define the Test Double as a self validating Mock Object using `expects` and `verify`:

```java
Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
warehouseController
    .expects()
        .method( 'hasInventory' )
        .withParameter( TALISKER )
        .andThenParameter( 50 )
        .returning( true )
    .then().expects()
        .method( 'remove' )
        .withParameter( TALISKER )
        .andThenParameter( 50 )
        .returning( true );

Warehouse warehouseDouble = warehouseController.generateDouble();

...

warehouseController.verify();
```

When done, the Mock will raise a failure if any method other than those specified are called, or if any method is called out of sequence.

`verify` then checks that every method that was expected, was called, ensuring that all the expecations were met.

This can be very useful if the order and completeness of processing is absolutely vital.

A single object can be used as both a mock and a test spy at the same time:

```java
Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
warehouseController
    .expects()
        .method( 'hasInventory' )
        .withParameter( TALISKER )
        .andThenParameter( 50 )
        .returning( true )
    .also().when()
        .method( 'remove' )
        .returning( true );

Warehouse warehouseDouble = warehouseController.generateDouble();

...

warehouseController.verify();

System.assertEquals( TALISKER, warehouseController.latestCallOf( 'remove' ).parameter( 0 )
                    , 'filling, will call remove against the warehouse, passing the product required, to remove the stock' );
```

This will then allow `remove` to be called at any time (and any number of times), but `hasInventory` must be called with the stated parameters, and must be called exactly once.

### Configuring a stricter Test Double that isn't a Mock Object

If you like the way Test Spies have clear assertions, but don't want just any method to be allowed to be called on your Test Double, you can use `allows`

```java
Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
warehouseController
    .allows()
        .method( 'hasInventory' )
        .withParameter( TALISKER )
        .andThenParameter( 50 )
        .returning( true )
    .also().allows()
        .method( 'remove' )
        .withParameter( TALISKER )
        .andThenParameter( 50 )
        .returning( true );

Warehouse warehouseDouble = warehouseController.generateDouble();

...
```

This means that `hasInventory` and `remove` can be called in any order, and do not *have* to be called, but that *only* these two methods with these precise parameters can be called, and any other method called against the Test Double will result a test failure.

### Throwing exceptions

Test Doubles can also be told to throw exceptions, using `throwing`, `throws` or `willThrow`:

```java
Amoss_Instance warehouseController = new Amoss_Instance( Warehouse.class );
warehouseController
    .when()
        .method( 'hasInventory' )
        .withParameter( TALISKER )
        .andThenParameter( 50 )
        .throws( new Warehouse.WarehouseOutOfStockException( 'Warehouse does not have stock' ) );

Warehouse warehouseDouble = warehouseController.generateDouble();

...
```

## What? When?

*Brief description of the different types, and when to use each of them*

Type                | Pattern
------------------- | -----------------------------------------------
Test Double         | when.method.with.returns
Strict Test Double  | allows.method.with.returns
Test Spy            | when.method.with.returns, call.of.parameter
Strict Test Spy     | allows.method.with.returns, call.of.parameter
Mock Object         | expect.method.with.returning, verify

## Synonyms

Most of the functions have synonyms, allowing you to choose the phrasing that is most readable for your team

* withParameter, thenParameter, andThenParameter
* withAnyParameter, thenAnyParameter, andThenAnyParameter
* returning, returns, willReturn
* throwing, throws, willThrow
* then, also
* call, get().call
* latestCallOf, call( -1 ).of