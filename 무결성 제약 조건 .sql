

--------------- NULL 과 NOT NULL 

DROP TABLE EMP01 PURGE;

CREATE TABLE EMP01(
    EMPNO NUMBER(4) NOT NULL,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(4)
);
INSERT INTO EMP01 VALUES (NULL, NULL, 'SALESMAN', 30);        -- NULL 

    SELECT * FROM EMP01;
    DESC EMP01;





-------------- UNIQUE KEY : 중복값을 허용하지 않는다.

DROP TABLE EMP02 PURGE;

CREATE TABLE EMP02(
    EMPNO NUMBER(4) UNIQUE,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(4)
);

INSERT INTO EMP02(EMPNO, ENAME, JOB, DEPTNO)
VALUES (7499, 'ALLEN', 'SALESMAN', 30);

INSERT INTO EMP02
VALUES (7499, 'ALLEN', 'SALESMAN', 30);   -- 에러

INSERT INTO EMP02
VALUES(NULL, 'JONES', 'MANAGER', 20);   -- NULL 도 불허하려면 NOT NULL UNIQUE을 쓴다. 

INSERT INTO EMP02
VALUES(NULL, 'JONES', 'SALESMAN', 10);

    SELECT * FROM EMP02;


------------------데이터 딕셔너리 뷰 

-- HR 사용자가 가진 테이블만 확인
SELECT TABLE_NAME FROM USER_TABLES
ORDER BY TABLE_NAME DESC;           -- '내림차순(Descending) 정렬하기'

-- 제약조건 확인
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME     -- CONSTRAINT TYPE : 제약 타입
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP02';

    SELECT * FROM EMP02;

-- 제약조건 컬럼 확인
SELECT OWNER, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME 
FROM USER_CONS_COLUMNS   -- 제약조건 컬럼 가져오겠다. 
WHERE TABLE_NAME = 'EMP02';



------------------------ PRIMARY KEY 

CREATE TABLE EMP03(
    EMPNO NUMBER(4) PRIMARY KEY,    -- UNIQUE와 NOT NULL 두 조건 모두 갖는다.
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(4)
);

INSERT INTO EMP03
VALUES(7499, 'ALLEN', 'SALESMAN', 30);

    SELECT * FROM EMP03;

INSERT INTO EMP03 
VALUES(7499, 'JONES', 'MANAGER', 20);   -- 에러 

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP03';



--------------------------- FOREIGN KEY 

-- 부서테이블(부모테이블)
CREATE TABLE DEPT01(
    DEPTNO NUMBER(2) PRIMARY KEY,
    DNAME VARCHAR2(14) NOT NULL,
    LOC VARCHAR2(13)
);
INSERT INTO DEPT01 (DEPTNO, DNAME, LOC) VALUES(10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT01 (DEPTNO, DNAME, LOC) VALUES(20, 'RESEARCH', 'DALLAS');
INSERT INTO DEPT01 (DEPTNO, DNAME, LOC) VALUES(30, 'SALES', 'CHICAGO');
INSERT INTO DEPT01 (DEPTNO, DNAME, LOC) VALUES(40, 'OPERATIONS', 'BOSTON');
    
    SELECT * FROM DEPT01;
    SELECT * FROM EMP04;


--사원테이블(자식테이블)
CREATE TABLE EMP04(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2) REFERENCES DEPT01(DEPTNO)   -- 부모키 지정 
);
INSERT INTO EMP04 VALUES (7499, 'ALLEN', 'SALESMAN', 30);
INSERT INTO EMP04 VALUES (7566, 'JONES', 'MANAGER', 50);      -- 오류 '무결성 오류'
    
    
    -- 딕셔너리로 살펴보기 
    SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME
    FROM USER_CONSTRAINTS
    WHERE TABLE_NAME = 'EMP04';



