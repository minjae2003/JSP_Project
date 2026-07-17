<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>
<%@ page import="javax.naming.InitialContext, javax.sql.DataSource" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");
    Integer storeNoAttr = (Integer) session.getAttribute("store_no");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int myStoreNo = (storeNoAttr != null) ? storeNoAttr : 1;
    List<Map<String, Object>> myOrderList = new ArrayList<>();
     String sql = "SELECT o.order_no, o.order_date, o.qty, o.result, p.product_name, p.product_price " +
                 "FROM order_history o JOIN product p ON o.product_no = p.product_no " +
                 "WHERE o.store_no = ? ORDER BY o.order_date DESC";

    try {
        InitialContext ic = new InitialContext();
        DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/jsp_project");
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, myStoreNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("order_no", rs.getInt("order_no"));
                    map.put("order_date", rs.getTimestamp("order_date"));
                    map.put("qty", rs.getInt("qty"));
                    map.put("result", rs.getString("result"));
                    map.put("product_name", rs.getString("product_name"));
                    map.put("product_price", rs.getInt("product_price"));
                    myOrderList.add(map);
                }
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가맹점 발주 처리 현황 리포트</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f8f9fa; }
    .top { height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
    .menu button { width:140px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#ecf0f1; font-weight:bold; margin-right:10px; }
    .logout button { width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; font-weight:bold; }
    .content { padding:40px; max-width:1300px; margin: 0 auto; }
    .title { font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }
    .list-table { width: 100%; border-collapse: collapse; text-align: center; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .list-table th, .list-table td { border: 1px solid #ccc; padding: 12px; }
    .list-table th { background: #f4f4f4; color: #333; }
    
    /* [★추가]: 본사의 처리 상태에 따라 화면에 색깔별로 출력되는 시각화 배지 스타일 명세 */
    .badge { padding: 4px 10px; border-radius: 20px; font-weight: bold; font-size: 13px; display: inline-block; }
    .badge-wait { background: #ffeaa7; color: #d63031; }
    .badge-approve { background: #badc58; color: #27ae60; }
    .badge-reject { background: #ffbebe; color: #c0392b; }
</style>
</head>
<body>
<div class="top">
    <div class="menu">
        <button onclick="location.href='OwnerMain.jsp'">메인으로</button>
        <button onclick="location.href='productList.jsp'">상품 발주 관리</button>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>
<div class="content">
    <div class="title">📋 가맹점 실시간 발주 처리 현황판</div>
    <table class="list-table">
        <tr>
            <th>발주번호</th>
            <th>신청 상품명</th>
            <th>발주 수량</th>
            <th>총 신청 금액</th>
            <th>발주 요청일시</th>
            <th>본사 결재 상태</th>
        </tr>
        <% if(myOrderList.isEmpty()) { %>
        <tr><td colspan="6" style="color:#7f8c8d; padding:40px;">접수된 발주 내역이 존재하지 않습니다.</td></tr>
        <% } else {
            for(Map<String, Object> o : myOrderList) { 
                int totalPrice = ((Integer)o.get("product_price")) * ((Integer)o.get("qty"));
                String status = (String)o.get("result");
        %>
            <tr>
                <td><%= o.get("order_no") %></td>
                <td><strong><%= o.get("product_name") %></strong></td>
                <td><%= o.get("qty") %>개</td>
                <td><%= String.format("%,d", totalPrice) %>원</td>
                <td style="color:#7f8c8d;"><%= o.get("order_date") %></td>
                <td>
                    <% if("대기".equals(status) || status == null) { %>
                        <span class="badge badge-wait">⏳ 승인 대기</span>
                    <% } else if("승인".equals(status) || "완료".equals(status)) { %>
                        <span class="badge badge-approve">✅ 발주 승인</span>
                    <% } else if("반려".equals(status)) { %>
                        <span class="badge badge-reject">❌ 발주 반려</span>
                    <% } %>
                </td>
            </tr>
        <%  }
        } %>
    </table>
</div>
</body>
</html>