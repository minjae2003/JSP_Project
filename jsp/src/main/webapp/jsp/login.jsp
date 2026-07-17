<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>편의점 관리 시스템</title>
<style>
    *{ margin:0; padding:0; box-sizing:border-box; }
    body{ height:100vh; display:flex; justify-content:center; align-items:center;
    	background:#f4f6f9; font-family:"맑은 고딕"; }
    .login-box{ width:400px; background:white; padding:40px; border-radius:12px;
    			 box-shadow:0 4px 15px rgba(0,0,0,0.15); }
    .title{ text-align:center; margin-bottom:30px; }
    .title h1{ font-size:28px; margin-bottom:10px; }
    .title p{ color:gray; }
    .input-box{ margin-bottom:15px; }
    .input-box input{ width:100%; height:45px; padding:0 10px; 
    					border:1px solid #ccc; border-radius:6px; font-size:15px; }
    .login-btn{ width:100%; height:48px; border:none; border-radius:6px; 
    background:#007bff; color:white; font-size:16px; cursor:pointer; }
    .login-btn:hover{ background:#0056b3; }
</style>
</head>
<body>
<div class="login-box">
    <div class="title">
        <h1>편의점 관리 시스템</h1>
        <p>Convenience Store Management</p>
    </div>
    <form action="loginAction.jsp" method="post">
        <div class="input-box">
            <input type="text" name="id" placeholder="아이디" required>
        </div>
        <div class="input-box">
            <input type="password" name="pw" placeholder="비밀번호" required>
        </div>
        <button type="submit" class="login-btn">로그인</button>
    </form>
</div>
</body>
</html>