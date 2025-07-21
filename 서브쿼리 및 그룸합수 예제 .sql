
-- 1. EMPLOYEES 테이블에서 가장 많은 사원이 속해있는 부서번호와 사원수를 출력하라.

select department_id 부서번호, count(*) 사원수
from employees 
group by department_id                                   -- 그룹 함수를 쓰면 where가 아닌 having을 써야한다. 
having count(*) = (select max(count(*))              
                        from employees
                        group by department_id);

-- 이해하려면.. 아래 두개를 먼저 출력해봐 
    select department_id 부서번호, count(*) 사원수
    from employees 
    group by department_id; 

    select max(count(*))              
    from employees
    group by department_id;                     




-- 2. EMPLOYEES 테이블에서 부서별 최고 급여를 받는 직원의 이름, 직급, 부서번호, 급여를 출력하라.​

SELECT first_name, job_id, department_id, salary
FROM employees e
WHERE salary = (  SELECT MAX(salary)
                          FROM employees
                         WHERE department_id = e.department_id)
ORDER BY department_id;



-- 3. EMPLOYEES 테이블에서 각 부서별 입사일이 가장 오래된 사원의 사원번호, 사원명, 부서번호, 입사일을 출력하라. 
-- 단 부서번호가 NULL은 제외한다

-- 문제점은 가진 쿼리문
SELECT employee_id, first_name, department_id, TO_CHAR(hire_date, 'YYYY-MM-DD') AS hire_date
FROM employees e
WHERE hire_date = (
                    SELECT MIN(hire_date)
                    FROM employees
                    WHERE department_id = e.department_id
                    )
ORDER BY department_id;

SELECT EMPLOYEE_ID, FIRST_NAME, DEPARTMENT_ID, 
TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') HIRE_DATE
FROM EMPLOYEES
WHERE (DEPARTMENT_ID, HIRE_DATE) IN (SELECT DEPARTMENT_ID, MIN(HIRE_DATE)
                                    FROM EMPLOYEES 
                                    GROUP BY DEPARTMENT_ID) 



-- 4. 2001년~2005년 사이에 입사한 사원들에 대해 각 부서별 사원수를 부서번호, 부서명, 
-- 2001년입사인원수, 2002년입사인원수, 2003년입사인원수, 2004년입사인원수, 2005년입사인원수로 출력하라.













