# Amoss for HttpCalloutMocks

Apex Mock Objects, Spies and Stubs can be used to create `HttpCalloutMocks` using a syntax that is very similar to that which is used to create other Test Doubles.

Because the `HttpCalloutMock` capabilities are built on top of the core of Amoss, it can take advantage of most of the capabilities of that core, including conditional behaviours and true mock object behaviours and verifications.

Whilst you do not need to understand everything about the core of Amoss to use it to build `HttpCalloutMocks` - it is built to be as simple as possible to use - understanding core Amoss is recommended and will make using it to generate `HttpCalloutMocks` simpler and explain some of the more advanced capabilities.  Therefore it is recommended that you read and understand [that documentation](README.md) before you start using Amoss.

That said - if you're comfortable with what you see here, why not give it a try...

## Building a simple `HttpCalloutMock`

The simplest `HttpCalloutMock` that can be created is one that will always return the same result - an empty `HttpResponse` object.

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock();
```

Calling `isACalloutMock` will:
* Tell the Amoss_Instance to create a Test Double of the `HttpCalloutMock` interface
* Register the generated Test Double as the Callout Mock.
** I.E. There is no need to call `Test.setMock`, Amoss does this for you.

In general, this is unlikely to be useful, since our code will rely on the callout returning some data in our response.  At the very least, we probably need status codes to be returned

## Defining a default return

If we always want our callout to return the same response, we can define a default response for it by calling `byDefault` and then defining the shape of the response:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .byDefault()
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 )
            .body( Map<String,Object>{ 'parameter' => 'value' } )
            .header( 'ResponseHeaderKey' ).setTo( 'value' )
```

The above defines the full shape of the `HttpResponse` object that is returned whenever a callout is made, and the majority will hopefully be self evident.

### `respondsWith().status( value )`

Sets the status of the response that will be returned.
I.E. calls `HttpResponse.setStatus( value )`.

### `respondsWith().statusCode( value )`

Sets the status code of the response that will be returned.
I.E. calls `HttpResponse.setStatusCode( value )`.

### `respondsWith().body( value )`

Sets the contents of the body that will be returned.
I.E. calls the appropriate variation of `HttpResponse.setBody...`.

That is,

* If `value` is a `String`, will call `HttpResponse.setBody( value )`
* If `value` is a `Blob`, will call `HttpResponse.setBodyAsBlob( value )`
* If `value` is any other type of `Object`, will JSON serialize the contents of `value` before passsing it into `HttpResponse.setBody`

### `respondsWith().header( key ).setTo( value )`

Sets the value of the specified header on the response that will be returned.  I.E. calls `HttpResponse.setHeader( key, value )`.

### `throws( exception )` / `willThrow( exception )` / `throwing( exception )`

Instructs the `HttpCalloutMock` to throw the given exception when a matching call is made.

## Defining a conditional return

Obviously, for some tests, we do not want the `HttpCalloutMock` to *always* behave in the same way - often we will:
* Want to make several calls to the service and have it return in different ways for each of the calls so we can check dependent behaviours.
* Want to use the `HttpCalloutMock` to check that services are called it in the appropriate way.

For those situations, we can specify the conditions under which the specified response will be returned.

For example:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .when()
        .method( 'GET' )
        .endpoint().contains( '/account/' )
        .header( 'Authorization' ).isSet()
        .compressed()
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 )
            .body( Map<String,Object>{ 'parameter' => 'value' } )
            .header( 'ResponseHeaderKey' ).setTo( 'value' );
```

In this situation, the service will return a 200 status code and the body if, and only if the stated conditions are met:
* The HTTP Method is 'GET'
* The Endpoint that is called contains the string `/account/`
* The Header with the key `Authorization` is set to a non blank value
* The `HttpRequest` is 'compressed'

If the above conditions aren't met, then the default - in this case an empty `HttpResponse` - is returned.

Multiple conditions can be defined, alongside a default.  So, the following is valid:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .when()
        .method( 'GET' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 )
            .body( Map<String,Object>{ 'parameter' => 'value' } )
    .also().when()
        .method( 'POST' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 )
    .byDefault()
        .respondsWith()
            .status( 'Not Found' )
            .statusCode( 404 )
```

