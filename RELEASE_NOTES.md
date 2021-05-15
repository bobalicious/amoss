# Version 1.1.0.1

* Git Tag                : `v1.1.0.1`
* SFDX Install           : `sfdx force:package:install --package "amoss@1.1.0-1"`
* Unlocked Package Links :
  * https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002CcPdQAK
  * https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002CcPdQAK

Minor tidy of commits - no functional change

# Version 1.1.0.0

* Git Tag                : `v1.1.0.0`
* SFDX Install           : `sfdx force:package:install --package "amoss@1.1.0-0"`
* Unlocked Package Links :
  * https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002CcPYQA0
  * https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002CcPYQA0

Added the following methods for checking parameters:
* `set` - Checks that the stated element is not 'null'.
* `containing` - Check that the stated element is a String and contains the given String.
* `matching` - Check that the stated element is a String and matches the given Regular Expression.
* `aListOfLength` - Check that the stated element is a List of the given length.

Added the following general methods:
* `getDouble` - Returns the most recently generated double from this `Amoss_Instance`.
* `byDefaultMethodsReturn` - Sets the return value for any methods that are not otherwise described by `when`/`allows`/`expects`.
* `isFluent` - Sets the return value for any methods that are not otherwise described by `when`/`allows`/`expects` to be `this`.
* `createClone` - Creates a new instance of Amoss_Instance, set with the same configuration as the existing one.


# Version 1.0.1.0

* Git Tag                : `v1.0.1.0`
* SFDX Install           : `sfdx force:package:install --package "amoss@1.0.1-0"`
* Unlocked Package Links :
  * https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002CcFwQAK
  * https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4K000002CcFwQAK

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
