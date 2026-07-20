DROP DATABASE IF EXISTS jsp_project;

CREATE DATABASE jsp_project;

USE jsp_project;

-- ==========================
-- 관리자 정보 테이블
-- ==========================
CREATE TABLE manager (
    manager_id VARCHAR(50) PRIMARY KEY,      -- 관리자 아이디(PK)
    pw VARCHAR(100) NOT NULL,                -- 비밀번호
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 가입일
    department VARCHAR(100),                -- 부서
    position VARCHAR(100)                   -- 직급
);

-- ==========================
-- 점주 정보 테이블
-- ==========================
CREATE TABLE owner (
    owner_id VARCHAR(50) PRIMARY KEY,       -- 점주 아이디(PK)
    pw VARCHAR(100) NOT NULL,               -- 비밀번호
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 가입일
    name VARCHAR(30),                       -- 이름
    phone VARCHAR(30),                      -- 연락처
    store_no INT                            -- 관리 매장 번호(FK)
);

-- ==========================
-- 매장 정보 테이블
-- ==========================
CREATE TABLE store (
    store_no INT PRIMARY KEY AUTO_INCREMENT, -- 매장 번호(PK)
    store_name VARCHAR(50) NOT NULL,         -- 매장명
    address VARCHAR(255),                    -- 주소
    owner_name VARCHAR(30),                  -- 점주명
    business_no VARCHAR(100),                -- 사업자등록번호
    phone VARCHAR(30),                       -- 연락처
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 등록일
    manager_id VARCHAR(50),                  -- 관리자 아이디(FK)
    owner_id VARCHAR(50),                    -- 점주 아이디(FK)

    FOREIGN KEY (manager_id) REFERENCES manager(manager_id),
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

-- 점주가 관리하는 매장 연결
ALTER TABLE owner
ADD CONSTRAINT fk_owner_store
FOREIGN KEY (store_no) REFERENCES store(store_no);

-- ==========================
-- 대분류 테이블
-- 예) 냉장, 냉동, 일반상품
-- ==========================
CREATE TABLE main_category (
    main_no INT PRIMARY KEY AUTO_INCREMENT, -- 대분류 번호(PK)
    main_name VARCHAR(255) NOT NULL         -- 대분류명
);

-- ==========================
-- 소분류 테이블
-- 예) 우유, 아이스크림, 과자
-- ==========================
CREATE TABLE sub_category (
    sub_no INT PRIMARY KEY AUTO_INCREMENT, -- 소분류 번호(PK)
    sub_name VARCHAR(255) NOT NULL,        -- 소분류명
    main_no INT,                           -- 대분류 번호(FK)

    FOREIGN KEY (main_no) REFERENCES main_category(main_no)
);

-- ==========================
-- 상품 정보 테이블
-- ==========================
CREATE TABLE product (
    product_no INT PRIMARY KEY AUTO_INCREMENT, -- 상품번호(PK)
    product_name VARCHAR(255) NOT NULL,        -- 상품명
    product_img VARCHAR(255),                  -- 상품 이미지 경로
    sub_no INT,                                -- 소분류 번호(FK)
    product_price INT,                         -- 판매 가격

    FOREIGN KEY (sub_no) REFERENCES sub_category(sub_no)
);

-- ==========================
-- 이벤트 정보 테이블
-- ==========================
CREATE TABLE product_event (
    event_no INT AUTO_INCREMENT PRIMARY KEY,
    product_no INT NOT NULL,
    event_type VARCHAR(50),
    event_count INT,
    event_value INT,
    start_date DATE,
    end_date DATE,

    FOREIGN KEY(product_no)
    REFERENCES product(product_no)
);
-- ==========================
-- 매장별 재고 테이블
-- ==========================
CREATE TABLE inventory (
    inventory_no INT PRIMARY KEY AUTO_INCREMENT, -- 재고번호(PK)
    store_no INT NOT NULL,                       -- 매장번호(FK)
    product_no INT NOT NULL,                     -- 상품번호(FK)
    stock_qty INT DEFAULT 0,                     -- 해당 매장의 상품 재고 수량
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,             -- 재고 수정일시

    FOREIGN KEY (store_no) REFERENCES store(store_no),
    FOREIGN KEY (product_no) REFERENCES product(product_no),

    UNIQUE (store_no, product_no)                -- 한 매장에 같은 상품은 한 번만 등록
);

-- ==========================
-- 판매 내역 테이블
-- ==========================
CREATE TABLE sales (
    sales_no INT PRIMARY KEY AUTO_INCREMENT, -- 판매번호(PK)
    product_no INT,                          -- 상품번호(FK)
    qty INT,                                 -- 판매수량
    sales_price INT,                         -- 판매금액
    store_no INT,                            -- 판매 매장(FK)
    sales_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 판매일시

    FOREIGN KEY (product_no) REFERENCES product(product_no),
    FOREIGN KEY (store_no) REFERENCES store(store_no)
);

-- ==========================
-- 입고 내역 테이블
-- ==========================
CREATE TABLE purchase (
    purchase_no INT PRIMARY KEY AUTO_INCREMENT, -- 입고번호(PK)
    product_no INT,                             -- 상품번호(FK)
    qty INT,                                    -- 입고수량
    purchase_price INT,                         -- 입고금액
    store_no INT,                               -- 입고 매장(FK)
    purchase_date DATE,                         -- 입고일
    purchase_time TIME,                         -- 입고시간

    FOREIGN KEY (product_no) REFERENCES product(product_no),
    FOREIGN KEY (store_no) REFERENCES store(store_no)
);

-- ==========================
-- 발주 내역 테이블
-- ==========================
CREATE TABLE order_history (
    order_no INT PRIMARY KEY AUTO_INCREMENT, -- 발주번호(PK)
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 발주일시
    product_no INT,                          -- 상품번호(FK)
    qty INT,                                 -- 발주수량
    result VARCHAR(20),                     -- 처리결과(대기/승인/완료 등)
    store_no INT,                            -- 발주 매장(FK)

    FOREIGN KEY (product_no) REFERENCES product(product_no),
    FOREIGN KEY (store_no) REFERENCES store(store_no)
);

-- 기존 데이터 삭제
DELETE FROM sub_category;
DELETE FROM main_category;

-- 1. 대분류 데이터 입력 (2개)
INSERT INTO main_category (main_name) VALUES ('냉장'), ('일반');

-- 2. 소분류 데이터 입력
-- 냉장(1): 삼각김밥, 김밥, 햄버거, 족발/편육, 우유, 요거트, 치즈, 아이스크림, 얼음, 만두, 냉동피자
INSERT INTO sub_category (sub_name, main_no) VALUES 
('삼각김밥', 1), ('김밥', 1), ('햄버거', 1), ('족발/편육', 1), 
('우유', 1), ('요거트', 1), ('치즈', 1), ('아이스크림', 1), 
('얼음', 1), ('만두', 1), ('냉동피자', 1);

-- 일반(2): 과자, 음료, 주류, 일회용품, 화장품, 세제
INSERT INTO sub_category (sub_name, main_no) VALUES 
('과자', 2), ('음료', 2), ('주류', 2), ('일회용품', 2), ('화장품', 2), ('세제', 2);

INSERT INTO manager (manager_id, pw)
VALUES ('admin', '1234');