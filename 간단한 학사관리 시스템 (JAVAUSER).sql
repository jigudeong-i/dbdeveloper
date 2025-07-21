
select no, s_num, s_name
from subject
order by no; 

select NVL(to_char(max(s_num) + 1, 'FM00'), '01') as subjectNum   -- NVL : 괄호 안이 null 이면 01을 주겠다.
from subject