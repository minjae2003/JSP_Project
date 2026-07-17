package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class TradeDAO {
    
    /**
     * 💡 JNDI 톰캣 커넥션 풀로부터 데이터베이스 Connection을 안전하게 획득합니다.
     */
    private Connection getConnection() throws Exception {
        InitialContext ic = new InitialContext();
        DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/jsp_project");
        return ds.getConnection();
    }

    /**
     * 1. [가맹점 점주] 본사가 '승인' 완료한 발주 내역만 필터링하여 입고 대기 목록으로 반환
     */
    public List<Map<String, Object>> getApprovedOrderList(int storeNo) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.order_no, o.product_no, o.qty, p.product_name, p.product_price, o.order_date " +
                     "FROM order_history o " +
                     "JOIN product p ON o.product_no = p.product_no " +
                     "WHERE o.store_no = ? AND o.result = '승인' " +
                     "ORDER BY o.order_date DESC";
                     
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, storeNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("order_no", rs.getInt("order_no"));
                    map.put("product_no", rs.getInt("product_no"));
                    map.put("qty", rs.getInt("qty"));
                    map.put("product_name", rs.getString("product_name"));
                    map.put("product_price", rs.getInt("product_price"));
                    map.put("order_date", rs.getTimestamp("order_date"));
                    list.add(map);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    /**
     * 2. [가맹점 점주] 점주가 상품 발주 신청을 새로 접수하는 기능
     */
    public boolean insertOrder(int productNo, int qty, int storeNo) {
        String sql = "INSERT INTO order_history (product_no, qty, result, store_no) VALUES (?, ?, '대기', ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, productNo);
            pstmt.setInt(2, qty);
            pstmt.setInt(3, storeNo);
            
            int row = pstmt.executeUpdate();
            return row > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 3. [본사 관리자] 모든 가맹점들이 신청한 발주 내역 전체 조회 (orderList.jsp 연동)
     */
    public List<Map<String, Object>> getAllOrderList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.order_no, o.order_date, o.qty, o.result, " +
                     "p.product_name, p.product_price, s.store_name " +
                     "FROM order_history o " +
                     "JOIN product p ON o.product_no = p.product_no " +
                     "JOIN store s ON o.store_no = s.store_no " +
                     "ORDER BY o.order_date DESC";
                     
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("order_no", rs.getInt("order_no"));
                map.put("order_date", rs.getTimestamp("order_date"));
                map.put("qty", rs.getInt("qty"));
                map.put("result", rs.getString("result"));
                map.put("product_name", rs.getString("product_name"));
                map.put("product_price", rs.getInt("product_price"));
                map.put("store_name", rs.getString("store_name"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 4. [본사 관리자] 선택한 발주 정보의 처리 상태를 동적으로 업데이트 (orderApprovePro.jsp 연동)
     */
    public boolean updateOrderStatus(int orderNo, String status) {
        String sql = "UPDATE order_history SET result = ? WHERE order_no = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, orderNo);
            
            int row = pstmt.executeUpdate();
            return row > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 5. [가맹점 점주] 현재 로그인한 점주 매장 전용 실시간 발주 처리 현황 리스트 조회
     */
    public List<Map<String, Object>> getStoreOrderList(int storeNo) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.order_no, o.order_date, o.qty, o.result, p.product_name, p.product_price " +
                     "FROM order_history o JOIN product p ON o.product_no = p.product_no " +
                     "WHERE o.store_no = ? ORDER BY o.order_date DESC";
                     
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, storeNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("order_no", rs.getInt("order_no"));
                    map.put("order_date", rs.getTimestamp("order_date"));
                    map.put("qty", rs.getInt("qty"));
                    map.put("result", rs.getString("result"));
                    map.put("product_name", rs.getString("product_name"));
                    map.put("product_price", rs.getInt("product_price"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 6. [salesPro.jsp 연동] 가맹점 포스기 결제 발생 시 매출 등록 처리 엔진 (sales 테이블 타겟 스펙 업그레이드)
     */
    public boolean processSales(Integer storeNo, int productNo, int qty, int price) {
        String sql = "INSERT INTO sales (store_no, product_no, qty, sales_price, sales_date) VALUES (?, ?, ?, ?, NOW())";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, storeNo != null ? storeNo : 1);
            pstmt.setInt(2, productNo);
            pstmt.setInt(3, qty);
            pstmt.setInt(4, qty * price); 
            
            int row = pstmt.executeUpdate();
            return row > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 🔥 [🆕 추가]: 7. [본사 관리자] salesReport.jsp 연동 전 가맹점 통합 매출 내역 리스트 조회
     */
    public List<Map<String, Object>> getSystemSalesReportList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT s.sales_no, s.qty, s.sales_price, s.sales_date, " +
                     "p.product_name, st.store_name " +
                     "FROM sales s " +
                     "JOIN product p ON s.product_no = p.product_no " +
                     "JOIN store st ON s.store_no = st.store_no " +
                     "ORDER BY s.sales_date DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sales_no", rs.getInt("sales_no"));
                map.put("store_name", rs.getString("store_name"));
                map.put("product_name", rs.getString("product_name"));
                map.put("qty", rs.getInt("qty"));
                map.put("sales_price", rs.getInt("sales_price"));
                map.put("sales_date", rs.getTimestamp("sales_date"));
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}