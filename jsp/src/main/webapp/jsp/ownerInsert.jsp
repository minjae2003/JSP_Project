<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String role = (String)session.getAttribute("role");

if(role == null || !role.equals("manager")){
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점주 및 매장 등록</title>
<style>
*{ margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
.top{ height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
.menu button{ width:140px; height:40px; border:none; border-radius:5px; margin-right:8px; cursor:pointer; }
.logout button{ width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; }
.content{ padding:40px; }
.title{ font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }

/* 폼 입력용 추가 테이블 스타일 */
.form-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
.form-table th, .form-table td { border: 1px solid #ccc; padding: 12px; }
.form-table th { background: #f4f4f4; width: 150px; text-align: left; }
.form-table input[type="text"], .form-table input[type="password"] { width: 250px; padding: 5px; }
.submit-btn { width: 140px; height: 40px; background: #3498db; color: white; 
		border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
.section-title { background: #e2e2e2 !important; text-align: center !important; font-weight: bold; }
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
    <div class="title">점주 및 매장 동시 등록</div>
    
    <form action="ownerInsertPro.jsp" method="post">
        <table class="form-table">
            <tr><th colspan="2" class="section-title">[ 매장 정보 ]</th></tr>
            <tr><th>매장명</th><td><input type="text" name="store_name" required></td></tr>
            <tr><th>매장 주소</th><td><input type="text" name="address" required></td></tr>
            <tr><th>사업자번호</th><td><input type="text" name="business_no" required></td></tr>
            <tr><th>매장 연락처</th><td><input type="text" name="phone" required></td></tr>
            <tr><th>담당 관리자 ID</th><td><input type="text" name="manager_id" 
            value="<%= session.getAttribute("id") %>" readonly style="background:#eee;"></td></tr>
            
            <tr><th colspan="2" class="section-title">[ 점주 정보 ]</th></tr>
            <tr><th>점주 ID</th><td><input type="text" name="owner_id" required></td></tr>
            <tr><th>비밀번호</th><td><input type="password" name="owner_pw" required></td></tr>
            <tr><th>점주 이름</th><td><input type="text" name="owner_name" required></td></tr>
            <tr><th>점주 연락처</th><td><input type="text" name="owner_phone" required></td></tr>
        </table>
        
        <div style="text-align: center;">
            <button type="submit" class="submit-btn">등록 완료하기</button>
        </div>
    </form>
</div>

</body>
</html>