<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.TradeDAO" %>
<%
    // 1. 인코딩 및 본사 관리자 세션 보안 검증
    request.setCharacterEncoding("UTF-8");
    String managerId = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (managerId == null || !"manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. 🔗 분리 완료: TradeDAO를 호출하여 깔끔한 비즈니스 데이터만 획득
    TradeDAO tradeDao = new TradeDAO();
    List<Map<String, Object>> orderList = tradeDao.getAllOrderList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본사 - 가맹점 발주 관리 시스템</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f8f9fa; }
    .top { height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
    .menu button { width:140px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#ecf0f1; font-weight:bold; }
    .logout button { width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; font-weight:bold; }
    .content { padding:40px; max-width: 1300px; margin: 0 auto; }
    .title { font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }
    
    /* 테이블 스타일 */
    .list-table { width: 100%; border-collapse: collapse; text-align: center; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .list-table th, .list-table td { border: 1px solid #ccc; padding: 12px; font-size: 15px; }
    .list-table th { background: #f4f4f4; color: #333; }
    
    /* 버튼 스타일 */
    .btn-approve { background: #2ecc71; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-approve:hover { background: #27ae60; }
    .btn-reject { background: #e74c3c; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-reject:hover { background: #c0392b; }
    
    /* 상태별 텍스트 색상 */
    .status-wait { color: #f39c12; font-weight: bold; }
    .status-ok { color: #2ecc71; font-weight: bold; }
    .status-no { color: #e74c3c; font-weight: bold; }
    .status-default { color: #7f8c8d; font-weight: bold; }
    
    .role-badge { background: #e67e22; color: white; padding: 3px 8px; border-radius: 3px; font-size: 12px; font-weight: normal; margin-left: 10px;}
</style>
</head>
<body>

<div class="top">
    <div class="menu">
        <button onclick="location.href='ManagerMain.jsp'">메인으로</button>
        <button onclick="location.href='productList.jsp'">상품 마스터 관리</button>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>

<div class="content">
    <div class="title">
        📦 가맹점 발주 신청 내역 관리
        <span class="role-badge">본사 관리자 전용</span>
    </div>

    <table class="list-table">
        <thead>
            <tr>
                <th>발주번호</th>
                <th>신청 매장명</th>
                <th>발주 상품명</th>
                <th>신청 수량</th>
                <th>총 금액</th>
                <th>발주 일시</th>
                <th>현재 상태</th>
                <th>관리 액션</th>
            </tr>
        </thead>
        <tbody>
        <% if(orderList == null || orderList.isEmpty()) { %>
        <tr>
            <td colspan="8" style="color:#7f8c8d; padding:30px;">접수된 가맹점 발주 내역이 전혀 없습니다.</td>
        </tr>
        <% } else { %>
            <% for(Map<String, Object> o : orderList) { 
                int price = ((Number)o.get("product_price")).intValue();
                int qty = ((Number)o.get("qty")).intValue();
                int totalPrice = price * qty;
                String resultStatus = (String)o.get("result");
            %>
            <tr>
                <td><%= o.get("order_no") %></td>
                <td><strong><%= o.get("store_name") %></strong></td>
                <td style="text-align:left; padding-left:15px;"><%= o.get("product_name") %></td>
                <td><%= qty %>개</td>
                <td><%= String.format("%,d", totalPrice) %>원</td>
                <td><%= o.get("order_date") %></td>
                <td>
                    <% if("대기".equals(resultStatus) || resultStatus == null || resultStatus.isEmpty()) { %>
                        <span class="status-wait">⏳ 승인 대기</span>
                    <% } else if("승인".equals(resultStatus) || "완료".equals(resultStatus)) { %>
                        <span class="status-ok">✅ <%= resultStatus %></span>
                    <% } else if("반려".equals(resultStatus)) { %>
                        <span class="status-no">❌ 발주 반려</span>
                    <% } else { %>
                        <span class="status-default"><%= resultStatus %></span>
                    <% } %>
                </td>
                <td>
                    <% if("대기".equals(resultStatus) || resultStatus == null || resultStatus.isEmpty()) { %>
                        <button class="btn-approve" onclick="processOrder('승인', <%= o.get("order_no") %>)">발주승인</button>
                        <button class="btn-reject" style="margin-left: 4px;" onclick="processOrder('반려', <%= o.get("order_no") %>)">발주반려</button>
                    <% } else { %>
                        <span style="color:#95a5a6; font-size:13px;">처리 완료 (<%= resultStatus %>)</span>
                    <% } %>
                </td>
            </tr>
            <% } %>
        <% } %>
        </tbody>
    </table>
</div>

<script>
function processOrder(status, orderNo) {
    var confirmMsg = status === '승인' 
        ? "선택한 발주 건을 [승인] 처리하고 물류 출고를 진행할까요?" 
        : "선택한 발주 건을 [반려(거절)] 처리하시겠습니까?";
        
    if(confirm(confirmMsg)) {
        // 방금 연동 분리 완료한 다목적 처리 페이지로 쿼리 스트링 전송
        location.href = "orderApprovePro.jsp?order_no=" + orderNo + "&status=" + encodeURIComponent(status);
    }
}
</script>
</body>
</html>