SELECT SUM(SALARY)
FROM EMPLOYEES;

--------------------- sum : 
SELECT TO_CHAR(SUM(SALARY), '$999,9999') AS TOTAL       -- to_char : 문자열로 바꿔주는 함수
FROM EMPLOYEES;

--------------------- avg : 직원의 평균 급여 구하기
select avg(salary) from employees;
select round(avg(salary), 1) from employees;                -- round : 숫자 반올림

-------------------- max/min : 최근 입사한 사원과 가장 오래전 입사한 직원의 입사일 출력 
select to_char(max(hire_date), 'YYYY-MM-DD'), to_char(min(hire_date), 'YYYY-MM-DD')  
from employees;
 
--------------------- count                                     -- count(*) : 테이블 전체 행 개수 (null 포함)  
-- 전체 사원 수와 커미션을 받는 사원의 수            -- count(컬럼명) : 컬럼의 행 개수 (null 제외)   
select count(*), count(commission_pct)      
from employees;                                  
-- count : 사원수 구하기 
select count(8), count(employee_id), count(commission_pct)          
from employees;                                                              -- count(8) 는 count(*) 와 결과가 같다. 상수8이 모든 행마다 있다고 간주하는 것.
                                                                                      -- 근데도 수를 넣는 건 특정 컬럼이 아닌 걸 강조하고 싶어서. 
select * from employees;


-- 문제 : job의 종류가 몇 개인지 즉, 중복되지 않은 직무의 개수를 구해보자. 
select job_id from employees;
select distinct job_id from employees;
--------------------
select count(job_id) from employees;
select count(distinct job_id) from employees; 


select first_name
from employees
where salary = 4800;

select * from employees;





---------------------------------------------- group by 

-- 컬럼과 그룹 함수를 같이 사용할 때 유의할 점 (중요!)
select first_name, min(salary) from employees;
-- 'ORA-00937: 단일 그룹의 그룹 함수가 아닙니다'   이때 group by 를 사용 

select department_id                    
from employees 
group by department_id         -- '값이 같은 행끼리는 묶어 그룹화하겠다. 그룹별 대표 하나씩만 출력하라' 
order by department_id; 


-- 부서별 최대 급여와 최소 급여 구하기 

select department_id, salary 
from employees                 
group by department_id      -- 오류남. 이 줄 지우고 출력해보면 왜인지 알 수 있음 
order by department_id;      

select department_id, max(salary) "최대 급여", min(salary) "최소 급여"
from employees
group by department_id
order by department_id;      -- 오류 안 남 

-- group by department_id 를 위에선 쓸 수 없는 이유 
-- group by 를 쓸 때 select 절에 오는 컬럼은 group by절에 포함되거나, 집계함수(max, min, sum 등)로 묶여 있어야 한다.   



-- 소속 부서별 급여의 합과 급여의 평균 구하기 
select department_id, sum(salary), avg(salary)
from employees
group by department_id
order by department_id; 

select department_id, sum(salary) "급여의 합", floor(avg(salary)) "급여의 평균"  -- floor : 내림해서 정수로 만드는 함수  
from employees 
group by department_id
order by department_id;


-- 소수점 처리에 관한 쿼리문
select department_id,
         sum (salary),
         avg (salary),
         floor (avg (salary)),
         round (avg (salary)),
         round (avg (salary), 1)
from employees
group by department_id
order by department_id;


-- 문제 : 부서별 사원 수와 커미션을 받는 사원 수를 출력하세요. 
select department_id, count(employee_id), count(commission_pct)
from employees
group by department_id 
order by department_id;

    select * from departments;
    select * from employees;


-- 추가문제 : 급여가 8000 이상인 사원들만 부서별로 사원수와 커미션을 받는 사원의 수를 카운트 해보자. 
select department_id, salary
from employees
-- where salary >= 8000
order by department_id;

select department_id, count(*), count(commission_pct)
from employees
where salary >= 8000
group by department_id
order by department_id;



-- 문제 : 부서별 같은 업무를 담당하는 사원의 수를 카운트해보자.

-- 처리 전 확인 쿼리문 
select department_id, job_id
from employees
group by department_id, job_id
order by department_id, job_id;

select department_id, job_id, count(employee_id)
from employees
group by department_id, job_id
-- order by department_id, job_id;
order by 1, 2; 



-- 문제 : 30번 부서에 소속된 사원 중에 오래 근무한 사원의 입사일을 출력해보자. 
select department_id, min(hire_date)
from employees
where department_id = 30
group by department_id; 





-------------------------------- having 
-- 통계를 낸 다음엔 where가 아닌 having 을 써야 한다. 

select department_id, (avg(salary))
from employees
group by department_id
order by department_id;

    select * from employees;

-- 부서별 급여의 평균을 구하여 그 평균이 5000이상인 부서만 조회하도록 쿼리문 작성.
select department_id, floor(avg(salary))    
from employees                                  -- floor : 소수점 아래를 내림처리하고, 정수로 만들어주는 함수 
group by department_id
having floor(avg(salary)) >= 5000
order by department_id;


-- 부서별 최대 급여와 최소 급여를 출력하되 최대급여가 5000초과한 부서만 출력하는 쿼리문 작성. 
select department_id, max(salary), min(salary)
from employees
group by department_id
having max(salary) > 5000
order by department_id;


-- 부서명(부서테이블)과 사원번호(사원테이블)를 조회하는 쿼리문 작성하라. 단 부서명, 사원 번호로..
select department_name, employee_id
from departments inner join employees
using (department_id);

    select * from employees;

