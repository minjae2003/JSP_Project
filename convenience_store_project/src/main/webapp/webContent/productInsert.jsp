<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<body>
    <h2>상품 등록</h2>
    <form action="insertAction.jsp" method="post">
        상품명: <input type="text" name="product_name"><br>
        이미지명: <input type="text" name="product_img"><br>
        카테고리 번호: <input type="text" name="sub_no"><br>
        가격: <input type="text" name="product_price"><br>
        <input type="submit" value="등록">
    </form>
</body>
</html>