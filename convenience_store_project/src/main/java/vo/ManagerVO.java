package vo;

import java.sql.Timestamp;

public class ManagerVO {

    private String manager_id;
    private String pw;
    private Timestamp join_date;
    private String department;
    private String position;

    public String getManager_id() {
        return manager_id;
    }

    public void setManager_id(String manager_id) {
        this.manager_id = manager_id;
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

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}