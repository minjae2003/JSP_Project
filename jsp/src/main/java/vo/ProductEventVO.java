package vo;

import java.sql.Date;

public class ProductEventVO {
	private int event_no;
	private int product_no;
	private String event_type;
	private int event_count;
	private int event_value;
	private Date start_date;
	private Date end_date;
	
	public int getEvent_no() {
		return event_no;
	}
	public void setEvent_no(int event_no) {
		this.event_no = event_no;
	}
	public int getProduct_no() {
		return product_no;
	}
	public void setProduct_no(int product_no) {
		this.product_no = product_no;
	}
	public String getEvent_type() {
		return event_type;
	}
	public void setEvent_type(String event_type) {
		this.event_type = event_type;
	}
	public int getEvent_count() {
		return event_count;
	}
	public void setEvent_count(int event_count) {
		this.event_count = event_count;
	}
	public int getEvent_value() {
		return event_value;
	}
	public void setEvent_value(int event_value) {
		this.event_value = event_value;
	}
	public Date getStart_date() {
		return start_date;
	}
	public void setStart_date(Date start_date) {
		this.start_date = start_date;
	}
	public Date getEnd_date() {
		return end_date;
	}
	public void setEnd_date(Date end_date) {
		this.end_date = end_date;
	}
}