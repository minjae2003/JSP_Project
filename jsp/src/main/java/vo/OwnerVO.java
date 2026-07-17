package vo;

import java.sql.Timestamp;

public class OwnerVO {

    private String owner_id;
    private String pw;
    private Timestamp join_date;
    private String name;
    private String phone;
    private int store_no;

    public String getOwner_id() {
        return owner_id;
    }

    public void setOwner_id(String owner_id) {
        this.owner_id = owner_id;
    }

    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }

    public Timestamp getJoin_date() {
        return join_date;
    }

    public void setJoin_date(Timestamp join_date) {
        this.join_date = join_date;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getStore_no() {
        return store_no;
    }

    public void setStore_no(int store_no) {
        this.store_no = store_no;
    }
}