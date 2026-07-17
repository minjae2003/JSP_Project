package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import vo.*; 

public class MemberDAO {

	private static MemberDAO instance = new MemberDAO();
	
	public static MemberDAO getInstance() { return instance; }
	
	private MemberDAO() { }
	
	private Connection getConnection() {		
		try {
			InitialContext ic = new InitialContext(); 
			DataSource ds = (DataSource)ic.lookup("java:comp/env/jdbc/jsp_project"); 
			return ds.getConnection();
		} catch(Exception e) {
			System.out.println("데이터베이스 연결에 문제가 발생했습니다.");
			return null;
		}				
	}
	
	// =========================================
	// Manager (관리자) CRUD
	// =========================================
	public void insertManager(ManagerVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {
			conn = getConnection();
			String sql = "insert into manager(manager_id, pw, department, position) values (?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, vo.getManager_id());
			pstmt.setString(2, vo.getPw());
			pstmt.setString(3, vo.getDepartment());
			pstmt.setString(4, vo.getPosition());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("manager 추가 실패");
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public List<ManagerVO> getManagers(int start, int end) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		List<ManagerVO> list = null;
		try {			
			conn = getConnection();			
			String sql = "select * from manager order by join_date desc limit ?, ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, start-1);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				list = new ArrayList<ManagerVO>();
				do {
					ManagerVO vo = new ManagerVO();
					vo.setManager_id(rs.getString("manager_id"));
					vo.setPw(rs.getString("pw"));
					vo.setJoin_date(rs.getTimestamp("join_date"));
					vo.setDepartment(rs.getString("department"));
					vo.setPosition(rs.getString("position"));
					list.add(vo);
				} while(rs.next());				
			}
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("manager 목록 검색 실패");
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return list;
	}

	public int getManagerCount() {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		int result = 0;
		try {			
			conn = getConnection();			
			String sql = "select count(*) from manager";
			pstmt = conn.prepareStatement(sql); 
			rs = pstmt.executeQuery(); 
			if(rs.next()) result = rs.getInt(1);				
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("manager 전체수 검색 실패");
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return result;
	}

	public ManagerVO getManager(String manager_id) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		ManagerVO vo = null;
		try {			
			conn = getConnection();	
			String sql = "select * from manager where manager_id=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, manager_id);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				vo = new ManagerVO();
				vo.setManager_id(rs.getString("manager_id"));
				vo.setPw(rs.getString("pw"));
				vo.setJoin_date(rs.getTimestamp("join_date"));
				vo.setDepartment(rs.getString("department"));
				vo.setPosition(rs.getString("position"));
			}
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("manager 상세보기 검색 실패");
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return vo;
	}	

	public void updateManager(ManagerVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "update manager set pw=?, department=?, position=? where manager_id=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, vo.getPw());
			pstmt.setString(2, vo.getDepartment());
			pstmt.setString(3, vo.getPosition());
			pstmt.setString(4, vo.getManager_id());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("manager 수정 실패");
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public void deleteManager(String manager_id) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "delete from manager where manager_id=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, manager_id);
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("manager 삭제 실패");
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	// =========================================
	// Owner (점주) CRUD
	// =========================================
	public void insertOwner(OwnerVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {
			conn = getConnection();
			String sql = "insert into owner(owner_id, pw, name, phone, store_no) values (?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, vo.getOwner_id());
			pstmt.setString(2, vo.getPw());
			pstmt.setString(3, vo.getName());
			pstmt.setString(4, vo.getPhone());
			pstmt.setInt(5, vo.getStore_no());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("owner 추가 실패");
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}

	public List<OwnerVO> getOwners(int start, int end) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		List<OwnerVO> list = null;
		try {			
			conn = getConnection();			
			String sql = "select * from owner order by join_date desc limit ?, ?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setInt(1, start-1);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				list = new ArrayList<OwnerVO>();
				do {
					OwnerVO vo = new OwnerVO();
					vo.setOwner_id(rs.getString("owner_id"));
					vo.setPw(rs.getString("pw"));
					vo.setJoin_date(rs.getTimestamp("join_date"));
					vo.setName(rs.getString("name"));
					vo.setPhone(rs.getString("phone"));
					vo.setStore_no(rs.getInt("store_no"));
					list.add(vo);
				} while(rs.next());				
			}
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("owner 목록 검색 실패");
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return list;
	}

	public OwnerVO getOwner(String owner_id) {
		Connection conn = null; PreparedStatement pstmt = null; ResultSet rs = null;
		OwnerVO vo = null;
		try {			
			conn = getConnection();	
			String sql = "select * from owner where owner_id=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, owner_id);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				vo = new OwnerVO();
				vo.setOwner_id(rs.getString("owner_id"));
				vo.setPw(rs.getString("pw"));
				vo.setJoin_date(rs.getTimestamp("join_date"));
				vo.setName(rs.getString("name"));
				vo.setPhone(rs.getString("phone"));
				vo.setStore_no(rs.getInt("store_no"));
			}
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("owner 상세보기 검색 실패");
		} finally {
			if(rs != null) try {rs.close();} catch(SQLException se) { }
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
		return vo;
	}	

	public void updateOwner(OwnerVO vo) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "update owner set pw=?, name=?, phone=?, store_no=? where owner_id=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, vo.getPw());
			pstmt.setString(2, vo.getName());
			pstmt.setString(3, vo.getPhone());
			pstmt.setInt(4, vo.getStore_no());
			pstmt.setString(5, vo.getOwner_id());
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("owner 수정 실패");
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
	
	public void deleteOwner(String owner_id) {		
		Connection conn = null; PreparedStatement pstmt = null; 
		try {			
			conn = getConnection();
			String sql = "delete from owner where owner_id=?";
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, owner_id);
			pstmt.executeUpdate(); 
		} catch(Exception e) {
			e.printStackTrace(); System.out.println("owner 삭제 실패");
		} finally {
			if(pstmt != null) try {pstmt.close();} catch(SQLException se) { }
			if(conn != null) try {conn.close();} catch(SQLException se) { }
		}
	}
}