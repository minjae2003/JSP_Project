CREATE TABLE admin (
    admin_id VARCHAR(30) PRIMARY KEY,
    admin_pw VARCHAR(30) NOT NULL
);

INSERT INTO admin
VALUES ('admin','1234');

CREATE TABLE owner (
    owner_id VARCHAR(30) PRIMARY KEY,
    owner_pw VARCHAR(30) NOT NULL,
    owner_name VARCHAR(50),
    business_no VARCHAR(30)
);

CREATE TABLE store (
    store_no INT AUTO_INCREMENT PRIMARY KEY,

    owner_id VARCHAR(30) NOT NULL,

    store_name VARCHAR(100),
    location VARCHAR(200),

    FOREIGN KEY(owner_id)
    REFERENCES owner(owner_id)
); 

CREATE DATABASE convenience_store;
USE convenience_store;

CREATE TABLE admin (
    admin_id VARCHAR(30) PRIMARY KEY,
    admin_pw VARCHAR(30) NOT NULL
);

INSERT INTO admin VALUES ('admin','1234');

CREATE TABLE owner (
    owner_id VARCHAR(30) PRIMARY KEY,
    owner_pw VARCHAR(30) NOT NULL
);

INSERT INTO owner VALUES ('owner','1234'); 

DROP DATABASE IF EXISTS convenience_store;

CREATE DATABASE convenience_store
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE convenience_store;

-- 점주 테이블
CREATE TABLE owner (
    owner_id VARCHAR(30) PRIMARY KEY,
    owner_pw VARCHAR(30) NOT NULL,
    owner_name VARCHAR(50)
);

-- 매장 테이블
CREATE TABLE store (
    store_id VARCHAR(30) PRIMARY KEY,
    store_pw VARCHAR(30) NOT NULL,
    store_name VARCHAR(100),
    location VARCHAR(200),
    business_no VARCHAR(30),
    owner_id VARCHAR(30),
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

-- 기본 데이터
INSERT INTO owner VALUES ('owner', '1234', '점주1');

INSERT INTO store VALUES
('store1', '1234', '강남점', '서울 강남', '111-11-11111', 'owner'),
('store2', '1234', '홍대점', '서울 홍대', '222-22-22222', 'owner');