<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.TradeDAO" %>
<%
    // 1. 한글 인코딩 및 세션 점주 정보 확인
    request.setCharacterEncoding("UTF-8");
    Integer storeNo = (Integer) session.getAttribute("store_no");
    if (storeNo == null) {
        storeNo = 1; // 테스트 및 세션 만료 대비 방어 코드
    }

    // 2. 폼 파라미터 수신 (에러 유발 지점 name 보정 완료)
    int productNo = Integer.parseInt(request.getParameter("product_no"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    
    // 🛠️ 핵심 교정: salesInsert.jsp에서 'purchase_price'라는 이름으로 넘어오므로 바인딩 이름을 맞춥니다.
    int price = Integer.parseInt(request.getParameter("purchase_price"));

    // 3. 🔗 TradeDAO 호출을 통한 일괄 비즈니스 로직(결제 및 매출 등록) 처리 위임
    TradeDAO tradeDao = new TradeDAO();
    boolean success = tradeDao.processSales(storeNo, productNo, qty, price);

    // 4. 결과 처리 알림창 및 페이지 이동 제어
    if (success) {
%>
        <script>
            alert("영수증 발행 및 결제가 완료되었습니다!\n실시간 매출 통계에 즉시 반영됩니다.");
            location.href = "OwnerMain.jsp"; // 점주 메인으로 이동
        </script>
<%
    } else {
%>
        <script>
            alert("결제 처리 실패! 입력 데이터나 매장 재고 상태를 확인하세요.");
            history.back();
        </script>
<%
    }
%>