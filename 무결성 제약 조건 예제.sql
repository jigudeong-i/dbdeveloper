
-----------------------------------------------학과 테이블 생성 
CREATE TABLE SUBJECT(
    NO           NUMBER                NOT NULL,           -- 일련번호
    S_NUM      CHAR(2)                 NOT NULL,           -- 학과번호(참조키 설정을 위해 유일키/기본키 설정)
    S_NAME     NVARCHAR2(80)      NOT NULL,           -- 학과명
    CONSTRAINT SUBJECT_NO_PK PRIMARY KEY(NO),
    CONSTRAINT SUBJECT_S_NUM_UK UNIQUE(S_NUM)
);   

-- 학과 테이블에 일련번호(NO)를 시퀀스에 의해 저장되도록
CREATE SEQUENCE SUBJECT_SEQ
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999
    NOCYCLE
    CACHE 2;

INSERT INTO SUBJECT (NO, S_NUM, S_NAME) VALUES (SUBJECT_SEQ.NEXTVAL, '01', '컴퓨터학과');
INSERT INTO SUBJECT (NO, S_NUM, S_NAME) VALUES (SUBJECT_SEQ.NEXTVAL, '02', '교육학과');    
INSERT INTO SUBJECT (NO, S_NUM, S_NAME) VALUES (SUBJECT_SEQ.NEXTVAL, '03', '신문방송학과');
INSERT INTO SUBJECT (NO, S_NUM, S_NAME) VALUES (SUBJECT_SEQ.NEXTVAL, '04', '인터넷비즈니스과');
INSERT INTO SUBJECT (NO, S_NUM, S_NAME) VALUES (SUBJECT_SEQ.NEXTVAL, '05', '기술경영과');
    
    SELECT * FROM SUBJECT;   
    --DROP TABLE SUBJECT;
    --DROP SEQUENCE SUBJECT_SEQ;
    
    
    
--------------------------------------------- 학생 테이블 생성
CREATE TABLE STUDENT(
    NO             NUMBER                       NOT NULL, 
    SD_NUM      CHAR(8)                        NOT NULL,        -- 학번 (년도(2) + 학과번호(2) + 일련번호(4)) 로 구성 
    SD_NAME     NVARCHAR2(5)              NOT NULL,
    SD_ID          VARCHAR2(15)                NOT NULL,
    SD_PASSWD  VARCHAR2(15)               NOT NULL, 
    S_NUM         CHAR(2)                       NOT NULL,
    SD_BIRTH      CHAR(10)                      NOT NULL, 
    SD_PHONE    VARCHAR2(13)               NOT NULL, 
    SD_ADDRESS NVARCHAR2(30)             NOT NULL,
    SD_EMAIL     VARCHAR(30)                 NOT NULL, 
    SD_DATE      DATE DEFAULT SYSDATE,
    CONSTRAINT STUDENT_NO_PK PRIMARY KEY(NO),
    CONSTRAINT STUDENT_SD_NUM_UK UNIQUE(SD_NUM),
    CONSTRAINT STUDENT_ID_UK UNIQUE(SD_ID),
    CONSTRAINT STUDENT_S_NUM_FK FOREIGN KEY(S_NUM) REFERENCES SUBJECT(S_NUM)
); 

-- 학생테이블에 일련번호(NO)를 시퀀스에 의해 저장되도록 시퀀스 생성 
CREATE SEQUENCE STUDENT_SEQ
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999
    NOCYCLE
    CACHE 2;

insert into student(no, sd_num, sd_name, sd_id, sd_passwd, s_num, sd_birth, sd_phone, sd_address, sd_email) 
values(student_seq.nextval, '06010001','김정수', 'javajsp', 'java1234', '01', '19860424', '01032789054','(03727) 서울특별시 서대문구 성산로 450-2','java12@naver.com');
insert into student(no, sd_num, sd_name, sd_id, sd_passwd, s_num, sd_birth, sd_phone, sd_address, sd_email) 
values(student_seq.nextval, '95010002','김수현', 'jdbcmania', 'mania12', '01', '19751009', '01034524680','(06774) 서울특별시 서초구 강남대로 27','jdbcmania@naver.com');
insert into student(no, sd_num, sd_name, sd_id, sd_passwd, s_num, sd_birth, sd_phone, sd_address, sd_email) 
values(student_seq.nextval, '98040001','공지영', 'gonji', 'mania12', '04', '19780516', '01012657455','(48000) 부산광역시 해운대구 반송로 816','gonji@nate.com');
insert into student(no, sd_num, sd_name, sd_id, sd_passwd, s_num, sd_birth, sd_phone, sd_address, sd_email) 
values(student_seq.nextval, '02050001','조수영', 'water', 'java1234', '05', '19820831', '01076812499','(34626) 대전광역시 동구 중앙로 215','water@korea.com');
insert into student(no, sd_num, sd_name, sd_id, sd_passwd, s_num, sd_birth, sd_phone, sd_address, sd_email) 
values(student_seq.nextval, '94040002','최경란', 'novel', 'novel2468', '04', '19741025', '01098792649','(16210) 경기도 수원시 장안구 서부로 2287','novel@naver.com');
insert into student(no, sd_num, sd_name, sd_id, sd_passwd, s_num, sd_birth, sd_phone, sd_address, sd_email) 
values(student_seq.nextval, '08020001','안익태', 'korea', 'korea99', '02', '19880805', '01084522895','(06181) 서울 강남구 테헤란로98길 12','korea@nate.com');

    SELECT * FROM STUDENT;
    --DROP TABLE STUDENT;   
    --DROP SEQUENCE STUDENT_SEQ;
    
    -- 제약조건 확인
    SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME
    FROM USER_CONSTRAINTS
    WHERE TABLE_NAME = 'STUDENT'; 




