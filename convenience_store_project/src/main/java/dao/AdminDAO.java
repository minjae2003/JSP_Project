package dao;

import java.sql.*;
import vo.AdminVO;

public class AdminDAO {

    // DB 연결 생성 메서드 (매 요청마다 연결)
    private Connection getConn() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/convenience_store?serverTimezone=UTC",
            "root",
            "1234"
        );
    }

    // 관리자 로그인 처리
    public AdminVO login(String id, String pw) {

        // 로그인 SQL (아이디 + 비밀번호 일치 여부 확인)
        String sql = "SELECT admin_id, admin_pw FROM admin WHERE admin_id=? AND admin_pw=?";

        try (
            Connection conn = getConn();          // DB 연결
            PreparedStatement ps = conn.prepareStatement(sql); // SQL 실행 객체
        ) {

            // ? 값 세팅 (SQL Injection 방지)
            ps.setString(1, id);
            ps.setString(2, pw);

            // SQL 실행 결과
            try (ResultSet rs = ps.executeQuery()) {

                // 결과가 존재하면 로그인 성공
                if (rs.next()) {

                    // VO 객체 생성 (데이터 전달용)
                    AdminVO vo = new AdminVO();

                    // DB값 VO에 저장
                    vo.setAdminId(rs.getString("admin_id"));
                    vo.setAdminPw(rs.getString("admin_pw"));

                    return vo; // 로그인 성공 반환
                }
            }

        } catch (Exception e) {
            // 예외 발생 시 콘솔 출력
            e.printStackTrace();
        }

        // 로그인 실패
        return null;
    }
}