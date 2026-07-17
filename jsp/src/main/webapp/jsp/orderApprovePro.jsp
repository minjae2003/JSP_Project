<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.TradeDAO" %>
<%
    // 1. 한글 인코딩 및 관리자 세션 검증
    request.setCharacterEncoding("UTF-8");
    String managerId = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (managerId == null || !"manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    // 2. 파라미터 수신 (발주번호, 처리 상태 - '승인' 또는 '반려')
    String orderNoParam = request.getParameter("order_no");
    String status = request.getParameter("status"); 

    if (orderNoParam == null || status == null || orderNoParam.isEmpty() || status.isEmpty()) {
%>
        <script>
            alert("잘못된 요청 파라미터입니다.");
            history.back();
        </script>
<%
        return;
    }
    int orderNo = Integer.parseInt(orderNoParam);

    // 3. 🔗 분리 완료: TradeDAO의 확장형 메서드를 호출하여 비즈니스 로직 처리
    TradeDAO tradeDao = new TradeDAO();
    boolean isSuccess = tradeDao.updateOrderStatus(orderNo, status);

    // 4. 처리 결과에 따른 스크립트 알림 및 리다이렉트
%>
<script>
    if (<%= isSuccess %>) {
        alert("선택하신 발주 정보가 성공적으로 [<%= status %>] 처리되었습니다.");
        // 호출한 이전 관리 목록 화면(managerOrderList.jsp)으로 깔끔하게 새로고침 이동
        location.href = document.referrer; 
    } else {
        alert("DB 업데이트 실패! 상태를 다시 확인해 주세요.");
        history.back();
    }
</script>