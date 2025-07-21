
-------------------1. Sales 부서 소속 사원의 이름과 입사일을 출력하라 
-- 오라클 전용 SQL 
select first_name, hire_date
from employees E, departments D
where E.department_id = D.department_id and department_name = 'Sales';

-- ANSI 표준 SQL
select first_name, hire_date
from employees E inner join departments D
on E.department_id = D.department_id
where department_name = 'Sales';

    select * from subject order by no;



-------------------2. 커미션을 받는 사원이 이름, 커미션 비율과 그가 속한 부서명을 출력하라. 
select first_name, commission_pct, department_name
from employees E left outer join departments D 
on E.department_id = D.department_id
where commission_pct is not null;



--------------------3. it 부서에서 근무하고 있는 사원번호, 이름, 업무, 부서명을 출력하라. 
select employee_id, last_name, first_name, job_id, department_name
from departments D inner join employees E
on D.department_id = E.department_id
where department_name = 'IT';




---------------------4. Guy와 동일한 부서에서 근무하는 동료들의 이름과 부서번호를 출력하라. 




----------------------5. employees, departments, locations 테이블의 구조를 파악한 후 oxford에 근무하는 사원의 성과 이름(Name으로 별칭) 
-- , 업무id, 부서명, 도시명을 출력하시오








