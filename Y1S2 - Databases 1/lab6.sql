--0
select employee_id
from works_on
where project_id in
    (select project_id
     from projects
     where budget=10000)
group by employee_id
having count(project_id)=(select count(*)
                          from projects
                          where budget=10000);
                          
--1
select employee_id
from works_on 
where project_id in (select project_id
                     from projects
                     where start_date<=to_date('30-jun-06') and start_date>=to_date('01-jan-06'))
group by employee_id
having count(project_id)=(select count(project_id)
                          from projects
                          where start_date<=to_date('30-jun-06') and start_date>=to_date('01-jan-06'));

--2
with angajati as (select employee_id Ang, count(job_id) Nr
                    from job_history 
                    group by employee_id
                    having count(job_id)>=2)
select project_id, project_name
from projects join works_on w using(project_id)
where w.employee_id in (select Ang from angajati)
group by project_id, project_name
having count(*)=(select count(count(employee_id))
                   from job_history
                   group by employee_id
                   having count(job_id) = 2
                 );

--sau

select *
from projects  -- lista tuturor proiectelor
where project_id in (select project_id
                     from works_on  -- proiecte la care lucreaza angajati
                     where employee_id in
                          (select employee_id
                           from job_history
                           group by employee_id
                           having count(job_id) = 2
                           ) --angaja?ii care au de?inut alte 2 posturi în firm? (101, 176, 200)
                      group by project_id -- grupam si numaram cati angajati lucreaza la acelasi proiect
                      having count(*) = (  select count(count(employee_id))
                                           from job_history
                                           group by employee_id
                                           having count(job_id) = 2
                                         )  -- si daca nr de angajati care lucreaza la acelasi proiect 
                                        -- este egal cu nr de ang care au detinut alte doua posturi in firma
                                        -- rezulta ca la aceste proiecte au participat TOTI ang care au detinut
                                        -- alte doua posturi in firma
                      );

--3
select count(count(job_id)) 
from job_history 
group by employee_id
having count(job_id)>=2;

--4
select c.country_id, count(employee_id)
from employees e join departments d on(e.department_id=d.department_id)
                 join locations l on(d.location_id=l.location_id)
                 right join countries c on(l.country_id=c.country_id)
group by c.country_id;

--5
select e.employee_id, project_id
from employees e left join works_on w on(e.employee_id=w.employee_id);

--6
select *
from employees
where department_id in (select department_id
                        from employees 
                        where employee_id in (select project_manager from projects))
                    and employee_id not in (select project_manager from projects);

--7
select *
from employees
where department_id not in (select department_id
                        from employees 
                        where employee_id in (select project_manager from projects));
                        
--8
select department_id
from employees
group by department_id
having avg(salary)>&p;

--9
select employee_id
from works_on 
where project_id in(select project_id 
                    from projects 
                    where project_manager=102)
                    --angajati care lucreaza la proiecte conduse de 102
minus --eliminam angajatii care lucreaza si la alte proiecte
select employee_id
from works_on
where project_id not in(select project_id
                         from projects
                         where project_manager=102);

            
--10a)
select employee_id, last_name
from employees join works_on using (employee_id)
where project_id in (select project_id
                     from works_on
                     where employee_id = 200
                     ) -- o sa avem angajatii care lucreaza la toate proiectele lui 200 sau doar la o parte din ele
group by employee_id, last_name    
having count(*) >= (select count(project_id)
                   from works_on
                   where employee_id = 200
                   );
    
--11
select employee_id, last_name
from employees join works_on using (employee_id)
where project_id in (select project_id
                     from works_on
                     where employee_id = 200
                     ) 
      and employee_id != 200
group by employee_id, last_name    
having count(*) = (select count(project_id)
                   from works_on
                   where employee_id = 200
                   ); -- angajatii lucreaza la toate proiectele la care lucreaza ang 200
                   -- dar pot lucra si la alte proiecte la care nu lucreaza ang 200
                   -- ex: ang 500 - p1, p2, p3 - nu este corect deoarece lucreaza si la alte proiecte 
                                               -- la care ang 200 nu lucreaza (p1)                                     
MINUS -- eliminam angajatii care lucreaza la proiecte la care ang 200 nu lucreaza 
select employee_id, last_name
from employees join works_on using (employee_id)
where project_id in (select distinct project_id
                     from works_on 
                     where project_id not in (select project_id
                                              from works_on
                                              where employee_id = 200) -- obtinem proiectele la care ang 200 nu lucreaza
                     );
