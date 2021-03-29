# Amoss

Apex Mock Objects, Spies and Stubs - A Simple Mocking framework for Apex (Salesforce)

## Why use Amoss?

Amoss provides a simple interface for implementing Mock, Test Spy and Stub objects (Test Doubles) for use in Unit Testing.

It's intended to be very straightforward to use, and to result in code that's even more straightforward to read.

As a simple example, the following example:

* Creates a Test Double of the class `DeliveryProvider`
* Configures the methods `canDeliver` and `scheduleDelivery` to always return `true`

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .when( 'canDeliver' )
        .willReturn( true )
    .also().when( 'scheduleDelivery' )
        .willReturn( true );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();
```

### Installating it

#### git clone / copy / deploy

If you are familar with using SFDX, the ant migration tool or using a local IDE, It is recommended that you either clone this repository or download a release from the release section, copy the Amoss files you require, and install them using your normal mechanism.

#### Unlocked Package - SFDX

Alternatively, Amoss is available as an Unlocked Package, and the 'currently published' version based *this* branch can be installed (after setting the default org), using:

`sfdx force:package:install --package "amoss@1.0.0-0"`

You should note that this *may not* be the most recent version that exists on this branch.  There are times when the most recent version has not been published as an Unlocked Package Version.  In addition, the Unlocked Package contains the `amoss_main` and `amoss_test` files, though does not include `amoss_examples`.

Links to the release notes, and any changes pending release can be found at the end of this file.

##### Note
If you are not familiar with the SFDX commands, then it is recommended that you read the documentation here: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_package.htm


#### Unlocked Package - Installation link

For Dev Instances or Production, the Unlocked Package can be installed via:

* https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O1vJQAS

For all other instances:

* https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O1vJQAS

#### Install Button

As a final option, you can install directly from this page, using the following 'Deploy to Salesforce' button.

##### Note

If running from the branch 'main', you should enter 'main' into the 'Branch/Tag/Commit:' field of 'Salesforce Deploy'.

This is because of a bug in that application that incorrectly selects the default branch as 'master' (https://github.com/afawcett/githubsfdeploy/issues/43)

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

Be aware that this will grant a third pary Heroku app access to your org.  I have no reason to believe that 'Andy in the Cloud'  (https://andyinthecloud.com/about/) will do anything malicious with that access, though you should always be aware that there are risks when you grant access to an org, and using such an app is entirely at your own risk.

#### What do I get?

Amoss consists of 3 sets of classes:
* `Amoss_`
  * The only parts that are necessary - the framework itself.
* `AmossTest_`
  * The tests for the framework, and their supporting files.  Required if you want to enhance Amoss, not so useful otherwise, but worth keeping if you can, just in case.  All `Amoss_` classes are defined as `@isTest`, meaning they do not count towards code coverage or Apex lines of codes.
* `AmossExample_`
  * Example classes and tests, showing simple use cases for Amoss in a runnable format.  There is no reason to keep these in your code-base once you've read and understand them.

## How do I use it?

### Constructing and using a Test Double

Amoss can be used to build simple stub objects - AKA Configurable Test Doubles, by:
* Constructing an `Amoss_Instance`, passing it the type of the class you want to make a double of.
* Asking the resulting 'controller' to generate a Test Double for you.

```java
    Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
    DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();
```

The result is an object that can be used in place of the object being stubbed.

Every non-static public method on the class is available, and when called, will do nothing.

If a method has a return value, then `null` will be returned.

You then use the Test Double as you would any other instance of the object.

In this example, we're testing `scheduleDelivery` on the class `Order`.

The method takes a `DeliveryProvider` as a parameter, calls methods against it and then returns `true` when the delivery is successfully scheduled:

```java

Test.startTest();
    Order order = new Order().setDeliveryDate( deliveryDate ).setDeliveryPostcode( deliveryPostcode );
    Boolean scheduled = order.scheduleDelivery( deliveryProviderDouble );
Test.stopTest();

System.assert( scheduled, 'scheduleDelivery, when called for an order that can be delivered, will check the passed provider if it can delivery and return true if the order can be' );