select department_name, count(employee_id)
from departments inner join employees
using(department_id)
group by department_name, department_id
order by department_id;

-- null까지 표시하려면?
select department_name, count(employee_id)
from departments right outer join employees
using (department_id)
group by department_name, department_id
order by department_id;




-- 부서별 인원수를 구하여 그 인원수가 4명 초과하는 부서를 조회하는 쿼리문 작성. 








----------------------------------- rollup -------------------------------
-- 자동으로 소계와 합계를 구해주는 함수 

select department_id, job_id, count(*), sum(salary)             -- 부서내 같은 직무 담당 사원의 급여의 합 및 사원수
from employees
group by department_id, job_id
union all 
select department_id, null job_id, count(*), sum(salary)           -- 부서별 급여의 합과 사원수 
from employees
group by department_id
union all 
select null department_id, null job_id, count(*), sum(salary)       -- 전체 사원의 급여의 합과 사원수 
from employees
order by department_id, job_id; 

-- 위 코드를 rollup을 쓰면? 한줄로 간단하게! 

select department_id, job_id, count(*), sum(salary)
from employees
group by rollup(department_id, job_id)
order by department_id;











----------------------------cube ---------------------------------
-- 소계와 전체 합계까지 출력하는 함수. 명시한 표현식 개수에 따라 가능한 모든 조합별로 집계한 결과를 반환. 
select department_id, job_id, count(*), sum(salary)
from employees
group by cube(department_id, job_id)        -- 2개의 컬럼으로 만들 수 있는 모든 집계 조합을 구하겠다.
order by department_id, job_id; 

    select * from employees;

----------------------------grouping ----------------------------------
-- rollup이나  cube에 의한 집계 산출물이 인자로 전달받은 컬럼 집합의 산출물이면 0 반환, 아니면 1 반환. 

select department_id, job_id, sum(salary), 
         case when grouping(department_id) = 0 and grouping(job_id) = 1 then '부서별 합계' 
                when grouping(department_id) = 1 and grouping(job_id) = 0 then '직급별 합계'  
                when grouping(department_id) = 1 and grouping(job_id) = 1 then '총 합계' 
                else '그룹별 합계'
    end as 구분
from employees
group by cube(department_id, job_id)
order by 1;

select department_id, job_id, count(*), sum(salary)
from employees
group by grouping sets(department_id, job_id)
order by department_id;



----------------------------------- 집합연산자 ------------------------------------

-- 한국과 일본의 10대 수출품 테이블
CREATE TABLE exp_goods_asia (
country NVARCHAR2(10),              -- 나라명
seq NUMBER,                               -- 번호
goods NVARCHAR2(80)                 -- 상품명
);
INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5, 'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7, '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8, '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9, '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10, '철 또는 비합금강');
INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

select * from exp_goods_asia where country = '한국';
select * from exp_goods_asia where country = '일본';


--- union : 중복은 한번만 조회
select goods from exp_goods_asia
where country = '한국'
union                                       -- 
select goods from exp_goods_asia
where country = '일본';


--union all : 중복된 항목도 모두 조회
select goods
from exp_goods_asia
where country = '한국'
union all 
select goods
from exp_goods_asia
where country = '일본';


-- intersect 
select goods
from exp_goods_asia
where country = '한국'
intersect
select goods
from exp_goods_asia
where country = '일본';


-- minus
select goods
from exp_goods_asia
where country = '한국'
minus
select goods
from exp_goods_asia
where country = '일본';




-- [예제] 공지 테이블과 자유게시판 테이블을 만들고 하나의 결과를 출력하시오 . 
-- 공지 테이블 
create table notice (
    no number, 
    name nvarchar2(10) not null,
    title nvarchar2(100) not null,
    contents nvarchar2(2000) not null,
    regdate date default sysdate,
    constraint notice_no_pk primary key(no)
);
drop table notice; 

create sequence notice_seq
    start with 1
    increment by 1
    minvalue 1
    maxvalue 99999999
    nocycle
    cache 2;
drop sequence notice_seq;    

insert into notice values(notice_seq.nextval, '관리자', '[필독]사이트 이용 방법', '저희 사이트를 방문해 주셔서 감사합니다.', default);
insert into notice values(notice_seq.nextval, '관리자', '[배송안내] 자바 프로그래밍 서적 일괄 배송', '자바 프로그래밍 서적을 구입해주신 분들께 진심으로 감사드립니다', default);


-- 자유게시판 테이블 
create table free (
    no number, 
    name nvarchar2(10) not null,
    title nvarchar2(100) not null,
    contents nvarchar2(2000) not null,
    regdate date default sysdate,
    constraint free_no_pk primary key(no)
);
-- drop table free; 

create sequence free_seq
    start with 1
    increment by 1
    minvalue 1
    maxvalue 99999999
    nocycle
    cache 2;
-- drop sequence notice_free;  

insert into free values(free_seq.nextval, '홍길동', '노력과 열정에 대한 명언', '나의 유일한 경쟁자는 어제의나다', default);
insert into free values(free_seq.nextval, '김철수', '노력과 열정에 대한 명언', '가장 큰 영광은 한번도 실패하지 않음이 아니다.', default);

    select * from notice; 
    select * from free;


-- 하나로 출력
select no, name, title, to_char(regdate, 'YYYY-MM-DD') regdate 
from notice
union all    
select no, name, title, to_char(regdate, 'YYYY-MM-DD') regdate
from free; 









