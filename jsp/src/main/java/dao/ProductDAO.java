package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ProductDAO {

    // JNDI 톰캣 커넥션 풀 커넥션 반환 엔진
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

    /**
     * 1. productInsert.jsp의 셀렉트 박스에 뿌려줄 소분류 카테고리 목록 전체 조회
     */
    public List<Map<String, Object>> getSubCategoryList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sub_no, sub_name, main_no FROM sub_category ORDER BY sub_no ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sub_no", rs.getInt("sub_no"));
                map.put("sub_name", rs.getString("sub_name"));
                map.put("main_no", rs.getInt("main_no"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 2. purchaseInsert.jsp 셀렉트 박스용 전체 상품 이름/가격 조인 리스트 반환
     */
    public List<Map<String, Object>> getPurchaseProductList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.product_no, p.product_name, p.product_price, s.sub_name " +
                     "FROM product p JOIN sub_category s ON p.sub_no = s.sub_no " +
                     "ORDER BY p.product_name ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("product_no", rs.getInt("product_no"));
                map.put("product_name", rs.getString("product_name"));
                map.put("product_price", rs.getInt("product_price"));
                map.put("sub_name", rs.getString("sub_name"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 🔥 [🆕 추가]: purchasePro.jsp 전용 다중 쿼리 트랜잭션 실행 엔진
     * 입고 기록 저장 및 재고 증가 처리가 모두 성공해야 커밋됩니다. (하나라도 실패 시 자동 롤백)
     */
    public boolean executePurchaseTransaction(int productNo, int qty, int purchasePrice, int storeNo, String purchaseDate, String purchaseTime) {
        String insertPurchaseSql = 
            "INSERT INTO purchase (product_no, qty, purchase_price, store_no, purchase_date, purchase_time) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        String upsertInventorySql = 
            "INSERT INTO inventory (store_no, product_no, stock_qty) VALUES (?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE stock_qty = stock_qty + ?";

        Connection conn = null;
        try {
            conn = getConnection();
            if (conn == null) return false;

            // 1. 수동 커밋 모드로 전환 (트랜잭션 개시)
            conn.setAutoCommit(false);

            try (PreparedStatement pstmt1 = conn.prepareStatement(insertPurchaseSql);
                 PreparedStatement pstmt2 = conn.prepareStatement(upsertInventorySql)) {
                
                // 1-1. 입고 내역 파라미터 세팅
                pstmt1.setInt(1, productNo);
                pstmt1.setInt(2, qty);
                pstmt1.setInt(3, purchasePrice);
                pstmt1.setInt(4, storeNo);
                pstmt1.setString(5, purchaseDate);
                pstmt1.setString(6, purchaseTime);
                pstmt1.executeUpdate();

                // 1-2. 매장 재고 수량 업데이트 파라미터 세팅 (ON DUPLICATE KEY)
                pstmt2.setInt(1, storeNo);
                pstmt2.setInt(2, productNo);
                pstmt2.setInt(3, qty); // 신규 등록 시 초기 값
                pstmt2.setInt(4, qty); // 기존 적재 수량이 존재할 때 가산할 값
                pstmt2.executeUpdate();

                // 2. 두 작업 모두 오류 없이 도달했다면 최종 승인(Commit)
                conn.commit();
                return true;

            } catch (SQLException ex) {
                // 내부 SQL 장애 감지 시 안전하게 이전 상태로 되돌림
                if (conn != null) { conn.rollback(); }
                ex.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            // 커넥션 자원 반환 제어
            if (conn != null) {
                try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
    }

    // 관리자 기능: 상품 등록
    public boolean insertProduct(Map<String, Object> product) {
        String sql = "INSERT INTO product (product_name, product_img, sub_no, product_price) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, (String) product.get("product_name"));
            pstmt.setString(2, (String) product.get("product_img"));
            pstmt.setInt(3, (Integer) product.get("sub_no"));
            pstmt.setInt(4, (Integer) product.get("product_price"));
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 관리자 기능: 상품 삭제
    public boolean deleteProduct(int productNo) {
        String sql = "DELETE FROM product WHERE product_no = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productNo);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 점주/관리자 공통: 전체 상품 조회 또는 카테고리별 필터링
    public List<Map<String, Object>> getProductList(int mainNo, int subNo) {
        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, s.sub_name, m.main_name " +
            "FROM product p " +
            "JOIN sub_category s ON p.sub_no = s.sub_no " +
            "JOIN main_category m ON s.main_no = m.main_no WHERE 1=1 "
        );
        
        if (subNo > 0) {
            sql.append("AND p.sub_no = ? ");
        } else if (mainNo > 0) {
            sql.append("AND s.main_no = ? ");
        }
        
        sql.append("ORDER BY p.product_no DESC");

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            if (subNo > 0) {
                pstmt.setInt(1, subNo);
            } else if (mainNo > 0) {
                pstmt.setInt(1, mainNo);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("product_no", rs.getInt("product_no"));
                    map.put("product_name", rs.getString("product_name"));
                    map.put("product_img", rs.getString("product_img"));
                    map.put("sub_no", rs.getInt("sub_no"));
                    map.put("product_price", rs.getInt("product_price"));
                    map.put("sub_name", rs.getString("sub_name"));
                    map.put("main_name", rs.getString("main_name"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 관리자 기능: 상품 행사 정보 등록
    public boolean insertProductEvent(Map<String, Object> event) {
        String sql = "INSERT INTO product_event (product_no, event_type, event_count, event_value, start_date, end_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (Integer) event.get("product_no"));
            pstmt.setString(2, (String) event.get("event_type"));
            pstmt.setInt(3, (Integer) event.get("event_count"));
            pstmt.setInt(4, (Integer) event.get("event_value"));
            pstmt.setString(5, (String) event.get("start_date"));
            pstmt.setString(6, (String) event.get("end_date"));
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}