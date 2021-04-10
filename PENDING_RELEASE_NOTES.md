# Release Notes since Last Release
Added the following methods for checking parameters:
* `set` - Checks that the stated element is not 'null'
* `containing` - Check that the stated element is a String and contains the given String

Added the following general methods:
* `getDouble` - Returns the most recently generated double from this `Amoss_Instance`.
* `byDefaultMethodsReturn` - Sets the return value for any methods that are not otherwise described by `when`/`allows`/`expects`.
* `isFluent` - Sets the return value for any methods that are not otherwise described by `when`/`allows`/`expects` to be `this`.
* `createClone` - Creates a new instance of Amoss_Instance, set with the same configuration as the existing one.

