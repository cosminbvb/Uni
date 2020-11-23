--1a)
create table angajati_cpe
    (cod_ang number(4) constraint p_key_cpe primary key,
     nume varchar2(20) constraint ang_nume_cpe not null,
     prenume varchar2(20),
     email char(15) unique,
     data_ang date default sysdate,
     job varchar2(10),
     cod_sef number(4),
     salariu number(8, 2) constraint ang_sal_cpe not null,
     cod_dep number(2)
    );
    
--1b)
drop table angajati_cpe;

CREATE TABLE angajati_cpe
       (cod_ang number(4),
        nume varchar2(20) constraint ang_nume_cpe not null,
        prenume varchar2(20),
        email char(15) unique,
        data_ang date default sysdate,
        job varchar2(10),
        cod_sef number(4),
        salariu number(8, 2) constraint ang_sal_cpe not null,
        cod_dep number(2),
        constraint p_key_cpe primary key(cod_ang)
       );
    
--2
insert into angajati_cpe(cod_ang, nume,prenume,data_ang,job,salariu, cod_dep)
       values(100,'Nume1','Prenume1',null,'Director',20000,10);
       
insert into angajati_cpe
       values(101,'nume2', 'prenume2', 'nume2', to_date('02-02-2004','dd-mm-yyyy'), 'Inginer', 100, 10000, 10);

insert into angajati_cpe
       values(102,'nume3', 'prenume3', 'nume3', to_date('05-06-2000','dd-mm-yyyy'), 'Analist', 101, 5000, 20);
                     
insert into angajati_cpe(cod_ang, nume, prenume, data_ang, job, cod_sef, salariu, cod_dep)  
       values(103, 'nume4', 'prenume4', null, 'Inginer', 100, 9000, 20);
       
insert into angajati_cpe
       values(104, 'nume5', 'prenume5', 'nume5', null, 'Analist', 101, 3000, 30);

commit;

--3
alter table angajati_cpe
add(comision number(4,2)); 


--4
alter table angajati_cpe
modify(salariu number(6,2));
--column to be modified must be empty to decrease precision or scale

--5
alter table angajati_cpe
modify(salariu number(8,2) default 10);

--6
alter table angajati_cpe
modify(comision number(2,2), salariu number(10,2));

--7
update angajati_cpe
set comision=0.1 
where upper(job) like 'A%';

commit;

--8
alter table angajati_cpe
modify(email varchar2(20));

--9
alter table angajati_cpe
add(nr_telefon varchar2(10) default '0722123456');

select*from angajati_cpe;

--10
alter table angajati_cpe
drop column nr_telefon;

--11
CREATE TABLE departamente_cpe
        (cod_dep number(2),
         nume varchar2(15) constraint nume_dept_cpe not null,
         cod_director number(4)
        );
        
--12
INSERT INTO departamente_cpe
       VALUES(10, 'Administrativ', 100);
       
INSERT INTO departamente_cpe
       VALUES(20, 'Proiectare', 101);
       
INSERT INTO departamente_cpe
       VALUES(30, 'Programare', NULL);

commit;

--13
alter table departamente_cpe
add constraint pk_dep_cpe primary key(cod_dep);

--14 a)
alter table angajati_cpe
add constraint fk_ang_dept_cpe foreign key(cod_dep) references departamente_cpe(cod_dep);

--14 b)
drop table angajati_cpe;
desc angajati_cpe;

CREATE TABLE angajati_cpe
       (cod_ang number(4) constraint pk_ang_cpe primary key,
        nume varchar2(20) constraint nume_ang_cpe not null,
        prenume varchar2(20),
        email char(15) unique,
        data_ang date default sysdate,
        job varchar2(10),
        cod_sef number(4) constraint sef_ang_cpe references angajati_cpe(cod_ang),
        salariu number(8,2),
        cod_dep number(2) constraint fk_ang_dep_cpe references departamente_cpe(cod_dep),
        comision number(2,2),
        check(cod_dep > 0),
        constraint verif_sal_cpe check(salariu > comision * 100),
        constraint num_pren_cpe unique(nume, prenume)
       );

--15
drop table angajati_cpe;
CREATE TABLE angajati_cpe
     (cod_ang number(4),
     nume varchar2(20) constraint nume_cpe not null,
     prenume varchar2(20),
     email char(15),
     data_ang date default sysdate,
     job varchar2(10),
     cod_sef number(4),
     salariu number(8, 2) constraint salariu_cpe not null,
     cod_dep number(2),
     comision number(2,2),
     constraint nume_prenume_unique_cpe unique(nume,prenume),
     constraint verifica_sal_cpe check(salariu > 100*comision),
     constraint pk_angajati_v primary key(cod_ang),
     unique(email),
     constraint sef_cpe foreign key(cod_sef) references angajati_cpe(cod_ang),
     constraint fk_dep_cpe foreign key(cod_dep) references departamente_cpe (cod_dep),
     check(cod_dep > 0)
     );


--16
INSERT INTO angajati_cpe
VALUES(100, 'nume1', 'prenume1', 'email1', sysdate, 'Director ',null, 20000,10, 0.1);

INSERT INTO angajati_cpe
VALUES(101,'nume2' , 'prenume2', 'email2',to_date('02-02-2004','dd-mm- yyyy'),'Inginer', 100, 10000 ,10, 0.2);

INSERT INTO angajati_cpe
VALUES(102,'nume3' , 'prenume3', 'email3',to_date('05-06-2000','dd-mm-yyyy'),'Analist', 101, 5000 ,20, 0.1);

INSERT INTO angajati_cpe
VALUES(103,'nume4','prenume4', 'email4', sysdate, 'Inginer ',100,9000,20, 0.1);

INSERT INTO angajati_cpe
VALUES(104,'nume5', 'prenume5', 'email5', sysdate, 'Analist', 101, 3000 ,30, 0.1);

select * from angajati_cpe;

commit;

--17
SELECT * FROM tab;
SELECT table_name FROM user_tables;

--18 a)
select constraint_name, constraint_type, table_name
from user_constraints
where lower(table_name) in ('angajati_cpe','departamente_cpe');

--18 b)
SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE LOWER(table_name) IN ('angajati_cpe');

--19
alter table angajati_cpe
modify(email not null);

--21
select * from departamente_cpe;
insert into departamente_cpe
values (60,'Analiza',null);
commit;


--22
delete from departamente_cpe
where cod_dep=20;
-- ORA-02292: integrity constraint (GRUPA43.FK_ANG_DEP_PNU) violated - child record found

--23
delete from departamente_cpe
where cod_dep=60;

rollback;

--24
select * from user_constraints where lower(table_name)='angajati_cpe';
alter table angajati_cpe
drop constraint fk_dep_cpe;

alter table angajati_cpe
add constraint fk_ang_dep_cpe foreign key (cod_dep) references departamente_cpe(cod_dep)
on delete cascade;

--25
delete from departamente_cpe
where cod_dep=20;
rollback;

--26
ALTER TABLE departamente_cpe
ADD CONSTRAINT cod_dir_fk FOREIGN KEY(cod_director)
REFERENCES angajati_cpe (cod_ang) ON DELETE SET NULL;

--27
update departamente_cpe
set cod_director=102
where cod_dep=30;

delete from angajati_cpe where cod_ang=102;

rollback;

--28
alter table angajati_cpe
add constraint v_sal_cpe check(salariu<=30000);

update angajati_cpe
set salariu=35000
where cod_ang=100; -- nu putem adauga un salariu mai mare de 30000, conform noii
--constrangeri adaugate

--29
alter table angajati_cpe
drop constraint v_sal_cpe;
