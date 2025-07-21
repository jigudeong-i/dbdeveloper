-- 사용자 계정 생성 
-- 사용자를 생성하기 위해서는 DBA만 사용자를 생성할 수 있다. 그래서 최고권한자(SYSDBA) 인 PDB_SYS로 접속한다.

-- create user 사용자명 identified by 비밀번호; (비밀번호는 대소문자 구분)
CREATE USER JAVAUSER IDENTIFIED BY java1234;

-- 비밀번호 변경시 
ALTER USER JAVAUSER IDENTIFIED BY java1234;

-- 사용자 권한, 롤 부여 : 사용자 생성시 어떠한 권한, 롤도 가지고 있지 않기에 부여를 해주어야 한다. 
-- 권한 : '무엇을 할 수 있는가' create table, drop, select, insert 등
-- 롤 : 여러 권한을 묶어놓은 권한 묶음. 롤을 부여하면 이 권한들을 모두 허용함.  

-- 우선 각 role에 어떤 권한(privilege)이 부여되어 있는지 확인 
SELECT * FROM role_sys_privs      
WHERE ROLE = 'CONNECT';      -- 이 롤에는 2가지 권한이 부여되어있음

SELECT * FROM role_sys_privs  
WHERE ROLE = 'RESOURCE';   

----------- 권한 부여 
-- GRANT 권한 TO 사용자명;
GRANT CREATE SESSION TO JAVAUSER;      -- CREATE SESSION : 접속은 되지만, 테이블 만들기나 조회는 불가능함.

-- GRANT 롤 TO 사용자명; 
GRANT CONNECT, RESOURCE TO JAVAUSER;

-- JAVAUSER에게 부여된 롤 확인 
SELECT * FROM dba_role_privs
WHERE GRANTEE = 'JAVAUSER';               -- (GRANTEE : 권한을 받은 자)


-- 테이블 스페이스 사용공간 설정 (테이블 스페이스 : Oracle에서 데이터가 실제 저장되는 공간 단위)
ALTER USER JAVAUSER
DEFAULT TABLESPACE USERS     -- JAVAUSER가 앞으로 테이블, 인덱스 등을 만들 때 기본으로 사용할 테이블 스페이스를 USERS로 설정하겠다.
QUOTA UNLIMITED ON USERS;   -- JAVAUSER가 USERS 테이블스페이스에 무제한으로 데이터를 저장할 수 있도록 허용하겠다.
                                                        





