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

/***
* 연습문제 PDF page1 (DDL, INSERT)
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
INSERT INTO SAM01 VALUES (1000, 'APPLE', 'POLICE', 10000);
INSERT INTO SAM01 VALUES (1010, 'BANANA', 'NURSE', 15000);
INSERT INTO SAM01 VALUES (1020, 'ORANGE', 'DOCTOR', 25000);
INSERT INTO SAM01 (EMPNO, ENAME, SAL) 
    VALUES (1030, 'VERY', 25000);
INSERT INTO SAM01 (EMPNO, ENAME, SAL) 
    VALUES (1040, 'CAT', 20000);
SELECT * FROM SAM01;
SELECT EMPNO, ENAME, JOB, SAL FROM EMP WHERE DEPTNO=10; -- SAM01에 INSERT할 내용
INSERT INTO SAM01 SELECT EMPNO, ENAME, JOB, SAL FROM EMP WHERE DEPTNO=10;
COMMIT;

-- 2. UPDATE 테이블명 SET 필드명1=값1[, 필드명2=값2, .. 필드명N=값N] [WHERE조건]
DROP TABLE EMP01;
-- 서브쿼리를 이용한 테이블 생성(제약조건이 제외된 데이터만 가져옴)
CREATE TABLE EMP01 AS SELECT * FROM EMP WHERE DEPTNO IN (20, 30);
SELECT * FROM EMP01;
DESC EMP01;
  -- EX. 부서번호를 99번으로 수정
  UPDATE EMP01 SET DEPTNO=99;
  SELECT * FROM EMP01;
  ROLLBACK; -- 트랜젝션 명령어들 취소
  SELECT * FROM EMP01;
  -- EX. 모든 사원의 급여(SAL)를 10%인상
  UPDATE EMP01 SET SAL = SAL*1.1;
  SELECT * FROM EMP01;
  -- EX. 급여(SAL)가 1200미만인 직원의 급여를 100$씩 인상
  UPDATE EMP01 SET SAL = SAL+100 WHERE SAL<1200;
  SELECT * FROM EMP01 WHERE ENAME='SMITH';
  -- EX. SMITH의 부서번호를 30, JOB을 'SALESMAN', SAL과 COMM을 500$씩 인상, 입사일을 오늘로, 상사는 BLAKE로
  UPDATE EMP01
    SET DEPTNO = 30,
        JOB = 'SALESMAN',
        SAL = SAL + 500,
        COMM = NVL(COMM, 0) + 500,
        -- HIREDATE = TO_DATE('26/08/21', 'RR/MM/DD'),
        HIREDATE = SYSDATE, -- SYSDATE : 실행시점의 날짜와 시간
        MGR = (SELECT EMPNO FROM EMP01 WHERE ENAME='BLAKE')
    WHERE ENAME = 'SMITH';
  SELECT * FROM EMP01 WHERE ENAME='SMITH';
  COMMIT;

-- 3. DELETE FROM 테이블명 [WHERE 조건];
  SELECT * FROM EMP01;
  DELETE FROM EMP01;
  SELECT * FROM EMP01;
  ROLLBACK;
  SELECT * FROM EMP01;
  -- EX. EMP01에서 'FORD' 직원을 퇴사
  DELETE FROM EMP01 WHERE ENAME='FORD';
  delete from emp01 where ename='FORD';
  -- EX. SAM01에서 JOB이 정해지지 않은 사원을 삭제
  DELETE FROM SAM01 WHERE JOB IS NULL;
  SELECT * FROM SAM01;
  -- EX. EMP01에서 30번 부서 직원을 삭제
  DELETE FROM EMP01 WHERE DEPTNO=30;
  SELECT * FROM EMP01;
  COMMIT;

/*** PDF 2PAGE 연습문제 ***/
    -- 1. 아래의 구조를 만족하는 MY_DATA 테이블을 생성하시오. 단 ID가 PRIMARY KEY이다.
    DROP TABLE MY_DATA;
    CREATE TABLE MY_DATA (
        ID     NUMBER(4)    PRIMARY KEY,
        NAME   VARCHAR2(10),
        USERID VARCHAR2(30),
        SALARY NUMBER(10,2)
    );
    
    -- 2. 생성된 테이블에 위의 도표와 같은 값을 입력하는 SQL문을 작성하시오.
    INSERT INTO MY_DATA (ID, NAME, USERID, SALARY)
        VALUES (1, 'Scott', 'sscott', 10000);
    INSERT INTO MY_DATA VALUES (2, 'Ford',  'fford',   13000);
    INSERT INTO MY_DATA VALUES (3, 'Patel', 'patel',   33000);
    INSERT INTO MY_DATA VALUES (4, 'Report','rreport', 23500);
    INSERT INTO MY_DATA VALUES (5, 'Good',  'ggood',   44450);
    
    -- 3. TO_CHAR 내장 함수를 이용하여 입력한 자료를 위의 도표와 같은 형식으로 출력
    SELECT ID, NAME, USERID, TO_CHAR(SALARY, '99,999.99') FROM MY_DATA;
    
    -- 4. 자료를 영구적으로 데이터베이스에 등록하는 명령어를 작성하시오.
    COMMIT;
    
    -- 5. ID가 3번인 사람의 급여를 65000.00으로 갱신하고 영구적으로 데이터베이스에 반영하라.
    UPDATE MY_DATA SET SALARY = 65000.00 WHERE ID = 3;
    COMMIT;
    
    -- 6. NAME이 Ford인 사람을 삭제하고 영구적으로 데이터베이스에 반영하라.
    DELETE FROM MY_DATA WHERE NAME='Ford';
    COMMIT;
    
    -- 7. SALARY가 15,000.00 이하인 사람의 급여를 15,000.00으로 변경하라
    UPDATE MY_DATA SET SALARY=15000.00 WHERE SALARY<=15000.00;
    SELECT * FROM MY_DATA;
    
    -- 8. 위에서 생성한 테이블을 삭제하라.
    DROP TABLE MY_DATA;
    
