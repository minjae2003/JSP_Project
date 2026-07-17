package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MemberDAO {

    private Connection getConnection() {        
        try {
            InitialContext ic = new InitialContext(); 
            DataSource ds = (DataSource)ic.lookup("java:comp/env/jdbc/jsp_project"); 
            return ds.getConnection();
        } catch(Exception e) {
            e.printStackTrace();
            return null;
        }                
    }

    // B안 로그인 방식: manager 테이블 먼저 확인 후 없으면 owner 테이블 확인
    public Map<String, Object> login(String id, String pw) {
        Map<String, Object> userSession = null;
        
        String managerSql = "SELECT manager_id FROM manager WHERE manager_id = ? AND pw = ?";
        String ownerSql = "SELECT owner_id, store_no FROM owner WHERE owner_id = ? AND pw = ?";
        
        // 1. 관리자 테이블 조회
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(managerSql)) {
            
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    userSession = new HashMap<>();
                    userSession.put("id", rs.getString("manager_id"));
                    userSession.put("role", "manager");
                    userSession.put("store_no", null);
                    return userSession; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 2. 관리자가 아니면 점주 테이블 조회
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(ownerSql)) {
            
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    userSession = new HashMap<>();
                    userSession.put("id", rs.getString("owner_id"));
                    userSession.put("role", "owner");
                    userSession.put("store_no", rs.getInt("store_no"));
                    return userSession;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return userSession; // 둘 다 없으면 null 반환
    }

    // 관리자 기능: 점주 + 매장 동시 생성
    public boolean registerStoreAndOwner(Map<String, String> param) {
        String insertStoreSql = "INSERT INTO store (store_name, address, business_no, phone, manager_id) VALUES (?, ?, ?, ?, ?)";
        String insertOwnerSql = "INSERT INTO owner (owner_id, pw, name, phone, store_no) VALUES (?, ?, ?, ?, ?)";
        String updateStoreSql = "UPDATE store SET owner_id = ? WHERE store_no = ?";
        
        Connection conn = null;
        PreparedStatement pstmtStore = null;
        PreparedStatement pstmtOwner = null;
        PreparedStatement pstmtUpdate = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 수동 커밋으로 전환 (안전한 저장)
            
            // 1. 매장 먼저 등록 (자동 생성된 매장 번호를 가져오기 위함)
            pstmtStore = conn.prepareStatement(insertStoreSql, Statement.RETURN_GENERATED_KEYS);
            pstmtStore.setString(1, param.get("store_name"));
            pstmtStore.setString(2, param.get("address"));
            pstmtStore.setString(3, param.get("business_no"));
            pstmtStore.setString(4, param.get("phone"));
            pstmtStore.setString(5, param.get("manager_id"));
            pstmtStore.executeUpdate();
            
            rs = pstmtStore.getGeneratedKeys();
            int storeNo = 0;
            if (rs.next()) {
                storeNo = rs.getInt(1);
            }
            
            // 2. 방금 생성된 매장 번호를 넣어서 점주 등록
            pstmtOwner = conn.prepareStatement(insertOwnerSql);
            pstmtOwner.setString(1, param.get("owner_id"));
            pstmtOwner.setString(2, param.get("owner_pw"));
            pstmtOwner.setString(3, param.get("owner_name"));
            pstmtOwner.setString(4, param.get("owner_phone"));
            pstmtOwner.setInt(5, storeNo);
            pstmtOwner.executeUpdate();
            
            // 3. 매장 테이블에 점주 아이디 업데이트 (서로 연결)
            pstmtUpdate = conn.prepareStatement(updateStoreSql);
            pstmtUpdate.setString(1, param.get("owner_id"));
            pstmtUpdate.setInt(2, storeNo);
            pstmtUpdate.executeUpdate();
            
            conn.commit(); 
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmtStore != null) pstmtStore.close(); } catch (Exception e) {}
            try { if (pstmtOwner != null) pstmtOwner.close(); } catch (Exception e) {}
            try { if (pstmtUpdate != null) pstmtUpdate.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}