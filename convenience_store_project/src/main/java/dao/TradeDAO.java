package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import vo.*;

public class TradeDAO {

	private static TradeDAO instance = new TradeDAO();
	
	public static TradeDAO getInstance() { return instance; }
	
	private TradeDAO() { }
	
	private Connection getConnection() {		
		try {
			InitialContext ic = new InitialContext(); 
			DataSource ds = (DataSource)ic.lookup("java:comp/env/jdbc/jsp_project"); 
			return ds.getConnection();
		} catch(Exception e) {
			return null;
		}				
	}
	
	public void insertSales(SalesVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {
			conn = getConnection();
			String sql = "insert into sales(product_no, qty, sales_price, store_no) values (?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getProduct_no());
			pstmt.setInt(2, vo.getQty());
			pstmt.setInt(3, vo.getSales_price());
			pstmt.setInt(4, vo.getStore_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public List<SalesVO> getSalesList(int start, int end) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		List<SalesVO> list = null;
		try {			
			conn = getConnection();			
			String sql = "select * from sales order by sales_no desc limit ?, ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, start-1);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				list = new ArrayList<SalesVO>();
				do {
					SalesVO vo = new SalesVO();
					vo.setSales_no(rs.getInt("sales_no"));
					vo.setProduct_no(rs.getInt("product_no"));
					vo.setQty(rs.getInt("qty"));
					vo.setSales_price(rs.getInt("sales_price"));
					vo.setStore_no(rs.getInt("store_no"));
					vo.setSales_date(rs.getTimestamp("sales_date"));
					list.add(vo);
				} while(rs.next());				
			}
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return list;
	}

	public int getSalesCount() {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		int result = 0;
		try {			
			conn = getConnection();			
			String sql = "select count(*) from sales";
			pstmt = conn.prepareStatement(sql); 
			rs = pstmt.executeQuery(); 
			if(rs.next()) result = rs.getInt(1);				
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return result;
	}

	public SalesVO getSales(int sales_no) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		SalesVO vo = null;
		try {			
			conn = getConnection();	
			String sql = "select * from sales where sales_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, sales_no);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				vo = new SalesVO();
				vo.setSales_no(rs.getInt("sales_no"));
				vo.setProduct_no(rs.getInt("product_no"));
				vo.setQty(rs.getInt("qty"));
				vo.setSales_price(rs.getInt("sales_price"));
				vo.setStore_no(rs.getInt("store_no"));
				vo.setSales_date(rs.getTimestamp("sales_date"));
			}
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return vo;
	}	

	public void updateSales(SalesVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "update sales set product_no=?, qty=?, sales_price=?, store_no=? where sales_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getProduct_no());
			pstmt.setInt(2, vo.getQty());
			pstmt.setInt(3, vo.getSales_price());
			pstmt.setInt(4, vo.getStore_no());
			pstmt.setInt(5, vo.getSales_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public void deleteSales(int sales_no) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "delete from sales where sales_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, sales_no);
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public void insertPurchase(PurchaseVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {
			conn = getConnection();
			String sql = "insert into purchase(product_no, qty, purchase_price, store_no, purchase_date, purchase_time) values (?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getProduct_no());
			pstmt.setInt(2, vo.getQty());
			pstmt.setInt(3, vo.getPurchase_price());
			pstmt.setInt(4, vo.getStore_no());
			pstmt.setDate(5, vo.getPurchase_date());
			pstmt.setTime(6, vo.getPurchase_time());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public List<PurchaseVO> getPurchases(int start, int end) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		List<PurchaseVO> list = null;
		try {			
			conn = getConnection();			
			String sql = "select * from purchase order by purchase_no desc limit ?, ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, start-1);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				list = new ArrayList<PurchaseVO>();
				do {
					PurchaseVO vo = new PurchaseVO();
					vo.setPurchase_no(rs.getInt("purchase_no"));
					vo.setProduct_no(rs.getInt("product_no"));
					vo.setQty(rs.getInt("qty"));
					vo.setPurchase_price(rs.getInt("purchase_price"));
					vo.setStore_no(rs.getInt("store_no"));
					vo.setPurchase_date(rs.getDate("purchase_date"));
					vo.setPurchase_time(rs.getTime("purchase_time"));
					list.add(vo);
				} while(rs.next());				
			}
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return list;
	}

	public int getPurchaseCount() {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		int result = 0;
		try {			
			conn = getConnection();			
			String sql = "select count(*) from purchase";
			pstmt = conn.prepareStatement(sql); 
			rs = pstmt.executeQuery(); 
			if(rs.next()) result = rs.getInt(1);				
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return result;
	}

	public PurchaseVO getPurchase(int purchase_no) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		PurchaseVO vo = null;
		try {			
			conn = getConnection();	
			String sql = "select * from purchase where purchase_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, purchase_no);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				vo = new PurchaseVO();
				vo.setPurchase_no(rs.getInt("purchase_no"));
				vo.setProduct_no(rs.getInt("product_no"));
				vo.setQty(rs.getInt("qty"));
				vo.setPurchase_price(rs.getInt("purchase_price"));
				vo.setStore_no(rs.getInt("store_no"));
				vo.setPurchase_date(rs.getDate("purchase_date"));
				vo.setPurchase_time(rs.getTime("purchase_time"));
			}
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return vo;
	}

	public void updatePurchase(PurchaseVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "update purchase set product_no=?, qty=?, purchase_price=?, store_no=?, purchase_date=?, purchase_time=? where purchase_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getProduct_no());
			pstmt.setInt(2, vo.getQty());
			pstmt.setInt(3, vo.getPurchase_price());
			pstmt.setInt(4, vo.getStore_no());
			pstmt.setDate(5, vo.getPurchase_date());
			pstmt.setTime(6, vo.getPurchase_time());
			pstmt.setInt(7, vo.getPurchase_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public void deletePurchase(int purchase_no) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "delete from purchase where purchase_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, purchase_no);
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public void insertOrderHistory(OrderHistoryVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {
			conn = getConnection();
			String sql = "insert into order_history(product_no, qty, result, store_no) values (?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getProduct_no());
			pstmt.setInt(2, vo.getQty());
			pstmt.setString(3, vo.getResult());
			pstmt.setInt(4, vo.getStore_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public List<OrderHistoryVO> getOrderHistories(int start, int end) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		List<OrderHistoryVO> list = null;
		try {			
			conn = getConnection();			
			String sql = "select * from order_history order by order_no desc limit ?, ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, start-1);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				list = new ArrayList<OrderHistoryVO>();
				do {
					OrderHistoryVO vo = new OrderHistoryVO();
					vo.setOrder_no(rs.getInt("order_no"));
					vo.setOrder_date(rs.getTimestamp("order_date"));
					vo.setProduct_no(rs.getInt("product_no"));
					vo.setQty(rs.getInt("qty"));
					vo.setResult(rs.getString("result"));
					vo.setStore_no(rs.getInt("store_no"));
					list.add(vo);
				} while(rs.next());				
			}
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return list;
	}

	public int getOrderHistoryCount() {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		int result = 0;
		try {			
			conn = getConnection();			
			String sql = "select count(*) from order_history";
			pstmt = conn.prepareStatement(sql); 
			rs = pstmt.executeQuery(); 
			if(rs.next()) result = rs.getInt(1);				
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return result;
	}

	public OrderHistoryVO getOrderHistory(int order_no) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		OrderHistoryVO vo = null;
		try {			
			conn = getConnection();	
			String sql = "select * from order_history where order_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, order_no);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				vo = new OrderHistoryVO();
				vo.setOrder_no(rs.getInt("order_no"));
				vo.setOrder_date(rs.getTimestamp("order_date"));
				vo.setProduct_no(rs.getInt("product_no"));
				vo.setQty(rs.getInt("qty"));
				vo.setResult(rs.getString("result"));
				vo.setStore_no(rs.getInt("store_no"));
			}
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return vo;
	}

	public void updateOrderHistory(OrderHistoryVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "update order_history set product_no=?, qty=?, result=?, store_no=? where order_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getProduct_no());
			pstmt.setInt(2, vo.getQty());
			pstmt.setString(3, vo.getResult());
			pstmt.setInt(4, vo.getStore_no());
			pstmt.setInt(5, vo.getOrder_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public void deleteOrderHistory(int order_no) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "delete from order_history where order_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, order_no);
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
}