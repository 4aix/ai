-- [II] SELECT문 - 조회

-- 1. SELECT 문자 작성법(실행:CTRL+ENTER)
SELECT * FROM TAB;  -- 현계정이 가지고 있는 테이블 정보
SELECT * FROM EMP;  -- EMP테이블의 모든 정보(모든 열, 모든행)
SELECT * FROM DEPT; -- DEPT테이블의 모든 정보
SELECT * FROM SALGRADE;

-- 2. 특정 열만 출력
DESC EMP; 
    -- EMP테이블 구조
SELECT EMPNO, ENAME, SAL, HIREDATE FROM EMP; -- EMP테이블에서 EMPNO, ENAME, SAL열만 검색    
SELECT EMPNO AS "사 번", ENAME AS "이름", SAL AS "급여", HIREDATE AS "입사일" FROM EMP;
SELECT EMPNO "사 번", ENAME "이름", SAL "급여", HIREDATE "입사일" FROM EMP;
SELECT EMPNO "사 번", ENAME, SAL 급여, HIREDATE 입사일 FROM EMP;

-- 3. 특정 행만 출력 : WHERE절(조건절)에서 비교연산자 - 같다(=), 다르다(!=, ^=, <>), >, <, >=, <=
SELECT EMPNO NO, ENAME NAME, SAL FROM EMP WHERE SAL=3000;
SELECT EMPNO NO, ENAME NAME, SAL FROM EMP WHERE SAL<>3000;
SELECT EMPNO NO, ENAME NAME, SAL FROM EMP WHERE SAL>3000;
    -- 비교연산자는 숫자, 문자, 날짜 모두 가능
    --EX1. 사원이름(ENAME)이 'A','B','C'로 시작하는 사원의 모든 필드  'A'<'AA'<'AAA'<'B'<'C'<'CA'<'CAA'..
    SELECT * FROM EMP WHERE ENAME < 'D';
    --EX2. 81년도 이전에 입사(HIREDATE)한 사원의 모든 필드
    SELECT * FROM EMP WHERE HIREDATE < '81/01/01';
    
    -- 날짜 표기법 셋팅(현재:RR/MM/DD)
    ALTER SESSION SET NLS_DATE_FORMAT = 'MM-DD-YYYY';
    SELECT * FROM EMP 
        WHERE TO_CHAR(HIREDATE, 'RR/MM/DD') < '81/01/01';
    SELECT * FROM EMP
        WHERE HIREDATE < TO_DATE('81/01/01', 'RR/MM/DD');
    ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-- 4. 특정 행만 출력 : WHERE절(조건절)에서 논리연산자 : OR, AND, NOT
    -- EX1. 급여(SAL)가 2000부터 3000인 직원의 모든 필드
    SELECT * FROM EMP WHERE 2000<=SAL AND SAL<=3000;
    -- EX2. 82년도에 입사한 사원의 모든 필드
    SELECT * FROM EMP WHERE HIREDATE>='82/01/01' AND HIREDATE<='82/12/31';
    SELECT * FROM EMP 
        WHERE HIREDATE>=TO_DATE('82/01/01', 'RR/MM/DD') AND HIREDATE<=TO_DATE('82/12/31','RR/MM/DD');
    -- EX3. 10번 부서(DEPTNO)이거나 JOB이 MANAGER인 직원의 모든 필드
    SELECT * FROM EMP WHERE DEPTNO=10 OR JOB='MANAGER';

-- 5. 산술연산자(SELECT절, WHERE절, ORDER BY절)
    -- EX. 연봉이 2400이상인 직원의 ENAME, SAL, 연봉(SAL*12)
    SELECT ENAME, SAL, SAL*12 연봉 -- (3)
        FROM EMP                   -- (1)번째
        WHERE SAL*12>=2400           -- (2)번째
        ORDER BY 연봉; -- 연봉 순 오름차순(ASC) 정렬 (4)번째
    -- EX. 연봉이 10000이상인 직원의 ENAME, SAL, comm, 연봉(SAL*12+COMM)
        -- 산술연산의 결과는 null을 포함하면 결과도 null
        -- NVL(NULL일수도있는필드명, 대체값) - 필드명과 대체값의 타입이 일치
    SELECT ENAME, SAL, COMM, SAL*12+NVL(COMM,0) "연봉"
        FROM EMP
        WHERE SAL*12+NVL(COMM,0)>10000;
    -- EX. 모든 사원의 ENAME, MGR(상사사번)을 출력(MGR이 NULL이면 'CEO'로 바꿔 출력)
    SELECT ENAME, NVL(TO_CHAR(MGR), 'CEO') MGR FROM EMP;
    DESC EMP;

