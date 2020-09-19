public with sharing class AmossExample_DeliveryProvider {

    public class DeliveryProviderException extends Exception {}

    public Boolean canDeliver( String postcode, Date deliveryDate ) {
        return true;
    }

    public Boolean scheduleDelivery( String postcode, Date deliveryDate ) {
        return true;
    }
}