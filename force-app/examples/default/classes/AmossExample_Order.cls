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
}