-- 6. 연결연산자(||) : 필드나 문자를 연결
SELECT ENAME || '은 ' || JOB FROM EMP;
    -- EX. 모든 사원에 대해서 "SMITH의 연봉은 XXXX$입니다"라고 출력하고 TITLE에는 MESSAGE.
    SELECT ENAME || '의 연봉은 ' || (SAL*12+NVL(COMM, 0)) || '$입니다' MESSAGE
        FROM EMP;

-- 7. 중복제거(DISTINCT)
SELECT DISTINCT JOB FROM EMP;
SELECT DISTINCT DEPTNO FROM EMP;

    -- ※ ☆ ★ 연습문제 꼭 풀기 ★ ☆ ※
    
    --1. emp 테이블의 구조 출력
    DESC EMP;
    --2. emp 테이블의 모든 내용을 출력 
    SELECT * FROM EMP;
    --3. 현 scott 계정에서 사용가능한 테이블 출력
    SELECT * FROM TAB;
    --4. emp 테이블에서 사번, 이름, 급여, 업무, 입사일 출력
    SELECT EMPNO, ENAME, SAL, JOB, HIREDATE FROM EMP;
    --5. emp 테이블에서 급여가 2000미만인 사람의 사번, 이름, 급여 출력
    SELECT EMPNO, ENAME, SAL FROM EMP WHERE SAL<2000;
    
    --6. 입사일이 81/02이후에 입사한 사람의 사번, 이름, 업무, 입사일 출력
    SELECT EMPNO, ENAME, JOB, HIREDATE FROM EMP WHERE HIREDATE >= '81/03/01';
    SELECT EMPNO, ENAME, JOB, HIREDATE FROM EMP WHERE HIREDATE >= TO_DATE('81/03/01');
    SELECT EMPNO, ENAME, JOB, HIREDATE FROM EMP WHERE TO_CHAR(HIREDATE,'RR/MM/DD') >= '81/03/01';
    
    --7. 업무가 SALESMAN인 사람들 모든 자료 출력
    SELECT * FROM EMP WHERE JOB='SALESMAN';
    
    --8. 급여가 1500이상이고 3000이하인 사람의 사번, 이름, 급여 출력
    SELECT EMPNO, ENAME, SAL FROM EMP WHERE SAL>=1500 AND SAL<=3000;
    
    --9. 부서코드가 10번이거나 30인 사람의 사번, 이름, 업무, 부서코드 출력
    SELECT EMPNO, ENAME, JOB, DEPTNO FROM EMP WHERE DEPTNO=10 OR DEPTNO=30;
    
    --10. 업무가 SALESMAN이거나 급여가 3000이상인 사람의 사번, 이름, 업무, 부서코드 출력
    SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP WHERE JOB='SALESMAN' OR SAL>=3000;
    
    --11.“ename은 XXX 업무이고 연봉은 XX다” 스타일로 모두 출력(연봉은 SAL*12+COMM)
    SELECT ENAME || '은 ' || JOB || '업무이고 연봉은 ' || (SAL*12+NVL(COMM, 0)) || '다' FROM EMP;

-- 8. SQL 연산자(BETWEEN, IN, LIKE, IS NULL)
 -- (1) 필드명 BETWEEN A AND B : 필드명이 A부터 B까지(A, B포함) A<B
    --  필드명 NOT BETWEEN A AND B : 필드명이 A미만 B초과(A, B미포함) A<B
    -- EX. 급여가 1500이상이고 3000이하인 사람의 모든 필드 출력
    SELECT * FROM EMP WHERE SAL BETWEEN 1500 AND 3000;
    SELECT * FROM EMP WHERE SAL BETWEEN 3000 AND 1500; -- 불가
    -- EX. 82년도 봄에 입사한 사람의 모든 필드 출력
    SELECT * FROM EMP
        WHERE HIREDATE BETWEEN TO_DATE('82/03/01', 'RR/MM/DD') AND TO_DATE('82/05/31', 'RR/MM/DD');
    -- EX. 급여가 1500미만, 3000초과인 사람의 모든 필드 출력
    SELECT * FROM EMP WHERE SAL NOT BETWEEN 1500 AND 3000;
    
 -- (2) 필드명 IN (값1, 값2, ... 값N) : 필드명이 값1이거나 값2이거나, ... 값N인 경우
    -- EX. 부서코드가 10번이거나 30인 사람의 사번, 이름, 부서코드 출력
    SELECT EMPNO, ENAME, DEPTNO FROM EMP WHERE DEPTNO IN (10,30);
    -- EX. 부서코드가 10,20,40번을 제외한 직원의 모든 필드 출력
    SELECT * FROM EMP WHERE NOT (DEPTNO=10 OR DEPTNO=20 OR DEPTNO=40);
    SELECT * FROM EMP WHERE DEPTNO NOT IN (10,20,40);
    -- EX. 사번이 7902, 7788, 7566인 사원의 이름, 사번, 직책을 출력
    SELECT ENAME, EMPNO, JOB FROM EMP WHERE EMPNO IN (7902, 7788, 7566);










