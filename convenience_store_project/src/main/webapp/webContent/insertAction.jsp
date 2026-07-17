<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO, vo.ProductVO" %>
<%
    request.setCharacterEncoding("UTF-8"); // 한글 깨짐 방지

    // 폼에서 데이터 받기
    String name = request.getParameter("product_name");
    String img = request.getParameter("product_img");
    int subNo = Integer.parseInt(request.getParameter("sub_no"));
    int price = Integer.parseInt(request.getParameter("product_price"));

    // VO 객체 생성
    ProductVO vo = new ProductVO();
    vo.setProduct_name(name);
    vo.setProduct_img(img);
    vo.setSub_no(subNo);
    vo.setProduct_price(price);

    // DB에 데이터 넣기
    ProductDAO.getInstance().insertProduct(vo);

    // 목록으로 돌아가기
    response.sendRedirect("productList.jsp");
%>