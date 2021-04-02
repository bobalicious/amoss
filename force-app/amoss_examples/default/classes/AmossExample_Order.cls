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
 *
 * An Amoss example class.  There is no reason for this to form part of an installation
 * of Amoss beyond the requirement to try out the provided example test class.
 * It is essentially forms part of the documentation, and should not be needed in a production
 * system.
 *
 */
@isTest
public with sharing class AmossExample_Order {

    String postcode;
    Date   deliveryDate;

    public AmossExample_Order setPostcode( String postcode ) {
        this.postcode = postcode;
        return this;
    }

    public AmossExample_Order setDeliveryDate( Date deliveryDate ) {
        this.deliveryDate = deliveryDate;
        return this;
    }

    public Boolean scheduleDelivery( List<AmossExample_DeliveryProvider> deliveryProviders ) {

        try {
            for ( AmossExample_DeliveryProvider thisDeliveryProvider : deliveryProviders ) {
                if ( thisDeliveryProvider.canDeliver( postcode, deliveryDate ) ) {
                    return thisDeliveryProvider.scheduleDelivery( postcode, deliveryDate );
                }
            }
        } catch( AmossExample_DeliveryProvider.DeliveryProviderException e ) {
            // maybe we would log something here, or similar
        }

        return false;
    }

    public AmossExample_Order fluentmethod() {
        return this;
    }
}