And so:
* All GET and POST requests will get a 200 - Complete
* GET requests will also have a body set
* Any other method will result in a 404 - Not Found

## Common Verification Methods

The above example uses some of the common mechanisms for verifying the properties of the passed `HttpRequest` object.

#### `method( httpMethod )`

Verifies that the given `HttpRequest` has the specified Method defined.

#### `endpoint( uri )`

Verifies that the given `HttpRequest` has the endpoint set to the precise URI provided.

#### `header( key ).setTo( value )`

Verifies that the given `HttpRequest` has the specifed header set to the value provided.

#### `body( value )`

Verifies that the given `HttpRequest` has the body set to the value provided.

#### `compressed()` / `notCompressed()`

Verifies that the given `HttpRequest` is, or is not compressed.

## Verifier Variations

In addition to these core verifications, certain `String` properties can also be checked in more advanced ways.

This is true of the following:
* endpoint
* body
* header

For those properties, the following options are available:

### `setTo( value )`

Verifies that the given property is set to the given value.

For example:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .when()
        .endpoint().setTo( 'http://example.com/account/12345' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );
```

### `set()`

Verifies that the given property is set to a non empty String.

For example:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .when()
        .header( 'Authorization' ).setTo()
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );
```

### `containing( value )`

Verifies that the given property contains the given value.

For example:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .when()
        .endpoint().contains( 'account/12345' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );
```

### `matching( expression )`

Verifies that the given property matches the given regular expression.

Note that this follows the Apex standard of requiring that the *whole* of the String matches

For example:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .when()
        .endpoint().matches( '.*/account/12345' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );
```

## `when()` / `allows()` / `expects()`

As described in an above example, multiple behaviours can be defined by stringing together definitions using the `also().when()` notation.

In addition, Amoss provides other syntaxes for defining more strict behaviours.  This is in line with the core Amoss capabilities.

