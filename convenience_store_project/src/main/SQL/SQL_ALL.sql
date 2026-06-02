CREATE DATABASE convenience_store

USE convenience_store;

DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS admin;

-- 관리자 테이블
CREATE TABLE admin (
    admin_id VARCHAR(30) PRIMARY KEY,
    admin_pw VARCHAR(30) NOT NULL
);

-- 매장 테이블
CREATE TABLE store (
    store_id VARCHAR(30) PRIMARY KEY,
    store_pw VARCHAR(30) NOT NULL,
    store_name VARCHAR(100),
    location VARCHAR(200),
    business_no VARCHAR(30)
);

-- 기본 데이터
INSERT INTO admin VALUES ('admin', '1234');

INSERT INTO store VALUES
('store1', '1234', '강남점', '서울 강남', '111-11-11111'),
('store2', '1234', '홍대점', '서울 홍대', '222-22-22222');