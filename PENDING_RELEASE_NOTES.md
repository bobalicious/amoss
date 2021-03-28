# Release Notes since Last Release

Added the methods:
* byDefaultMethodsReturn
* isFluent

generateDouble will now always return the same instance.  This is to allow the easy generation of a fluent interface.
generateNewDouble added, which will generate a new instance.  This includes internally cloning the Amoss_Instance to that isFluent objects will return the right instance.