The following describes them in simple terms, though the documentation for the core of Amoss describes the precise behaviour and gives descriptions of when you would decide to use one over another.  It is strongly recommended that you read the [core documentation](README.md#using-the-test-double-as-a-mock-object) to understand these concepts.

### `allows()`

Defines that the only calls that are allowed against the service are those defined in against the `HttpCalloutMock`.

Any other call against the service will result in the test failing.

For example:
```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .allows()
        .method( 'GET' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 )
    .also().allows()
        .method( 'POST' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );
```

States that:
* All GET and POST requests will get a 200 - Complete
* GET requests will also have a body set
* Any other method will result in the test failing.

### `expects()`

States that the only calls that are expected against the service are those specified, and that they are expected to occur in the given order.

If any other call is made, the test will fail.

If any call is made out of sequence, the test will fail.

Once test is complete, `verify` may be called against the mock controller in order to ensure that *every* expected call was made

For example:
```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .expects()
        .method( 'GET' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 )
    .then().expects()
        .method( 'POST' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );

Test.startTest();
    // Do the stuff that is tested
Test.stopTest();

// Then verify that everything that was expected was called
httpCalloutMock.verify();

```

## `expectsNoCalls()`

When specified as `expectsNoCalls()`, the generated Mock will fail the test if any call is made to a service.

For example:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

new Amoss_Instance()
    .isACalloutMock()
    .expectsNoCalls();

```

This useful for ensuring that services are not called - for example checking that guard clauses work correctly.

## `allowsAnyCall( false )`

In addition, you can specify responses using the `when()` syntax, and still have the mock fail tests if any other calls are made, by specifying `allowsAnyCall( false )`.

For example:


```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

new Amoss_Instance()
    .isACalloutMock()
    .allowsAnyCall( false )
    .when()
        .method( 'GET' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );

```

The above will allow GET requests to be made, but will fail the test if any other method is used.

This is generally synonymous with using `allows()` in place of `when()`.

## Test Spy Behaviours

As with core, after a test has performed its actions, you can access the parameters that were passed into calls against the `HttpCalloutMock`.

So, for example, you can:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .expects()
        .method( 'GET' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 )
    .then().expects()
        .method( 'POST' )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );

Test.startTest();
    // Do the stuff that is tested
Test.stopTest();

HttpRequest requestZeroCalledWith   = (HttpRequest)httpCalloutMock.get().call(0).of( 'respond' ).parameter( 0 );
HttpRequest latestRequestCalledWith = (HttpRequest)httpCalloutMock.get().latestCallOf( 'respond' ).parameter( 0 );

```

Once retrieved, you can then make assertions against that `HttpRequest` object, if required.

For a full explanation of the capabilities of the Test Spy methods, review the [core documentation](README.md.#using-the-test-double-as-a-spy).

## Custom verifiers - `verifiedBy( verifier )`

It is possible that the methods provided with Amoss are not enough to verify the state of the `HttpRequest` that is passed into the mock.

If that's the case, it is possible to inject an object that implements one of the verifier interfaces.

Regardless of the interface used, the verifier can be assigned thus:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .when()
        .verifiedBy( customVerifier )
        .respondsWith()
            .status( 'Complete' )
            .statusCode( 200 );

```

### `Amoss_ValueVerifier`

A full explaination of how to implement this classes is defined in the [core documentation](README.md#custom-verifiers).

In short, it requires the implementation of a class that defines the following methods:
* `toString` - A string representation that will be used when describing the expected call in a failed verify call against the Test Double's controller.
* `verify` - The method that will check the given value 'matches' the expected.

The `verify` method should then check the passed parameter to see if it matches the expected shape, and throw an exception of the following types if it does not:
* `Amoss_Instance.Amoss_AssertionFailureException`
* `Amoss_Instance.Amoss_EqualsAssertionFailureException`

### `Amoss_HttpRequestVerifier`

Particular to the `HttpCalloutMock` implementation is an interface specifically designed for testing `HttpRequests`.

It is defined in the same way as the `Amoss_ValueVerifier` other than the fact that the `verify` method is defined as receiving an `HttpRequest` object.  This makes the implementation a little simpler.

## Custom handlers - `handledBy( handler )`

Similar to the verification scenraio, it is possible that the response to the call cannot be generated by Amoss's methods.  For example, if you require the `HttpResponse` to be built using some data from the `HttpRequest`.  Generally this is only required if you have a series of callouts that you need to mock and absolutely require a sequence of data that links together.

If that's the case, it is possible to inject an object that implements one of the method handler interfaces.

Regardless of the interface used, the handler can be registered as such:

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock()
    .expects()
        .method( 'GET' )
        .handledBy( customHandler );

```

Once again, a full explaination of how to implement this classes is defined in the [core documentation](README.md#using-method-handlers).

### `HttpCalloutMock`

The simplest mechanism is probably to define an implementation of the standard `HttpCalloutMock`.

Since Amoss can deal with the conditions under which the response is generated, this can be a much simpler version of the class than would normally be the case.  That is, there is no requirement to check the values of on the `HttpRequest` and change the behaviour based on those values.  Similarly, you should not check that values are 'valid'.  These should be handled by the configuration of the `Amoss_Instance`.

All the implementation should do is build the `HttpResponse` based on the `HttpRequest` that is passed in, and return it.

If there's no requirement to reference values in the passed in `HttpRequest`, then there is almost certainly no requirement for a class to be defined.

It is worth noting that the `HttpCalloutMock` method of generating responses does allow legacy tests to be migrated to take advantage of some of Amoss's capabilities with less re-write than would otherwise be the case.  Though it's recommended that this be a stop-gap solution in most situations.

### `Amoss_MethodHandler`

The Amoss supplied `Amoss_MethodHandler` can be used, and since this is the recommended approach for defining method handlers outside of the definition of Http Callout Mocks, this may be a desired approach in order to keep things similar across the whole of a codebase.

### `StubProvider`

In addition, the standard Salesforce `StubProvider` can be used, as in the core Amoss, though this is probably an overly complex solution and should be avoided.
