<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.InitialContext, javax.sql.DataSource" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("id");
    Integer storeNoAttr = (Integer) session.getAttribute("store_no");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String productNoParam = request.getParameter("product_no");
    String qtyParam = request.getParameter("qty");

    if (productNoParam == null || qtyParam == null) {
%>
        <script>alert("정상적인 접근이 아닙니다."); history.back();</script>
<%
        return;
    }

    int productNo = Integer.parseInt(productNoParam);
    int qty = Integer.parseInt(qtyParam);
    int storeNo = (storeNoAttr != null) ? storeNoAttr : 1; 

    String insertSql = "INSERT INTO order_history (product_no, store_no, qty, order_date, result) VALUES (?, ?, ?, NOW(), '대기')";
    boolean isSuccess = false;

    try {
        InitialContext ic = new InitialContext();
        DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/jsp_project");
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
            pstmt.setInt(1, productNo);
            pstmt.setInt(2, storeNo);
            pstmt.setInt(3, qty);
            if (pstmt.executeUpdate() > 0) { isSuccess = true; }
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<script>
    if (<%= isSuccess %>) { alert("본사에 발주 신청이 접수되었습니다. (승인 대기)"); }
    else { alert("데이터베이스 처리 오류가 발생했습니다."); }
    location.href = document.referrer; 
</script>