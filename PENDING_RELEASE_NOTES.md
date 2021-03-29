# Release Notes since Last Release

## Breaking Change

The following changes allow for the creation of `isFluent`, including providing it consistent behaviour when new doubles are created.  It also cleans up what was a slightly misleading interface.

* `generateDouble` has been renamed `getDouble`, and will now always return the same instance of the object being doubled.
* `generateNewDouble` has been added, which will generate a new instance.  This includes internally cloning the Amoss_Instance.  However, there is no direct access to this cloned instance.

Added the following methods:
* `byDefaultMethodsReturn`
* `isFluent`

