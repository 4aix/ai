-- [IV] DCL, DDL, DML
/* SQL
(1) DCL : 사용자 계정 생성(CREATE USER), 권한부여(GRANT), 권한박탈(REVOKE), 사용자 계정 삭제(DROP USER)
          트랜젝션명령어(ROLLBACK, COMMIT)
(2) DDL : 테이블 생성(CREATE TABLE), 테이블구조변경(ALTER TABLE), 테이블삭제(DROP TABLE)
(3) DML : CRUD
      입력(INSERT), 수정(UPDATE), 삭제(DELETE) - 취소(ROLLBACK) 가능
      검색(SELECT)
*/
----------------
--- ★ DDL ★ ---
----------------
-- 1. 테이블 생성(CREATE TABLE 테이블명...) : 테이블 구조 정의
    -- ORACLE 타입 : NUMBER(38이하의자릿수), DATE, VARCHAR2(4000이하의 바이트수), CLOB
CREATE TABLE BOOK(
    BOOKID    NUMBER(4),     -- BOOKID필드의 타입은 숫자4자리
    BOOKNAME  VARCHAR2(30),  -- BOOKNAME필드의 타입은 문자30BYTE(한글1자=3BYTE)
    PUBLISHER VARCHAR2(30),
    RDATE     DATE,          -- RDATE 필드의 타입은 DATE(날짜+시간)
    PRICE     NUMBER(8,2),   -- PRICE필드의 타입은 숫자 전체8자리 중 소숫점 2자리
    PRIMARY KEY(BOOKID)      -- 제약조건 : BOOKID를 주키(PRIMARY KEY)로 
);
DESC BOOK;
SELECT * FROM BOOK;
DROP TABLE BOOK; -- 2. 테이블 삭제(DROP TABLE 테이블명)

CREATE TABLE BOOK(
    BOOKID    NUMBER(4) PRIMARY KEY,  -- 제약조건
    BOOKNAME  VARCHAR2(30),  
    PUBLISHER VARCHAR2(30),
    RDATE     DATE,          
    PRICE     NUMBER(8,2)
);
DROP TABLE BOOK;
-- DEPT와 유사한 DEPT01테이블 / EMP와 유사한 EMP01테이블 생성
-- DEPT01 : DEPTNO(PK:숫자(2)), DNAME(문14byte), LOC(문13byte)
CREATE TABLE DEPT01(
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME  VARCHAR2(14),
    LOC    VARCHAR2(13)
);
SELECT * FROM DEPT01;
INSERT INTO DEPT01 VALUES (10, '재무','신림'); -- 트랜젝션에 쌓아놓은 상태
SELECT * FROM DEPT01;
ROLLBACK; -- 트랜젝션에 쌓인 명령어 날리기
--EMP01;EMPNO(숫4;PK),ENAME(문10),JOB(문9),MGR(숫4),HIREDATE(날),SAL(숫7.2),COMM(숫7.2),DEPTNO(숫2;FK)
CREATE TABLE EMP01 (
    EMPNO NUMBER(4)    PRIMARY KEY, -- 주키 제약조건(NULL불가, 유일한 값)
    ENAME VARCHAR2(10),
    JOB   VARCHAR2(9),
    MGR   NUMBER(4),
    HIREDATE DATE,
    SAL   NUMBER(7,2),
    COMM  NUMBER(7,2),
    DEPTNO NUMBER(2) REFERENCES DEPT01(DEPTNO) -- 외래키(FOREIGN KEY) 제약조건
);
DROP TABLE EMP01;
CREATE TABLE EMP01 (
    EMPNO NUMBER(4), -- 주키 제약조건(NULL불가, 유일한 값)
    ENAME VARCHAR2(10),
    JOB   VARCHAR2(9),
    MGR   NUMBER(4),
    HIREDATE DATE,
    SAL   NUMBER(7,2),
    COMM  NUMBER(7,2),
    DEPTNO NUMBER(2), 
    PRIMARY KEY(EMPNO),
    FOREIGN KEY(DEPTNO) REFERENCES DEPT01(DEPTNO)-- 외래키(FOREIGN KEY) 제약조건
);
SELECT * FROM EMP01;
INSERT INTO DEPT01 VALUES (10, '재무', '신림');
INSERT INTO EMP01 VALUES (1000, '홍길동', NULL, NULL, NULL, NULL, NULL, 10);
SELECT * FROM DEPT01;
COMMIT; -- 트랜젝션이 쌓여있는 명령어를 오라클 적용
DROP TABLE DEPT01; -- 참조하는테이블이 있을 경우, 삭제 불가(삭제하려면 참조하는 테이블을 DROP한후 DROP추천)
DROP TABLE DEPT01 CASCADE CONSTRAINTS; -- 비추(참조하는 테이블이 있어도 삭제 - EMP01테이블의 Fk연결이 끊김 )

----------------
--- ★ DML ★ ---
----------------
-- 1. INSERT INTO 테이블명 VALUES (값1, 값2, .. 값N);
   -- INSERT INTO 테이블명 (필드명1, 필드명2,..) VALUES (값1, 값2, ..);
SELECT * FROM DEPT01;
INSERT INTO DEPT01 VALUES (50, '법무', '서초');
INSERT INTO DEPT01 (LOC, DNAME, DEPTNO) VALUES ('신림', '인사', 60);
INSERT INTO DEPT01 (DEPTNO, DNAME, LOC) VALUES (70, '영업', NULL); -- 명시적 NULL입력
INSERT INTO DEPT01 (DEPTNO, DNAME) VALUES (80, '고객지원'); -- 묵시적 NULL입력
SELECT * FROM DEPT01;
   -- 서브쿼리를 이용한 INSERT
   -- EX. DEPT테이블의 20~40번 부서정보를 DEPT01에 INSERT
   INSERT INTO DEPT01 SELECT * FROM DEPT WHERE DEPTNO >= 20;
   SELECT * FROM DEPT01;

/* 연습문제 PDF page1 (DDL, INSERT)
다음과 같은 구조로 SAM01테이블을 생성하시오. 같은 이름의 테이블이 존재할 수 있으니, DROP
TABLE로 삭제 후 생성하시오
– SAM01의 구조 (EMPNO를 주키로)
• EMPNO(사번) – NUMBER(4)
• ENAME(이름) – VARCHAR2(10)
• JOB(직책) – VARCHAR2(9)
• SAL(급여) – NUMBER(7,2)
• EMP 에 저장된 사원 중 10번 부서의 정보를 추가*/
DROP TABLE SAM01;
CREATE TABLE SAM01(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10),
    JOB   VARCHAR2(9),
    SAL   NUMBER(7,2)
);
















