<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.ProductDAO" %>
<%
    // 1. 점주 세션 보안 검증
    request.setCharacterEncoding("UTF-8");
    String ownerId = (String) session.getAttribute("id");
    Integer storeNo = (Integer) session.getAttribute("store_no"); 
    String role = (String) session.getAttribute("role");

    if (ownerId == null || !"owner".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. 🔗 ProductDAO를 호출하여 판매 셀렉트 박스에 보여줄 상품 목록 가져오기
    ProductDAO productDao = new ProductDAO();
    List<Map<String, Object>> activeProductList = productDao.getPurchaseProductList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가맹점 POS 시스템 - 판매 등록</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f1f2f6; }
    .top{ height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; }
	.menu button{ width:140px; height:40px; border:none; border-radius:5px; margin-right:8px; cursor:pointer; }
	.logout button{ width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; }
	.content{ padding:40px; }
	.title{ font-size:28px; font-weight:bold; color:#2c3e50; margin-bottom:20px; }
	
    .pos-container { max-width: 650px; margin: 50px auto; background: white; padding: 35px; border-radius: 12px; box-shadow: 0 8px 20px rgba(0,0,0,0.15); border-top: 6px solid #3498db; }
    .pos-title { font-size: 26px; font-weight: bold; color: #2c3e50; margin-bottom: 30px; text-align: center; display: flex; justify-content: center; align-items: center; gap: 10px; }
    
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #2c3e50; }
    .form-control { width: 100%; height: 48px; padding: 12px; border: 2px solid #ced4da; border-radius: 6px; font-size: 16px; background-color: #fff; transition: 0.2s; }
    .form-control:focus { border-color: #3498db; outline: none; }
    
    .row-group { display: flex; gap: 20px; }
    .row-group .form-group { flex: 1; }
    
    /* 포스기 계산 대기판 느낌의 요약창 */
    .receipt-preview { background: #2c3e50; color: #2ecc71; padding: 20px; border-radius: 6px; margin: 25px 0; text-align: right; font-family: 'Courier New', Courier, monospace; }
    .receipt-preview .label { font-size: 14px; color: #bdc3c7; display: block; margin-bottom: 5px; }
    .receipt-preview .total-price { font-size: 32px; font-weight: bold; }

    .btn-group { display: flex; gap: 15px; margin-top: 10px; }
    .btn { flex: 1; height: 52px; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; transition: 0.2s; }
    .btn-submit { background: #3498db; color: white; }
    .btn-submit:hover { background: #2980b9; }
    .btn-cancel { background: #95a5a6; color: white; }
    .btn-cancel:hover { background: #7f8c8d; }
	</style>
</head>
<body>

	<div class="top">
    	<div class="menu">
        	<button onclick="location.href='OwnerMain.jsp'">메인으로</button>
    	</div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
	</div>
	<div class="pos-container">
    <div class="pos-title">🖥️ 실시간 가맹점 POS 판매 단말기</div>

    <form action="salesPro.jsp" method="post" onsubmit="return validatePOS()">
        
        <div class="form-group">
            <label for="product_select">🛍️ 스캔 / 상품 선택</label>
            <select name="product_no" id="product_select" class="form-control" onchange="calculateTotal()">
                <option value="">-- 판매할 상품을 선택(스캔) 하세요 --</option>
                <% if(activeProductList != null) {
                    for(Map<String, Object> p : activeProductList) { %>
                        <option value="<%= p.get("product_no") %>" data-price="<%= p.get("product_price") %>">
                            [<%= p.get("sub_name") %>] <%= p.get("product_name") %> — (<%= String.format("%,d", (Integer)p.get("product_price")) %>원)
                        </option>
                <%  }
                   } %>
            </select>
        </div>

        <div class="row-group">
            <div class="form-group">
                <label for="qty">🔢 판매 수량</label>
                <input type="number" name="qty" id="qty" class="form-control" min="1" value="1" oninput="calculateTotal()">
            </div>
            <div class="form-group">
                <label for="display_price">💵 개당 단가(원)</label>
                <input type="text" id="display_price" class="form-control" readonly style="background-color: #e9ecef; color: #495057; font-weight: bold;">
                <!-- 실제 서버로 전송할 hidden 가격 파라미터 -->
                <input type="hidden" name="purchase_price" id="purchase_price">
            </div>
        </div>

        <!-- 영수증 금액 모니터 박스 -->
        <div class="receipt-preview">
            <span class="label">💳 결제 예정 총 금액 (TOTAL AMOUNT)</span>
            <span class="total-price" id="total_price_view">0원</span>
        </div>

        <div class="btn-group">
            <button type="button" class="btn btn-cancel" onclick="location.href='OwnerMain.jsp'">닫기</button>
            <button type="submit" class="btn btn-submit">🛒 영수증 발행 및 결제 완료</button>
        </div>
    </form>
</div>

<script>
// 상품 선택 및 수량 변경 시 하단 전광판에 총 결제 금액을 계산해주는 POS 자바스크립트 엔진
function calculateTotal() {
    var select = document.getElementById("product_select");
    var selectedOption = select.options[select.selectedIndex];
    
    // 선택된 상품의 단가 가져오기 (없으면 0)
    var price = parseInt(selectedOption.getAttribute("data-price")) || 0;
    var qty = parseInt(document.getElementById("qty").value) || 1;
    
    if(qty < 1) {
        qty = 1;
        document.getElementById("qty").value = 1;
    }

    // 단가 화면 표시 및 히든 폼 값 입력
    document.getElementById("display_price").value = price.toLocaleString() + " 원";
    document.getElementById("purchase_price").value = price;
    
    // 총합 계산 및 표시
    var total = price * qty;
    document.getElementById("total_price_view").innerText = total.toLocaleString() + "원";
}

function validatePOS() {
    var product = document.getElementById("product_select").value;
    var qty = document.getElementById("qty").value;

    if(!product) {
        alert("결제 진행할 상품을 선택해 주세요.");
        return false;
    }
    if(!qty || qty < 1) {
        alert("판매 수량은 최소 1개 이상이어야 합니다.");
        return false;
    }

    return confirm("결제를 확정하시겠습니까?\n확정 즉시 매장 재고가 차감되며 매출 내역으로 집계됩니다.");
}
</script>

</body>
</html>