-----------------------------CHECK
CREATE TABLE EMP05(
    EMPNO NUMBER(4) PRIMARY KEY,
    ENAME VARCHAR2(10) NOT NULL,
    GENDER VARCHAR2(1) CHECK (GENDER IN('M', 'F')),   -- M 이거나 F 여야 한다. 
    REGDATE DATE DEFAULT SYSDATE                          --아무값도 안 주거나, DEFAULT를 입력하면 SYSDATE를 넣겠다.
);
INSERT INTO EMP05(EMPNO, ENAME, GENDER, REGDATE) VALUES (7567, 'JONES', 'M', SYSDATE);
INSERT INTO EMP05(EMPNO, ENAME, GENDER) VALUES (7566, 'JONES', 'M');
INSERT INTO EMP05 VALUES (7568, 'JONES', 'M', DEFAULT);

    SELECT * FROM EMP05;

INSERT INTO EMP05(EMPNO, ENAME, GENDER) VALUES(7566, 'JONES', 'A');

--제약조건
    SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, SEARCH_CONDITION
    FROM USER_CONSTRAINTS
    WHERE TABLE_NAME = 'EMP05';         --DEFAULT 는 항목에 포함시키지 않는다. PK, NOT NULL, CHECK 다 아니기에. 







------------------------------------------ 제약조건명 직접 설정하기-------------------------------------------
CREATE TABLE EMP06(
    EMPNO NUMBER(4)     CONSTRAINT EMP06_EMPNO_PK   PRIMARY KEY,
    ENAME VARCHAR2(10) CONSTRAINT EMP06_ENAME_NN  NOT NULL,
    JOB VARCHAR2(9)        CONSTRAINT EMP06_JOB_UK       UNIQUE,
    DEPTNO NUMBER(2)    CONSTRAINT EMP06_DEPTNO_FK   REFERENCES DEPT01(DEPTNO)
); 
INSERT INTO EMP06 VALUES (7499, 'ALLEN', 'SALESMAN', 30);

    SELECT * FROM EMP06;
    
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'EMP06'; 


------ 어떤 제약조건에 위배되는지 확인 

-- 무결성 제약 조건(HR.EMP06_EMPNO_PK)에 위배됩니다
INSERT INTO EMP06 VALUES (7499, 'ALLEN', 'SALESMAN', 30);       -- 위에서 이미 들어갔음. 중복저장X

-- SQL 오류: ORA-01400: NULL을 ("HR"."EMP06"."ENAME") 안에 삽입할 수 없습니다
INSERT INTO EMP06 VALUES (7499, NULL, 'SALESMAN', 50);

-- ORA-00001: 무결성 제약 조건(HR.EMP06_EMPNO_PK)에 위배됩니다
INSERT INTO EMP06 VALUES (7499, 'ALLEN', 'SALESMAN', 50);

-- ORA-00001: 무결성 제약 조건(HR.EMP06_JOB_UK)에 위배됩니다
INSERT INTO EMP06 VALUES(7500, 'ALLEN', 'SALESMAN', 50);

-- ORA-02291: 무결성 제약조건(HR.EMP06_DEPTNO_FK)이 위배되었습니다- 부모 키가 없습니다
INSERT INTO EMP06 VALUES(7500, 'ALLEN', 'MANAGER', 50); 









----------------------------- 테이블 레벨 방식으로 제약조건 지정하기 ---------------------------

-- NOT NULL, CHECK, DEFAULT는 컬럼 레벨로 정의
-- 기본키, 유일키, 외래키(참조키) 는 테이블 레벨로 정의 
CREATE TABLE EMP08(
    EMPNO      NUMBER(4),
    ENAME      VARCHAR2(10) NOT NULL,
    JOB           VARCHAR2(9),
    DEPTNO     NUMBER(2),
    CONSTRAINT EMP08_EMPNO_PK   PRIMARY KEY (EMPNO),
    CONSTRAINT EMP08_JOB_UK        UNIQUE (JOB),
    CONSTRAINT EMP08_DEPTNO_FK   FOREIGN KEY (DEPTNO) REFERENCES DEPT01 (DEPTNO)
);

    SELECT * FROM EMP08;

    SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME
    FROM USER_CONSTRAINTS
    WHERE TABLE_NAME = 'EMP08';




-------------------------------------- 제약 조건 변경하기 ------------------------------------

