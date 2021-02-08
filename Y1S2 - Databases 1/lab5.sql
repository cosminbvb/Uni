--0 a)
select last_name, salary, department_id
from employees e
where salary>(select avg(salary) from employees where department_id=e.department_id);

--0 b)
select last_name, salary, e.department_id, department_name, Salariu_Mediu, Nr_Ang
from employees e, departments d, (select department_id, round(avg(salary)) Salariu_Mediu, count(*)Nr_Ang
from employees group by department_id)x
where e.department_id=d.department_id and d.department_id=x.department_id and
salary>(select avg(salary) from employees where department_id=e.department_id);

--sau
select last_name, salary, e.department_id, department_name, 
(select round(avg(salary)) from employees where department_id=e.department_id),
(select count(*) from employees where department_id=e.department_id)
from employees e join departments d on(e.department_id=d.department_id)
where salary>(select avg(salary) from employees where department_id=e.department_id);

--1
select last_name, salary 
from employees
where salary > ALL(select round(avg(salary)) from employees group by department_id);

--sau

select last_name, salary
from employees
where salary > (select max(avg(salary)) from employees group by department_id);

--2
select last_name, salary
from employees e
where salary=(select min(salary)from employees where department_id=e.department_id);

select last_name, salary, department_id
from employees
where (department_id, salary) in (select department_id, min(salary) from employees group by department_id);

--3
select last_name, salary 
from employees
where department_id in (select department_id from employees where salary=(select max(salary)
from employees 
where department_id=30) and department_id!=30);

--sau

select last_name, salary
from employees e
where exists(select 1 from employees where e.department_id=department_id and
salary=(select max(salary) from employees where department_id=30) and department_id!=30);


--4
--sol1: subcerere sincronizata
--numaram cate salarii sunt mai mari fata de salariul pe care il avem pe linia curenta
select last_name, salary
from(select last_name, salary 
     from employees
     order by salary desc) e 
     where 3>(select count(salary) 
              from employees
              where salary>e.salary) and rownum<=3;


--sol2: vezi analiza top-n
select last_name, salary
from employees
where rownum<=3
order by salary desc;
--e gresit deoarece se executa mai intai where, dupa ordonarea

select last_name, salary 
from(select last_name, salary
     from employees
     order by salary desc)
where rownum<=3;

--5
select employee_id, last_name, first_name
from employees
where employee_id in (select manager_id from employees group by manager_id having count(employee_id)>=2);

--6
select location_id 
from locations
where location_id in(select location_id from departments)
order by location_id desc;
--sau
select distinct location_id from departments
order by location_id desc;
--sau
select location_id
from locations loc
where exists (select null from departments where loc.location_id=location_id);

--7
select department_id, department_name
from departments
where department_id not in (select nvl(department_id,0)
                            from employees 
                            group by department_id);
--sau
select department_id
from departments
minus
select department_id
from employees 
group by department_id;
--sau
SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (SELECT 'x'
FROM employees
WHERE department_id = d.department_id);

--8
with  val_dep as(select department_name, sum(salary) as total
                 from departments d join employees e on(d.department_id=e.department_id)
                 group by department_name),
      val_medie as(select sum(total)/count(*) as medie from val_dep)
select* 
from val_dep
where total>(select medie from val_medie)
order by department_name;

--9
--angajatii condusi de king 
with king_sub as
(select employee_id, first_name, last_name, hire_date
from employees
where manager_id=(select employee_id from employees where initcap(first_name)='Steven' and initcap(last_name)='King')
and to_char(hire_date, 'yyyy') != '1970'
order by hire_date),
    dates as --grupari in functie de data
    (select hire_date
    from king_sub
    group by hire_date),
    oldest as --cea mai veche data de angajare
    (select hire_date  from dates where rownum=1)
select * from king_sub where hire_date=(select hire_date from oldest);

--10
with best_paid as
(select * from employees 
 order by salary desc)
 select * 
 from best_paid 
 where rownum<=10;
 
 --11
select unique 'Departamentul ' || d.department_name || ' este condus de ' || nvl(to_char(d.manager_id), 'nimeni') || ' si ' ||
nvl2(to_char(salariati), 'are numarul de salariati ' || to_char(salariati), 'nu are salariati')
from departments d, employees e, (select count(em.employee_id) salariati, dep.department_id
                                  from employees em join departments dep on(dep.department_id = em.department_id)
                                  group by dep.department_id) c
where d.department_id = e.department_id(+)
      and c.department_id(+) = d.department_id;
      
--12
select last_name, first_name, decode(length(last_name),length(first_name),'same',length(last_name)) as Length
from employees;

--13
select last_name, hire_date, salary,
case to_char(hire_date,'YYYY')
    when '1989' then salary*1.20
    when '1990' then salary*1.15
    when '1991' then salary*1.10
    else salary
end "Salariu marit"
from employees;

--sau

select last_name, hire_date, salary,
decode(to_char(hire_date,'YYYY'),'1989', salary*1.20,
'1990', salary* 1.15, '1991', salary*1.10, salary) "Salariu marit"
from employees;

--14 a)
select job_title,sum(salary)
from employees e join jobs j using(job_id)
where upper(j.job_title) like 'S%'
group by job_title;


