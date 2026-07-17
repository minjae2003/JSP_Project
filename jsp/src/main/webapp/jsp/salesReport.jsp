<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.TradeDAO" %>
<%
    // 1. 한글 인코딩 및 본사 관리자 세션 검증
    request.setCharacterEncoding("UTF-8");
    String managerId = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (managerId == null || !"manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. 🔗 분리 완료: TradeDAO를 장착하여 전 가맹점 통합 실시간 매출 내역 데이터 획득
    TradeDAO tradeDao = new TradeDAO();
    List<Map<String, Object>> salesReportList = tradeDao.getSystemSalesReportList();
    
    // 3. 루프 전 인메모리 스캔으로 시스템 총 매출 합계 신속 계산
    int totalSystemSales = 0; 
    if (salesReportList != null) {
        for (Map<String, Object> s : salesReportList) {
            totalSystemSales += (Integer) s.get("sales_price");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본사 관리자 - 전 가맹점 통합 매출 리포트</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f8f9fa; }
    .top { height:100%; white-space:nowrap; height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
    .menu button { width:20%; min-width:140px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#ecf0f1; font-weight:bold; }
    .logout button { width:10%; min-width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; font-weight:bold; }
    .content { padding:40px; max-width: 1300px; margin: 0 auto; }
    .title { font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }
    
    /* 상단 요약 카드 상자 */
    .summary-box { background: white; padding: 20px; border-radius: 8px; border-left: 5px solid #2ecc71; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
    .summary-box h3 { color: #7f8c8d; font-size: 16px; margin-bottom: 5px; }
    .summary-box .total-amount { font-size: 26px; font-weight: bold; color: #2ecc71; }

    /* 테이블 스타일 */
    .list-table { width: 100%; border-collapse: collapse; text-align: center; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .list-table th, .list-table td { border: 1px solid #ccc; padding: 12px; font-size: 15px; }
    .list-table th { background: #f4f4f4; color: #333; }
    
    .role-badge { background: #e67e22; color: white; padding: 3px 8px; border-radius: 3px; font-size: 12px; font-weight: normal; margin-left: 10px;}
</style>
</head>
<body>

<div class="top">
    <div class="menu">
        <button onclick="location.href='ManagerMain.jsp'">메인으로</button>
        <button onclick="location.href='productList.jsp'">상품 마스터 관리</button>
        <button onclick="location.href='orderList.jsp'">발주 내역 관리</button>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>

<div class="content">
    <div class="title">
        📊 전 가맹점 통합 매출 리포트
        <span class="role-badge">본사 총괄 관리자 모드</span>
    </div>

    <div class="summary-box">
        <div>
            <h3>🏪 전체 가맹점 누적 매출 총액</h3>
            <div class="total-amount"><%= String.format("%,d", totalSystemSales) %>원</div>
        </div>
        <div style="text-align: right; color: #95a5a6; font-size: 14px;">
            실시간 판매 데이터 반영 완료
        </div>
    </div>

    <table class="list-table">
        <tr>
            <th>판매번호</th>
            <th>가맹점명</th>
            <th>판매 상품명</th>
            <th>판매 수량</th>
            <th>총 판매 금액</th>
            <th>판매 일시</th>
        </tr>
        <% if(salesReportList == null || salesReportList.isEmpty()) { %>
        <tr>
            <td colspan="6" style="color:#7f8c8d; padding:40px;">현재 시스템에 집계된 가맹점 매출 판매 데이터가 없습니다.</td>
        </tr>
        <% } else { %>
            <% for(Map<String, Object> s : salesReportList) { %>
            <tr>
                <td><%= s.get("sales_no") %></td>
                <td><strong><%= s.get("store_name") %></strong></td>
                <td style="text-align: left; padding-left: 20px;"><%= s.get("product_name") %></td>
                <td><%= s.get("qty") %>개</td>
                <td style="color:#27ae60; font-weight:bold;"><%= String.format("%,d", (Integer)s.get("sales_price")) %>원</td>
                <td style="color:#7f8c8d;"><%= s.get("sales_date") %></td>
            </tr>
            <% } %>
        <% } %>
    </table>
</div>

</body>
</html>