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

public class StoreDAO {

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

    // 점주 기능: 매장별 재고 조회 (현재 날짜가 행사 기간 안에 있으면 행사 종류 포함)
    public List<Map<String, Object>> getStoreInventory(int storeNo) {
        List<Map<String, Object>> list = new ArrayList<>();
        // CURDATE()를 써서 오늘 날짜가 행사 시작일과 종료일 사이에 있는지 체크
        String sql = "SELECT p.product_name, p.product_price, i.stock_qty, " +
                     "       IFNULL(e.event_type, '없음') AS event_type " +
                     "FROM inventory i " +
                     "JOIN product p ON i.product_no = p.product_no " +
                     "LEFT JOIN product_event e ON p.product_no = e.product_no " +
                     "      AND CURDATE() BETWEEN e.start_date AND e.end_date " +
                     "WHERE i.store_no = ? " +
                     "ORDER BY i.last_update DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, storeNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("product_name", rs.getString("product_name"));
                    map.put("product_price", rs.getInt("product_price"));
                    map.put("stock_qty", rs.getInt("stock_qty"));
                    map.put("event_type", rs.getString("event_type"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 점주 기능: 부족 상품 자동 추천 (재고 수량이 3개 이하인 상품 리스트업)
    public List<Map<String, Object>> getLowStockRecommendations(int storeNo) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.product_no, p.product_name, p.product_price, i.stock_qty " +
                     "FROM inventory i " +
                     "JOIN product p ON i.product_no = p.product_no " +
                     "WHERE i.store_no = ? AND i.stock_qty <= 3 " +
                     "ORDER BY i.stock_qty ASC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, storeNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("product_no", rs.getInt("product_no"));
                    map.put("product_name", rs.getString("product_name"));
                    map.put("product_price", rs.getInt("product_price"));
                    map.put("stock_qty", rs.getInt("stock_qty"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}