<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO, vo.ProductVO" %>
<%
    request.setCharacterEncoding("UTF-8");

    try {
        // 폼에서 텍스트 데이터 받기
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
        ProductDAO productDao = new ProductDAO();

        // 정상 처리 시 목록으로 돌아가기
        response.sendRedirect("productList.jsp");

    } catch (Exception e) {
        // DB 추가 실패 시 에러 화면 출력
        e.printStackTrace();
%>
        <script>
            alert("DB 추가 실패! 원인: <%= e.getMessage() %>\n(존재하지 않는 카테고리 번호를 입력했거나 DB 연결 문제일 수 있습니다.)");
            history.back();
        </script>
<%
    }
%>