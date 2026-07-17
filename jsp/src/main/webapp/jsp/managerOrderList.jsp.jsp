<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.TradeDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 관리자 세션 및 권한 체크 기본 방어막
    String id = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (id == null || !"manager".equals(role)) {
%>
        <script>
            alert("본사 관리자만 접근 가능한 메뉴입니다.");
            location.href = "login.jsp";
        </script>
<%
        return;
    }

    // 2. TradeDAO를 호출하여 데이터 리스트 획득
    TradeDAO tradeDao = new TradeDAO();
    List<Map<String, Object>> orderList = tradeDao.getAllOrderList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본사 물류 시스템 - 가맹점 발주 관리</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<style>
    body { background-color: #f8f9fa; font-family: 'Malgun Gothic', sans-serif; }
    .container { background-color: #ffffff; border-radius: 10px; box-shadow: 0px 0px 15px rgba(0,0,0,0.05); padding: 30px; margin-top: 50px; }
    .badge-대기 { background-color: #ffc107; color: #212529; }
    .badge-승인 { background-color: #198754; color: #ffffff; }
    .badge-완료 { background-color: #0dcaf0; color: #ffffff; }
</style>
</head>
<body>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary fw-bold">🏪 가맹점 발주 신청 내역 관리</h2>
        <button class="btn btn-secondary btn-sm" onclick="location.href='ManagerMain.jsp'">관리자 메인으로</button>
    </div>
    
    <table class="table table-hover table-bordered text-center align-middle">
        <thead class="table-dark">
            <tr>
                <th>발주번호</th>
                <th>신청 가맹점</th>
                <th>카테고리</th>
                <th>상품명</th>
                <th>단가</th>
                <th>신청수량</th>
                <th>총금액</th>
                <th>발주일시</th>
                <th>처리상태</th>
                <th>관리기능</th>
            </tr>
        </thead>
        <tbody>
        <%
            if (orderList == null || orderList.isEmpty()) {
        %>
            <tr>
                <td colspan="10" class="text-muted py-5">현재 가맹점에서 신청한 발주 내역이 존재하지 않습니다.</td>
            </tr>
        <%
            } else {
                for (Map<String, Object> order : orderList) {
                    int price = (int) order.get("product_price");
                    int qty = (int) order.get("qty");
                    int totalPrice = price * qty;
                    String resultStatus = (String) order.get("result");
        %>
            <tr>
                <td><%= order.get("order_no") %></td>
                <td class="fw-bold"><%= order.get("store_name") %></td>
                <td><span class="badge bg-secondary"><%= order.get("sub_name") %></span></td>
                <td class="text-start ps-3"><%= order.get("product_name") %></td>
                <td><%= String.format("%,d원", price) %></td>
                <td class="table-active fw-bold"><%= qty %>개</td>
                <td class="text-danger fw-bold"><%= String.format("%,d원", totalPrice) %></td>
                <td class="text-muted" style="font-size: 0.9rem;"><%= order.get("order_date") %></td>
                <td>
                    <span class="badge badge-<%= resultStatus %> px-2.5 py-2"><%= resultStatus %></span>
                </td>
                <td>
                <% if ("대기".equals(resultStatus)) { %>
                    <button class="btn btn-success btn-sm fw-bold" onclick="approveOrder(<%= order.get("order_no") %>)">발주승인</button>
                <% } else { %>
                    <button class="btn btn-light btn-sm text-muted" disabled>처리완료</button>
                <% } %>
                </td>
            </tr>
        <%
                } // for문 끝
            } // else문 끝
        %>
        </tbody>
    </table>
</div>

<script>
function approveOrder(orderNo) {
    if(confirm(orderNo + "번 발주 내역을 승인하시겠습니까?\n승인 시 해당 매장 입고 대기 목록으로 즉시 전송됩니다.")) {
        location.href = "orderApprovePro.jsp?order_no=" + orderNo;
    }
}
</script>

</body>
</html>