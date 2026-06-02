package dao;

import java.sql.*;
import vo.OwnerVO;

public class OwnerDAO {

    // DB 연결 메서드
    private Connection getConn() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/convenience_store?serverTimezone=UTC",
            "root",
            "1234"
        );
    }

    // 점주 로그인 처리
    public OwnerVO login(String id, String pw) {

        // 점주 로그인 SQL
        String sql = "SELECT owner_id, owner_pw FROM owner WHERE owner_id=? AND owner_pw=?";

        try (
            Connection conn = getConn();          // DB 연결
            PreparedStatement ps = conn.prepareStatement(sql); // SQL 실행 객체
        ) {

            // 파라미터 바인딩
            ps.setString(1, id);
            ps.setString(2, pw);

            // 결과 실행
            try (ResultSet rs = ps.executeQuery()) {

                // 로그인 성공 조건
                if (rs.next()) {

                    OwnerVO vo = new OwnerVO();

                    // DB → VO 매핑
                    vo.setOwnerId(rs.getString("owner_id"));
                    vo.setOwnerPw(rs.getString("owner_pw"));

                    return vo;
                }
            }

        } catch (Exception e) {
            // 오류 출력
            e.printStackTrace();
        }

        // 실패
        return null;
    }
}