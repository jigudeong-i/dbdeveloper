create table board(
    num         number(4)   not null,
    author      varchar2(20) not null,
    title          varchar2(500) not null,
    content     varchar2(4000) not null,
    writeday    date default sysdate,
    readcnt     number(4) default 0,
    passwd      varchar2(12) not null,
    
    constraint board_pk primary key(num)
);
-- drop table board;

comment on table board is '게시판 테이블';
comment on column board.num is '게시판 번호';
comment on column board.author is '게시판 작성자';
comment on column board.title is '게시판 제목';
comment on column board.content is '게시판 내용';
comment on column board.writeday is '게시판 등록일';
comment on column board.readcnt is '게시판 조회수';
comment on column board.passwd is '게시판 비밀번호';

create sequence board_seq start with 1
increment by 1
minvalue 1
nocycle
cache 2;
-- drop sequence board_seq;

insert into board( num, author, title, content, passwd )
values ( board_seq.nextval , '홍길동', '노력에 관련된 명언', '중요한 것은 목표를 이루는 것이 아니라 그 과정에서 무엇을 배우며 얼마나 성장했느냐이다. - 앤드류 매튜스' , '1234');

select * from board;
commit;

-- BoardDAO 클래스 : 비밀번호 체크 쿼리 확인해본것 
select case when exists (select 1 from board where num = 1 and passwd = '22')
then 1
else 0
end as result 
from dual;



---------------------------- 예제 

-- 공지 테이블
CREATE TABLE notice ( 
    notice_no      number primary key,
    title             varchar2(200) not null,
    content        varchar2(4000) not null,
    writer           varchar2(50) not null,
    writeday        date default sysdate,
    view_count    number default 0, 
    is_important   char(1) default 'N' check (is_important IN ('Y', 'N'))
);

-- 공지 테이블 시퀀스
CREATE SEQUENCE notice_seq start with 1
increment by 1
minvalue 1
nocycle
cache 2;

-- 데이터 입력(1개 이상)
INSERT INTO notice (notice_no, title, content, writer, writeday, is_important)
VALUES (notice_seq.NEXTVAL, '서버 점검 안내', '8월 2일 오전 1시부터 서버 점검이 예정되어 있습니다.', '관리자', SYSDATE, 'Y');

-- 조회
SELECT * FROM notice;