--------------------------------------------과목테이블 생성
CREATE TABLE COURSE(
    NO            NUMBER           NOT NULL,
    C_NUM       CHAR(7)            NOT NULL,
    C_NAME     VARCHAR2(80)    NOT NULL,  
    C_CREDIT    NUMBER(2)        CHECK(C_CREDIT BETWEEN 2 AND 4),
    C_SECTION  NCHAR(2)  CHECK(C_SECTION IN ('교양', '일반', '전공')),
    CONSTRAINT COURSE_NO_PK PRIMARY KEY(NO),
    CONSTRAINT COURSE_C_NUM_UK UNIQUE(C_NUM)
);


-- 과목테이블에 일련번호(NO)를 시퀀스에 의해 저장되도록 생성 
CREATE SEQUENCE COURSE_SEQ
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999
    NOCYCLE
    CACHE 2;
    
INSERT INTO COURSE(NO, C_NUM, C_NAME, C_CREDIT, C_SECTION)
VALUES(COURSE_SEQ.NEXTVAL, 'UA04001', '대학영어', 2, '교양');

INSERT INTO COURSE(NO, C_NUM, C_NAME, C_CREDIT, C_SECTION)
VALUES(COURSE_SEQ.NEXTVAL, 'UA05001', '소프트웨어와 창의적 사고', 4, '교양');

INSERT INTO COURSE(NO, C_NUM, C_NAME, C_CREDIT, C_SECTION)
VALUES(COURSE_SEQ.NEXTVAL, 'UBB0001', '독서와 토론', 3, '교양');

INSERT INTO COURSE(NO, C_NUM,C_NAME,  C_CREDIT, C_SECTION)
VALUES(COURSE_SEQ.NEXTVAL, 'UGG0010', '한국의 이해', 3, '일반');

INSERT INTO COURSE(NO, C_NUM, C_NAME, C_CREDIT, C_SECTION)
VALUES(COURSE_SEQ.NEXTVAL, 'UGG0031', '내아이디어로 창업하기', 4, '일반');

INSERT INTO COURSE(NO, C_NUM, C_NAME, C_CREDIT, C_SECTION)
VALUES(COURSE_SEQ.NEXTVAL, 'UCR0001', '데이터베이스 설계와 구축', 4, '전공');

INSERT INTO COURSE(NO, C_NUM, C_NAME, C_CREDIT, C_SECTION)
VALUES(COURSE_SEQ.NEXTVAL, 'UCR0002', '데이터 분석', 4, '전공');

    
    select * from course;
    select * from student;
    select * from subject;
    
-----------------------------------------수강테이블 생성--------------------------------
CREATE TABLE ENROLLMENT(                                            -- 왜 안 돼 
    NO NUMBER NOT NULL,
    E_YEAR CHAR(4) NOT NULL,
    E_SEMESTER NVARCHAR2(4) CHECK(E_SEMESTER IN ('1학기', '2학기', '여름학기', '겨울학기')),
    SD_NUM CHAR(8) NOT NULL,         -- 학번 (학생테이블)
    C_NUM CHAR(7) NOT NULL,           -- 과목번호(과목테이블)
    E_GRADE NUMBER(2, 1) CHECK(E_GRADE BETWEEN 0 AND 4.5),
    E_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT ENROLLMENT_NO_PK PRIMARY KEY(NO),
    CONSTRAINT ENROLLMENT_SD_NUM_FK FOREIGN KEY(SD_NUM) REFERENCES STUDENT(SD_NUM),
    CONSTRAINT ENROLLMENT_C_NUM_FK FOREIGN KEY(C_NUM) REFERENCES COURSE(C_NUM)
);                                                  
CREATE SEQUENCE ENROLLMENT_SEQ
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999
    NOCYCLE
    CACHE 2;
    
INSERT INTO ENROLLMENT(NO, E_YEAR, E_SEMESTER, SD_NUM, C_NUM, E_GRADE)
VALUES(ENROLLMENT_SEQ.NEXTVAL, '2004', '1학기', '06010001', 'UA05001', 4.0);
    
INSERT INTO ENROLLMENT(NO, E_YEAR, E_SEMESTER, SD_NUM, C_NUM, E_GRADE)
VALUES(ENROLLMENT_SEQ.NEXTVAL, '2004', '1학기', '98040001', 'UBB0001', 3.8);
    
INSERT INTO ENROLLMENT(NO, E_YEAR, E_SEMESTER, SD_NUM, C_NUM, E_GRADE)
VALUES(ENROLLMENT_SEQ.NEXTVAL, '2004', '1학기', '06010001', 'UCR0001', 4.3);

INSERT INTO ENROLLMENT(NO, E_YEAR, E_SEMESTER, SD_NUM, C_NUM, E_GRADE)
VALUES(ENROLLMENT_SEQ.NEXTVAL, '2004', '1학기', '08020001', 'UGG0031', 3.6);

    SELECT * FROM ENROLLMENT;
    drop table enrollment;







