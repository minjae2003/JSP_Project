<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.StoreDAO" %>
<%@ page import="java.util.*" %>
<%
String role = (String)session.getAttribute("role");

if(role == null || !role.equals("owner")){
    response.sendRedirect("login.jsp");
    return;
}

// 세션에 저장된 현재 점주의 매장번호 가져오기
int storeNo = (Integer)session.getAttribute("store_no");

StoreDAO storeDAO = new StoreDAO();
List<Map<String, Object>> invList = storeDAO.getStoreInventory(storeNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 조회</title>
<style>
*{ margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
.top{ height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
.menu button{ width:140px; height:40px; border:none; border-radius:5px; margin-right:8px; cursor:pointer; }
.logout button{ width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; }
.content{ padding:40px; }
.title{ font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }

/* 리스트용 테이블 스타일 */
.list-table { width: 100%; border-collapse: collapse; text-align: center; }
.list-table th, .list-table td { border: 1px solid #ccc; padding: 12px; }
.list-table th { background: #f4f4f4; }
.event-badge { background: #e74c3c; color: white; padding: 4px 10px; border-radius: 4px; font-size: 13px; font-weight: bold; }
</style>
</head>
<body>

<div class="top">
    <div class="menu">
        <button onclick="location.href='OwnerMain.jsp'">메인으로</button>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>

<div class="content">
    <div class="title">우리 매장 재고 현황</div>
    
    <table class="list-table">
        <tr>
            <th>상품명</th>
            <th>단가</th>
            <th>현재 재고 수량</th>
            <th>적용중인 행사</th>
        </tr>
        <% for(Map<String, Object> item : invList) { %>
        <tr>
            <td><%= item.get("product_name") %></td>
            <td><%= item.get("product_price") %>원</td>
            <td><strong><%= item.get("stock_qty") %>개</strong></td>
            <td>
                <% if(!"없음".equals(item.get("event_type"))) { %>
                    <span class="event-badge"><%= item.get("event_type") %></span>
                <% } else { %>
                    -
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>
</div>

</body>
</html>