```

What we need to do, is configure our Test Double version of `DeliveryProvider` so that tells the order that it can deliver, and then allows the order to schedule it.

### Configuring return values

We can configure the Test Double, so that certain methods return certain values by calling `when`, `method` and`willReturn` against the controller.

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .when( 'canDeliver' )
        .willReturn( true )
    .also().when( 'scheduleDelivery' )
        .willReturn( true );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

Now, whenever either `canDeliver` or `scheduleDelivery` are called against our double, `true` will be returned.  This is regardless of what parameters have been passed in.

#### Responding based on parameters

If we want our Test Double to be a little more strict about the parameters it recieves, we can also specify that methods should return particular values *only when certain parameters are passed* by using methods like `withParameter`, `thenParameter`:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .when( 'canDeliver' )
        .withParameter( deliveryPostcode )
        .thenParameter( deliveryDate )
        .willReturn( true )
    .also().when( 'canDeliver' )
        .willReturn( false );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

We can also use a 'named parameter' notation, by using the methods `withParameterNamed` and `setTo`:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .when( 'canDeliver' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
        .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
        .willReturn( true )
    .also().when( 'canDeliver' )
        .willReturn( false );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

If we want to be strict about some parameters, but don't care about others we can also be flexible about the contents of particular parameters, using `withAnyParameter`, and `thenAnyParameter`:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .when( 'canDeliver' )
        .withParameter( deliveryPostcode )
        .thenAnyParameter()
        .willReturn( true );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

Or, when using 'named notation', we can simply omit them from our list:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .when( 'canDeliver' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode ) // since we don't mention 'deliveryDate', it can be any value
        .willReturn( true )
    .also().when( 'canDeliver' )
        .willReturn( false );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

This is very useful for making sure that our tests only configure the Test Doubles to care about the parameters that are important for the tests we are running, making them less brittle.

There are several ways of specifying the expected values of parameters, and the details are covered later in the documentation.

### Using the Test Double as a Spy

The controller can then be used as a Test Spy, allowing us to find out what values where passed into methods by using `latestCallOf` and `call` and `get().call()`:

```java

System.assertEquals( deliveryPostcode, deliveryProviderController.latestCallOf( 'canDeliver' ).parameter( 0 )
                    , 'scheduling a delivery, will call canDeliver against the deliveryProvider, passing the postcode required, to find out if it can deliver' );

System.assertEquals( deliveryDate, deliveryProviderController.call( 0 ).of( 'canDeliver' ).parameter( 1 )
                    , 'scheduling a delivery, will call canDeliver against the deliveryProvider, passing the date required, to find out if it can deliver' );

```

Much like when we set the expected parameters, we can also name the parameters:

```java

System.assertEquals( deliveryPostcode, deliveryProviderController.latestCallOf( 'canDeliver' ).parameter( 'postcode' )
                    , 'scheduling a delivery, will call canDeliver against the deliveryProvider, passing the postcode required, to find out if it can deliver' );

System.assertEquals( deliveryDate, deliveryProviderController.call( 0 ).of( 'canDeliver' ).parameter( 'deliveryDate' )
                    , 'scheduling a delivery, will call canDeliver against the deliveryProvider, passing the date required, to find out if it can deliver' );

```

This allows us to check that the correct parameters are passed into methods when there are no visible effects of those parameters, and to do so in a way that follows the standard format of a unit test.

### Using the Test Double as a Mock Object

A very similar configuraiton syntax can be used to define the Test Double as a self validating Mock Object using `expects` and `verify`:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .expects( 'canDeliver' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
        .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
        .returning( true )
    .then().expects( 'scheduleDelivery' )
        .withParameter( deliveryPostcode )  // once again, either syntax is fine
        .thenParameter( deliveryDate )
        .returning( true );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...

deliveryProviderController.verify();
```

When done, the Mock will raise a failure if any method other than those specified are called, or if any method is called out of sequence.

`verify` then checks that every method that was expected, was called, ensuring that all the expecations were met.

