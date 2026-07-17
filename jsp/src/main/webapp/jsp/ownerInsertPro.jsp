<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="dao.MemberDAO" %>
<%
    // 1. 인코딩 설정 (한글 깨짐 방지)
    request.setCharacterEncoding("UTF-8");

    // 2. 관리자 세션 체크 및 기본값 방어 코드
    // 현재 관리자 로그인 세션에서 id를 꺼내옵니다.
    String managerId = (String) session.getAttribute("id"); 
    if (managerId == null || managerId.isEmpty()) {
        managerId = "admin"; 
    }

    // 3. 화면(ownerInsert.jsp)의 폼 엘리먼트에서 넘어온 데이터 수집
    String storeName   = request.getParameter("store_name");
    String address     = request.getParameter("address");
    String businessNo  = request.getParameter("business_no");
    String storePhone  = request.getParameter("phone"); // 매장 전화번호

    String ownerId     = request.getParameter("owner_id");
    String ownerPw     = request.getParameter("owner_pw");
    String ownerName   = request.getParameter("owner_name");
    String ownerPhone  = request.getParameter("owner_phone"); // 점주 개인 전화번호

    // 4. MemberDAO 규격에 맞게 하나의 Map 주머니로 병합 포장
    Map<String, String> param = new HashMap<>();
    // [매장 정보]
    param.put("store_name", storeName);
    param.put("address", address);
    param.put("business_no", businessNo);
    param.put("phone", storePhone);  
    param.put("manager_id", managerId); 
    // [점주 계정 정보]
    param.put("owner_id", ownerId);
    param.put("owner_pw", ownerPw);
    param.put("owner_name", ownerName);
    param.put("owner_phone", ownerPhone);
    // 5. 비즈니스 로직 실행 (MemberDAO의 트랜잭션 연동 메서드 호출)
    MemberDAO memberDao = new MemberDAO();
    boolean isSuccess = memberDao.registerStoreAndOwner(param);
    // 6. 결과 처리 알림 피드백
    if (isSuccess) {
%>
        <script>
            alert("가맹점 매장 등록 및 점주 계정 생성이 무결하게 연동 완료되었습니다.");
            location.href = "ManagerMain.jsp"; // 등록 완료 후 점주/매장 목록 화면으로 이동
        </script>
<%
    } else {
%>
        <script>
            alert("등록 실패: 데이터 무결성 제약조건 위배 또는 입력 데이터 오류가 발생하여 자동 롤백되었습니다.\n이클립스 콘솔 로그를 확인하세요.");
            history.back(); // 입력하던 폼으로 복귀
        </script>
<%}%>