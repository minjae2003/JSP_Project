<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO" %>
<%@ page import="java.util.*" %>
<%
    String role = (String)session.getAttribute("role");
    if(role == null || !role.equals("manager")){
        response.sendRedirect("login.jsp");
        return;
    }

    ProductDAO dao = new ProductDAO();
    // 드롭다운(Select)에 상품 목록을 띄워주기 위해 전체 상품 불러오기
    List<Map<String, Object>> pList = dao.getProductList(0, 0);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 행사 등록</title>
<style>
*{ margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
.top{ height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
.menu button{ width:140px; height:40px; border:none; border-radius:5px; margin-right:8px; cursor:pointer; }
.logout button{ width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; }
.content{ padding:40px; }
.title{ font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }

.form-table { width: 600px; border-collapse: collapse; }
.form-table th, .form-table td { border: 1px solid #ccc; padding: 12px; }
.form-table th { background: #f4f4f4; width: 150px; text-align: left; }
.form-table select, .form-table input { width: 100%; padding: 8px; box-sizing: border-box; }
.submit-btn { width: 150px; height: 45px; background: #9b59b6; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin-top: 15px; }
</style>
</head>
<body>

<div class="top">
    <div class="menu">
        <button onclick="location.href='ManagerMain.jsp'">메인으로</button>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>

<div class="content">
    <div class="title">신규 행사(이벤트) 등록</div>  
    <form action="eventInsertPro.jsp" method="post">
        <table class="form-table">
            <tr>
                <th>대상 상품</th>
                <td>
                    <select name="product_no" required>
                        <option value="">상품을 선택하세요</option>
                        <% for(Map<String, Object> p : pList) { %>
                            <option value="<%= p.get("product_no") %>">
                                [<%= p.get("main_name") %>] <%= p.get("product_name") %>
                            </option>
                        <% } %>
                    </select>
                </td>
            </tr>
            <tr>
                <th>행사 타입</th>
                <td>
                    <select name="event_type" required>
                        <option value="1+1">1+1 행사</option>
                        <option value="2+1">2+1 행사</option>
                        <option value="할인">할인 행사</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>기준 수량 (N개)</th>
                <td><input type="number" name="event_count" value="1" min="1" placeholder="예: 1+1이면 1 입력"></td>
            </tr>
            <tr>
                <th>할인/증정 값</th>
                <td><input type="number" name="event_value" value="1" min="1" placeholder="예: 1+1이면 1 입력, 할인이면 금액입력"></td>
            </tr>
            <tr>
                <th>행사 시작일</th>
                <td><input type="date" name="start_date" required></td>
            </tr>
            <tr>
                <th>행사 종료일</th>
                <td><input type="date" name="end_date" required></td>
            </tr>
        </table>       
        <button type="submit" class="submit-btn">행사 등록하기</button>
    </form>
</div>
</body>
</html>