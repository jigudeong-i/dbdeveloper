

-- 서브 쿼리 

-- 조인을 사용하지 않고 Susan 사원이 소속된 부서명을 출력하라.
select department_name from departments
where department_id = (select department_id from employees
                                where first_name = 'Susan');


-- lex와 같은 부서에 있는 모든 사원의 이름과 입사일자(0000-00-00)를 출력하시오
select department_id from employees where first_name = 'lex';

select first_name, to_char(hire_date, 'yyyy-mm-dd') as hire_date from employees 
where department_id = 90; 

select first_name, to_char(hire_date, 'yyyy-mm-dd') as hire_date, department_id
from employees
where department_id = (select department_id
                                from employees
                                where first_name = 'Lex');
  
  
  
                                
-------------------------- 단일 행 서브쿼리          

-- Guy와 같은 부서에서 근무하는 사원의 정보를 출력. (사원번호, 사원명, 급여, 커미션비율, 입사일)
SELECT EMPLOYEE_ID, FIRST_NAME, JOB_ID, SALARY, NVL(COMMISSION_PCT, 0) COMMISSION_PCT, TO_CHAR(HIRE_DATE, 'YYYY.MM.DD') HIRE_DATE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ( SELECT DEPARTMENT_ID 
                                    FROM EMPLOYEES 
                                    WHERE FIRST_NAME = 'Guy' );
                                                      
-- 서브 쿼리를 사용하여 평균 급여보다 더 많은 급여를 받는 사원을 검색하는 쿼리                                                
select first_name, salary
from employees
where salary > (select avg(salary)
                     from employees); 

-- <문제> EMPLOYEES 테이블에서 LAST_NAME 컬럼에서 Kochhar의 급여보다 
-- 많은 사원의 정보를 사원번호, 이름, 담당업무, 급여를 출력해 주세요
select employee_id, first_name, job_id, salary
from employees
where salary > (select salary 
                    from employees
                    where last_name = 'Kochhar');

-- <문제> 가장 적은 급여를 받는 사원의 사번, 이름, 급여를 출력해 주세요.
select employee_id, first_name, salary 
from employees
where salary = (select min(salary)
                     from employees);

-- <추가 문제> 가장 많은 급여를 받는 사원 이름과 사원의 핸드폰번호를 출력해 주세요.
select first_name, phone_number
from employees
where salary = (select max(salary)
                     from employees);

-- <문제> 가장 오랜 기간 근무한 사원의 이름과 이메일, 담당업무, 입사일를 출력해 주세요.
select first_name, email, job_id, hire_date
from employees
where hire_date = (select min(hire_date)
                         from employees);


select * from student;
select * from subject; 






----------------------다중 행 서브쿼리 

-- in 연산자 (서브쿼리 출력 결과와 하나라도 일치하면 됨)

-- 급여를 14000이상 받는 사원이 소속된 부서와 동일한 부서에서 근무하는 사원 출력 
select first_name, salary, department_id
from employees
where department_id in (select distinct department_id
                                 from employees
                                 where salary >= 14000)
order by department_id; 

select * from employees
where salary >= 14000;

-- employees 테이블에서 이름에 'z'가 있는 직원이 근무하는 부서에서 일하는 모든 직원에 대해 
-- 직원 번호, 이름, 급여를 출력하라. 단, 부서번호 순으로. 
select employee_id, first_name, department_id, salary
from employees
where department_id in (select distinct department_id
                                from employees
                                where first_name like '%z%')             -- 이름에 z가 어딨음?
order by department_id;

-- Susan 또는 Lex와 월급이 같은 직원의 이름, 업무, 급여를 출력하시오. (Susna, Lex는 제외)
select first_name, job_id, salary
from employees
where salary in (select salary
                      from employees 
                      where first_name in ('Susan', 'Lex')
                      )
and (first_name <> 'Susan' and first_name <> 'Lex');

-- 적어도 한 명 이상으로부터 보고를 받을 수 있는 직원의 직원번호, 이름, 업무, 부서번호를 출력하시오. 
-- (다른 직원을 관리하는 직원)
select employee_id, first_name, job_id, department_id
from employees
where employee_id in (select distinct manager_id
                             from employees
                             where manager_id is not null);

-- <문제> accounting 부서에서 근무하는 직원과 같은 업무를 하는 직원의 이름, 업무명을 출력하시오
select first_name, job_id, department_id 
from employees 
where job_id in (select job_id
                        from employees
                        where department_id = (select department_id
                                                        from departments 
                                                        where department_name = 'Accounting'));

-- <문제> 지역이 Toronto에 있는 부서에 소속된 사원 정보를 출력.
select * from locations;
select * from employees 
where department_id in ( select department_id
                                 from departments
                                 where location_id =  (select location_id
                                                             from locations
                                                             where city = 'Toronto'));





