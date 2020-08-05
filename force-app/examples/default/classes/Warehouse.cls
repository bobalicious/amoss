public class Warehouse {

    public class WarehouseException extends Exception {}

    public Warehouse() {

    }

    public Boolean hasInventory( String product, Integer numberRequired ) {
        return true;
    }

    public Boolean remove( String product, Integer numberRequired ) {
        return true;
    }

}