/*** PDF 3PAGE 연습문제 ***/
    -- 1. EMP 테이블과 같은 구조와 같은 내용의 테이블 EMP01을 생성(테이블이 있을시 제거한 후)하고,
        -- 모든 사원의 부서번호를 30번으로 수정합니다.
    DROP TABLE EMP01;
    CREATE TABLE EMP01 
        AS SELECT * FROM EMP;
    UPDATE EMP01 
        SET DEPTNO=30;
    SELECT * FROM EMP01;
    
    -- 2. EMP01테이블의 모든 사원의 급여를 10% 인상시키는 UPDATE문을 작성
    UPDATE EMP01 
        SET SAL = SAL*1.1;
    SELECT * FROM EMP01;
        
    -- 3. 급여가 3000이상인 사원만 급여를 10%인상
    UPDATE EMP01 
        SET SAL = SAL*1.1 
        WHERE SAL>=3000;
    SELECT * FROM EMP01;
    
    -- 4. EMP01테이블에서 ‘DALLAS’에서 근무하는 직원들의 월급을 1000인상
    UPDATE EMP01
        SET SAL = SAL + 1000
        WHERE DEPTNO = (SELECT DEPTNO FROM DEPT WHERE LOC='DALLAS');
        
    -- 5. SCOTT사원의 부서번호는 20번으로, 직급은 MANAGER로 한꺼번에 수정
    UPDATE EMP01
        SET DEPTNO = 20,
            JOB = 'MANAGER'
        WHERE ENAME='SCOTT';
    SELECT * FROM EMP01;    
    
    -- 6. 부서명이 RESEARCH인 사원을 모두 삭제하는 SQL작성
    DELETE FROM EMP01 
        WHERE DEPTNO = (SELECT DEPTNO FROM DEPT WHERE DNAME='RESEARCH');
    
    -- 7. 사원명이 ‘FORD’인 사원을 삭제하는 SQL 작성
    DELETE FROM EMP01 
        WHERE ENAME = 'FORD';
    
    -- 8. SAM01 테이블에서 JOB이 NULL인 사원을 삭제하시오
    DELETE FROM SAM01
        WHERE JOB IS NULL;
    
    -- 9. SAM01테이블에서 ENAME이 ORANGE인 사원을 삭제하시오
    DELETE FROM SAM01
        WHERE ENAME = 'ORANGE';
    
    -- 10. 급여가 1500이하인 사람의 급여를 1500으로 수정
    UPDATE EMP01
        SET SAL = 1500
        WHERE SAL <= 1500;
    
    -- 11. JOB이 ‘MANAGER’인 사원의 급여를 10%인하하시오
    UPDATE EMP01
        SET SAL = SAL * 0.9
        WHERE JOB='MANAGER';
    COMMIT;
    
