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

With such flexibility, it's important that you make good decisions on which behaviours to use, and when.

The decision will be based on a balance of two main factors:
* Ensuring that you produce a meaningful test of the behaviour.
whilst
* Limiting the scope of test changes that are required when the implementation of the classes that are being stubbed change.

The following aims to describe when to each of the constructs, roughly referencing the types of Test Doubles that are described in Gerard Meszaros's book "xUnit Test Patterns".

### Test Double

Is the least brittle of the constructs, allowing any method to be called, potentially with any parameters.  In most cases, some return values for some methods will be specified.

Typically used to 'stub out' an object that is not the focus of the test.

That is, the object provides some functionality that means that the test can run, but it is not the calling of methods on this object that define the behaviour that is being tested.

However, it is likely that the test will check that the method under tests acts in a particular way when it receives certain values from the methods being stubbed.

It is of particular note that when implemented using 'withAnyParameter' (or without parameters being specified), the method signatures of the object being stubbed can change without impacting the tests.

#### Is characterised by the pattern: when.method.with.willReturn

```java

testDoubleController
    .when()
        .method( 'methodName1' )
        .withAnyParameters()
        .willReturn( true )
    .also().when()
        .method( 'methodName2' )
        .withAnyParameters()
        .willReturn( true );
```

If return values do not need to be specified, may be as simple as:

```java
    ObjectUnderTestDouble testDouble = new Amoss_Instance( ObjectUnderTestDouble.class ).generateDouble();
```

#### Brittle?

* Additions to the interface of the object being stubbed will not break the test, unless particular return values are required in the test.
* Changes to the interface of existing methods will not break tests when `withAnyParameters` or `withAnyParameter` are used and the parameters do not need to be reflected in the return values.
* Changes to the interface of existing methods may break tests when parameter values are specified in the configuration.
* Generally not affected by changes the implementation of the method under test that affect the order of processing in, or number of method calls made by the method under test.
* Is affected by changes in the implementation of the method under test where the change results in different values being returned by the methods being stubbed.

### Strict Test Double

Similar to a Test Double, although is defined in such a way that *only* the methods that are configured are allowed to be called.

Also typically used when the object being stubbed is not the focus of the test, and potentially the parameter values being passed in are not of importance.

However, it is implied that it is important that *other* methods, those not specified, are *not* called.

Is not particularly brittle to changes in the implementation of the class being mocked.  However, tests may start to break when the implementation under test changes and new methods are called against the object that is stubbed.

#### Is characterised by the pattern: allows.method.with.returning

```java

testDoubleController
    .allows()
        .method( 'methodName1' )
        .withAnyParameters()
        .returning( true )
    .also().allows()
        .method( 'methodName2' )
        .withAnyParameters()
        .returning( true );
```

#### Brittle?

* Additions to the interface of the object being stubbed **will** break the test if those methods are called by the method under test.
* Changes to the interface of existing methods will not break tests when `withAnyParameters` or `withAnyParameter` are used and the parameters do not need to be reflected in the return values.
* Changes to the interface of existing methods may break tests when parameter values are specified in the configuration.
* Generally not affected by changes to the order of processing in, or number of method calls made by the method under test.
* Is affected by changes in the implementation of the method under test where the change results in additional methods being called against the object being stubbed.
* Is affected by changes in the implementation of the method under test where the change results in different values being returned by the methods being stubbed.

### Test Spy

Is specified intially in the same way as a Test Double, though after the method under test is executed, the controller is then interrogated to determine the value of parameters.

Typically used to 'stub out' an object that *is* the focus of the test.

That is, the test is checking that the method under test calls particular methods on the given Test Double passing parameters with certain values that are predictable.

Can be used to test that individual methods are called, and the order in which that particular method is called.  However, cannot be used to test that different methods are called in a particular sequence.  In order to do that, a Mock Object (see below) is required.

#### Is characterised by the pattern: when.method.with.willReturn followed by call.of.parameter

```java

spiedUponObjectController
    .when()
        .method( 'methodName1' )
        .withAnyParameters()
        .willReturn( true )
    .also().when()
        .method( 'methodName2' )
        .withAnyParameters()
        .willReturn( true );

// followed by

System.assertEquals( 'expectedParameterValue1',
                        spiedUponObjectController.latestCallOf( 'method1' ).parameter( 0 ),
                        'methodUnderTest, when called will pass "expectedParameterValue1" into "method1"' );

System.assertEquals( 'expectedParameterValue2',
                        spiedUponObjectController.call( 0 ).of( 'method2' ).parameter( 0 ),
                        'methodUnderTest, when called will pass "expectedParameterValue2" into "method2"' );

```

### Strict Test Spy

Similar to a Test Spy, although is defined in such a way that *only* the methods that are configured are allowed to be called.

As with the Test Spy, is used to 'stub out' an object that *is* the focus of the test.

That is, the test is checking that the method under test calls particular methods on the given Test Double passing parameters with certain values that are predictable.

Can be used to test that individual methods are called, and the order in which that particular method is called.  However, cannot be used to test that different methods are called in a particular sequence.  In order to do that, a Mock Object (see below) is required.

It is implied that it is important that *other* methods, those not specified, are *not* called.

#### Is characterised by the pattern: allows.method.with.willReturn followed by call.of.parameter

