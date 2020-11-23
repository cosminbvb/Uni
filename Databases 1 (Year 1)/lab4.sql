create table grupare (id number(5) not null,
                      nume varchar2(10) not null,
                      salariu number(10) not null,
                      manager_id number(5) not null);
                      
select * from grupare;

insert into grupare values (1, 'user1', 1000, 1);

insert into grupare values (2, 'user2', 1400, 1);

insert into grupare values (3, 'user3', 700, 2);

insert into grupare values (4, 'user4', 300, 2);

insert into grupare values (5, 'user5', 1600, 2);

insert into grupare values (6, 'user6', 1200, 2);

commit;

--exemplu folosind clauza where
select *
from grupare
where salariu < 1100;

--exemplu folosind where si grupare
select manager_id, salariu
from grupare
where salariu < 1100
group by manager_id, salariu;

--exemplu folosind where, iar gruparea realizata doar dupa coloana manager_id
select manager_id
from grupare
where salariu < 1100
group by manager_id;

--exemplu folosind having
select max(salariu)
from grupare
having max(salariu) < 10000;

--group by si having
select manager_id, min(salariu)
from grupare
group by manager_id
having min(salariu) <= 1000;

drop table grupare;

--2 
select max(salary) "Maxim", min(salary) "Minim", sum(salary) "Suma", floor(avg(salary)) "Media"
from employees;

--3
select job_id, max(salary) "Maxim", min(salary) "Minim", sum(salary) "Suma", floor(avg(salary)) "Media"
from employees
group by job_id;

--4
select count(department_id), department_id
from employees
group by department_id;

--5
select count(distinct manager_id) "Nr. Manageri"
from employees;

--6
select max(salary)-min(salary) "Diferenta" from employees;

--7
select d.department_name, d.location_id, count(e.employee_id), floor(avg(e.salary))
from employees e join departments d using(department_id)
group by d.department_name, d.location_id;

--8
select employee_id, last_name 
from employees
where salary>(select avg(salary) from employees)
order by salary desc;

--9
select distinct e.manager_id, e.salary
from employees e
where e.salary=(select min(salary) from employees where e.manager_id=manager_id having min(salary)>1000)
order by e.salary desc;

--10
select d.department_id, d.department_name, max(e.salary)
from employees e join departments d on(e.department_id=d.department_id)
group by d.department_id, d.department_name
having max(e.salary)>3000;

--11
select min(avg(salary))
from employees
group by job_id;

--12
select max(avg(salary))
from employees 
group by department_id;

--13
select j.job_id, job_title, avg(salary)
from employees e join jobs j on(e.job_id=j.job_id)
group by j.job_id, job_title
having avg(salary)=(select min(avg(salary)) from employees group by job_id);

--14
select avg(salary)
from employees
having avg(salary)>2500;

--15
select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
order by department_id;

--16 a)
select department_id, department_name, count(employee_id)
from employees e join departments using(department_id)
group by department_id, department_name
having count(employee_id)<4;

--16 b)
select department_id, department_name, count(employee_id)
from employees e join departments using(department_id)
group by department_id, department_name
having count(employee_id)=(select max(count(employee_id)) from employees group by department_id);

--17
select last_name, hire_date
from employees
where to_char(hire_date, 'DD')=(select to_char(hire_date, 'DD')
from employees
group by to_char(hire_date, 'DD')
having count(employee_id)=(select max(count(employee_id)) from employees group by to_char(hire_date, 'DD'))
);

--18
select count(count(employee_id))
from employees
group by(department_id)
having count(employee_id)>=15;

--19
select department_id, sum(salary)
from employees
group by department_id
having count(employee_id)>10 and department_id!=30;

--20
select employee_id, count(job_id)
from job_history
group by employee_id
having count(job_id) >= 2;

--21
select avg(nvl(commission_pct,0)) from employees;

--22
select job_id, sum(decode(department_id,30,salary))Dep30,
sum(decode(department_id,50,salary))Dep50,
sum(decode(department_id,80,salary))Dep80,
sum(salary)Total
from employees
group by job_id;

--sau

SELECT job_id, (SELECT SUM(salary)
 FROM employees
 WHERE department_id = 30
 AND job_id = e.job_id) Dep30,
 (SELECT SUM(salary)
 FROM employees
 WHERE department_id = 50
 AND job_id = e.job_id) Dep50,
 (SELECT SUM(salary)
 FROM employees
 WHERE department_id = 80
 AND job_id = e.job_id) Dep80,
 SUM(salary) Total
FROM employees e
GROUP BY job_id;

--23

select count(employee_id), count(decode(to_char(hire_date,'YYYY'),'1997',hire_date)) "1997",
count(decode(to_char(hire_date,'YYYY'),'1998',hire_date)) "1998",
count(decode(to_char(hire_date,'YYYY'),'1999',hire_date)) "1999",
count(decode(to_char(hire_date,'YYYY'),'2000',hire_date)) "2000"
from employees;

--24
select d.department_id, department_name, sum(salary)
from employees e join departments d on(d.department_id=e.department_id)
group by d.department_id, department_name;

select a.department_id, department_name, a.suma
from departments d,(select department_id, sum(salary) suma from employees group by department_id)a
where d.department_id=a.department_id;

--25
select last_name, salary, department_id, SalariuMediu
from employees join (select round(avg(salary)) SalariuMediu, department_id from employees group by department_id)
using (department_id);

--26
select last_name, salary, department_id, SalariuMediu, NrAng
from employees join (select round(avg(salary)) SalariuMediu, department_id, count(employee_id) NrAng from employees group by department_id)
using (department_id);