This can be very useful if the order and completeness of processing is absolutely vital.

A single object can be used as both a Mock and a Test Spy at the same time:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .expects( 'canDeliver' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
        .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
        .returning( true )
    .also().when( 'scheduleDelivery' )
        .willReturn( true );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...

deliveryProviderController.verify();

System.assertEquals( deliveryPostcode, deliveryProviderController.latestCallOf( 'scheduleDelivery' ).parameter( 'postcode' )
                    , 'scheduling a delivery, will call scheduleDelivery against the deliveryProvider, passing the postcode required' );
```

This will then allow `scheduleDelivery` to be called at any time (and any number of times), but `canDeliver` must be called with the stated parameters, and must be called exactly once.

### Configuring a stricter Test Double that isn't a Mock Object

If you like the way Test Spies have clear assertions, but don't want just any method to be allowed to be called on your Test Double, you can use `allows`

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .allows( 'canDeliver' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
        .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
        .returning( true )
    .also().allows( 'scheduleDelivery' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
        .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
        .returning( true );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

This means that `canDeliver` and `scheduleDelivery` can be called in any order, and do not *have* to be called, but that *only* these two methods with these precise parameters can be called, and any other method called against the Test Double will result a test failure.

## Specifying parameters in different ways

All of the below can be used with either `withParameter` or `withParameterNamed`.

### `setTo`

In general, will check that the expected and passed values are the same instance, unless object specific behaviour has been defined.

It is probably the most common method of checking values, particularly when you care that the Sobjects / Objects / collections are the same instance and therefore may be mutated by the methods correctly - for example, when you are testing trigger handlers that aim to mutate the trigger context variables.

In detail, it checks that the passed parameter:

* If an Sobject / List / Set / Map, equals the expected, as per the behaviour of '===', being:
  * That the expected and passed objects are the same instance.

* Otherwise, as per the behaviour of '==', being:
  * If the parameter is a primitive -  that the value is the same.
  * If the parameter is an Object that does not implement `equals`:
    * That the expected and passed objects are the same instance.
  * If the parameter is an Object that does implement `equals`:
    * That the return of `equals` is true.

Note: the specification of `withParmeter( value )` is shorthand for `withParameter().setTo( value )`.

### `setToTheSameValueAs`

Attempts to check that the expected and passed values evaluate to the same value, regardless of whether they are the same instance.

Used when you don't have access to the instances that are likely to be passed, or if it is unimportant that the objects are new instances.  For example, it may be used to check the values of parameters where the objects are constructed within the method under test.

In detail, it checks that the expected and passed values equal each other when serialised as JSON strings.

You should note that this may not be reliable in all situations, but should suffice for the majority of use cases.

Examples:
```java
classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameter().setToTheSameValueAs( anObject )
        .willReturn( 'theReturn' );

classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameterNamed( 'parameterName' ).setToTheSameValueAs( anObject )
        .willReturn( 'theReturn' );
```

### sObject Specific Comparisons

#### `withFieldsSetLike` / `withFieldsSetTo`

Used to check the field values of sObjects when only some of the fields are important.  For example, you may check that certain fields are populated by the method under test before passing them into the method being doubled.  This allows you to specify the fields that will be set without concerning your test with the other values, which will be incidental.

* `withFieldsSetLike` - Receives an sObject
* `withFieldsSetTo` - Receives a `Map<String,Object>`

For each of the properties set on the 'expected' object, the passed sObject is checked.  Only if all the specified properties match will the passed object 'pass'.

The passed object may have more properties set, and they can have any value.

Examples:
```java
classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameter().withFieldsSetLike( new Contact( FirstName = 'theFirstName', LastName = 'theLastName' ) )
        .willReturn( 'theReturn' );

classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameterNamed( 'parameterName' ).withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'theFirstName', 'LastName' => 'theLastName' } )
        .willReturn( 'theReturn' );