```java

spiedUponObjectController
    .allows()
        .method( 'methodName1' )
        .withAnyParameters()
        .willReturn( true )
    .also().allows()
        .method( 'methodName2' )
        .withAnyParameters()
        .willReturn( true );

// followed by

System.assertEquals( 'expectedParameterValue1',
                        spiedUponObjectController.latestCallOf( 'method1' ).parameter( 0 ),
                        'methodUnderTest, when called will pass "expectedParameterValue1" into "method1"' );

System.assertEquals( 'expectedParameterValue2',
                        spiedUponObjectController.call( 0 ).of( 'method2' ).parameter( 0 ),
                        'methodUnderTest, when called will pass "expectedParameterValue2" into "method2"' );

```

### Mock Object

Similar to a Test Spy, although is defined in such a way that *only* the methods that are configured are allowed to be called, and only in the order that they are specified.

If any specified method is called out of order, or with the wrong parameters, it will fail the test.

Is therefore used to 'stub out' an object when the order of execution of different methods is important to the success of the test.

It is also implied that it is important that *other* methods, those not specified, are *not* called.

Because of the strict nature of the specification, this is the most brittle of the constructs, and often results in tests that fail when the implementation of the method under test is altered.

#### Is characterised by the pattern: expects.method.with.willReturn followed by verify

```java

mockObjectController
    .expects()
        .method( 'methodName1' )
        .withParameter( 'expectedParameterValue1' )
        .willReturn( true )
    .then().expects()
        .method( 'methodName2' )
        .withParameter( 'expectedParameterValue2' )
        .willReturn( true );

// followed by
mockObjectController.verify();

```

### Summary

Type                | Use Cases | Brittle? | Construct Pattern
------------------- | --------- | -------- | ------------------------
Test Double         | Ancillary objects, parameters passed are not the main focus of the test             | Least brittle | when.method.with.willReturn
Strict Test Double  | Ancillary objects, parameters passed are not the main focus of the test             | Brittle to addition of new calls on object being stubbed | allows.method.with.returning
Test Spy            | Focus of the test, order of execution is not important, prefer the assertion syntax | Is brittle to the interface of the object being stubbed, less brittle to the implementation of the method under test | when.method.with.willReturn, call.of.parameter
Strict Test Spy     | Focus of the test, order of execution is not important, prefer the assertion syntax | Is brittle to the interface of the object being stubbed and addition of new calls on object being stubbed, a little more brittle to the implementation of the method under test | allows.method.with.returns, call.of.parameter
Mock Object         | Focus of the test, order of execution is important                                  | Most brittle construct, brittle to the implementation of the method under test | expect.method.with.returning, verify

## Synonyms

Most of the functions have synonyms, allowing you to choose the phrasing that is most readable for your team.

Purpose                                                      | Synonyms
------------------------------------------------------------ | ---------------------------------
Specifying individual parameters                             | `withParameter`, `thenParameter`, `andThenParameter`
Stating that any single parameter is allowed                 | `withAnyParameter`, `thenAnyParameter`, `andThenAnyParameter`
Stating the return value of a method                         | `returning`, `returns`, `willReturn`
Stating that a method throws an exception                    | `throwing`, `throws`, `willThrow`
Start the specification of an additional method              | `then`, `also`
Retrieving the parameters from a particular call of a method | `call`, `get().call`
Retrieving the parameters from the latest call of a method   | `latestCallOf`, `call( -1 ).of`

## Development Ideals

For those who are looking to contribute to the project.

In order for the project to succeed it must:

* Require as little code as possible to create Test Mocks and Spies, so that mocking does not get in the way of testing.
* Use natural language to express the configuration so tests are as clear as possible to read.
* Have an auto-complete considered class structure, so that IDEs give you as much guidence as possible when tests are being written.
* Issue assertion failures that are as clear as possible, so the meaning of the failure is easy to understand.

Design Principles:

* The consumer should not need to reference any class other than the instantiation of the mock in the first place.
    * This limits the amount of noise in the specification of a mock.  Class names (espcially namespaced ones) get in the way of the meaning of the code and so they should not be required.
* Designing Methods:
    * Every method call should be expressive of what it does in plain english, particularly within the context of where it is used.
    * Methods should only have one parameter, which is described by the context provided in the method name, so that it is always clear what is being passed in.
    * Methods should be set up so they can be strung together to form sentences giving a full description of the work being done.
    * For example:
        * call( 1 ).of( 'theStubbedMethod' ).parameters()
        rather than:
        * getParameters( 'theStubbedMethod', 1 )

* Designing Classes:
    * Classes should be defined with the primary focus of making it easier for a consumer to use the framework, as opposed to making it easier for the developer to build the framework.
    * Particularly, where the context of the phrasing changes, a new object should be returned that provides an interface that is appropriate for that part of the phrasing.
    * For example:
        * when and expects on TestMock both return a TestExpectation.
            * The TestExpectation defines the phrasing (essentially the interface) for defining the expectation, being
                * method
                * withParameter / withAnyParameters / withParameterAtPostion
                * returning / returns / willReturn / throws / throwing
            * The following methods then define the end of that phrasing, and result in a TestMock being returned
                * then
                * also
    * However, the consumer should never be concerned with this, and should not need to directly reference any class other than when initially constructing a TestMock


## Roadmap

- Ability to inject a Test Double with a Salesfore Stub Provider, allowing for code driven responses to method calls
- Test Recorder style implementation of expectations
