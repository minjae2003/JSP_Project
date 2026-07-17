DROP DATABASE IF EXISTS jsp_project;
CREATE DATABASE jsp_project;
USE jsp_project;

-- ==========================
-- 1. 관리자 정보 테이블
-- ==========================
CREATE TABLE manager (
    manager_id VARCHAR(50) PRIMARY KEY,      
    pw VARCHAR(100) NOT NULL,                
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    department VARCHAR(100),                
    position VARCHAR(100)                   
);

-- ==========================
-- 2. 매장 정보 테이블
-- ==========================
CREATE TABLE store (
    store_no INT PRIMARY KEY AUTO_INCREMENT, 
    store_name VARCHAR(50) NOT NULL,         
    address VARCHAR(255),                    
    owner_name VARCHAR(30),                  
    business_no VARCHAR(100),                
    phone VARCHAR(30),                       
    reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    manager_id VARCHAR(50),                  
    owner_id VARCHAR(50),                    

    FOREIGN KEY (manager_id) REFERENCES manager(manager_id)
);

-- ==========================
-- 3. 점주 정보 테이블
-- ==========================
CREATE TABLE owner (
    owner_id VARCHAR(50) PRIMARY KEY,       
    pw VARCHAR(100) NOT NULL,               
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    name VARCHAR(30),                       
    phone VARCHAR(30),                      
    store_no INT,                            
    
    FOREIGN KEY (store_no) REFERENCES store(store_no)
);

-- 매장과 점주 외래키 상호 연결 제약조건 추가
ALTER TABLE store ADD CONSTRAINT fk_store_owner FOREIGN KEY (owner_id) REFERENCES owner(owner_id);

-- ==========================
-- 4. 대분류 테이블
-- ==========================
CREATE TABLE main_category (
    main_no INT PRIMARY KEY AUTO_INCREMENT, 
    main_name VARCHAR(255) NOT NULL         
);

-- ==========================
-- 5. 소분류 테이블
-- ==========================
CREATE TABLE sub_category (
    sub_no INT PRIMARY KEY AUTO_INCREMENT, 
    sub_name VARCHAR(255) NOT NULL,        
    main_no INT,                           

    FOREIGN KEY (main_no) REFERENCES main_category(main_no)
);

-- ==========================
-- 6. 상품 정보 테이블
-- ==========================
CREATE TABLE product (
    product_no INT PRIMARY KEY AUTO_INCREMENT, 
    product_name VARCHAR(255) NOT NULL,        
    product_img VARCHAR(255),                  
    sub_no INT,                                
    product_price INT,                         

    FOREIGN KEY (sub_no) REFERENCES sub_category(sub_no)
);

-- ==========================
-- 7. 이벤트 정보 테이블
-- ==========================
CREATE TABLE product_event (
    event_no INT AUTO_INCREMENT PRIMARY KEY,
    product_no INT NOT NULL,
    event_type VARCHAR(50),
    event_count INT,
    event_value INT,
    start_date DATE,
    end_date DATE,

    FOREIGN KEY(product_no) REFERENCES product(product_no)
);

-- ==========================
-- 8. 매장별 재고 테이블
-- ==========================
CREATE TABLE inventory (
    inventory_no INT PRIMARY KEY AUTO_INCREMENT, 
    store_no INT NOT NULL,                       
    product_no INT NOT NULL,                     
    stock_qty INT DEFAULT 0,                     
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,             

    FOREIGN KEY (store_no) REFERENCES store(store_no),
    FOREIGN KEY (product_no) REFERENCES product(product_no),
    UNIQUE (store_no, product_no)                
);

-- ==========================
-- 9. 판매 내역 테이블
-- ==========================
CREATE TABLE sales (
    sales_no INT PRIMARY KEY AUTO_INCREMENT, 
    product_no INT,                          
    qty INT,                                 
    sales_price INT,                         
    store_no INT,                            
    sales_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

    FOREIGN KEY (product_no) REFERENCES product(product_no),
    FOREIGN KEY (store_no) REFERENCES store(store_no)
);

