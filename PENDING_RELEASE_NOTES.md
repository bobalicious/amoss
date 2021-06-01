# Release Notes since Last Release
* Added the ability to specify HttpCalloutMock implementations using the Amoss grammar directly.  E.g.
```
Amoss_Instance mockHttp = new Amoss_Instance( Amoss_HttpCalloutMock.class );
mockHttp
    .isACalloutMock()
        .expects()
            .method( 'GET' )
            .endpoint( 'http://api.example.com/accounts' )
        .respondsWith()
            .statusCode( 200 )
            .status( 'Complete' )
            .body( '[{"Name":"sForceTest1"}]' );
```

* Can now specify multiple verifiers for a single named parameter by referencing the same parameter multiple times. E.g.
```
controller
    .when( 'method' )
    .withParameterNamed( 'param1' ).containing( 'string1' )
    .andParameterNamed( 'param1' ).containing( 'string2' )
```

* Added `withParameterNamed` as a synonym for `andParameterNamed`. E.g.
```
controller
    .when( 'method' )
    .withParameterNamed( 'param1' ).setTo( 'value1' )
    .withParameterNamed( 'param2' ).setTo( 'value2' )
```