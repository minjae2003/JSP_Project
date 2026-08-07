## 📦 통합 상품 물류 관리 페이지 (`productList.jsp`)

본사 관리자와 가맹점주 간의 통합 상품 마스터 관리, 발주 신청, POS 결제를 처리하는 핵심 모듈입니다. 로그인 세션의 **역할(Role-Based Access Control)**을 검증하여 사용자 권한에 최적화된 동적 UI/UX를 제공합니다.

---

### 🔑 주요 기능 (Key Features)

* **권한 기반 동적 렌더링 (Role-Based Access Control):** 세션 내 `role` 값(`manager` / `owner`)에 따라 접근 가능한 메뉴와 관리 기능을 동적으로 분기 처리합니다.
* **실시간 카테고리 동기화 (Dynamic Category Sync):** JavaScript를 활용해 대분류(냉장, 일반) 선택에 따라 소분류 옵션이 실시간으로 바뀌도록 구현했습니다.
* **단일 폼(Action Form) 데이터 전송:** 수량 입력 후 발주/판매 선택 시, hidden 폼 및 스크립트를 통해 각 처리 페이지(`orderPro.jsp`, `pos.jsp`)로 유연하게 데이터를 전달합니다.
* **반응형/스크롤 보호 레이아웃:** `min-width`와 CSS Flexbox 구조를 적용하여 브라우저 리사이징 환경에서도 레이아웃 파손을 방지합니다.

---

### 👥 권한별 제공 기능

| 구분 | 본사 관리자 (`manager`) | 가맹점주 (`owner`) |
| :--- | :--- | :--- |
| **상품 등록** | 대/소분류 지정, 상품명, 단가 입력 후 DB 마스터 추가 | 접근 불가 (보안 처리) |
| **상품 삭제** | 물류 마스터 DB 등록 상품 영구 삭제 | 접근 불가 |
| **발주 / 판매** | - | 원하는 상품 수량 선택 후 **본사 발주 신청** 및 **POS 결제** 실행 |
| **상단 메뉴** | 관리자 전용 메인 페이지 이동 | 점주 전용 메인, 재고조회, 발주현황 이동 |

---

### 🛠️ 구현 기술 (Tech Stack)

* **Frontend:** HTML5, CSS3, JavaScript (Vanilla ES6)
* **Backend:** Java, JSP, Servlet Container (Apache Tomcat v9.0)
* **Database Interfacing:** Custom `ProductDAO`를 활용한 JDBC 데이터 매핑 (`List<Map<String, Object>>`)
