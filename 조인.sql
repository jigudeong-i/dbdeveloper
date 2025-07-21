

select employee_id, first_name, department_id
from employees;

select department_id, department_name
from departments;





---------------------------------------------------Equi Join(Inner Join) ---------------------------------------------------- 
-- select 컬럼 from 테이블명, 테이블명 where join 조건문.

select first_name, department_name  -- department_id  넣으면 오류 : 왜냐면 department_id가 두 갠데 어떤 걸 원하는데?
from employees, departments                                 -- 이럴때는 테이블명, 컬럼 또는 테이블 별칭. 컬럼으로 명시
where employees.department_id = departments.department_id;

    select * from employees;
    select * from departments;

select first_name, department_name, employees.department_id
from employees, departments  
where employees.department_id = departments.department_id;

-- 테이블명을 간단한 별칭으로 접근하기
select first_name, department_name, E.department_id
from employees E, departments D  
where E.department_id = D.department_id;

select first_name, department_name, hire_date              
from employees E, departments D
where E.department_id = D.department_id and E.first_name = 'Susan';


-- 사원명, 직무ID, 직무명(JOB_TITLE), 부서번호, 부서명을 출력하라
-- 사원테이블과 직무 테이블 => 공통 컬럼 : job_id
-- 사원테이블과 부서테이블 => 공통 컬럼 : department_id

select E.first_name, E.job_id, J.job_title, E.department_id, D.department_name              -- 앞에서 별칭 설정해서 뒤로는 써줘야 한다. 
from employees E, departments D, jobs J
where J.job_id = E.job_id and E.department_id = D.department_id ;

select * from departments;
select * from employees;
select * from jobs;






------------------------------------------------------- Non-Equi Join----------------------------------------------------
create table salarygrade(
    grade number, 
    minsalary number,
    maxsalary number
);
insert into salarygrade (grade, minsalary, maxsalary) values (1, 2000, 3000);
insert into salarygrade (grade, minsalary, maxsalary) values (2, 3001, 4500);
insert into salarygrade (grade, minsalary, maxsalary) values (3, 4501, 6000);
insert into salarygrade (grade, minsalary, maxsalary) values (4, 6001, 8000);
insert into salarygrade (grade, minsalary, maxsalary) values (5, 8001, 10000);
insert into salarygrade (grade, minsalary, maxsalary) values (6, 10001,13000);
insert into salarygrade (grade, minsalary, maxsalary) values (7, 13001, 20000);
insert into salarygrade (grade, minsalary, maxsalary) values (8, 20001, 30000);
    
select E.first_name, E.salary, S.grade
from employees E, salarygrade S
where E.salary between S.minsalary and S.maxsalary;          

select E.first_name, E.salary, S.grade
from employees E, salarygrade S
where E.salary >= S.minsalary and E.salary <= S.maxsalary;

    select * from salarygrade;
    select * from Employees;



---------------------------------------------------------Outer Join ---------------------------------------------------------
-- 조인 조건에 불만족하는 행들도 나타내기 위해 사용. 조인 조건에서 정보가 부족한 컬럼명 뒤에 ‘+’ 를 붙인다. 

select E.first_name, D.department_id, D.department_name
from employees E, departments D
where E.department_id = D.department_id
order by D.department_id;          -- 오름차순 정렬

    select * from departments;
    select * from employees;

select E.first_name, D.department_id, D.department_name
from employees E, departments D
where E.department_id(+) = D.department_id; 

-- + 기호 위치를 바꾸면??
select E.first_name, D.department_id, D.department_name
from employees E, departments D
where E.department_id = D.department_id(+); 


--예제 : 2007년도 상반기에 입사한 사원의 사원번호, 사원명, 입사일, 부서명을 구해보자.
--(결과 행의 수 : 12) null 사원 포함
select employee_id, first_name, hire_date, department_id
from employees
where hire_date >= '2007/01/01' and hire_date <= '2007/06/30';

-- 2007년도 상반기에 입사한 사원의 사원번호, 이름, 입사일, 부서명을 출력
-- (결과 행의 수 : 11)  null 사원 제외됨. 그러니 inner join 말고 outer join 을 써야됨) 
select employee_id, first_name, hire_date, D.department_name
from employees E, departments D
where E.department_id = D.department_id 
    and hire_date between '2007/01/01' and '2007/06/30';

