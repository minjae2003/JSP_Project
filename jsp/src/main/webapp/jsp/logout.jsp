<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String confirm = request.getParameter("confirm");

if("yes".equals(confirm)){
    session.invalidate();
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그아웃</title>

<style>

body{
    background:#f4f6f9;
    font-family:"맑은 고딕";
}

.box{
    width:400px;
    margin:200px auto;
    background:white;
    padding:40px;
    text-align:center;
    border-radius:10px;
    box-shadow:0 4px 15px rgba(0,0,0,0.15);
}

button{
    width:120px;
    height:45px;
    border:none;
    border-radius:5px;
    cursor:pointer;
    margin:10px;
}

.ok{
    background:#e74c3c;
    color:white;
}

.cancel{
    background:#3498db;
    color:white;
}

</style>

</head>
<body>

<div class="box">

    <h2>로그아웃 하시겠습니까?</h2>

    <br>

    <button class="ok"
            onclick="location.href='logout.jsp?confirm=yes'">
        확인
    </button>

    <button class="cancel"
            onclick="history.back()">
        취소
    </button>

</div>

</body>
</html>