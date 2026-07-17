<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.ProductDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    
    // 1. 점주 세션 보안 검증 및 권한 체크
    String ownerId = (String) session.getAttribute("id");
    Integer storeNo = (Integer) session.getAttribute("store_no"); 
    String role = (String) session.getAttribute("role");

    if (ownerId == null || !"owner".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. 🔗 분리 완료: ProductDAO를 호출하여 입고 폼에 노출할 상품 마스터 데이터 획득
    ProductDAO productDao = new ProductDAO();
    List<Map<String, Object>> allProductList = productDao.getPurchaseProductList();

    // 3. 오늘 날짜 및 현재 시간 기본값 세팅용 자바 포맷 로직
    java.text.SimpleDateFormat sdfDate = new java.text.SimpleDateFormat("yyyy-MM-dd");
    java.text.SimpleDateFormat sdfTime = new java.text.SimpleDateFormat("HH:mm");
    String today = sdfDate.format(new java.util.Date());
    String nowTime = sdfTime.format(new java.util.Date());
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>점주 - 물품 입고 등록 (재고 증가)</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f5f6fa; padding: 20px; }
    .container { max-width: 600px; margin: 40px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
    .title { font-size: 24px; font-weight: bold; color: #2c3e50; margin-bottom: 25px; text-align: center; border-bottom: 2px solid #e67e22; padding-bottom: 10px; }
    
    .form-group { margin-bottom: 18px; }
    .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #34495e; }
    .form-control { width: 100%; height: 45px; padding: 10px; border: 1px solid #ccd1d1; border-radius: 4px; font-size: 16px; background-color: #fff; }
    .form-control:focus { border-color: #e67e22; outline: none; }
    
    .row-group { display: flex; gap: 15px; }
    .row-group .form-group { flex: 1; }
    
    .btn-group { display: flex; gap: 10px; margin-top: 25px; }
    .btn { flex: 1; height: 50px; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; }
    .btn-submit { background: #e67e22; color: white; }
    .btn-submit:hover { background: #d35400; }
    .btn-cancel { background: #95a5a6; color: white; }
    .btn-cancel:hover { background: #7f8c8d; }
</style>
</head>
<body>

<div class="container">
    <div class="title">📦 매장 물품 입고 등록 (재고 반영)</div>

    <form action="purchasePro.jsp" method="post" onsubmit="return validateForm()">
        
        <div class="form-group">
            <label for="product_select">입고 상품 선택</label>
            <select name="product_no" id="product_select" class="form-control" onchange="autoFillPrice()">
                <option value="">-- 입고할 상품을 선택하세요 --</option>
                <% if(allProductList != null) {
                    for(Map<String, Object> p : allProductList) { %>
                        <option value="<%= p.get("product_no") %>" data-price="<%= p.get("product_price") %>">
                            [<%= p.get("sub_name") %>] <%= p.get("product_name") %>
                        </option>
                <%  }
                   } %>
            </select>
        </div>

        <div class="row-group">
            <div class="form-group">
                <label for="qty">입고 수량(개)</label>
                <input type="number" name="qty" id="qty" class="form-control" min="1" value="1">
            </div>
            <div class="form-group">
                <label for="purchase_price">판매(입고) 단가(원)</label>
                <input type="number" name="purchase_price" id="purchase_price" class="form-control" min="0">
            </div>
        </div>

        <div class="row-group">
            <div class="form-group">
                <label for="purchase_date">입고 날짜</label>
                <input type="date" name="purchase_date" id="purchase_date" class="form-control" value="<%= today %>">
            </div>
            <div class="form-group">
                <label for="purchase_time">입고 시간</label>
                <input type="time" name="purchase_time" id="purchase_time" class="form-control" value="<%= nowTime %>">
            </div>
        </div>

        <div class="btn-group">
            <button type="button" class="btn btn-cancel" onclick="location.href='OwnerMain.jsp'">취소</button>
            <button type="submit" class="btn btn-submit">실제 재고 입고 처리</button>
        </div>
    </form>
</div>

<script>
// 상품을 선택하면 기본 등록되어 있는 판매 가격을 금액란에 자동으로 입력해 주는 함수
function autoFillPrice() {
    var select = document.getElementById("product_select");
    var selectedOption = select.options[select.selectedIndex];
    var basePrice = selectedOption.getAttribute("data-price") || 0;
    
    document.getElementById("purchase_price").value = basePrice;
}

function validateForm() {
    var product = document.getElementById("product_select").value;
    var qty = document.getElementById("qty").value;
    var price = document.getElementById("purchase_price").value;
    var pDate = document.getElementById("purchase_date").value;
    var pTime = document.getElementById("purchase_time").value;

    if(!product) { alert("입고할 상품을 선택해주세요."); return false; }
    if(!qty || qty < 1) { alert("올바른 수량을 입력해주세요."); return false; }
    if(!price || price < 0) { alert("올바른 금액을 입력해주세요."); return false; }
    if(!pDate) { alert("입고 날짜를 지정해주세요."); return false; }
    if(!pTime) { alert("입고 시간을 지정해주세요."); return false; }

    return confirm("이 물품들을 확인하셨습니까?\n확인 시 즉시 내 매장의 재고 수량이 증가합니다.");
}
</script>

</body>
</html>