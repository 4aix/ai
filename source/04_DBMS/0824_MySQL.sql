-- DCL(계정생성, 권한부여, 권한박탈, 계정삭제)
-- DDL(타입, 시퀀스없음, FK 지정을 아래에)
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
drop table if exists friend;
create table friend(
	no   int         primary key auto_increment, -- auto_increment 필드타입은 int
	name varchar(30) not null,
    tel  varchar(30) unique,
    age  numeric(3) default 1 check (age>=0),
    last_modify datetime default now()
);
select * from friend;
insert into friend (name, tel) values ('홍길동', null);
insert into friend (name, tel, age) values ('성춘향', '010-9999-9999', -2);
insert into friend (name, tel, age) values ('성춘향', '010-9999-9999', 22);

-- ★ ★ ★  파이썬 수업시간에 쓸 테이블 ★ ★ ★
-- DDL과 DML 명령어는 데이터베이스안에서만 실행
select database(); -- 현재 들어와 있는 데이터베이스
use devdb;
drop table if exists person; -- emp테이블 유사
drop table if exists division; -- dept테이블 유사
create table division(
	dno int primary key,
    dname varchar(20), 
    phone varchar(20),
    position varchar(20)
);
create table person(
	pno int primary key,
    pname varchar(15) not null,
    job   varchar(15) not null,
    manager int, -- 상사사번
    hiredate date, -- 입사일
    sal     numeric(10),
    comm    numeric(10),
    dno     int,
    foreign key(dno) references division(dno) -- FK 제약조건은 반드시 아래에 따로 명시
);
select * from division;
insert into person 
	values (1111, 'smith','manager', 1001, '1990-12-17', 1000, null, 10);
select * from person;











