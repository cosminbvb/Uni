--1
create table EMP_CPE as 
select  * from employees;

create table DEPT_CPE as 
select * from departments;

--2
desc employees;
desc EMP_CPE;

--3
select * from EMP_CPE;

--4
select * from user_constraints 
where upper(table_name)='EMP_CPE';
select * from user_constraints 
where upper(table_name)='EMPLOYEES';

alter table EMP_CPE 
add constraint pk_emp_cpe primary key(employee_id);

alter table DEPT_CPE
add constraint pk_dept_cpe primary key(department_id);

alter table EMP_CPE
add constraint fk_emp_dept_cpe foreign key (department_id) references DEPT_CPE(department_id);

alter table EMP_CPE
add constraint fk_emp_sef_cpe foreign key(manager_id) references EMP_CPE(employee_id);

alter table DEPT_CPE
add constraint fk_dept_sef_cpe foreign key(manager_id) references EMP_CPE(employee_id);

--5
INSERT INTO DEPT_pnu (department_id, department_name)
VALUES (302, 'Programare');
commit;

--6
insert into EMP_CPE 
values (302, NULL, 'nume302', 'email302', NULL, SYSDATE, 'IT_PROG', NULL, NULL, NULL, NULL);
commit;

select * from emp_cpe
where employee_id=302;

--7
INSERT INTO emp_pnu (hire_date, job_id, employee_id, last_name, email, department_id)
       VALUES (sysdate, 'sa_man', 279, 'nume_279', 'email_279', 300);
commit;

--8
INSERT INTO (SELECT employee_id, last_name, hire_date, job_id, email
 FROM emp_pnu)
 VALUES ( (SELECT max(employee_id) + 1
 FROM emp_pnu
 ), 'nume_nou', sysdate, 'sa_man', 'email@pnu.com'
 );

SELECT * FROM emp_pnu;

rollback;

--9
desc employees;
create table EMP1_CPE
     (employee_id number(6) not null,
      first_name varchar2(20),
      last_name varchar2(20) not null,
      email varchar2(25) not null,
      phone_number varchar2(20),
      hire_date date not null,
      job_id varchar2(10) not null,
      salary number(8,2),
      commission_pct number(2,2),
      manager_id number(6),
      department_id number(4),
      primary key(employee_id)
      );
insert into emp1_cpe
(select * from employees where commission_pct>0.25);
rollback;

--10
INSERT INTO emp_cpe
 (SELECT 0,USER,USER, 'TOTAL', 'TOTAL',SYSDATE,
 'TOTAL', SUM(salary), ROUND(AVG(commission_pct)), null, null
 FROM employees);
SELECT * FROM emp_cpe;
ROLLBACK;

--11
INSERT INTO emp_cpe (employee_id, first_name, last_name, email, hire_date, job_id, salary)
VALUES(&cod, '&&prenume', '&&nume', substr('&prenume',1,1) || substr('&nume',1,7), sysdate, 'it_prog',&sal);

UNDEFINE prenume;

UNDEFINE nume;

select * from emp_cpe
where initcap(first_name)='Vreau';

rollback;

--12
create table emp2_cpe as select * from employees;
delete from emp2_cpe;
create table emp3_cpe as select * from employees;
delete from emp3_cpe;

insert all
when salary<5000 then into emp1_cpe
when salary>=5000 and salary<=10000 then into emp2_cpe
else into emp3_cpe
select * from employees;

rollback;

--13
CREATE TABLE emp0_cpe AS SELECT * FROM employees;
DELETE FROM emp0_cpe;
INSERT FIRST
WHEN department_id = 80 THEN
INTO emp0_cpe
 WHEN salary < 5000 THEN
 INTO emp1_cpe
 WHEN salary > = 5000 AND salary <= 10000 THEN
 INTO emp2_cpe
 ELSE
 INTO emp3_cpe
SELECT * FROM employees;

--14
update emp_cpe
set salary=salary*1.05;

select * from emp_cpe;
rollback;

--15
update emp_cpe
set job_id='SA_REP'
where department_id=80;

select * from emp_cpe;

rollback;

--16
select * from dept_pnu
where department_id = 20;

select * from emp_pnu
where employee_id = 201;

update dept_pnu
set manager_id = (select employee_id
                  from emp_pnu
                  where initcap(last_name) = 'Grant' and initcap(first_name) = 'Douglas'
                  )
where department_id = 20;

update emp_pnu 
set salary = salary + 1000
where initcap(last_name) = 'Grant' and initcap(first_name) = 'Douglas';

rollback; -- o sa se anuleze ambele comenzi update

--17
update emp_cpe e
set (salary, commission_pct)=(select salary, commission_pct from emp_cpe where e.manager_id=employee_id)
where salary=(select min(salary) from emp_cpe);

rollback;

--18
update emp_cpe e
set email=substr(last_name, 1, 1)||nvl(first_name,'.')
where salary=(select max(salary) from emp_cpe where e.department_id=department_id);

rollback;

--19
UPDATE emp_pnu d
SET salary = (SELECT avg(salary)
 FROM emp_pnu
 )
WHERE hire_date = (SELECT min(hire_date)
 FROM emp_pnu
 WHERE department_id = d.department_id
 );
 
 rollback;
 
 --20
delete from dept_pnu; -- integrity constraint (GRUPA43.FK_EMP_DEPT_PNU) violated - child record found
-- nu se pot sterge departamentele care se afla si in emp
-- in emp department_id este cheie externa

-- se pot sterge doar acele departamente care nu au angajati

--21
delete from dept_pnu
where department_id in (select department_id
                        from dept_pnu -- din lista tuturor depart
                        
                        MINUS  -- eliminam depart in care lucreaza angajati
                        
                        select department_id
                        from emp_pnu
                        ); -- se obtin departamentele care nu au angajati

-- sau
delete from dept_cpe
where department_id not in (select nvl(department_id, -100)
                            from emp_cpe
                            ); -- lista departametelor care au angajati

rollback;

--22
desc dept_cpe;
--metode de inserare - implicita, explicita
insert into dept_cpe
values (400, 'depart400', null, null);
select * from dept_cpe where department_id=400;

--23
savepoint p;

--24
delete from dept_cpe
where department_id between 160 and 200;

--25
rollback to p;