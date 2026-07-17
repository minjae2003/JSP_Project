package vo;

import java.sql.Timestamp;

public class InventoryVO {

    private int inventory_no;
    private int store_no;
    private int product_no;
    private int stock_qty;
    private Timestamp last_update;

    public int getInventory_no() {
        return inventory_no;
    }

    public void setInventory_no(int inventory_no) {
        this.inventory_no = inventory_no;
    }

    public int getStore_no() {
        return store_no;
    }

    public void setStore_no(int store_no) {
        this.store_no = store_no;
    }

    public int getProduct_no() {
        return product_no;
    }

    public void setProduct_no(int product_no) {
        this.product_no = product_no;
    }

    public int getStock_qty() {
        return stock_qty;
    }

    public void setStock_qty(int stock_qty) {
        this.stock_qty = stock_qty;
    }

    public Timestamp getLast_update() {
        return last_update;
    }

    public void setLast_update(Timestamp last_update) {
        this.last_update = last_update;
    }
}