CREATE TABLE EMP09(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(10),
    JOB VARCHAR2(9),
    DEPTNO NUMBER(4)
);

    SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME, R_CONSTRAINT_NAME
    FROM USER_CONSTRAINTS 
    WHERE TABLE_NAME = 'EMP09';             

-- 제약조건명을 명시하지 않고 기본키 추가 
ALTER TABLE EMP09
ADD PRIMARY KEY (EMPNO);
-- 제약조건명을 명시하고 기본키 추가
ALTER TABLE EMP09
ADD CONSTRAINT EMP09_EMPNO_PK PRIMARY KEY(EMPNO);

-- 제약조건명 명시, 외래키 추가
ALTER TABLE EMP09
ADD CONSTRAINT EMP09_DEPTNO_FK FOREIGN KEY(DEPTNO) REFERENCES DEPT01 (DEPTNO);

-- ENAME 컬럼에 NOT NULL 제약조건 추가
ALTER TABLE EMP09
MODIFY(ENAME VARCHAR2(10) NOT NULL);






------------------- 외래키가 설정된 데이터 삭제

CREATE TABLE DEPT02(
    DEPTNO NUMBER(2),
    DNAME VARCHAR2(14),
    LOC VARCHAR2(13),
    CONSTRAINT DEPT02_DEPTNO_PK PRIMARY KEY(DEPTNO)
);
INSERT INTO DEPT02 VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT02 VALUES (20, 'RESEARCH', 'DALLAS');

    SELECT * FROM DEPT02;
    
CREATE TABLE EMP02(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(10) NOT NULL,
    JOB VARCHAR2(9),
    DEPTNO NUMBER(2),
    CONSTRAINT EMP02_EMPNO_PK PRIMARY KEY(EMPNO),
    CONSTRAINT EMP02_DEPTNO_FK FOREIGN KEY(DEPTNO) REFERENCES DEPT02(DEPTNO)
);
INSERT INTO EMP02 VALUES (7499, 'ALLEN', 'SALESMAN', 10);
INSERT INTO EMP02 VALUES(7369, 'SMITH', 'CLERK', 20);

    SELECT * FROM EMP02;
    
    
DELETE FROM DEPT02 
WHERE DEPTNO = 10;  -- 오류
-- 자식테이블인 EMP02는 부모테이블인 DEPT02의 기본키인 부서번호를 참조하고있어 삭제할 수 없다. 

-- 부서번호 10번 자료를 삭제하려면? 
-- 방법 1 : 사원 테이블 부서번호가 10번인 사원을 20번 부서로 이동 후 삭제
UPDATE EMP02
SET DEPTNO = 20
WHERE EMPNO = 7499;
DELETE FROM DEPT02 WHERE DEPTNO = 10; 

-- 방법 2 : 사원 테이블 부서 번호가 10인 사원을 먼저 삭제하고 부서 테이블 부서번호 10을 삭제. 
DELETE FROM EMP02 WHERE DEPTNO = 10;
DELETE FROM DEPT02 WHERE DEPTNO = 10; 

-- 방법 3 : ON DELETE CASCADE, ON DELTE SET NULL 




------------------ ON DELETE CASCADE ----------------------
-- 부모 테이블 데이터 삭제시, 자식 테이블 데이터도 삭제


CREATE TABLE TREATMENT(
    T_NO                   NUMBER(4) NOT NULL,
    T_COURSE_ABBR       VARCHAR(3) NOT NULL,
    T_COURSE             VARCHAR2(30) NOT NULL,
    T_TEL                VARCHAR2(15) NOT NULL,
    CONSTRAINT TREATMENT_NO_PK PRIMARY KEY(T_NO),
    CONSTRAINT TREATMENT_COURSE_ABBR_UK UNIQUE(T_COURSE_ABBR)
);
INSERT INTO TREATMENT(T_NO, T_COURSE_ABBR, T_COURSE, T_TEL) VALUES (1001, 'NS', '신경외과', '02-4568-7785');
INSERT INTO TREATMENT(T_NO, T_COURSE_ABBR, T_COURSE, T_TEL) VALUES (1002, 'OS', '정형외과', '02-4858-3385');
INSERT INTO TREATMENT(T_NO, T_COURSE_ABBR, T_COURSE, T_TEL) VALUES (1003, 'C', '순환기내과', '02-8965-2580');

    SELECT * FROM TREATMENT;
    
    SELECT * FROM EMPLOYEES;
    
    delete from treatment
    where t_no=123;
    
    -- 컬럼에 주석을 다는 구문 : COMMENT ON COLUMN 테이블명.컬럼명 IS '주석 내용';
    COMMENT ON COLUMN TREATMENT.T_NO IS '진료번호';
    COMMENT ON COLUMN TREATMENT.T_COURSE_ABBR IS '진료과목약어';
    COMMENT ON COLUMN TREATMENT.T_COURSE IS '진료과목';
    COMMENT ON COLUMN TREATMENT.T_TEL IS '전화번호';
    
    -- 주석 확인 
    SELECT TABLE_NAME, COLUMN_NAME, COMMENTS
    FROM ALL_COL_COMMENTS
    WHERE TABLE_NAME = 'TREATMENT';

