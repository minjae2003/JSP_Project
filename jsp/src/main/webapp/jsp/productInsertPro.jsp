<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="dao.ProductDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String productName = request.getParameter("product_name");
    String subNoStr = request.getParameter("sub_no");
    String priceStr = request.getParameter("product_price");
    String productImg = request.getParameter("product_img"); // 이미지 파일 경로 혹은 파일명

    // 숫자형 데이터 데이터 변환 (빈 값 방어 코드)
    int subNo = (subNoStr != null && !subNoStr.isEmpty()) ? Integer.parseInt(subNoStr) : 0;
    int productPrice = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;

    Map<String, Object> productMap = new HashMap<>();
    productMap.put("product_name", productName);
    productMap.put("product_img", productImg != null && !productImg.isEmpty() ? productImg : "default.jpg");
    productMap.put("sub_no", subNo);
    productMap.put("product_price", productPrice);

    ProductDAO productDao = new ProductDAO();
    boolean isSuccess = productDao.insertProduct(productMap);
    if(isSuccess) {
%>
        <script>
            alert("신규 마스터 상품이 성공적으로 등록되었습니다.");
            location.href = "productList.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("상품 등록에 실패했습니다. 입력 데이터 혹은 제약조건을 확인하세요.");
            history.back();
        </script>
<%
    }
%>