
SELECT * FROM v$instance;

-- sys로 접속후 hr에게 권한 부여, 
grant create view to hr;
-- 그리고 hr로 접속 


-- 테이블 생성 
    drop table emp01;

create table emp01
as
select employee_id, last_name, email, hire_date, salary, job_id, department_id
from employees;

    select * from emp01;


-- 뷰 생성
desc employees;

create or replace view view_emp01
as 
select employee_id, last_name, email, hire_date, salary, job_id, department_id -- not null로 잡혀진 대상들 가져오기 
from emp01
where department_id = 30; 

select employee_id, last_name, email, hire_date, salary, job_id, department_id
from emp01
where department_id = 30;

    -- 뷰 실행
    select * from view_emp01;

    -- 생성한 모든 뷰 보기 (user_view)
    select view_name, text      -- text : 쿼리가 저장돼있음.   
    from user_views;
    
    select view_name, text
    from user_views
    where view_name = 'EMP_DETAILS_VIEW';

    select * from view_emp01;
    select * from emp_details_view;



-- 단순뷰를 기준으로 삽입, 수정, 삭제가 가능하다. (근데 잘 사용 안함)
-- 뷰를 기준으로 입력하면 실제 테이블(기본 테이블)에 데이터가 저장된다.
insert into view_emp01
values(250, 'ANGEL', 'mail', '03/11/12', 7000, 'PU_MAN', 30);






    drop table emp01;

create table emp01
as 
select employee_id, first_name, salary, department_id
from employees;

-- 단순 뷰의 칼럼에 별칭 부여 
-- 1
create or replace view view_emp02
as 
select employee_id 사원번호, first_name 사원명, salary 급여, department_id 부서번호
from emp01;
-- 2
create or replace view view_emp02(사원번호, 사원명, 급여, 부서번호)
as
select employee_id, first_name, salary, department_id
from emp01;

    select * from view_emp02;
    desc view_emp02

select * from view_emp02
where 부서번호 = 10;        -- 별칭 부여 후에는 무조건 별칭으로 불러야 한다. 





-- 그룹 함수를 사용한 단순 뷰 
-- 부서별 급여의 합, 급여의 평균을 조회할 수 있는 view_salary 뷰 생성. 
create or replace view view_salary
as 
select department_id, sum(salary) as "SalarySum", trunc(avg(salary))as "SalaryAvg" -- 함수를 사용하여 얻은 컬럼은 '반드시' 이름을 설정해주어야 한다. 
from emp01
group by department_id
order by department_id;

    select * from view_salary;

-- 사원번호, 사원이름, 급여, 부서번호, 부서명을 조회할 수 있는 view_emp_dept를 생성
create or replace view view_emp_dept
as
select employee_id, first_name, salary, E.department_id, department_name
from employees E inner join departments D
on E.department_id = D.department_id
order by department_id desc;

-- 위 예제에서 on 대신 using으로 변경시 공통 컬럼에 대해 별칭을 명시하지 않고 작성.
create or replace view view_emp_dept
as
select E.employee_id, E.first_name, E.salary, department_id, D.department_name
from employees E join departments D
using(department_id)
order by department_id desc;

    select * from view_emp_dept;


-- 뷰 삭제 
drop view view_salary;
drop view view_emp_dept;



-- employee_id로 명시한 조건을 department_id로 변경하기.
create or replace view view_emp03
as
select employee_id, first_name, salary, department_id
from emp01
where employee_id = 10;

create or replace view view_emp03
as
select employee_id, first_name, salary, department_id
from emp01
where department_id = 10;



---- force : 뷰를 '미리' 만들어 놓기 
create or replace force view view_notable
as
select employee_id, first_name, department_id
from emp15                  -- 없는 테이블인데 생성 가능. 뷰를 '미리' 만드는 거기 때문에
where employee_id = 10;

    select view_name, text
    from user_views;

    select * from employees;



--- with check option : 뷰 생성시 조건으로 지정한 칼럼값을 맘대로 변경 못하게 
create or replace view view_chk
as 
select employee_id, first_name, salary, department_id
from emp01
where department_id = 20
with check option; 

update view_chk 
set department_id = 10
where salary >= 5000;          -- 바꿀 수 없다. 



--- with read only  : 어떤 컬럼에 대해서도 내용 변경 불가능 
create or replace view view_read 
as
select employee_id, first_name, salary, department_id
from emp01
where department_id = 30 with read only;

update view_read
set department_id = 1000;      -- 바꿀 수 없다.



----------------------------- 뷰의 활용

--- rownum : insert문에 의해 입력한 순서에 따라 1씩 증가 되면서 값이 지정. 정렬로는 안 바뀜. 
-- 최근에 입사한 사원 5명을 출력.
select rownum, employee_id, first_name, hire_date
from employees;

select rownum, employee_id, first_name, hire_date
from employees
order by hire_date desc;        -- 내림차순으로 했는데도 정렬 제대로 안 됨

-- 해결 : 가상테이블인 뷰와 rownum으로 해결 
create or replace view view_hire
as 
select employee_id, first_name, hire_date
from employees
order by hire_date desc; 

