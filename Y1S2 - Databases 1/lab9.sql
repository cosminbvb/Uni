--1
create or replace view viz_emp30_cpe as
(select employee_id, last_name, email, salary from emp_cpe where department_id=30);

select * from viz_emp30_cpe;

insert into viz_emp30_cpe
values(559,'last_name','eemail',10000);--cannot insert NULL into ("GRUPA43"."EMP_PNU"."HIRE_DATE")

drop view viz_emp30_cpe;

--2
desc emp_cpe;
create or replace view viz_emp30_cpe as
(select employee_id,last_name,email,salary,hire_date,job_id,department_id from emp_cpe where department_id=30);

desc viz_emp30_cpe;

insert into viz_emp30_cpe 
values(601,'last_name','eemail',10000,sysdate,'IT_PROG',30);

select*from emp_cpe;

UPDATE viz_emp30_cpe
SET hire_date = hire_date-15
WHERE employee_id = 601;

select*from emp_cpe;

delete from viz_emp30_cpe
where employee_id=601;

commit;

--3 
create or replace view viz_empsal50_cpe as
(select employee_id, last_name, email, job_id, hire_date, salary*12 sal_anual 
from emp_cpe where department_id=50);

--4 a)
select * from emp_cpe;
INSERT INTO VIZ_EMPSAL50_CPE(employee_id, last_name, email, job_id, hire_date)
       VALUES(567, 'last_name', 'email000', 'IT_PROG', sysdate);
select * from emp_cpe;

--4 b)
select * from user_updatable_columns where lower(table_name)='viz_empsal50_cpe';

--5 a)
create or replace view viz_emp_dep30_cpe as
(select v.*, d.department_name from viz_emp30_cpe v join departments d on(d.department_id=v.department_id));

--5 b)
INSERT INTO VIZ_EMP_DEP30_CPE(employee_id,last_name,email,salary,job_id,hire_date,department_id)
       VALUES (358, 'lname', 'email', 15000, 'IT_PROG', sysdate, 30);
       
--5 c)
select * 
from USER_UPDATABLE_COLUMNS
where table_name = 'VIZ_EMP_DEP30_CPE';

--5 d)
DELETE FROM VIZ_EMP_DEP30_CPE WHERE employee_id = 358;

--6
create or replace view viz_dept_sum_cpe as
(select department_id, min(salary) min_sal, max(salary) max_sal, avg(salary) med_sal from employees right join
departments using(department_id) group by department_id);

select * from viz_dept_sum_cpe;

--7
CREATE OR REPLACE VIEW VIZ_EMP30_CPE AS
    (SELECT employee_id, last_name, email, salary, hire_date, job_id, department_id
     FROM emp_pnu
     WHERE department_id = 30)
WITH READ ONLY CONSTRAINT verific;

INSERT INTO VIZ_EMP30_CPE
VALUES(600, 'last_name', 'eemail', 10000, SYSDATE, 'IT_PROG', 50);
-- cannot perform a DML operation on a read-only view

--8
select view_name, text from user_views where view_name like '%CPE';

--9
select last_name, salary, department_id, 
(select max(salary) from employees where department_id=e.department_id) max_salary from employees e;


--10
create or replace view viz_sal_cpe as
(select last_name, department_name, salary, city from
employees join departments using(department_id) join locations using(location_id));

select * from viz_sal_cpe;

--11
alter table emp_cpe
add constraint ck_name_emp_cpe
check(upper(last_name) not like 'WX%');

--12
create sequence seq_dept_cpe 
increment by 10
start with 400
maxvalue 10000
nocycle
nocache;

select * from dept_cpe;

insert into dept_cpe
values(seq_dept_cpe.nextval,'DeptNou',null,null);

select * from dept_cpe;

delete from dept_cpe
where department_id=seq_dept_cpe.currval; --nu merge in delete

delete from dept_cpe
where department_id=400;

commit;

drop sequence seq_dept_cpe;