package vo;

import java.sql.Timestamp;

public class TradeVO {
    private int orderNo;
    private Timestamp orderDate;
    private int productNo;
    private int qty;
    private String result;
    private int storeNo;

    // Getter / Setter
    public int getOrderNo() { return orderNo; }
    public void setOrderNo(int orderNo) { this.orderNo = orderNo; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public int getProductNo() { return productNo; }
    public void setProductNo(int productNo) { this.productNo = productNo; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }

    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }

    public int getStoreNo() { return storeNo; }
    public void setStoreNo(int storeNo) { this.storeNo = storeNo; }
}