-- ==========================
-- 10. 발주 내역 테이블 (순서를 purchase 위로 이동!)
-- ==========================
CREATE TABLE order_history (
    order_no INT PRIMARY KEY AUTO_INCREMENT, 
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    product_no INT,                          
    qty INT,                                 
    result VARCHAR(20),                     
    store_no INT,                            

    FOREIGN KEY (product_no) REFERENCES product(product_no),
    FOREIGN KEY (store_no) REFERENCES store(store_no)
);

-- ==========================
-- 11. 입고 내역 테이블 (콤마 추가 및 참조 무결성 오류 해결)
-- ==========================
CREATE TABLE purchase (
    purchase_no INT PRIMARY KEY AUTO_INCREMENT, 
    product_no INT,                             
    qty INT,                                    
    purchase_price INT,                         
    store_no INT,                               
    purchase_date DATE,                         
    purchase_time TIME,                         
    order_no INT,                               
        
    FOREIGN KEY (product_no) REFERENCES product(product_no),
    FOREIGN KEY (store_no) REFERENCES store(store_no), -- 콤마 추가 완료
    FOREIGN KEY (order_no) REFERENCES order_history(order_no)
);


-- ========================================================
-- 마스터 데이터 및 초기 샘플 데이터 인서트 구역
-- ========================================================

-- 대분류 기본 세팅
INSERT INTO main_category (main_name) VALUES ('냉장'), ('일반');

-- 소분류 매핑 데이터 세팅
INSERT INTO sub_category (sub_name, main_no) VALUES 
('삼각김밥', 1), ('김밥', 1), ('햄버거', 1), ('족발/편육', 1), 
('우유', 1), ('요거트', 1), ('치즈', 1), ('아이스크림', 1), 
('얼음', 1), ('만두', 1), ('냉동피자', 1);

INSERT INTO sub_category (sub_name, main_no) VALUES 
('과자', 2), ('음료', 2), ('주류', 2), ('일회용품', 2), ('화장품', 2), ('세제', 2);

-- 상품 기본 데이터 구성 (소분류 인덱스 번호 100% 매칭 완료)
INSERT INTO product (product_name, sub_no, product_price) VALUES 
('참치마요 삼각김밥', 1, 1200),  -- sub_no 1: 삼각김밥
('서울우유 500ml', 5, 1800),     -- sub_no 5: 우유
('포카칩 오리지널', 12, 1500);    -- sub_no 12: 과자

-- 관리자, 초기 가맹점 및 점주 원천 데이터 동기화
INSERT INTO manager (manager_id, pw, department, position) VALUES ('admin', '1234', '물류부', '팀장');

INSERT INTO store (store_name, address, owner_name, business_no) VALUES 
('강남역점', '서울시 강남구 역삼동 123', '김점주', '111-22-33333'),
('홍대입구점', '서울시 마포구 동교동 456', '이점주', '444-55-66666'),
('부산서면점', '부산시 부산진구 부전동 789', '박점주', '777-88-99999');

INSERT INTO owner (owner_id, pw, name, phone, store_no) VALUES 
('owner01', '1234', '김점주', '010-1111-2222', 1),
('owner02', '1234', '이점주', '010-3333-4444', 2),
('owner03', '1234', '박점주', '010-5555-6666', 3);

UPDATE store SET owner_id = 'owner01' WHERE store_no = 1;
UPDATE store SET owner_id = 'owner02' WHERE store_no = 2;
UPDATE store SET owner_id = 'owner03' WHERE store_no = 3;

-- 초기 데모용 발주 히스토리 적재
INSERT INTO order_history (product_no, qty, result, store_no) VALUES 
(1, 50, '승인', 1),  
(2, 20, '대기', 1),  
(3, 30, '승인', 1);