```

### List Specific Comparisons

#### `withAnyElement`

Used to check that a parameter is a list that contains *any* of the elements passing the specified condition.  It can be used with any of the matching methods that you can use directly on the parameter (e.g. `setTo`, `setToTheSameValueAs`, etc), with the exception of the other list comparisons (I.E. you cannot check a list within a list.  Yet).

* `withAnyElement` - Requires a further condition to be defined.

Examples:
```java
classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameter().withAnyElement().setTo( 'expectedString' )
        .willReturn( 'theReturn' );

classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameterNamed( 'parameterName' ).withAnyElement().withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'theFirstName', 'LastName' => 'theLastName' } )
        .willReturn( 'theReturn' );
```

#### `withAllElements`

Used to check that a parameter is a list where *all* of the elements pass the specified condition.  It can be used with any of the matching methods that you can use directly on the parameter (e.g. `setTo`, `setToTheSameValueAs`, etc), with the exception of the other list comparisons (I.E. you cannot check a list within a list.  Yet).

* `withAllElements` - Requires a further condition to be defined.

Examples:
```java
classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameter().withAllElements().setTo( 'expectedString' )
        .willReturn( 'theReturn' );

classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameterNamed( 'parameterName' ).withAllElements().withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'theFirstName', 'LastName' => 'theLastName' } )
        .willReturn( 'theReturn' );
```

#### `withElementAt`

Used to check that a parameter is a list where the element at the given position passes the specified condition.  It can be used with any of the matching methods that you can use directly on the parameter (e.g. `setTo`, `setToTheSameValueAs`, etc), with the exception of the other list comparisons.

* `withElementAt` - Requires an element position to be defined, followed by a further condition.

Examples:
```java
classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameter()
            .withElementAt( 0 ).setTo( 'expectedString-number1' )
            .withElementAt( 1 ).setTo( 'expectedString-number2' )
        .willReturn( 'theReturn' );

classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameterNamed( 'parameterName' )
            .withElementAt( 0 ).withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'Person1' } )
            .withElementAt( 1 ).withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'Person2' } )
        .willReturn( 'theReturn' );
```

#### Combining list specifications

All of the list based specifications can be combined, providing the opportunity to create quite complex parameter checking with simple structures.

For example, you may want to check that every Contact in a list has the 'PersonAccount' flag set, and then also check the particular Names of the Contacts at the same time, maybe to ensure they are passed in a particular order.  You might do that with:

```java
classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameter()
            .withAllElements().withFieldsSetTo( new Map<String,Object>{ 'IsPersonAccount' => true } )
            .withElementAt( 0 ).withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'Person1' } )
            .withElementAt( 1 ).withFieldsSetTo( new Map<String,Object>{ 'FirstName' => 'Person2' } )
        .willReturn( 'theReturn' );
```

### Custom Verifiers

If the standard means of verifying parameters doesn't give you the level of control you need, you might consider writing a custom verifier.

Before you do so, you might consider if you would be better served by making your Test Double's behaviour less specific and using it as a Test Spy (check parameters after the call).  Doing so will likely result in a more readable test that is less brittle.

That said, if you need to, you can implement your own implementations of `Amoss_ValueVerifier` and pass it into the specification using `verifiedBy`.

For example:

```java
classToDoubleController
    .when( 'objectMethodUnderDouble' )
        .withParameterName( 'parameter1' ).verifiedBy( customVerifier )
        .willReturn( 'theReturn' );
```

An implementation must implement two methods:

* `toString` - A string representation that will be used when describing the expected call in a failed verify call against the Test Double's controller.
* `verify` - The method that will check the given value 'matches' the expected.

### Writing the `verify` method

`verify` is used in two ways:
* Checking that a method call matches an expectation, and ultimately issuing a failing assertion if it doesn't.
* Checking if a 'when' is applicable for a particular method call.

In order to ensure that that the method works in both situations, `verify` should check that the passed given value passes verification, by reporting any via throwing an exception of one the following types:
    * `Amoss_Instance.Amoss_AssertionFailureException`
    * `Amoss_Instance.Amoss_EqualsAssertionFailureException`

These exceptions are then either caught and resolved as a 'mis-match', or converted into a failed assertion.

When the Exception is raised, `setAssertionMessage` should be called to clearly define the failure.

E.g.

```java
throw new Amoss_Instance.Amoss_AssertionFailureException()
                                .setAssertionMessage( 'Value should be a Map indexed by Date, containing if each is a bank holiday' )
                                // or some other complex check
