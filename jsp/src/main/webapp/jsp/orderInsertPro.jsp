<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.TradeDAO" %>
<%
    // 로그인한 점주의 매장번호 가져오기
    Integer storeNo = (Integer)session.getAttribute("store_no");
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

    if(storeNo != null && cart != null && !cart.isEmpty()) {
        TradeDAO dao = new TradeDAO();
        boolean allSuccess = true;
        
        // 장바구니에 있는 거 하나씩 DB에 발주 내역으로 넣기
        for(Map<String, Object> item : cart) {
            int productNo = (Integer) item.get("product_no");
            int qty = (Integer) item.get("qty");
            
            boolean result = dao.insertOrder(storeNo, productNo, qty);
            if(!result) allSuccess = false; // 하나라도 실패하면 체크
        }
        
        if(allSuccess) {
            session.removeAttribute("cart"); // 성공했으니 장바구니 비우기
%>
            <script>
                alert("발주 신청이 완료되었습니다! 관리자 승인을 기다려주세요.");
                location.href = "OwnerMain.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("발주 신청 중 오류가 발생했습니다.");
                history.back();
            </script>
<%
        }
    } else {
%>
        <script>
            alert("세션이 만료되었거나 장바구니가 비어있습니다.");
            location.href = "productList.jsp";
        </script>
<%
    }
%>