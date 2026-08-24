-- DCL(계정생성, 권한부여, 권한박탈, 계정삭제)
-- DDL(타입, 시퀀스없음)
-- DML(outer join, and;&&, or;||, 일부함수)

-- ■■■■■■■■■■■■■
-- ※ DCL ※ ■■■■
-- ■■■■■■■■■■■■■
create user userid identified by 'password'; -- 계정 생성
grant all privileges on *.* to userid; -- 권한 부여
revoke all on *.* from userid; -- 권한 박탈
drop user userid; -- 계정 삭제
-- 데이터 베이스로 들어가기
show databases; -- 데이터베이스들의 리스트
create database devdb; -- 새로운 데이터베이스(devdb) 생성
show databases;
use devdb; -- 데이터베이스로 들어감
use information_schema;
show tables; -- 현재 데이터베이스 내의 테이블들
use devdb;
show tables; -- 현재 데이터베이스 내의 테이블들

-- ■■■■■■■■■■■■■
-- ※ DDL ※ ■■■■
-- ■■■■■■■■■■■■■
/* mySQL 타입 : numeric(n, d), varchar(n), date(날짜만), datetime, timestamp(날짜시간)
정수 : tinyint(1byte), smallint(2byte), dediumint(3byte) 
	int/integer(4byte), bigint(8byte)
실수 : float(n, d ; 4byte), double(n, d;8byte)
문자 : char(n;비추), text, longtext(4GB)
*/



