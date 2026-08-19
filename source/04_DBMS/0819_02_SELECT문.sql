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