```

When using Amoss_EqualsAssertionFailureException, setExpected and setActual should also be set, with the values
being relevant within the context of the stated assertionMessage.

E.g.

```java
throw new Amoss_Instance.Amoss_EqualsAssertionFailureException()
                                .setExpected( 'Map<Date,Boolean>' )
                                .setActual( actualType )
                                .setAssertionMessage( 'Value should be a Map indexed by Date, containing if each is a bank holiday.  Was not the expected Type.' )
```
(Note that `setAssertionMessage` returns a `Amoss_AssertionFailureException`, so it is easiest to order the method calls this way round)

If other verifiers are used within a custom verifier, any `Amoss_AssertionFailureExceptions` can be caught and
have context added to the failure by calling addContextToMessage against the exception before re-throwing.

Care should be taken to ensure that no exceptions other than `Amoss_AssertionFailureExceptions` and its subclasses are
thrown.  This ensures that failures are clearly reported to the user.

In addition, no calls to `System.assert` or its variations should be made directly in this method otherwise unexpected behaviours may result, particularly when using the 'when' and 'allows' syntax.

## Other Behaviours

### Using Method Handlers

In some situations it is not enough to define a response statically in this way.

For example, you may require a response that is based on the values of a passed in parameter in a more dynamic way - like the Id of an Sobject that is passed in.

Also, you want to take advantage of some of the parameter checking and verify mechanisms of the framework for existing tests that currently use the standard Salesforce `StubProvider`.

For those situations, you can use `handledBy` in order to specify an object that will handle the call, perform processing and generate a return.

This method can take one of two types of parameter:
* `StubProvider` - Providing the full capabilities of the StubProvider interface means that you can re-use any pre-existing test code, as well as write new classes that utilise the full set of parameters (`methodName`, `parameterTypes`, etc), if so required.
* `Amoss_MethodHandler` - A much simpler version of a `StubProvider`-like interface means that you can create handler methods that are focused entirely on the parameter values of the called method.

#### Example using Amoss_MethodHandler

For example, you are testing a method that uses a method on another object (`ClassBeingDoubled.getContactId`) to get the Id from a Contact.  This method has a single parameter - the Contact.

You may implement this be defining an implementation of Amoss_MethodHandler and using that in your Test Double's definition:

```java
class ExampleMethodHandler implements Amoss_MethodHandler {
    public Object handleMethodCall( List<Object> parameters ) {
        Contact passedContact = (Contact)parameters[0];
        return passedContact.Id;
    }
}