--------------------
--- ★ 제약조건 ★ ---
--------------------
  -- (1) PRIMARY KEY : 테이블의 각 행을 유일한 값으로 식별하기 위한 필드
  -- (2) FOREIGN KEY : 테이블의 열이 다른 테이블의 열을 참조
  -- (3) NOT NULL : NULL을 포함하지 않음
  -- (4) UNIQUE : 모든 행의 값이 유일해야 함. NULL값은 허용(NULL은 여러개 가능)
  -- (5) CHECK(조건) : 해당 조건이 만족해야 함. NULL값은 허용
  -- DEFAULT 기본값 : 기본값 설정(INSERT 할 경우, 해당 열의 데이터를 입력하지 않으면 NULL이 들어가지 않고 기본값)
  
-- DEPT1 & EMP1
DROP TABLE EMP1;
DROP TABLE DEPT1;
-- PRIMARY KEY와 UNIQUE 제약조건은 오른쪽 나열, 밑에 나열
-- NOT NULL 제약조건은 오른쪽에 나열
CREATE TABLE DEPT1 (
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME  VARCHAR2(14) UNIQUE,
    LOC    VARCHAR2(13) NOT NULL
);
INSERT INTO DEPT1 SELECT * FROM DEPT;
SELECT * FROM DEPT1;
INSERT INTO DEPT1 VALUES (40, '법무', 'SEOUL'); -- PK 제약조건 에러
UPDATE DEPT1 SET DNAME='SALES' WHERE DEPTNO=40; -- UNIQUE제약조건 에러
INSERT INTO DEPT1 (DEPTNO, DNAME) VALUES (50, '전산'); -- 묵시적으로 LOC에 NULL을 입력-NOT NULL제약조건 에러

CREATE TABLE EMP1 (
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10) NOT NULL,
    JOB   VARCHAR2(9),
    MGR   NUMBER(4),
    HIREDATE DATE DEFAULT SYSDATE,
    SAL   NUMBER(7,2) CHECK(SAL>0),
    COMM  NUMBER(7,2),
    DEPTNO NUMBER(2) REFERENCES DEPT1(DEPTNO)
);
INSERT INTO EMP1 (EMPNO, ENAME, DEPTNO) VALUES (1000, 'HONG', 10); -- HIREDATE에 SYSDATE 기본값 입력
INSERT INTO EMP1 (EMPNO, ENAME, SAL, DEPTNO)
    VALUES (1001, 'HONG', 0, 10); -- CHECK 제약조건 에러
INSERT INTO EMP1 (EMPNO, ENAME, SAL, DEPTNO)
    VALUES (1002, 'HONG', 100, 50); -- FK 제약조건 에러
INSERT INTO EMP1 (EMPNO, ENAME, SAL, DEPTNO)
    VALUES (1002, 'HONG', 100, 10);
SELECT * FROM EMP1;