select rownum, employee_id, first_name, hire_date
from view_hire
where rownum <= 5;



----------------인라인 뷰 (괄호 안 칼럼은 괄호 밖 칼럼을 포함해야 한다.) 
-- 최근 입사한 사원 5명 
select rownum, employee_id, first_name, hire_date
from (
        select employee_id, first_name, hire_date
        from employees
        order by hire_date desc
        )
where rownum <= 5;

-- 월급 많이 받는 탑5 사원을 구하라. 
select rownum, salary, first_name 
from (
        select salary, first_name
        from employees
        order by salary desc
        )
where rownum <= 5;

-- 부서번호와 부서명, 부서별 최대 급여를 출력하라. 
select E.department_id, D.department_name, E.salary
from (
        select department_id, max(salary) salary
        from employees
        group by department_id
        )
E inner join departments D            -- 괄호 안 데이터를 E로 부르겠다. 
on E.department_id = D.department_id; 



---------------with
-- 서브쿼리에 이름을 붙이고 인라인뷰로 사용시 서브쿼리의 이름으로 from절에 기술 가능. 
-- 같은 서브쿼리가 여러번 사용될 경우 중복을 피할 수 있고 속도도 빨라진다는 장점. 

with topn_hire
as
(select employee_id, first_name, hire_date
from employees
order by hire_date desc)          -- '괄호안 쿼리를 topn_hire라고 부르겠다'  

select rownum, employee_id, first_name, hire_date
from topn_hire
where rownum <= 5;




-------------------------------------- 순위 함수 ---------------------------------------
-- 특정 컬럼을 기준으로 크기에 따른 순위를 구하는 함수들

------------------ rank() over 
-- 순위부여시 중복값(같은값)이 발생되면 중복 값의 갯수만큼 건너 뛰고 다음 순위 부여한다
-- 예를 들어 90, 80, 80, 80, 70이면 순위는 1, 2, 2, 2, 5로 부여한다. 
select employee_id as 사원번호, first_name as 사원명, hire_date as 입사일자, rank() over(order by hire_date desc) as 순위
from employees
where department_id = 80;

-- 사원테이블에서 80번 부서에 소속된 사원 중에서 급여를 가장 많이 받는 순으로 
-- 사원번호, 사원명, 급여, 순위를 부여하여 출력해 주세요.
select employee_id as 사원번호, first_name as 사원명, salary as 급여, 
rank()over(order by salary desc, employee_id) as 순위         -- 값이 같으면 employee_id 순으로 출력하겠다. 이렇게 적으면 중복순위가 없어짐
from employees
where department_id = 80;

-- 사원테이블에서 급여를 가장 많이 받는 순으로 순위를 부여하고 상위 5명을 출력하시오
select salary_rank, first_name, salary 
from (
        select first_name, salary, rank()over(order by salary desc) salary_rank 
        from employees
        order by salary desc
        )
-- where rownum <= 5
where salary_rank <= 5;




-------------row_number() over()      : 순위를 매긴다. 
-- 사원테이블에서 80번 부서에 소속된 사원 중에서 급여를 가장 많이 받는 순으로 
-- 사원번호, 사원명, 급여, 순위를 부여하여 출력해 주세요.
select employee_id as 사원번호, first_name as 사원명, salary as 급여,
row_number() over(order by salary desc) as 순위
from employees
where department_id = 60;




--------------partition by 
-- group by 으로 묶지 않고, 조회된 각 행에 그룹으로 집계된 값을 표시할 때 사용 

-- 부서번호가 10~30 인 부서들의 부서번호, 부서별 급여의 합 출력
select department_id, sum(salary)
from employees
where department_id between 10 and 30
group by department_id
order by department_id; 




select department_id, sum(salary)

where department_id between 10 and 30




    select * from employees;

-- 부서번호가 10~30인 부서의 부서번호와 사원명, 부서별 급여의 합 
select department_id, first_name, sum(salary) over(partition by department_id) as salary_total
from employees
where department_id between 10 and 30
order by department_id; 


select department_id, first_name, salary, 
sum(salary) over(partition by department_id) as department_total, 
sum(salary) over() as salary_total

from employees
where department_id between 10 and 30
order by department_id;


-- 각 부서별 한명의 사원만을 출력하고자 한다. 이때 사원번호, 사원명, 직무번호, 급여, 부서번호를 출력하라. 

-- 우선 각 부서별로 순위 매기기. 
select employee_id, 
        first_name, 
        job_id, 
        salary, 
        department_id, 
        row_number() over(partition by department_id order by employee_id) as rnum      -- 부서별로 순위 매길건데 '사원번호 내림차순'으로 매기겠다 
from employees
order by department_id; 

-- 그 중 1위만 출력. 
select employee_id, first_name, department_id, hire_date
from ( select
                 row_number() over(partition by department_id order by employee_id) as rnum,
                 employee_id, first_name, department_id, hire_date
            from employees
        ) data
where data.rnum = 1;



