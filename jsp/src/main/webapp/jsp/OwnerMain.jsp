<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 한글 인코딩 및 점주 세션 보안 검증
    request.setCharacterEncoding("UTF-8");
    String ownerId = (String) session.getAttribute("id");
    Integer storeNo = (Integer) session.getAttribute("store_no"); 
    String role = (String) session.getAttribute("role");

    if (ownerId == null || ! "owner".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>편의점 ERP - 가맹점주 시스템</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f5f6fa; color: #2c3e50; min-width:1200px;}
    
    /* 상단 네비게이션 바 */
    .top { width:100%; white-space:nowrap; height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
    .logo { width:15%; min-width:300px; color: #f1c40f; font-size: 20px; font-weight: bold; }
    .menu button { width:20%; min-width:100px; height:40px; border:none; border-radius:5px; margin-right:8px; cursor:pointer; font-weight:bold; background:#ecf0f1; transition: 0.2s; }
    .menu button:hover { background: #bdc3c7; }
    .logout button { width:10%; min-width:150px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; font-weight:bold; }
    .logout button:hover { background:#c0392b; }
    
    /* 본문 레이아웃 */
    .content { padding:40px; max-width: 1200px; margin: 0 auto; }
    .header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #34495e; padding-bottom: 15px; }
    .title { font-size:28px; font-weight:bold; color:#2c3e50; }
    .store-info { background: #34495e; color: white; padding: 8px 15px; border-radius: 20px; font-size: 14px; }
    
    /* 대시보드 카드 그리드 */
    .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 25px; margin-top: 20px; }
    .card { background: white; border-radius: 8px; padding: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); display: flex; flex-direction: column; justify-content: space-between; border-top: 4px solid #2c3e50; transition: 0.3s; }
    .card:hover { transform: translateY(-5px); box-shadow: 0 6px 12px rgba(0,0,0,0.15); }
    
    .card.purple { border-top-color: #9b59b6; }
    .card.orange { border-top-color: #e67e22; }
    .card.green { border-top-color: #2ecc71; }
    .card.blue { border-top-color: #3498db; }
    
    .card-title { font-size: 16px; color: #7f8c8d; font-weight: bold; margin-bottom: 10px; }
    .card-desc { font-size: 14px; color: #95a5a6; margin-bottom: 20px; line-height: 1.4; }
    .card-btn { width: 100%; height: 45px; border: none; border-radius: 4px; color: white; font-weight: bold; font-size: 15px; cursor: pointer; transition: 0.2s; }
    
    .purple .card-btn { background: #9b59b6; } .purple .card-btn:hover { background: #8e44ad; }
    .orange .card-btn { background: #e67e22; } .orange .card-btn:hover { background: #d35400; }
    .green .card-btn { background: #2ecc71; } .green .card-btn:hover { background: #27ae60; }
    .blue .card-btn { background: #3498db; } .blue .card-btn:hover { background: #2980b9; }
    .skyblue .card-btn { background: #32AAFF; } .skyblue .card-btn:hover { background: blue; }
</style>
</head>
<body>

<div class="top">
    <div class="logo">🏪 Smart GS24 관리자 시스템</div>
    <div class="menu">
        <button onclick="location.href='productList.jsp'">상품조회/발주</button>
        <button onclick="location.href='orderInsert.jsp'">발주현황</button>
        <button onclick="location.href='purchaseInsert.jsp'">입고처리</button>
        <button onclick="location.href='inventoryList.jsp'">재고조회</button>
        <button onclick="location.href='salesInsert.jsp'">포스기 결제</button>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>

<div class="content">
    
    <div class="header-box">
        <div class="title">가맹점주 경영 대시보드</div>
        <div class="store-info">
            🔑 접속 ID: <strong><%= ownerId %></strong> | 🏪 가맹점 코드: <strong><%= storeNo %>호점</strong>
        </div>
    </div>

    <div class="dashboard-grid">
        
        <div class="card purple">
            <div>
                <div class="card-title">📦 본사 상품 마스터 조회</div>
                <div class="card-desc">본사에서 취급 및 취급 대기 중인 전체 카테고리별 상품 리스트와 표준 출고 단가를 확인합니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='productList.jsp'">상품 카탈로그 보기</button>
        </div>

        <div class="card orange">
            <div>
                <div class="card-title">📝 본사 물품 발주 현황</div>
                <div class="card-desc">매장에 부족한 재고를 본사에 신청한 현황을 보여줍니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='orderInsert.jsp'">발주 현황보기 </button>
        </div>

        <div class="card green">
            <div>
                <div class="card-title">📦 매장 실시간 입고 등록</div>
                <div class="card-desc">본사에서 승인되어 도착한 물품들을 매장 창고에 넣고 **실시간 보유 재고 수량을 증가**시킵니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='purchaseInsert.jsp'">실제 재고 입고하기</button>
        </div>
        
        <div class="card skyblue">
            <div>
                <div class="card-title">📦 매장 실시간 재고 확인</div>
                <div class="card-desc">본사에서 승인되어 도착한 물품들의 재고를 확인 할 수 있습니다</div>
            </div>
            <button class="card-btn" onclick="location.href='inventoryList.jsp'">실제 재고 입고하기</button>
        </div>

        <div class="card blue">
            <div>
                <div class="card-title">🖥️ 가맹점 POS 판매 결제</div>
                <div class="card-desc">손님이 물건을 구매할 때 사용합니다. 판매 즉시 매장 **재고는 감소**하고 본사 **매출에 반영**됩니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='salesInsert.jsp'">포스기 결제창 열기</button>
        </div>

    </div>
</div>

</body>
</html>