@isTest
private static void methodBeingTested_whenGivenSomething_doesSomething() {

    Amoss_MethodHandler methodHander = new ExampleMethodHandler();

    Amoss_Instance objectBeingDoubledController = new Amoss_Instance( ClassBeingDoubled.class );

    objectBeingDoubledController
        .when( 'getContactId' )
            .withAnyParameter()
            .handledBy( methodHander );

    ...
```

Notice that you can still use `withParameter` and the related methods in order to specify the situations in which the handler will be called, as well as any of the other `expects`, `allows` and spy capabilities.

#### Example using StubProvider

Alternatively, you may define the handler class using the `StubProvider` interface.

E.g.

```java
class ExampleMethodHandler implements StubProvider {

    public Object handleMethodCall( Object       mockedObject,
                                    String       mockedMethod,
                                    Type         returnType,
                                    List<Type>   parameterTypes,
                                    List<String> parameterNames,
                                    List<Object> parameters ) {

        Contact passedContact = (Contact)parameters[0];
        return passedContact.Id;
    }
}

@isTest
private static void methodBeingTested_whenGivenSomething_doesSomething() {

    StubProvider methodHander = new ExampleMethodHandler();

    Amoss_Instance objectBeingDoubledController = new Amoss_Instance( ClassBeingDoubled.class );

    objectBeingDoubledController
        .when( 'getContactId' )
            .withAnyParameter()
            .handledBy( methodHander );

    ...
```

That is, `handledBy` is overloaded, and can take either definition type.  The behaviours being identical to each other.

### Throwing exceptions

Test Doubles can also be told to throw exceptions, using `throwing`, `throws` or `willThrow`:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .when( 'canDeliver' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
        .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
        .throws( new DeliveryProvider.DeliveryProviderUnableToDeliverException( 'DeliveryProvider does not have a delivery slot' ) );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

### Don't allow any calls

In some situations you may want to create a Mock Object that ensures that no calls are made against it.

For that, you can use `expectsNoCalls`.

This method cannot be used in conjunction with any other method definition (`expects`, `allows`, `when`). If an attempt is made to do so, an exception is thrown.

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .expectsNoCalls();

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();

...
```

It is valid to call `verify` against the controller at the end of the test, but this will always pass since the expected call stack will always be empty.

### Longer format .method definition

Occassionally you may find that the definition of the method name gets swamped by the other definitions.  In that situation you may want to use the slightly longer form `when().method( methodName )`, to more clearly highlight the methods being defined.

For example:

```java

Amoss_Instance deliveryProviderController = new Amoss_Instance( DeliveryProvider.class );
deliveryProviderController
    .expects()
        .method( 'canDeliver' )
        .withParameterNamed( 'postcode' ).setTo( deliveryPostcode )
        .andParameterNamed( 'deliveryDate' ).setTo( deliveryDate )
        .returning( true )
    .also().when()
        .method( 'scheduleDelivery' )
        .willReturn( true );

DeliveryProvider deliveryProviderDouble = (DeliveryProvider)deliveryProviderController.getDouble();
```
The `method` variation is available for all three method definition scenarios: `when`, `allows` and `expects`.

## What? When?

With such flexibility, it's important that you make good decisions on which behaviours to use, and when.

The decision will be based on a balance of two main factors:
* Ensuring that you produce a meaningful test of the behaviour, whilst
* Limiting the scope of test changes that are required when the implementation of the classes that are being stubbed or tested change.

The following aims to describe when to each of the constructs, roughly referencing the types of "Test Doubles" that are described in Gerard Meszaros's book "xUnit Test Patterns".

### Test Stub

Is the least brittle of the constructs, allowing any method to be called, potentially with any parameters.  In most cases, some return values for some methods will be specified.

Typically used to replace ('stub out') an object that is not the focus of the test, but on which the test relies, often in order to direct the object under test into a specificaly required behaviour.

That is, the object provides some functionality that means that the test can run, but it is not the calling of methods on this object that define the behaviour that is being tested.

However, it is likely that the test will check that the method under tests acts in a particular way when it receives certain values from the methods being stubbed.

It is of particular note that when implemented using 'withAnyParameter' (or without parameters being specified), the method signatures of the object being stubbed can change without impacting the tests.

#### Is characterised by the pattern: when.with.willReturn

```java

testDoubleController
    .when( 'methodName1' )
        .withAnyParameters()    // this is actually redundant, as the default behaviour is 'withAnyParameters'
        .willReturn( true )
    .also().when( 'methodName2' )
        .withAnyParameters()
        .willReturn( true );
```

If return values do not need to be specified, may be as simple as:

```java
    ObjectUnderTestDouble testDouble = (ObjectUnderTestDouble)( new Amoss_Instance( ObjectUnderTestDouble.class ).getDouble() );
```

#### Brittle?

* Additions to the interface of the object being stubbed will not break the test, unless particular return values are required in the test.
* Changes to the interface of existing methods will not break tests when `withAnyParameters` or `withAnyParameter` are used and the parameters do not need to be reflected in the return values.
* Changes to the interface of existing methods may break tests when parameter values are specified in the configuration.
* Generally not affected by changes the implementation of the method under test that affect the order of processing in, or number of method calls made by the method under test.
* Is affected by changes in the implementation of the method under test where the change results in different values being returned by the methods being stubbed.

### Strict Test Stub

Similar to a Test Stub, although is defined in such a way that *only* the methods that are configured are allowed to be called.

Also typically used when the object being stubbed is not the focus of the test, and potentially the parameter values being passed in are not of importance.

However, it is implied that it is important that *other* methods, those not specified, are *not* called.

Is not particularly brittle to changes in the implementation of the class being 'stubbed'.  However, tests may start to break when the implementation under test changes and new methods are called against that object.

#### Is characterised by the pattern: allows.with.returning

```java

testDoubleController
    .allows( 'methodName1' )
        .withAnyParameters()
        .returning( true )
    .also().allows( 'methodName2' )
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

Is specified intially in the same way as a Test Stub, though after the method under test is executed, the controller is then interrogated to determine the value of parameters.

Typically used to create a Test Double of an object that *is* the focus of the test.

That is, the test is checking that the method under test calls particular methods on the given Test Double passing parameters with certain values that are predictable.

Can be used to test that individual methods are called, and the order in which that particular method is called.  However, cannot be used to test that different methods are called in a particular sequence.  In order to do that, a Mock Object (see below) is required.

#### Is characterised by the pattern: when.with.willReturn followed by call.of.parameter

```java

spiedUponObjectController
    .when( 'methodName1' )
        .withAnyParameters()
        .willReturn( true )
    .also().when( 'methodName2' )
        .withAnyParameters()
        .willReturn( true );

// followed by

System.assertEquals( 'expectedParameterValue1',
                        spiedUponObjectController.latestCallOf( 'method1' ).parameter( 'parameter1' ),
                        'methodUnderTest, when called will pass "expectedParameterValue1" into "method1"' );

System.assertEquals( 'expectedParameterValue2',
                        spiedUponObjectController.call( 0 ).of( 'method2' ).parameter( 'parameter2' ),
                        'methodUnderTest, when called will pass "expectedParameterValue2" into "method2"' );

```

### Strict Test Spy

Similar to a Test Spy, although is defined in such a way that *only* the methods that are configured are allowed to be called.

As with the Test Spy, is used to create a Test Double an object that *is* the focus of the test.

That is, the test is checking that the method under test calls particular methods on the given Test Double passing parameters with certain values that are predictable.

Can be used to test that individual methods are called, and the order in which that particular method is called.  However, cannot be used to test that different methods are called in a particular sequence.  In order to do that, a Mock Object (see below) is required.

It is implied that it is important that *other* methods, those not specified, are *not* called.

#### Is characterised by the pattern: allows.with.willReturn followed by call.of.parameter

```java

spiedUponObjectController
    .allows( 'methodName1' )
        .withAnyParameters()
        .willReturn( true )
    .also().allows( 'methodName2' )
        .withAnyParameters()
        .willReturn( true );

// followed by

System.assertEquals( 'expectedParameterValue1',
                        spiedUponObjectController.latestCallOf( 'method1' ).parameter( 'parameter1' ),
                        'methodUnderTest, when called will pass "expectedParameterValue1" into "method1"' );

System.assertEquals( 'expectedParameterValue2',
                        spiedUponObjectController.call( 0 ).of( 'method2' ).parameter( 'parameter2' ),
                        'methodUnderTest, when called will pass "expectedParameterValue2" into "method2"' );

```

### Mock Object

Similar to a Test Spy, although is defined in such a way that *only* the methods that are configured are allowed to be called, and only in the order that they are specified.

If any specified method is called out of order, or with the wrong parameters, it will fail the test.

Is therefore used to 'mock' an object when the order of execution of different methods is important to the success of the test.

It is also implied that it is important that *other* methods, those not specified, are *not* called.

Because of the strict nature of the specification, this is the most brittle of the constructs, and often results in tests that fail when the implementation of the method under test is altered.

#### Is characterised by the pattern: expects.with.willReturn followed by verify

```java

mockObjectController
    .expects( 'methodName1' )
        .withParameter( 'expectedParameterValue1' )
        .willReturn( true )
    .then().expects( 'methodName2' )
        .withParameter( 'expectedParameterValue2' )
        .willReturn( true );

// followed by
mockObjectController.verify();

```

### Summary

In all cases, 'willReturn' or 'returning' could be replaced with 'throws' or 'handledBy' without changing the categorisation of the Test Double in question.

Type                | Use Cases | Brittle? | Construct Pattern
------------------- | --------- | -------- | ------------------------
Test Stub           | Ancillary objects, parameters passed are not the main focus of the test             | Least brittle | when.with.willReturn
Strict Test Stub    | Ancillary objects, parameters passed are not the main focus of the test             | Brittle to addition of new calls on object being stubbed | allows.with.returning
Test Spy            | Focus of the test, order of execution is not important, prefer the assertion syntax | Is brittle to the interface of the object being stubbed, less brittle to the implementation of the method under test | when.with.willReturn, call.of.parameter
Strict Test Spy     | Focus of the test, order of execution is not important, prefer the assertion syntax | Is brittle to the interface of the object being stubbed and addition of new calls on object being stubbed, a little more brittle to the implementation of the method under test | allows.with.returns, call.of.parameter
Mock Object         | Focus of the test, order of execution is important                                  | Most brittle construct, brittle to the implementation of the method under test | expect.with.returning, verify

## Synonyms

Some of the functions have synonyms, allowing you to choose the phrasing that is most readable for your team.

Purpose                                                            | Synonyms
------------------------------------------------------------------ | ---------------------------------
Specifying individual parameters (positional notation)             | `withParameter`, `thenParameter` (I.E. start with withParameter, otherwise use thenParameter)
Stating that any single parameter is allowed (positional notation) | `withAnyParameter`, `thenAnyParameter` (I.E. start with withAnyParameter, otherwise use thenAnyParameter)
Specifying individual parameters (named notation)                  | `withParameterNamed`, `andParameterNamed` (I.E. start with withParameterNamed, otherwise use andParameterNamed)
Stating the return value of a method                               | `returning`, `returns`, `willReturn`
Stating that a method throws an exception                          | `throwing`, `throws`, `willThrow`
Start the specification of an additional method                    | `then`, `also` (Generally use 'then' with 'expects', 'also' with 'when' and 'allows' )
Retrieving the parameters from a particular call of a method       | `call`, `get().call`
Retrieving the parameters from the latest call of a method         | `latestCallOf`, `call( -1 ).of`

## Limitations

Since the codebase uses that Salesforce provided StubProvider as its underlying mechanism for creating the Test Double, it suffers from the same fundamental limitations.

Primarily these are:
* The following cannot have Test Doubles generated:
  * Sobjects
  * Classes with only private constructors (e.g. Singletons)
  * Inner Classes
  * System Types
  * Batchables
* Static and Private methods may not be stubbed / spied or mocked.
* Member variables, getters and setters may not be stubbed / spied or mocked.
* Iterators cannot be used as return types or parameter types.

For more information, see here: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_interface_System_StubProvider.htm

## Release Notes

Release notes for Amoss can be found [here](./RELEASE_NOTES.md), and changes on this branch that are pending release into the Unlocked Package / Release Tags can be found [here](./PENDING_RELEASE_NOTES.md).

## Acknowledgements / References

Thanks to Aidan Harding (https://twitter.com/AidanHarding), for kickstarting the whole process.  If it wasn't for his post on an experiment he did https://twitter.com/AidanHarding/status/1276512814421639168, this project probably wouldn't have started.

You can find the repo with his experimental implementation here: https://github.com/aidan-harding/apex-stub-as-mock

Also to Martin Fowler for the beautifully succinct article referenced in that tweet - https://martinfowler.com/articles/mocksArentStubs.html

And Gerard Meszaros for his book "xUnit Test Patterns", from which many of the ideas of how Mocks, Spies and Test Doubles should work are taken.