-- all 연산자 (다 만족해야 됨)

-- 30번 소속 직원들 중 급여를 가장 많이 받은 사원보다 더 많은 급여를 받는 사람의 이름, 급여를 
-- 출력하는 쿼리문 작성 (30번 부서 직원 급여들 모두에 대해 커야 하므로 최대값보다 큰 급여만)
select first_name, salary
from employees
where salary > all ( select salary
                           from employees 
                           where department_id = 30);
select * from employees 
where department_id = 30; 


-- any 연산자 (하나만 만족하면 됨)
-- 찾아진 값에 대해 하나라도 크면 참이 되는 셈이다. 그러므로 찾아진 값 중 가장 작은 값, 즉 최소값보다 크면 참이다.

-- 부서번호가 110번인 사원들의 급여 중 가장 작은 값(8300)보다 많은 급여를 받는 사원의 이름, 급여를 출력
select first_name, salary
from employees
where salary > any ( select salary
                            from employees
                            where department_id = 110);         
select * from employees
where department_id = 110;



-- exists 연산자 (서브 쿼리의 결과 값이 참이 나오기만 하면 바로 메인 쿼리의 결과값을 리턴)

-- job 변동 이력이 있는 모든 사원의 사원번호, first_name, 현재 job_id, 현재 job_title을 출력 
select * from jobs;
select * from job_history;

select employee_id, first_name, E.job_id, job_title 
from employees E inner join jobs J
on E.job_id = J.job_id
where exists (select * from job_history
                    where E.employee_id = employee_id)
order by E.employee_id;





-- 스칼라 서브 쿼리 (select 컬럼명, 서브쿼리 from 테이블명)

-- 사원명과 그 사원이 소속된 부서명 조회. 
select first_name, (select department_name 
                        from departments D
                        where D.department_id = E.department_id) department_name
from employees E;

-- 모든 사원의 사원번호, 이름, 관리자번호, 관리자명을 조회. 
select employee_id, first_name, manager_id, 
        NVL (( select M.first_name                     -- NVL : 괄호 안 쿼리문이 null 이면 ~을 대입하겠다.
                from employees M
                where M.employee_id = E.manager_id), '없음') as 관리자명
from employees E
order by 1;




-- 상호 연관 서브 쿼리 

-- 급여가 자신이 속한 부서의 평균보다 많이 받는 사원의 부서번호, 이름, 급여를 출력
select E.department_id, first_name, E.salary
from employees E
where E.salary > ( select AVG(salary)
                        from employees D
                        where D.department_id = E.department_id)    -- 자신이 속한 부서의 평균 
order by E.department_id, E.salary desc;

select * from employees;


-- 각 부서에 속한 사원 중 최고 급여를 받는 사원의 정보를 출력 
select * from employees e
where salary = ( select MAX(salary)
                    from employees d
                    where d.department_id = e.department_id
                    )
order by department_id; 

-- 최소 한 명 이상의 사원이 있는 부서 정보를 출력 
SELECT * FROM departments d
WHERE EXISTS ( SELECT employee_id
                        FROM employees e
                        WHERE e.department_id = d.department_id ); 




----------------------- 서브 쿼리로 테이블 작성 
drop table emp01; 

create table emp01
as 
select * from employees; 

-- 테이블 구조만 복사 
drop table emp03; 

create table emp03
as 
select * 
from employees 
where 1=0; 
    
    select * from emp03;
    desc emp03; 




------------------- 서브쿼리로 데이터 추가
-- insert를 쓰며 values 절은 사용 안함
drop table dept01;



create table dept01
as 
select * from departments
where 1=0; 

    select * from dept01; 

insert into dept01
select * from departments; 



-------------------- 서브쿼리로 데이터 수정
update dept01
set location_id = (select location_id
                        from departments
                        where department_id = 40)
where department_id = 10; 

    select * from dept01; 



---------------------서브쿼리를 이용한 두개 이상의 칼럼 값 변경

-- 20번 부서의 부서명과 지역명을 30번 부서 것으로 수정 
-- 형식1
update dept01
set department_name = (select department_name
                                from dept01
                                where department_id = 30),
    location_id = (select location_id
                        from dept01
                        where department_id = 30)
where department_id = 20;

-- 형식2
update dept01
set (department_name, location_id) = (select department_name, location_id
                                                    from dept01
                                                    where department_id = 30)
where department_id = 20;

    select * from dept01; 



----------------------서브 쿼리를 이용한 데이터 삭제 
drop table emp01; 

create table emp01
as
select * from employees;

    select * from emp01; 
    
delete from emp01
where department_id = ( select department_id
                                from departments
                                where department_name = 'Sales');

    select * from emp01;
