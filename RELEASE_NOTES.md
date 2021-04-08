# Version 1.0.1.0

* Git Tag                : `v1.0.1.0`
* SFDX Install           : `sfdx force:package:install --package "amoss@1.0.0-0"`
* Unlocked Package Links :
  * https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O1vJQAS
  * https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O1vJQAS


Fixed test failures when running in a namespaced org.

# Version 1.0.0.0

* Git Tag                : `v1.0.0.0`
* SFDX Install           : `sfdx force:package:install --package "amoss@1.0.0-0"`
* Unlocked Package Links :
  * https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O1vJQAS
  * https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O1vJQAS

Improved format of the Release Notes file.

Simplified internal implementation of some of the shortcuts (e.g. `withParameter( value )` ).

# Version 0.9.1.0

* Git Tag                : `v0.9.1.0`
* SFDX Install           : `sfdx force:package:install --package "amoss@0.9.1-0"`
* Unlocked Package Links :
  * https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O0PoQAK
  * https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O0PoQAK

Introduced a slighty shorter format for defining `when`, `allows` and `expects`.

For example:
* `when( 'methodName' ).willReturn( 'value' )`
* `allows( 'methodName' ).willReturn( 'value' )`
* `expects( 'methodName' ).willReturn( 'value' )`

Introduced parameter-free version of `allowsAnyCall` that is equivalent to `allowsAnyCall( true )`

# Version 0.9.0.1

* Git Tag                : `v0.9.0.1`
* SFDX Install           : `sfdx force:package:install --package "amoss@0.9.0-1"`
* Unlocked Package Links :
  * https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O0PeQAK
  * https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002O0PeQAK

Introduced the Release Notes file.
