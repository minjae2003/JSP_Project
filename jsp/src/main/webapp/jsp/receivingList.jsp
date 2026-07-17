<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, dao.TradeDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("id");
    Integer storeNoAttr = (Integer) session.getAttribute("store_no");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int myStoreNo = (storeNoAttr != null) ? storeNoAttr : 1;

    // ★ 패키지화된 DAO를 호출하여 '승인'된 데이터만 깔끔하게 가져옴
    TradeDAO tradeDAO = new TradeDAO();
    List<Map<String, Object>> receivingList = tradeDAO.getApprovedOrderList(myStoreNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>미입고 상품 확정 처리</title>
<style>
    body { font-family: '맑은 고딕'; padding: 30px; background: #f8f9fa; }
    .title { font-size: 24px; font-weight: bold; color: #2c3e50; margin-bottom: 20px; }
    .table { width: 100%; border-collapse: collapse; background: white; }
    .table th, .table td { border: 1px solid #ddd; padding: 12px; text-align: center; }
    .table th { background: #34495e; color: white; }
    .btn-btn { background: #2ecc71; color: white; border: none; 
    padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
</style>
</head>
<body>
<div class="title">🚚 본사 승인 완료 - 입고 대기 목록</div>
<table class="table">
    <tr>
        <th>발주 번호</th>
        <th>상품명</th>
        <th>승인 수량</th>
        <th>발주 일자</th>
        <th>물류 확정</th>
    </tr>
    <% if (receivingList.isEmpty()) { %>
        <tr><td colspan="5" style="padding: 30px; color: #7f8c8d;">본사로부터 승인되어 배송 중인 상품이 없습니다.</td></tr>
    <% } else { 
        for (Map<String, Object> item : receivingList) { %>
        <tr>
            <td><%= item.get("order_no") %></td>
            <td><strong><%= item.get("product_name") %></strong></td>
            <td><%= item.get("qty") %> 개</td>
            <td><%= item.get("order_date") %></td>
            <td>
                <button class="btn-btn" onclick="location.href='receivingPro.jsp?order_no=<%= item.get("order_no") %>
                &product_no=<%= item.get("product_no") %>&qty=<%= item.get("qty") %>'">
                    입고 확정
                </button>
            </td>
        </tr>
    <%  } 
    } %>
</table>

</body>
</html>