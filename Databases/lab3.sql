--1
select e.first_name, e.last_name, to_char(e.hire_date,'MONTH/YYYY')
from employees e, employees g
where g.department_id=e.department_id and initcap(g.last_name) = 'Gates' and lower(e.last_name) like '%a%'
      and initcap(e.last_name) != 'Gates';

--sau 

select e.first_name, e.last_name, to_char(e.hire_date,'MONTH/YYYY')
from employees e join employees g on (g.department_id=e.department_id)
where initcap(g.last_name) = 'Gates' and lower(e.last_name) like '%a%'
      and initcap(e.last_name) != 'Gates';
      
--2
select e.employee_id, e.last_name, d.department_id, d.department_name
from employees e join employees t on(e.department_id=t.department_id)
                 join departments d on(e.department_id=d.department_id)
where lower(t.last_name) like '%t';

--3 
select e.last_name, e.salary, job_title, city, country_name, k.last_name
from employees e join employees k on (e.manager_id = k.employee_id)
                 join jobs j on (e.job_id = j.job_id)
                 join departments d on (e.department_id = d.department_id)
                 join locations l on (d.location_id = l.location_id)
                 join countries c on (l.country_id = c.country_id)
where initcap(k.last_name) like 'King';

--4
select e.department_id, d.department_name, e.last_name, e.job_id , to_char(e.salary,'$99,999.00')
from employees e join departments d on(e.department_id=d.department_id)
where lower(d.department_name) like '%ti%'
order by department_name, last_name;

--6
select department_id 
from departments 
where lower(department_name) like '%re%'
union
select department_id 
from employees
where upper(job_id)='SA_REP';

--sau

select distinct d.department_id
from employees e full join departments d on (e.department_id = d.department_id)
where lower(department_name) like '%re%' or upper(job_id) like '%SA_REP%'
order by 1;

--8
select department_id 
from departments 
minus
select department_id
from employees;

--sau 

select d.department_id -- pentru ca in d - department_id este cheie primara si nu poate fi null
from employees e right join departments d on (e.department_id = d.department_id)
where employee_id is null;

--9 
select department_id "cod departament"
from employees
where upper(job_id)='HR_REP'
intersect
select department_id
from departments
where lower(department_name) like '%re%'; 

--10
select last_name, hire_date
from employees
where hire_date>(select hire_date from employees where initcap(last_name)='Gates');

--11
select last_name, salary 
from employees 
where department_id=(select department_id from employees where initcap(last_name)='Gates') and initcap(last_name)!='Gates';

--12 
select last_name, salary 
from employees
where manager_id=(select employee_id from employees where manager_id is null);

--13
select last_name, department_id, salary
from employees
where (department_id, salary) in (select department_id, salary from employees where commission_pct is not null);

--14
select employee_id, last_name, salary
from employees
where salary>(select avg(salary) from employees);

--15
select last_name
from employees 
where salary+salary*nvl(commission_pct,0)>(select max(salary+salary*nvl(commission_pct,0)) from employees where upper(job_id) like '%CLERK%');

--16
select last_name, department_name, salary 
from employees e join departments d on(e.department_id=d.department_id)
where e.commission_pct is null and e.manager_id in (select employee_id from employees where commission_pct is not null);

--17
select last_name, department_id, salary, job_id
from employees 
where (commission_pct, salary) in 
(select commission_pct, salary from employees e join departments d on(e.department_id = d.department_id)
join locations l on(l.location_id = d.location_id) where initcap(l.city)='Oxford');

--18
select last_name, e.department_id, job_id
from employees e join departments d on(e.department_id=d.department_id) 
join locations l on(d.location_id=l.location_id)
where initcap(l.city)='Toronto';