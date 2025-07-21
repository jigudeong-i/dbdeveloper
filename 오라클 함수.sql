








------------- 6. 일반함수 

-- NVL
select first_name, salary, nvl(commission_pct, 0), job_id 
from employees
order by job_id;


-- NVL2
select first_name, salary, commission_pct,
nvl2(commission_pct, salary + (salary * commission_pct), salary) total_sal
from employees;


-- <문제>모든 직원은 자신의 상관(MANAGER_ID)이 있다. 하지만 EMPLOYEES 테이블에 유일하게 
-- 상관이 없는 사원이 있는데 그 사람의 MANAGER_ID 칼럼 값을 CEO로 출력하라. 
select employee_id, first_name, manager_id
from employees
where manager_id is null;

-- manager_id 컬럼의 값을 0으로 치환
select employee_id, first_name, nvl(manager_id, 0)
from employees
where manager_id is null;

-- manager_id 컬럼의 값을 'ceo'로 치환 
select employee_id, first_name, nvl(manager_id, 'ceo')
from employees
where manager_id is null;           -- 오류 (타입이 맞아야 대체가 가능하다)

select employee_id, first_name, nvl(to_char (manager_id), 'ceo')
from employees
where manager_id is null;           -- 성공


-- <문제> 커미션 정보가 없는 직원들도 있는데 커미션이 없는 직원 그룹은 '<커미션 없음>'이 출력되게 한다. 
select employee_id, first_name, nvl(to_char (commission_pct), '<커미션 없음>')
from employees;




---------------------------- DECODE ------------------------------
SELECT DEPARTMENT_ID, DECODE(DEPARTMENT_ID, 10, 'Administration', 
                                                                      20, 'Marketing', 
                                                                      30, 'Purchasing', 
                                                                      40, 'Human Resources', 
                                                                      50, 'Shipping', 
                                                                      60, 'IT' ) AS DEPARTMENTS 
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID;




---------------------------- CASE -------------------------------------
SELECT FIRST_NAME, DEPARTMENT_ID,
          CASE  WHEN DEPARTMENT_ID=10 THEN 'Administration' 
                   WHEN DEPARTMENT_ID=20 THEN 'Marketing' 
                   WHEN DEPARTMENT_ID=30 THEN 'Purchasing' 
                   WHEN DEPARTMENT_ID=40 THEN 'Human Resources'
                   WHEN DEPARTMENT_ID=50 THEN 'Shipping'
                   WHEN DEPARTMENT_ID=60 THEN 'IT'
             END DEPARTMENT_NAME
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID;

-- <문제> 부서별에 따라 급여를 인상하자. (직원번호, 직원명, 직급, 급여)
-- 부서명이 'Marketing'인 직원은 5%, 'Purchasing'인 사원은 10%, 
-- 'Human Resources'인 사원은 15%, 'IT'인 직원은 20%인 인상한다.

SELECT employee_id, first_name, job_id, E.department_id, department_name, salary,
    CASE WHEN DEPARTMENT_NAME = 'Marketing' THEN SALARY * 1.05
            WHEN DEPARTMENT_NAME = 'purchasing' THEN SALARY * 1.1
            WHEN DEPARTMENT_NAME = 'human resources' THEN SALARY * 1.15
            WHEN DEPARTMENT_NAME = 'IT' THEN SALARY * 1.2
            else salary
        end upsalary
from employees E inner join departments D
on E.department_id = d.department_id
order by E.department_id;
        
        
select first_name, department_name 
from employees E inner join departments D
on E.department_id = D.department_id ;






