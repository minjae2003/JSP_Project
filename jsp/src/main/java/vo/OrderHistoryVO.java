package vo;

import java.sql.Timestamp;

public class OrderHistoryVO {

    private int order_no;
    private Timestamp order_date;
    private int product_no;
    private int qty;
    private String result;
    private int store_no;

    public int getOrder_no() {
        return order_no;
    }

    public void setOrder_no(int order_no) {
        this.order_no = order_no;
    }

    public Timestamp getOrder_date() {
        return order_date;
    }

    public void setOrder_date(Timestamp order_date) {
        this.order_date = order_date;
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

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public int getStore_no() {
        return store_no;
    }

    public void setStore_no(int store_no) {
        this.store_no = store_no;
    }
}