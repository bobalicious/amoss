# Amoss for HttpCalloutMocks

Apex Mock Objects, Spies and Stubs can be used to create HttpCalloutMocks using a syntax that is very similar to that which is used to create other Test Doubles.

Because the HttpCalloutMock capabilities are built on top of the core of Amoss, it can take advantage of most of the capabilities of that core, including conditional behaviours and true mock object behaviours and verifications.

Whilst you do not need to understand everything about the core of Amoss to use it to build HttpCalloutMocks - it is built to be as simple as possible to use, understanding core Amoss is recommended and will make using it in this way simpler and explain some of the more advanced capabilities.  Therefore it is recommended that you read and understand [that documentation](README.md) before you start using Amoss.

That said - if you're comfortable with what you see here, why not give it a try anyway!

## Building a simple HttpCalloutMock

The simplest HttpCalloutMock that can be created is one that will always return the same result - an empty HttpResponse object.

```java

Amoss_Instance httpCalloutMock = new Amoss_Instance();

httpCalloutMock
    .isACalloutMock();
```

Calling `isACalloutMock` will tell the Amoss_Instance to create a Test Double of the HttpCalloutMock interface, and the register it as the Callout Mock.
I.E. There is no need to call `Test.setMock`, Amoss does this for you.

In general, this is unlikely to be useful, since our code will rely on the callout returning some data in our response.  At the very least, we probably need status codes.

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

Sets the status of the response that will be returned.  I.E. calls `HttpResponse.setStatus( value )`.

### `respondsWith().statucCode( value )`

Sets the status code of the response that will be returned.  I.E. calls `HttpResponse.setStatusCode( value )`.

### `respondsWith().body( value )`

Sets the contents of the body that will be returned.  I.E. calls the appropriate variation of `HttpResponse.setBody...`.

That is,

* If `value` is a `String`, will call `HttpResponse.setBody( value )`
* If `value` is a `Blob`, will call `HttpResponse.setBodyAsBlob( value )`
* If `value` is any other type of `Object`, will JSON serialize the contents of `value` before passsing it into `HttpResponse.setBody`

### `respondsWith().header( key ).setTo( value )`

Sets the value of the specified header on the response that will be returned.  I.E. calls `HttpResponse.setHeader( key, value )`.

### `throws( exception )` / `willThrow( exception )` / `throwing( exception )`

Instructs the HttpCalloutMock to throw the given exception when a matching call is made.

## Defining a conditional return

Obviously, some of the time we do not want the HttpCalloutMock to *always* behave in the same way - often we will:
* Want to make several calls to the service and have it return in different ways for each of the calls.
* Want to use the HttpCalloutMock to ensure that we call it in the appropriate way.

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

If the above conditions aren't met, then the default - in this case an empty `HttpResponse` is returned.

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

### `method( httpMethod )`

Verifies that the given `HttpRequest` has the specified Method defined.

### `endpoint( uri )`

Verifies that the given `HttpRequest` has the endpoint set to the precise URI provided.

### `header( key ).setTo( value )`

Verifies that the given `HttpRequest` has the specifed header set to the value provided.

### `body( value )`

Verifies that the given `HttpRequest` has the body set to the value provided.

### `compressed()` / `notCompressed()`

Verifies that the given `HttpRequest` is, or is not compressed.

## Different Verifiers

As is described in the example above, some of the properties can be checked for different properties.

This is true of the following:
* endpoint
* body
* header

The following options are available:

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

The following describes them in simple terms, though the documentation for the core of Amoss describes the precise behaviour and gives descriptions of when you would decide to use one over another.  It is strongly recommended that you read the core documentation to understand these concepts.

### `allows()`

Defines that the only calls that are allowed against the service are those defined in against the HttpCalloutMock.

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

## Test Spy Behaviours

As with core

## Custom verifiers - `verifiedBy( verifier )`

TBD

### `Amoss_ValueVerifier`

TBD

### `Amoss_HttpRequestVerifier`

TBD

## Custom handlers - `handledBy( handler )`

TBD

### `StubProvider`

TBD

### `Amoss_MethodHandler`

TBD

### `HttpCalloutMock`

TBD
