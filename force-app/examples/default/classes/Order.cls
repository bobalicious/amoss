public class Order {

    Boolean isFilled = false;
    String  product;
    Integer numberRequired;


    public Order( String product, Integer numberRequired ) {
        this.product = product;
        this.numberRequired = numberRequired;
    }

    public Boolean fill( Warehouse warehouse ) {
        if ( ! warehouse.hasInventory( product, numberRequired ) ) {
            return false;
        }

        this.isFilled = warehouse.remove( product, numberRequired );
        return this.isFilled;
    }

    public Boolean isFilled() {
        return this.isFilled;
    }
}