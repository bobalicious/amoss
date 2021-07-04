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

Calling `isACalloutMock` will tell the Amoss_Instance to create a Test Double of the HttpCalloutMock interface, and the register it as the Callout Mock.  I/I.E. There is no need to call `Test.setMock`, Amoss does this for you.

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
            .statucCode( 200 )
            .body( Map<String,Object>{ 'parameter' => 'value' } )
            .header( 'ResponseHeaderKey' ).setTo( 'value' )
```

The above defines the full shape of the `HttpResponse` object that is returned whenever a callout is made, and the majority will be entirely self evident.

### respondsWith().status( value )

Sets the status of the response that will be returned.  I.E. calls `HttpResponse.setStatus( value )`.

### respondsWith().statucCode( value )

Sets the status code of the response that will be returned.  I.E. calls `HttpResponse.setStatusCode( value )`.

### respondsWith().body( value )

Sets the contents of the body that will be returned.  I.E. calls the appropriate variation of `HttpResponse.setBody...`.

That is,

* If `value` is a `String`, will call `HttpResponse.setBody( value )`
* If `value` is a `Blob`, will call `HttpResponse.setBodyAsBlob( value )`
* If `value` is any other type of `Object`, will JSON serialize the contents of `value` before passsing it into `HttpResponse.setBody`

### respondsWith().header( key ).setTo( value )

Sets the value of the specified header on the response that will be returned.  I.E. calls `HttpResponse.setHeader( key, value )`.

### throws( exception ) / willThrow( exception ) / throwing( exception )

TBD

## Defining a conditional return

TBD

### `method( httpMethod )`

TBD

### `endpoint( uri )`

TBD

### `header( key ).setTo( value )`

TBD

### `body( value )`

TBD

### `compressed()` / `notCompressed()`

TBD

## Different Verifiers

TBD

### `setTo( value )`

TBD

### `set`

TBD

### `containing( value )`

TBD

### `matching( expression )`

TBD

## Defining multiple returns

TBD

### `when()` / `allows()` / `expects()`

TBD

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
