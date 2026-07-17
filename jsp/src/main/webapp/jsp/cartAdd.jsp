<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 넘어온 데이터 받기
    int productNo = Integer.parseInt(request.getParameter("product_no"));
    String productName = request.getParameter("product_name");
    int qty = Integer.parseInt(request.getParameter("qty"));

    // 브라우저 기억 공간(세션)에서 기존 장바구니 꺼내기
    List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");
    
    // 장바구니가 없으면 새로 하나 만들기
    if(cart == null) {
        cart = new ArrayList<>();
    }

    // 새 상품 정보 맵으로 묶어서 장바구니에 넣기
    Map<String, Object> item = new HashMap<>();
    item.put("product_no", productNo);
    item.put("product_name", productName);
    item.put("qty", qty);
    cart.add(item);

    // 업데이트된 장바구니를 다시 세션에 저장
    session.setAttribute("cart", cart);
%>
<script>
    alert("장바구니에 담겼습니다!");
    location.href = "productList.jsp";
</script>