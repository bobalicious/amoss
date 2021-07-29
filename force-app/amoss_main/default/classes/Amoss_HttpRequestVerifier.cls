/*
MIT License

Copyright (c) 2020 Robert Baillie

https://github.com/bobalicious/amoss

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/**
* Public interface for the specification of a mechanism for checking the value of an HttpRequest.
*
* Can be used to extend the functionality of the HttpCalloutMock Amoss framework and allow for complex parameter checking
* to take place that is specific to a particular system's implementation.
*
* However, it is generally not required to create custom verifiers.
*/
public interface Amoss_HttpRequestVerifier {

    /**
    * Describes the verification that this object to configured to make in a way that will be easy to
    * interpret when reported in a failed assertion message.
    *
    * @return String - A clear description of the value's verification
    */
    String toString();

    /**
    * Should check that the given value (the parameter, or fragment of the parameter) passes verification, reporting any
    * failures by throwing an exception of the following types:
    *   * Amoss_Instance.Amoss_AssertionFailureException
    *   * Amoss_Instance.Amoss_EqualsAssertionFailureException
    *
    * In both cases, setAssertionMessage should be called to clearly define the failure.
    *
    * When using Amoss_EqualsAssertionFailureException, setExpected and setActual should also be set, with the values
    * being relevant within the context of the stated assertionMessage.
    *
    * If other verifiers are used within a custom verifier, any Amoss_AssertionFailureExceptions can be caught and
    * have context added to the failure by calling addContextToMessage against the exception before re-throwing.
    *
    * Care should be taken to ensure that no exceptions other than Amoss_AssertionFailureExceptions and its subclasses are
    * thrown.  This ensures that failures are clearly reported to the user.
    *
    * In addition, no calls to System.assert or its variations should be made directly in this method as it is also called
    * without the intention of reporting assertion failures to the user, and unexpected behaviours may result, particularly when using
    * the 'when' and 'allows' syntax.
    *
    * @param Object - The value to verify
    */
    void verify( HttpRequest value );
}
