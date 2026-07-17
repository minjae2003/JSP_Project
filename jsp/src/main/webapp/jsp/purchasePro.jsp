<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 1. 세션에서 점주의 매장 정보 검증
    Integer storeNo = (Integer) session.getAttribute("store_no");
    if (storeNo == null) {
        storeNo = 1; // 테스트 환경 및 방어 코딩용 디폴트 매장 지정
    }

    // 2. 넘어온 폼 파라미터 값 추출
    int productNo = Integer.parseInt(request.getParameter("product_no"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    int purchasePrice = Integer.parseInt(request.getParameter("purchase_price"));
    String purchaseDate = request.getParameter("purchase_date");
    String purchaseTime = request.getParameter("purchase_time");
    
    // 3. 시간 포맷 규격 보정 처리 (:00 세컨드 규격 강제 매핑)
    if(purchaseTime != null && purchaseTime.length() == 5) {
        purchaseTime += ":00";
    }

    // 4. 🔗 분리 완료: ProductDAO의 트랜잭션 전용 결제 처리 메서드 원라인 호출
    ProductDAO productDao = new ProductDAO();
    boolean success = productDao.executePurchaseTransaction(productNo, qty, purchasePrice, storeNo, purchaseDate, purchaseTime);

    // 5. 비즈니스 로직 실행 결과 피드백 분기 처리
    if (success) {
%>
        <script>
            alert("물품 입고가 정상 완료되었습니다!\n매장 재고 수량이 실시간으로 반영되었습니다.");
            location.href = "OwnerMain.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("입고 실패! 데이터를 다시 확인하세요.");
            history.back();
        </script>
<%
    }
%>