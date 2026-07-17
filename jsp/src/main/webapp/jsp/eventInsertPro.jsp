<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO" %>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    Map<String, Object> event = new HashMap<>();
    event.put("product_no", Integer.parseInt(request.getParameter("product_no")));
    event.put("event_type", request.getParameter("event_type"));
    event.put("event_count", Integer.parseInt(request.getParameter("event_count")));
    event.put("event_value", Integer.parseInt(request.getParameter("event_value")));
    event.put("start_date", request.getParameter("start_date"));
    event.put("end_date", request.getParameter("end_date"));

    ProductDAO dao = new ProductDAO();
    boolean success = dao.insertProductEvent(event);

    if(success) {
%>
        <script>
            alert("행사(이벤트)가 성공적으로 등록되었습니다!");
            location.href = "ManagerMain.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("행사 등록 중 오류가 발생했습니다. 다시 시도해주세요.");
            history.back();
        </script>
<%
    }
%>