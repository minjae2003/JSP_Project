<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO, vo.ProductVO, java.util.List" %>
<%
    // DAO 인스턴스 가져오기
    ProductDAO dao = ProductDAO.getInstance();
    // 데이터 가져오기 (예: 1부터 10까지)
    List<ProductVO> list = dao.getProducts(1, 10);
%>
<html>
<head>
<title>상품 목록</title>
</head>
<body>
    <h2>상품 목록</h2>
    <a href="productInsert.jsp">상품 등록하기</a>
    <hr>
    <table border="1">
        <tr>
            <th>번호</th><th>상품명</th><th>가격</th><th>카테고리</th>
        </tr>
        <% if(list != null) { 
             for(ProductVO p : list) { %>
        <tr>
            <td><%= p.getProduct_no() %></td>
            <td><%= p.getProduct_name() %></td>
            <td><%= p.getProduct_price() %></td>
            <td><%= p.getSub_no() %></td>
        </tr>
        <%   } 
           } else { %>
        <tr><td colspan="4">등록된 상품이 없습니다.</td></tr>
        <% } %>
    </table>
</body>
</html>