<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 한글 인코딩 및 본사 총괄 관리자 세션 보안 검증
    request.setCharacterEncoding("UTF-8");
    String managerId = (String) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (managerId == null || ! "manager".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>편의점 ERP - 본사 총괄 관리자 시스템</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; font-family:"맑은 고딕"; }
    body { background: #f5f6fa; color: #2c3e50; min-width:1200px;}
    
    /* 상단 네비게이션 바 */
    .top { width:100%;height:70px; background:#2c3e50; display:flex; justify-content:space-between; align-items:center; padding:0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
    .logo { width:15% min-width:300px; color: #f1c40f; font-size: 20px; font-weight: bold; }
    .menu button { width:15%; min-width:100px; height:40px; border:none; border-radius:5px; margin-right:8px; cursor:pointer; font-weight:bold; background:#ecf0f1; transition: 0.2s; }
    .menu button:hover { background: #bdc3c7; }
    .logout button { width:100px; height:40px; border:none; border-radius:5px; cursor:pointer; background:#e74c3c; color:white; font-weight:bold; }
    .logout button:hover { background:#c0392b; }
    
    /* 본문 레이아웃 */
    .content { padding:40px; max-width: 1400px; margin: 0 auto; }
    .header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid #c0392b; padding-bottom: 15px; }
    .title { font-size:28px; font-weight:bold; color:#2c3e50; }
    .manager-info { background: #c0392b; color: white; padding: 8px 15px; border-radius: 20px; font-size: 14px; font-weight: bold; }
    
    /* 대시보드 카드 그리드 (5개 메뉴 균형 배치) */
    .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 25px; margin-top: 20px; }
    .card { background: white; border-radius: 8px; padding: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); display: flex; flex-direction: column; justify-content: space-between; border-top: 4px solid #2c3e50; transition: 0.3s; }
    .card:hover { transform: translateY(-5px); box-shadow: 0 6px 12px rgba(0,0,0,0.15); }
    
    .card.teal { border-top-color: #1abc9c; }
    .card.purple { border-top-color: #9b59b6; }
    .card.orange { border-top-color: #e67e22; }
    .card.red { border-top-color: #e74c3c; }
    .card.green { border-top-color: #2ecc71; }
    
    .card-title { font-size: 16px; color: #7f8c8d; font-weight: bold; margin-bottom: 10px; }
    .card-desc { font-size: 14px; color: #95a5a6; margin-bottom: 20px; line-height: 1.4; }
    .card-btn { width: 100%; height: 45px; border: none; border-radius: 4px; color: white; font-weight: bold; font-size: 15px; cursor: pointer; transition: 0.2s; }
    
    .teal .card-btn { background: #1abc9c; } .teal .card-btn:hover { background: #16a085; }
    .purple .card-btn { background: #9b59b6; } .purple .card-btn:hover { background: #8e44ad; }
    .orange .card-btn { background: #e67e22; } .orange .card-btn:hover { background: #d35400; }
    .red .card-btn { background: #e74c3c; } .red .card-btn:hover { background: #c0392b; }
    .green .card-btn { background: #2ecc71; } .green .card-btn:hover { background: #27ae60; }
</style>
</head>
<body>

<!-- 상단 네비게이션 바 -->
<div class="top">
    <div class="logo">🏢 Smart GS24 본사 ERP 시스템</div>
    <div class="menu">
        <button onclick="location.href='ownerInsert.jsp'">가맹점/점주등록</button>
        <button onclick="location.href='productList.jsp'">상품관리</button>
        <button onclick="location.href='orderList.jsp'">발주관리</button>
        <button onclick="location.href='eventList.jsp'">행사관리</button>
        <button onclick="location.href='salesReport.jsp'">통합 매출</button>
    </div>
    <div class="logout">
        <button onclick="location.href='logout.jsp'">로그아웃</button>
    </div>
</div>

<!-- 본문 경영 컨트롤 타워 -->
<div class="content">
    
    <div class="header-box">
        <div class="title">본사 경영 총괄 컨트롤타워</div>
        <div class="manager-info">
            🛡️ 최고 관리자 계정: <strong><%= managerId %></strong>
        </div>
    </div>

    <!-- 5대 총괄 업무 관리 카드 대시보드 -->
    <div class="dashboard-grid">
        
        <!-- 1. 점주 및 매장 등록 카드 -->
        <div class="card teal">
            <div>
                <div class="card-title">🏪 가맹점 및 점주 계정 생성을 제어합니다.</div>
                <div class="card-desc">새로운 가맹 계약이 체결된 매장 인프라 정보와 가맹점주의 로그인 계정을 마스터 데이터베이스에 신규 등록합니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='ownerInsert.jsp'">신규 가맹점 등록</button>
        </div>

        <!-- 2. 상품 마스터 관리 카드 -->
        <div class="card purple">
            <div>
                <div class="card-title">📦 전사 상품 데이터 세팅</div>
                <div class="card-desc">전국 가맹점에서 발주 및 판매할 수 있는 표준 카테고리별 마스터 상품 목록을 구성하고 단가를 제어합니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='productList.jsp'">상품 마스터 관리</button>
        </div>

        <!-- 3. 가맹점 발주 승인 관리 카드 -->
        <div class="card orange">
            <div>
                <div class="card-title">📝 실시간 가맹점 발주 제어</div>
                <div class="card-desc">각 가맹점주들이 요청한 물류 발주 내역을 실시간 모니터링하여 물량 배정을 **'승인' 또는 '반려'** 처리합니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='orderList.jsp'">발주 요청 승인하기</button>
        </div>

        <!-- 4. 마케팅 행사 관리 카드 -->
        <div class="card red">
            <div>
                <div class="card-title">🎁 전사 프로모션 기획</div>
                <div class="card-desc">편의점 핵심 마케팅인 1+1, 2+1, 가격 할인 등의 프로모션 이벤트를 기획하고 대상 상품의 기간을 지정합니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='eventList.jsp'">행사 프로모션 관리</button>
        </div>

        <!-- 5. 전 가맹점 통합 매출 리포트 카드 (🆕 추가 및 연동 완료) -->
        <div class="card green">
            <div>
                <div class="card-title">📊 전사 가맹점 실시간 정산</div>
                <div class="card-desc">전국 매장에서 실시간으로 결제되는 매출 데이터를 수집하여 **누적 총액 및 매장별 상세 판매 추이**를 정밀 분석합니다.</div>
            </div>
            <button class="card-btn" onclick="location.href='salesReport.jsp'">통합 매출 리포트 보기</button>
        </div>

    </div>
</div>

</body>
</html>