CREATE TABLE DOCTOR(
    D_NO       NUMBER(4)     NOT NULL,
    D_NAME   VARCHAR2(20) NOT NULL,
    D_SSN      CHAR(14)         NOT NULL,
    D_EMAIL   VARCHAR2(80)  NOT NULL,
    D_MAJOR  VARCHAR2(50)  NOT NULL,
    T_NO        NUMBER(4),
    CONSTRAINT DOCTOR_D_NO_PK PRIMARY KEY(D_NO)
);

ALTER TABLE DOCTOR
ADD CONSTRAINT DOCTOR_T_NO FOREIGN KEY(T_NO) REFERENCES TREATMENT(T_NO)
ON DELETE CASCADE;             -- 중복이 허용되선 안 된다. (기본키, 유일키)

INSERT INTO DOCTOR(D_NO, D_NAME, D_SSN, D_EMAIL, D_MAJOR, T_NO)
VALUES (1, '홍길동', '660606-1234561', 'javauser@naver.com', '척추신경외과', 1001);

INSERT INTO DOCTOR(D_NO, D_NAME, D_SSN, D_EMAIL, D_MAJOR, T_NO)
VALUES (2, '이재환', '694506-1234561', 'jaehwan@naver.com', '뇌혈관외과', 1003);

INSERT INTO DOCTOR(D_NO, D_NAME, D_SSN, D_EMAIL, D_MAJOR, T_NO)
VALUES (3, '양익환', '700606-1234561', 'sheep1209@naver.com', '인공관절', 1002);

INSERT INTO DOCTOR(D_NO, D_NAME, D_SSN, D_EMAIL, D_MAJOR, T_NO)
VALUES (4, '김승현', '720606-1234561', 'seunghyeon@naver.com', '종양외과', 1002);

    SELECT * FROM DOCTOR;
    COMMIT;
    
DELETE FROM TREATMENT 
WHERE T_NO = 1002;

    SELECT * FROM TREATMENT;
    SELECT * FROM DOCTOR;


------------------------ DELETE SET NULL ---------------------------
-- 부모 테이블 데이터 삭제시, 자식 테이블 값을 NULL로 설정. 
    
    ROLLBACK; 

ALTER TABLE DOCTOR
DROP CONSTRAINT DOCTOR_T_NO;       

ALTER TABLE DOCTOR
ADD CONSTRAINT DOCTOR_T_NO FOREIGN KEY(T_NO) REFERENCES TREATMENT(T_NO)
ON DELETE SET NULL;

DELETE FROM TREATMENT
WHERE T_NO = 1002;

    SELECT * FROM TREATMENT;
    SELECT * FROM DOCTOR;



-- HR 사용자로 생성한 DEPT01 테이블과 외래키 설정 테이블 확인 
SELECT FK.OWNER, FK.CONSTRAINT_NAME, FK.TABLE_NAME
FROM ALL_CONSTRAINTS FK, ALL_CONSTRAINTS PK
WHERE FK.R_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
    AND PK.OWNER = 'HR'
    AND FK.CONSTRAINT_TYPE = 'R'
    AND PK.TABLE_NAME = 'DEPT01'
ORDER BY FK.TABLE_NAME;            



