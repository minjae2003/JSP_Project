<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.ProductDAO" %>
<%
    // 1. 한글 인코딩 및 본사 관리자 세션 보안 검증
    request.setCharacterEncoding("UTF-8");
    String managerId = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (managerId == null || !"manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. 🔗 분리 완료: ProductDAO를 호출하여 카테고리(소분류) 리스트 획득
    ProductDAO productDao = new ProductDAO();
    List<Map<String, Object>> subCategoryList = productDao.getSubCategoryList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 상품 등록</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f5f6fa; padding: 20px; }
    .container { max-width: 600px; margin: 40px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    .title { font-size: 24px; font-weight: bold; color: #2c3e50; margin-bottom: 25px; text-align: center; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
    
    .form-group { margin-bottom: 18px; }
    .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #34495e; }
    .form-control { width: 100%; height: 45px; padding: 10px; border: 1px solid #ccd1d1; border-radius: 4px; font-size: 16px; background-color: #fff; }
    .form-control:focus { border-color: #3498db; outline: none; }
    
    .btn-group { display: flex; gap: 10px; margin-top: 25px; }
    .btn { flex: 1; height: 50px; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; }
    .btn-submit { background: #3498db; color: white; }
    .btn-submit:hover { background: #2980b9; }
    .btn-cancel { background: #95a5a6; color: white; }
    .btn-cancel:hover { background: #7f8c8d; }
</style>
</head>
<body>

<div class="container">
    <div class="title">🛒 신규 상품 등록 (본사 관리자용)</div>

    <form action="productInsertPro.jsp" method="post" onsubmit="return validateForm()">
        
        <div class="form-group">
            <label for="product_name">상품명</label>
            <input type="text" name="product_name" id="product_name" class="form-control" placeholder="예: 매콤 삼각김밥">
        </div>

        <div class="form-group">
            <label for="product_img">상품 이미지 파일명</label>
            <input type="text" name="product_img" id="product_img" class="form-control" placeholder="예: samgak.png">
        </div>

        <div class="form-group">
            <label for="sub_no">카테고리(소분류) 선택</label>
            <select name="sub_no" id="sub_no" class="form-control">
                <option value="">-- 카테고리를 선택하세요 --</option>
                <% if (subCategoryList != null) {
                    for(Map<String, Object> sub : subCategoryList) { %>
                        <option value="<%= sub.get("sub_no") %>">
                            <%= sub.get("sub_name") %> (분류번호: <%= sub.get("sub_no") %>)
                        </option>
                <%     }
                   } %>
            </select>
        </div>

        <div class="form-group">
            <label for="product_price">본사 판매 가격(원)</label>
            <input type="number" name="product_price" id="product_price" class="form-control" min="0" placeholder="예: 1200">
        </div>

        <div class="btn-group">
            <button type="button" class="btn btn-cancel" onclick="location.href='ManagerMain.jsp'">취소</button>
            <button type="submit" class="btn btn-submit">상품 등록 완료</button>
        </div>
    </form>
</div>

<script>
function validateForm() {
    var name = document.getElementById("product_name").value.trim();
    var subNo = document.getElementById("sub_no").value;
    var price = document.getElementById("product_price").value;

    if(!name) { alert("상품명을 입력해주세요."); return false; }
    if(!subNo) { alert("카테고리를 선택해주세요."); return false; }
    if(!price || price < 0) { alert("올바른 가격을 입력해주세요."); return false; }

    return confirm("이 정보로 신규 상품을 마스터 테이블에 등록하시겠습니까?");
}
</script>

</body>
</html>