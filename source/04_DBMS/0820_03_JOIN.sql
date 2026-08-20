-- [III] JOIN : 2개 이상의 테이블을 연결하여 데이터를 검색하는 방법
SELECT * FROM EMP WHERE ENAME='SCOTT'; -- 1행
SELECT * FROM DEPT;   -- 4행
-- CROSS JOIN (FROM절에 테이블을 2개이상)
SELECT * FROM EMP, DEPT WHERE ENAME='SCOTT'; -- EMP의 1행 * DEPT의 4행

-- ▶ 1. EQUI JOIN : 공통필드 값이 일치되는 조건만 JOIN
SELECT * FROM EMP, DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO;
SELECT E.*, DNAME, LOC
    FROM EMP E, DEPT D
    WHERE E.DEPTNO=D.DEPTNO;
  -- EX. 모든 사원의 사번, 이름, JOB, 상사사번, 부서번호, 부서명
  SELECT EMPNO, ENAME, JOB, MGR, E.DEPTNO, DNAME
    FROM EMP E, DEPT D
    WHERE E.DEPTNO=D.DEPTNO;
  -- EX. 급여가 2000이상인 직원의 이름, 직책, 급여, 부서명
  SELECT ENAME, JOB, SAL, DNAME, LOC FROM EMP E, DEPT D WHERE E.DEPTNO=D.DEPTNO AND SAL>=2000;
  -- EX. 근무지(LOC)가 'CHIGAGO'인 직원의 이름, 업무, 급여, 부서번호
  
    