-- outer join 를 써서 보면 행 12줄. 
select employee_id, first_name, hire_date, D.department_name
from employees E, departments D
where E.department_id = D.department_id(+)
    and hire_date between '2007/01/01' and '2007/06/30';





--------------------------------------------------------Self Join---------------------------------------------------------

-- 사원 테이블
select employee_id, first_name, manager_id
from employees;

-- 관리자 테이블 
select employee_id, first_name
from employees order by employee_id;

-- employees 테이블에 별칭을 부여하여 하나의 테이블을 두 개의 테이블인 것처럼 사용해보자.
-- 사원테이블과 매니저 테이블을 work, manager로 별칭 부여 

    select * from employees;

select work.first_name 사원명, manager.first_name 매니저명
from employees work, employees manager
where work.manager_id = manager.employee_id                                 -- 이해 안됨 
order by work.employee_id;

select work.first_name | | '의 매니저는 ' | | manager.first_name | | '이다.'      
as "그 사원의 매니저"
from employees work, employees manager
where work.manager_id = manager.employee_id; 






-------------------------------------------------------ANSI join --------------------------------------------------------------
-- select 컬럼, 컬럼
-- from 테이블1 inner join 테이블2
-- on 테이블1.공통칼럼 = 테이블2.공통컬럼
-- where 조건절; 

select first_name, department_name 
from employees inner join departments    -- '두 테이블을 특정 조건에 따라 연결하겠다'
on employees.department_id = departments.department_id;  -- '직원테이블 부서번호와 부서테이블 부서번호가 같은 경우에만 데이터를 연결해서 보여줘'

    select * from employees;
    select * from departments;

-- join만 작성 시 기본값은 inner join
select first_name, department_name, employees.department_id
from employees join departments
on employees.department_id = departments.department_id;



-------------------------ANSI Inner Join
-- select 컬럼, 컬럼
-- from 테이블1 inner join 테이블2 on 테이블1.공통컬럼 = 테이블2.공통컬럼
--                    inner join 테이블3 on 테이블1.공통컬럼 = 테이블3.공통컬럼
-- where 조건절;

select E.first_name, E.job_id, J.job_title, E.department_id, d.department_name
from employees E inner join jobs J on J.job_id = E.job_id
                         inner join departments D on E.department_id = D.department_id;
                        
        
-- 조인의 조건과 데이터 검색을 위한 조건 부여 
select first_name, department_name
from employees inner join departments
on employees.department_id = departments.department_id
where first_name = 'Susan';

-- 연결에 사용하려는 컬럼 명이 같은 경우 using 사용 (다른 경우엔 on 사용) 
select first_name, department_name, department_id
from employees inner join departments
using(department_id);        -- '이걸 공통으로 하여 연결하겠습니다'

select first_name, department_name, employees.department_id  -- 에러 : using을 쓰면 공통 컬럼은 하나로 합쳐지기에 테이블명을 따로 붙일 수 없음
from employees inner join departments
using(department_id);



---------------------------- ANSI Outer join 
-- "한쪽 테이블은 전부 다 나오게 하고, 다른 쪽 테이블은 조건에 맞는 것만 붙이겠다"
-- (전체 데이터를 가져올 테이블을 기준으로 left, right를 명시해준다)
-- select 컬럼명
-- from 테이블1 left/right/full outer join 테이블2
-- on 조인 조건. 

select E.first_name, D.department_id, D.department_name
from employees E right outer join departments D              -- right, left 바꿔보기 
on E.department_id = D.department_id; 

    select department_id from employees;
    select department_id from departments;


-- on으로 조건절 명시
select E.first_name, D.department_id, D.department_name
from departments D left outer join employees E
on E.department_id = D.department_id;

-- using으로 조건절 명시 
select employee_id, first_name, hire_date, D.department_name
from employees E left outer join departments D
on e.department_id = D.department_id
where hire_date >= '2007/01/01' and hire_date <= '2007/06/30';

-- 2007년 상반기에 입력한 사원번호, 사원명, 입사일, 부서명을 출력해 주세요. 
select employee_id, first_name, hire_date, D.department_name
from employees E left outer join departments D
on E.department_id = D.department_id 
where hire_date between '2007/01/01' and '2007/06/30'; 


    commit;




