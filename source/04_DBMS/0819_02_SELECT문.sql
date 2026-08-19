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









