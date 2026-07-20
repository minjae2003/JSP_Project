<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ProductDAO" %>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String id = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (id == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String userRole = "manager".equals(role) ? "manager" : "owner";

    ProductDAO productDao = new ProductDAO();
    List<Map<String, Object>> productList = productDao.getProductList(0, 0);
    
    if(productList == null) {
        productList = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통합 상품 물류 시스템</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f8f9fa; min-width:1200px;}
    .top { height:100%;white-space:nowrap;height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
    .menu button { width:30%; min-width:140px; height:40px; border:none; border-radius:5px; margin-right:8px; cursor:pointer; background:#ecf0f1; font-weight:bold; }
    .logout button {width:10%; min-width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; font-weight:bold; }
    .content { padding:40px; max-width: 1300px; margin: 0 auto; }
    .title { font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }
    
    /* [관리자 전용] 상품 등록 폼 */
    .insert-box { background: white; padding: 25px; border-radius: 8px; border-top: 4px solid #3498db; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 30px; }
    .insert-box h3 { margin-bottom: 15px; color: #2c3e50; }
    .form-group { display: flex; flex-wrap: wrap; gap: 12px; align-items: center; }
    .form-group input, .form-group select { padding: 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
    .btn-submit { background: #3498db; color: white; border: none; padding: 10px 25px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-submit:hover { background: #2980b9; }

    /* 테이블 스타일 */
    .list-table { width: 100%; border-collapse: collapse; text-align: center; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .list-table th, .list-table td { border: 1px solid #ccc; padding: 12px; }
    .list-table th { background: #f4f4f4; color: #333; }
    
    /* 버튼 스타일 */
    .qty-input { width: 60px; padding: 5px; text-align: center; }
    .btn-order { background: #3498db; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-sales { background: #e67e22; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-delete { background: #e74c3c; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-delete:hover { background: #c0392b; }
    .role-badge { background: #2c3e50; color: white; padding: 3px 8px; border-radius: 3px; font-size: 12px; font-weight: normal; margin-left: 10px;}
</style>
</head>
<body>

<div class="top">
    <div class="menu">
        <% if("manager".equals(userRole)) { %>
            <button onclick="location.href='ManagerMain.jsp'">메인으로</button>
        <% } else { %>
            <button onclick="location.href='OwnerMain.jsp'">메인으로</button>
            <button onclick="location.href='inventoryList.jsp'">재고조회 확인</button>
            <button onclick="location.href='orderInsert.jsp'" style="background-color: #34495e; color: white;">발주 현황 확인</button>
        <% } %>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>

<div class="content">
    <div class="title">
        물류 시스템 상품 관리 
        <span class="role-badge"><%= "manager".equals(userRole) ? "본사 관리자 모드" : "매장 점주 모드" %></span>
    </div>
    
    <% if("manager".equals(userRole)) { %>
    <div class="insert-box">
        <h3>✨ 편의점 새 상품 등록 (DB 카테고리 동기화)</h3>
        <form action="productInsertPro.jsp" method="post" class="form-group">
            <select id="mainCategory" onchange="updateSubCategory()" required>
                <option value="">-- 대분류 선택 --</option>
                <option value="1">냉장 상품</option>
                <option value="2">일반 상품</option>
            </select>
            
            <select name="sub_no" id="subCategory" required>
                <option value="">-- 소분류 선택 --</option>
            </select>
            
            <input type="text" name="product_name" placeholder="상품명 입력 (예: 전주비빔삼각김밥)" required style="width: 280px;">
            <input type="number" name="product_price" placeholder="판매 가격(원)" min="0" required style="width: 140px;">
            
            <button type="submit" class="btn-submit">상품 추가</button>
        </form>
    </div>
    <% } %>

    <table class="list-table">
        <tr>
            <th>상품번호</th>
            <th>대분류</th>
            <th>소분류</th>
            <th>상품명</th>
            <th>소비자 단가</th>
            <% if("owner".equals(userRole)) { %>
                <th>수량 선택</th>
                <th>본사 발주</th>
                <th>매장 판매(POS)</th>
            <% } else { %>
                <th>관리 액션</th>
            <% } %>
        </tr>
        <% if(productList.isEmpty()) { %>
        <tr>
            <td colspan="<%= "owner".equals(userRole) ? 8 : 6 %>" style="color:#7f8c8d; padding:30px;">등록된 상품이 없습니다.</td>
        </tr>
        <% } else { %>
            <% for(Map<String, Object> p : productList) { %>
            <tr>
                <td><%= p.get("product_no") %></td>
                <td><%= p.get("main_name") != null ? p.get("main_name") : "-" %></td>
                <td><span style="color:#2980b9; font-weight:bold;"><%= p.get("sub_name") != null ? p.get("sub_name") : "-" %></span></td>
                <td style="text-align: left; padding-left: 20px;"><strong><%= p.get("product_name") %></strong></td>
                <td><%= String.format("%,d", ((Number)p.get("product_price")).intValue()) %>원</td>             
                <% if("owner".equals(userRole)) { %>
                    <td>
                        <input type="number" id="qty_<%= p.get("product_no") %>" class="qty-input" value="1" min="1">
                    </td>
                    <td>
                        <button class="btn-order" onclick="actionSubmit('order', <%= p.get("product_no") %>, <%= p.get("product_price") %>)">발주 신청</button>
                    </td>
                    <td>
                        <button class="btn-sales" onclick="actionSubmit('sales', <%= p.get("product_no") %>, <%= p.get("product_price") %>)">POS 결제</button>
                    </td>
                <% } else { %>
                    <td>
                        <button class="btn-delete" onclick="deleteProduct(<%= p.get("product_no") %>, '<%= p.get("product_name") %>')">삭제</button>
                    </td>
                <% } %>
            </tr>
            <% } %>
        <% } %>
    </table>
</div>

<form id="actionForm" method="post" style="display:none;">
    <input type="hidden" name="product_no" id="form_pno">
    <input type="hidden" name="qty" id="form_qty">
    <input type="hidden" name="product_price" id="form_price">
</form>

<script>
const dbSubCategories = {
    "1": [
        {val: "1", txt: "삼각김밥"}, {val: "2", txt: "김밥"}, {val: "3", txt: "햄버거"}, 
        {val: "4", txt: "족발/편육"}, {val: "5", txt: "우유"}, {val: "6", txt: "요거트"}, 
        {val: "7", txt: "치즈"}, {val: "8", txt: "아이스크림"}, {val: "9", txt: "얼음"}, 
        {val: "10", txt: "만두"}, {val: "11", txt: "냉동피자"}
    ],
    "2": [
        {val: "12", txt: "과자"}, {val: "13", txt: "음료"}, {val: "14", txt: "주류"}, 
        {val: "15", txt: "일회용품"}, {val: "16", txt: "화장품"}, {val: "17", txt: "세제"}
    ]
};

function updateSubCategory() {
    const mainSelect = document.getElementById("mainCategory");
    const subSelect = document.getElementById("subCategory");
    const selectedMain = mainSelect.value;
    
    subSelect.innerHTML = '<option value="">-- 소분류 선택 --</option>';
    
    if(dbSubCategories[selectedMain]) {
        dbSubCategories[selectedMain].forEach(sub => {
            const opt = document.createElement("option");
            opt.value = sub.val;
            opt.textContent = sub.txt;
            subSelect.appendChild(opt);
        });
    }
}

function actionSubmit(type, pno, price) {
    var qty = document.getElementById("qty_" + pno).value;
    if(qty < 1 || qty == "") { alert("올바른 수량을 입력해주세요."); return; }
    document.getElementById("form_pno").value = pno;
    document.getElementById("form_qty").value = qty;
    document.getElementById("form_price").value = price;
    var form = document.getElementById("actionForm");
    
    if(type === 'order') {
        if(confirm("본사에 해당 상품을 " + qty + "개 발주 신청하시겠습니까?")) {
            form.action = "orderPro.jsp"; form.submit();
        }
    } else if(type === 'sales') {
        if(confirm("해당 상품을 " + qty + "개 판매(결제) 완료 처리합니까?")) {
            form.action = "pos.jsp"; form.submit();
        }
    }
}

// 👑 관리자 전용 삭제 핸들러 함수
function deleteProduct(productNo, productName) {
    if(confirm("[" + productName + "] 상품을 물류 마스터 DB에서 영구 삭제하시겠습니까?\n(※ 삭제 시 복구가 불가능합니다.)")) {
        location.href = "productDeletePro.jsp?product_no=" + productNo;
    }
}
</script>
</body>
</html>