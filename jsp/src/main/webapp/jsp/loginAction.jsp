<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDAO, java.util.Map" %>
<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");

    MemberDAO dao = new MemberDAO(); 

    // 통합 로그인 메서드 호출
    Map<String, Object> user = dao.login(id, pw);

    if (user != null) {
        // 세션에 정보 저장
        session.setAttribute("id", user.get("id"));
        session.setAttribute("role", user.get("role"));
        
        // 점주일 경우에만 store_no 저장
        if (user.get("store_no") != null) {
            session.setAttribute("store_no", user.get("store_no"));
        }

        // 역할에 따른 페이지 이동
        if ("manager".equals(user.get("role"))) {
            response.sendRedirect("ManagerMain.jsp");
        } else {
            response.sendRedirect("OwnerMain.jsp");
        }
        return;
    }

    out.println("<script>alert('아이디 또는 비밀번호가 잘못되었습니다.'); history.back();</script>");
%>