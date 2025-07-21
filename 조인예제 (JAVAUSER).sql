
--------------1. 학번, 학생명과 학과번호, 학과명을 출력하도록 쿼리문을 작성
select sd_num 학번, sd_num 학생명, st.s_num 학과번호, s_name 학과명
from subject sb inner join student st
on sb.s_num = st.s_num;

select sd_num 학번, sd_num 학생명, s_num 학과번호, s_name 학과명
from subject sb join student st
using(s_num);       -- 칼럼명이 같을 때 



------------ 2. 우리 학교 전체 학과명과 그 학과에 소속된 학생명, 아이디를 출력하시오
select sb.s_num, s_name 학과명, sd_name 학생명, sd_id 아이디
from subject sb left outer join student st
on sb.s_num = st.s_num
order by sb.s_num;



-------------3.1. 수강 테이블(enrollment)에서 수강 신청한 학생명, 과목명, 등록일(2018.12.28 형태)을 출력하시오.
select sd_name 학생명, c_name 과목명, to_char(e_date, 'YYYY.MM.DD') 수강신청일
from enrollment en, student st, course co
where en.sd_num = st.sd_num and en.c_num = co.c_num;

select sd_name 학생명, c_name 과목명, to_char(e_date, 'YYYY.MM.DD') 수강신청일 
from enrollment en inner join student st on en.sd_num = st.sd_num
                        inner join course co on en.c_num = co.c_num; 
                        
                        
                        
--------------3.2. 위의 쿼리문에서 수강신청한 학생의 학과명, 학번, 학생명, 과목명,수강신청일(2018.12.28형태)을 출력하시오. 
select s_name 학과명, st.sd_num 학번, sd_name 학생명, c_name 과목명, to_char(e_date, 'YYYY.MM.DD') 수강신청일 
from subject su inner join student st on su.s_num = st.s_num
                      inner join enrollment en on en.sd_num = st.sd_num
                      inner join course co on en.c_num = co.c_num;
                      
                      
                      
---------------4. 학과에 소속된 학생 수를 출력하도록 쿼리문 작성.

select s_name 학과명, count(sd_name) 학생수
from student st inner join subject sb
on st.s_num = sb.s_num
group by s_name, sb.s_num
order by sb.s_num;

    select * from student;


---------------5. 전체 학과명(학생이 존재하지 않는 학과)을 기준으로 소속된 학생 수를 출력하도록 쿼리문 작성. 

select s_name 학과명, count(sd_num) 학생수
from subject left outer join student
using(s_num)
group by s_name, s_num
order by s_num; 

select * from subject;
select * from student;
select * from course;
select * from enrollment;









             
               