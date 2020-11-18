# Development Ideals

For those who are looking to contribute to the project.

In order for the project to succeed it must:

* Require as little code as possible to create Test Doubles, so that creating the Test Double does not get in the way of testing.
* Use natural language to express the configuration so tests are as clear as possible to read.
* Have an auto-complete considered class structure, so that IDEs give you as much guidence as possible when tests are being written.
* Issue assertion failures that are as clear as possible, so the meaning of the failure is easy to understand.

## Design Principles:

The consumer should not need to reference any class other than the instantiation of the Test Double - `Amoss_Instance` - in the first place.

* This limits the amount of noise in the specification of a Test Double.  Class names (espcially namespaced ones) get in the way of the meaning of the code and so they should not be required.

### Designing Methods:

* Every method call should be expressive of what it does in plain english, particularly within the context of where it is used.
* Methods should ideally only have one parameter, which is described by the context provided in the method name, so that it is always clear what is being passed in.
* Methods should be set up so they can be strung together to form sentences giving a full description of the work being done.
* For example:
    * `call( 1 ).of( 'theStubbedMethod' ).parameters()`, rather than:
    * `getParameters( 'theStubbedMethod', 1 )`
* Take care when defining methods to ensure that you are not creating a dead end in the phrasing.  If it is possible that the aspect of the language you are defining may be extended in the future then ensure you design the phrasing in a way that makes this possible.
* For example:
    * `withParameter().setTo()` is better than `withParameterSetTo()`, since this more easily allows additional behaviours, e.g. `setToTheSameValueAs()`, to be implemented and then presented to the user in a clear way via auto-complete.

### Designing Classes:

* Classes should be defined with the primary focus of making it easier for a consumer to use the framework, as opposed to making it easier for the developer to build the framework.
* Particularly, where the context of the phrasing changes, a new object should be returned that provides an interface that is appropriate for that part of the phrasing.
* For example:
    * `when`, `allows` and `expects` on `Amoss_Instance` all return an `Amoss_MethodDefiner`.
        * The `Amoss_MethodDefiner` defines the initial phrasing (essentially the interface) for method for the expectation, being `method`.
        * It then returns an 'Amoss_ParametersDefiner', which defines the entry point of the parameter phrasing, and so on.
        * The following methods (which are available on most 'Definers' then state the end of that phrasing, and result in an `Amoss_Instance` being returned.  This then re-starts the whole process.
* However, the consumer should never be concerned with this, and should not need to directly reference any class other than when initially constructing a `Amoss_Instance`.
