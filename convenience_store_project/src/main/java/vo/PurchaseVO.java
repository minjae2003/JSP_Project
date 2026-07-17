package vo;

import java.sql.Date;
import java.sql.Time;

public class PurchaseVO {

    private int purchase_no;
    private int product_no;
    private int qty;
    private int purchase_price;
    private int store_no;
    private Date purchase_date;
    private Time purchase_time;

    public int getPurchase_no() {
        return purchase_no;
    }

    public void setPurchase_no(int purchase_no) {
        this.purchase_no = purchase_no;
    }

    public int getProduct_no() {
        return product_no;
    }

    public void setProduct_no(int product_no) {
        this.product_no = product_no;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public int getPurchase_price() {
        return purchase_price;
    }

    public void setPurchase_price(int purchase_price) {
        this.purchase_price = purchase_price;
    }

    public int getStore_no() {
        return store_no;
    }

    public void setStore_no(int store_no) {
        this.store_no = store_no;
    }

    public Date getPurchase_date() {
        return purchase_date;
    }

    public void setPurchase_date(Date purchase_date) {
        this.purchase_date = purchase_date;
    }

    public Time getPurchase_time() {
        return purchase_time;
    }

    public void setPurchase_time(Time purchase_time) {
        this.purchase_time = purchase_time;
    }
}