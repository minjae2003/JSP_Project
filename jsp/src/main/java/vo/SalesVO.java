package vo;

import java.sql.Timestamp;

public class SalesVO {

    private int sales_no;
    private int product_no;
    private int qty;
    private int sales_price;
    private int store_no;
    private Timestamp sales_date;

    public int getSales_no() {
        return sales_no;
    }

    public void setSales_no(int sales_no) {
        this.sales_no = sales_no;
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

    public int getSales_price() {
        return sales_price;
    }

    public void setSales_price(int sales_price) {
        this.sales_price = sales_price;
    }

    public int getStore_no() {
        return store_no;
    }

    public void setStore_no(int store_no) {
        this.store_no = store_no;
    }

    public Timestamp getSales_date() {
        return sales_date;
    }

    public void setSales_date(Timestamp sales_date) {
        this.sales_date = sales_date;
    }
}