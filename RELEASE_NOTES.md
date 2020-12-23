# Version 0.9.1.0

* Git Tag               : `v0.9.1.0`
* SFDX Install          : `sfdx force:package:install --package "amoss@0.9.1-0"`
* Unlocked Package Link : https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O0PoQAK

Introduced a slighty shorter format for defining `when`, `allows` and `expects`.

For example:
* `when( 'methodName' ).willReturn( 'value' )`
* `allows( 'methodName' ).willReturn( 'value' )`
* `expects( 'methodName' ).willReturn( 'value' )`

Introduced parameter-free version of `allowsAnyCall` that is equivalent to `allowsAnyCall( true )`

# Version 0.9.0.1

* Git Tag               : `v0.9.0.1`
* SFDX Install          : `sfdx force:package:install --package "amoss@0.9.0-1"`
* Unlocked Package Link : https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O0PeQAK

Introduced the Release Notes file.