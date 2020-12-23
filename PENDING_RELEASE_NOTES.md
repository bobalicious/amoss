# Release Notes since Last Release

Introduced a slighty shorter format for defining `when`, `allows` and `expects`.

For example:
* `when( 'methodName' ).willReturn( 'value' )`
* `allows( 'methodName' ).willReturn( 'value' )`
* `expects( 'methodName' ).willReturn( 'value' )`

Introduced parameter-free version of `allowsAnyCall` that is equivalent to `allowsAnyCall( true )`
