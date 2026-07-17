package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import vo.*;

public class StoreDAO {

	private static StoreDAO instance = new StoreDAO();
	
	public static StoreDAO getInstance() { return instance; }
	
	private StoreDAO() { }
	
	private Connection getConnection() {		
		try {
			InitialContext ic = new InitialContext(); 
			DataSource ds = (DataSource)ic.lookup("java:comp/env/jdbc/jsp_project"); 
			return ds.getConnection();
		} catch(Exception e) {
			return null;
		}				
	}
	
	public void insertStore(StoreVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {
			conn = getConnection();
			String sql = "insert into store(store_name, address, owner_name, business_no, phone, manager_id, owner_id) values (?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, vo.getStore_name());
			pstmt.setString(2, vo.getAddress());
			pstmt.setString(3, vo.getOwner_name());
			pstmt.setString(4, vo.getBusiness_no());
			pstmt.setString(5, vo.getPhone());
			pstmt.setString(6, vo.getManager_id());
			pstmt.setString(7, vo.getOwner_id());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public List<StoreVO> getStores(int start, int end) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		List<StoreVO> list = null;
		try {			
			conn = getConnection();			
			String sql = "select * from store order by store_no desc limit ?, ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, start-1);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				list = new ArrayList<StoreVO>();
				do {
					StoreVO vo = new StoreVO();
					vo.setStore_no(rs.getInt("store_no"));
					vo.setStore_name(rs.getString("store_name"));
					vo.setAddress(rs.getString("address"));
					vo.setOwner_name(rs.getString("owner_name"));
					vo.setBusiness_no(rs.getString("business_no"));
					vo.setPhone(rs.getString("phone"));
					vo.setReg_date(rs.getTimestamp("reg_date"));
					vo.setManager_id(rs.getString("manager_id"));
					vo.setOwner_id(rs.getString("owner_id"));
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

	public int getStoreCount() {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		int result = 0;
		try {			
			conn = getConnection();			
			String sql = "select count(*) from store";
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

	public StoreVO getStore(int store_no) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		StoreVO vo = null;
		try {			
			conn = getConnection();	
			String sql = "select * from store where store_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, store_no);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				vo = new StoreVO();
				vo.setStore_no(rs.getInt("store_no"));
				vo.setStore_name(rs.getString("store_name"));
				vo.setAddress(rs.getString("address"));
				vo.setOwner_name(rs.getString("owner_name"));
				vo.setBusiness_no(rs.getString("business_no"));
				vo.setPhone(rs.getString("phone"));
				vo.setReg_date(rs.getTimestamp("reg_date"));
				vo.setManager_id(rs.getString("manager_id"));
				vo.setOwner_id(rs.getString("owner_id"));
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

	public void updateStore(StoreVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "update store set store_name=?, address=?, owner_name=?, business_no=?, phone=?, manager_id=?, owner_id=? where store_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, vo.getStore_name());
			pstmt.setString(2, vo.getAddress());
			pstmt.setString(3, vo.getOwner_name());
			pstmt.setString(4, vo.getBusiness_no());
			pstmt.setString(5, vo.getPhone());
			pstmt.setString(6, vo.getManager_id());
			pstmt.setString(7, vo.getOwner_id());
			pstmt.setInt(8, vo.getStore_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public void deleteStore(int store_no) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "delete from store where store_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, store_no);
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public void insertInventory(InventoryVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {
			conn = getConnection();
			String sql = "insert into inventory(store_no, product_no, stock_qty) values (?, ?, ?)";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getStore_no());
			pstmt.setInt(2, vo.getProduct_no());
			pstmt.setInt(3, vo.getStock_qty());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public List<InventoryVO> getInventories(int store_no, int start, int end) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		List<InventoryVO> list = null;
		try {			
			conn = getConnection();			
			String sql = "select * from inventory where store_no=? order by inventory_no desc limit ?, ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, store_no);
			pstmt.setInt(2, start-1);
			pstmt.setInt(3, end);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				list = new ArrayList<InventoryVO>();
				do {
					InventoryVO vo = new InventoryVO();
					vo.setInventory_no(rs.getInt("inventory_no"));
					vo.setStore_no(rs.getInt("store_no"));
					vo.setProduct_no(rs.getInt("product_no"));
					vo.setStock_qty(rs.getInt("stock_qty"));
					vo.setLast_update(rs.getTimestamp("last_update"));
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

	public int getInventoryCount(int store_no) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		int result = 0;
		try {			
			conn = getConnection();			
			String sql = "select count(*) from inventory where store_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, store_no);
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

	public InventoryVO getInventory(int inventory_no) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		InventoryVO vo = null;
		try {			
			conn = getConnection();	
			String sql = "select * from inventory where inventory_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, inventory_no);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				vo = new InventoryVO();
				vo.setInventory_no(rs.getInt("inventory_no"));
				vo.setStore_no(rs.getInt("store_no"));
				vo.setProduct_no(rs.getInt("product_no"));
				vo.setStock_qty(rs.getInt("stock_qty"));
				vo.setLast_update(rs.getTimestamp("last_update"));
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

	public void updateInventory(InventoryVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "update inventory set stock_qty=? where inventory_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, vo.getStock_qty());
			pstmt.setInt(2, vo.getInventory_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public void deleteInventory(int inventory_no) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "delete from inventory where inventory_no=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, inventory_no);
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); 
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
}