package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import vo.ProductVO;

public class ProductDAO {

    // 싱글톤 패턴
    private static ProductDAO instance = new ProductDAO();
    private ProductDAO() {}
    public static ProductDAO getInstance() { return instance; }

    // DB 연결 (JNDI 방식)
    private Connection getConnection() {
        try {
            InitialContext ic = new InitialContext(); // JNDI 서버 객체 생성 
            DataSource ds = (DataSource)ic.lookup("java:comp/env/jdbc/jsp_project"); // connection 객체 찾기
            Connection conn = ds.getConnection(); // connection 객체를 할당 받음
            return conn;
        } catch(Exception e) {
            System.out.println("데이터베이스 연결에 문제가 발생했습니다.");
            return null;
        }
    }
    // 상품 목록 가져오기
    public List<ProductVO> getProductList() {
        List<ProductVO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            // ※ 여기서 'product' 테이블명과 컬럼명을 본인의 DB와 맞게 확인하세요!
            String sql = "SELECT * FROM product ORDER BY product_no DESC";
            System.out.println("[DAO] SQL 실행: " + sql);
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            int count = 0;
            while(rs.next()) {
                count++;
                System.out.println("[DAO] 데이터 " + count + "번 줄 발견!");
                
                ProductVO vo = new ProductVO();
                vo.setProduct_no(rs.getInt("product_no"));
                vo.setProduct_name(rs.getString("product_name"));
                vo.setProduct_price(rs.getInt("product_price"));
                // 필요한 컬럼 추가...
                
                list.add(vo);
            }
            System.out.println("[DAO] 총 가져온 데이터 개수: " + count);

        } catch (Exception e) {
            System.out.println("[DAO] 데이터 조회 중 에러 발생");
            e.printStackTrace();
        } finally {
            // 자원 반납
            try { if(rs!=null) rs.close(); if(pstmt!=null) pstmt.close(); if(conn!=null) conn.close(); } catch(Exception e) {}
        }
        return list;
    }

    // 상품 등록하기
    public void insertProduct(ProductVO vo) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            String sql = "INSERT INTO product (product_name, product_price) VALUES (?, ?)";
            System.out.println("[DAO] Insert 실행: " + vo.getProduct_name());
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, vo.getProduct_name());
            pstmt.setInt(2, vo.getProduct_price());
            
            int result = pstmt.executeUpdate();
            System.out.println("[DAO] Insert 결과(성공 시 1): " + result);
            
        } catch (Exception e) {
            System.out.println("[DAO] Insert 중 에러 발생");
            e.printStackTrace();
        } finally {
            try { if(pstmt!=null) pstmt.close(); if(conn!=null) conn.close(); } catch(Exception e) {}
        }
    }
}