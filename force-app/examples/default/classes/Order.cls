public class Order {

    Boolean isFilled = false;
    String  product;
    Integer numberRequired;


    public Order( String product, Integer numberRequired ) {
        this.product = product;
        this.numberRequired = numberRequired;
    }

    public Boolean fill( Warehouse warehouse ) {

        try {
            if ( ! warehouse.hasInventory( product, numberRequired ) ) {
                return false;
            }

            this.isFilled = warehouse.remove( product, numberRequired );
            return this.isFilled;
        } catch ( Exception e ) {
            return false;
        }
    }

    public Boolean isFilled() {
        return this.isFilled;
    }
}