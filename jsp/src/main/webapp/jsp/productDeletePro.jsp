<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO" %>
<%
    // 1. 보안 검증: 세션 확인 및 관리자 권한 차단
    String role = (String)session.getAttribute("role");
    if(role == null || !role.equals("manager")){
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. 주소창(GET 방식)으로 넘어온 product_no 파라미터 받기
    String productNoStr = request.getParameter("product_no");
    
    if(productNoStr == null || productNoStr.trim().equals("")) {
%>
        <script>
            alert("잘못된 접근입니다.");
            location.href = "productList.jsp";
        </script>
<%
        return;
    }

    int productNo = Integer.parseInt(productNoStr);

    // 3. ProductDAO 객체를 생성해서 실제 DB 행 삭제 메서드 호출
    ProductDAO dao = new ProductDAO();
    boolean success = dao.deleteProduct(productNo); // ProductDAO에 이 메서드가 선언되어 있어야 합니다.

    // 4. 결과 알림 및 새로고침 이동
    if(success) {
%>
        <script>
            alert("선택하신 상품이 시스템 DB에서 영구 삭제되었습니다.");
            location.href = "productList.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("삭제 실패: 이미 발주 내역이 존재하거나 점주 재고 테이블에 등록되어 사용 중인 상품입니다.");
            history.back();
        </script>
<%
    }
%>