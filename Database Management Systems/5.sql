SELECT * FROM emp_cpe;
DESC emp_cpe; -- obs: job_id e varchar2
SELECT MAX(employee_id) FROM emp_cpe; -- ultimul id e 206

CREATE SEQUENCE sequence_cpe
    START WITH 207
    INCREMENT BY 1;


CREATE OR REPLACE PACKAGE pachet_cpe AS
    --a
    PROCEDURE new_emp (new_first_name emp_cpe.first_name%TYPE,
                       new_last_name emp_cpe.last_name%TYPE,
                       new_phone_number emp_cpe.phone_number%TYPE,
                       new_email emp_cpe.email%TYPE,
                       manager_first_name emp_cpe.first_name%TYPE,
                       manager_last_name emp_cpe.last_name%TYPE,
                       dep_name departments.department_name%TYPE,
                       job_name jobs.job_title%TYPE);
    
    FUNCTION new_salary(dep_id departments.department_id%TYPE,
                        j_id jobs.job_id%TYPE)
        RETURN emp_cpe.salary%TYPE;
    
    FUNCTION new_manager_id (manager_first_name emp_cpe.first_name%TYPE,
                         manager_last_name emp_cpe.last_name%TYPE)
        RETURN emp_cpe.employee_id%TYPE;
    
    FUNCTION new_department_id (dep_name departments.department_name%TYPE)
        RETURN departments.department_id%TYPE;
    
    FUNCTION new_job_id (job_name jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE;
    
    --b
    PROCEDURE move_emp (v_first_name emp_cpe.first_name%TYPE, 
                        v_last_name emp_cpe.last_name%TYPE,
                        v_dep_name departments.department_name%TYPE,
                        v_job_name jobs.job_title%TYPE,
                        v_manager_first_name emp_cpe.first_name%TYPE,
                        v_manager_last_name emp_cpe.last_name%TYPE);
                        
    --c
    FUNCTION nr_subordinates (v_first_name emp_cpe.first_name%TYPE, 
                              v_last_name emp_cpe.last_name%TYPE)
        RETURN NUMBER;
    
    --e
    PROCEDURE update_salary (v_salary emp_cpe.salary%TYPE, 
                             v_last_name emp_cpe.last_name%TYPE);
          
    --f
    CURSOR employees_from_job (v_job_id emp_cpe.job_id%TYPE)
        RETURN emp_cpe%ROWTYPE;
    
    --g
    CURSOR all_jobs
        RETURN jobs%ROWTYPE;
        
    --h
    PROCEDURE employees_for_every_job;
        
END pachet_cpe;
/

CREATE OR REPLACE PACKAGE BODY pachet_cpe AS
    
    --cursoarele trebuie puse primele aparent
    CURSOR employees_from_job (v_job_id emp_cpe.job_id%TYPE)
    RETURN emp_cpe%ROWTYPE IS
        SELECT * 
        FROM emp_cpe
        WHERE job_id = v_job_id;
        
    CURSOR all_jobs
    RETURN jobs%ROWTYPE IS
        SELECT * 
        FROM jobs;
    
        
    FUNCTION new_manager_id (manager_first_name emp_cpe.first_name%TYPE,
                             manager_last_name emp_cpe.last_name%TYPE)
        RETURN emp_cpe.employee_id%TYPE IS 
        manager_id emp_cpe.employee_id%TYPE;
    BEGIN
        SELECT employee_id INTO manager_id
        FROM emp_cpe
        WHERE UPPER(first_name) = UPPER(manager_first_name) AND
              UPPER(last_name) = UPPER(manager_last_name);
        
        RETURN manager_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No such employee');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('More than one employees with the given names');
            RETURN -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Another error occured');
            RETURN -1;
    END new_manager_id;
    
    FUNCTION new_department_id (dep_name departments.department_name%TYPE)
        RETURN departments.department_id%TYPE IS
        dep_id departments.department_id%TYPE;
    BEGIN
        SELECT department_id INTO dep_id
        FROM departments 
        WHERE UPPER(department_name) = UPPER(dep_name);
        
        RETURN dep_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Department not found');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('More than one department');
            RETURN -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Another error occured');
            RETURN -1;
    END new_department_id;
    
    FUNCTION new_job_id (job_name jobs.job_title%TYPE)
        RETURN jobs.job_id%TYPE IS
        j_id jobs.job_id%TYPE;
    BEGIN
        SELECT job_id INTO j_id
        FROM jobs
        WHERE UPPER(job_title) = UPPER(job_name);
        
        RETURN j_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Job not found');
            RETURN '-1';
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('More than one job');
            RETURN '-1';
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Another error occured');
            RETURN '-1';
    END new_job_id;
    
    FUNCTION new_salary(dep_id departments.department_id%TYPE,
                        j_id jobs.job_id%TYPE)
        RETURN emp_cpe.salary%TYPE IS
        salary emp_cpe.salary%TYPE;
    BEGIN
        SELECT MIN(salary) INTO salary
        FROM emp_cpe
        WHERE department_id = dep_id AND job_id = j_id;
        
        RETURN salary;
    END new_salary;
    
    PROCEDURE new_emp (new_first_name emp_cpe.first_name%TYPE,
                   new_last_name emp_cpe.last_name%TYPE,
                   new_phone_number emp_cpe.phone_number%TYPE,
                   new_email emp_cpe.email%TYPE,
                   manager_first_name emp_cpe.first_name%TYPE,
                   manager_last_name emp_cpe.last_name%TYPE,
                   dep_name departments.department_name%TYPE,
                   job_name jobs.job_title%TYPE) IS
        
        v_new_id emp_cpe.employee_id%TYPE;
        v_new_job_id emp_cpe.job_id%TYPE;
        v_new_salary emp_cpe.salary%TYPE;
        v_new_commission emp_cpe.commission_pct%TYPE := NULL;
        v_new_manager_id emp_cpe.manager_id%TYPE;
        v_new_department_id emp_cpe.department_id%TYPE;
        
    BEGIN
        v_new_id := sequence_cpe.NEXTVAL;
        v_new_job_id := new_job_id(job_name);
        v_new_department_id := new_department_id(dep_name);
        v_new_salary := new_salary(v_new_department_id, v_new_job_id);
        v_new_manager_id := new_manager_id(manager_first_name, manager_last_name);
        
        IF v_new_job_id != '-1' AND v_new_department_id != -1 AND v_new_manager_id != -1 THEN
            INSERT INTO emp_cpe 
            VALUES (v_new_id, new_first_name, new_last_name, new_email, new_phone_number, 
                    SYSDATE, v_new_job_id, v_new_salary, v_new_commission, v_new_manager_id,
                    v_new_department_id);
            COMMIT;
        END IF;
        
    END new_emp;
    
    PROCEDURE move_emp (v_first_name emp_cpe.first_name%TYPE, 
                    v_last_name emp_cpe.last_name%TYPE,
                    v_dep_name departments.department_name%TYPE,
                    v_job_name jobs.job_title%TYPE,
                    v_manager_first_name emp_cpe.first_name%TYPE,
                    v_manager_last_name emp_cpe.last_name%TYPE) IS
        
        v_dep_id emp_cpe.department_id%TYPE; -- cu functia de la a
        v_job_id emp_cpe.job_id%TYPE; -- -//-
        v_manager_id emp_cpe.manager_id%TYPE; -- -//-
        v_salary emp_cpe.salary%TYPE;
        v_commission emp_cpe.commission_pct%TYPE;
        
        v_current_salary emp_cpe.salary%TYPE;
        
    BEGIN
        v_dep_id := new_department_id(v_dep_name);
        v_job_id := new_job_id(v_job_name);
        v_manager_id := new_manager_id(v_manager_first_name, v_manager_last_name);
        
        --salariul curent
        SELECT salary INTO v_current_salary
        FROM emp_cpe
        WHERE UPPER(first_name) = UPPER(v_first_name) AND UPPER(last_name) = UPPER(v_last_name);

        --salariul minim
        SELECT NVL(MIN(salary),0) INTO v_salary
        FROM emp_cpe
        WHERE department_id = v_dep_id AND job_id = v_job_id;
        
        --se pastreaza cel mai mare
        IF v_salary < v_current_salary THEN
            v_salary := v_current_salary;
        END IF;

        --comision
        SELECT MIN(commission_pct) INTO v_commission
        FROM emp_cpe
        WHERE department_id = v_dep_id AND job_id = v_job_id;
        
        UPDATE emp_cpe
        SET department_id = v_dep_id,
            job_id = v_job_id,
            manager_id = v_manager_id,
            salary = v_salary,
            commission_pct = v_commission,
            hire_date = SYSDATE
        WHERE UPPER(first_name) = UPPER(v_first_name) AND UPPER(last_name) = UPPER(v_last_name);
            
    END move_emp;
    
    FUNCTION nr_subordinates (v_first_name emp_cpe.first_name%TYPE, 
                              v_last_name emp_cpe.last_name%TYPE)
        RETURN NUMBER IS
        
        emp_id emp_cpe.employee_id%TYPE;
        nr NUMBER := 0;
        
        --functia auxiliara e luata din tema 4
        FUNCTION is_subordinate (emp employees.employee_id%TYPE)
            RETURN NUMBER IS
            v_emp employees.employee_id%TYPE;
        BEGIN
            SELECT NVL(manager_id, 0) 
            INTO v_emp
            FROM emp_cpe
            WHERE employee_id = emp;
            
            IF v_emp = emp_id THEN
                RETURN 1;
            END IF;
            IF v_emp = 0 THEN
                RETURN -1;
            ELSE
                RETURN is_subordinate(v_emp);
            END IF;
        END is_subordinate;
        
    BEGIN
        SELECT employee_id INTO emp_id
        FROM emp_cpe
        WHERE UPPER(first_name) = UPPER(v_first_name) AND UPPER(last_name) = UPPER(v_last_name);

        -- trebuie sa cautam aplicam o functie recursiva pe fiecare angajat
        FOR i IN (SELECT employee_id
                  FROM emp_cpe) LOOP
            IF is_subordinate(i.employee_id) = 1 THEN
                nr := nr + 1;
            END IF;
        END LOOP;
        
        RETURN nr;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee not found');
            RETURN -1;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('More than one employees with the given names');
            RETURN -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Another error occured');
            RETURN -1;
    END nr_subordinates;
    
    PROCEDURE update_salary (v_salary emp_cpe.salary%TYPE, 
                             v_last_name emp_cpe.last_name%TYPE) IS
        nr NUMBER := 0;
        emp_id emp_cpe.employee_id%TYPE;
        min_salary jobs.min_salary%TYPE;
        max_salary jobs.max_salary%TYPE;
    BEGIN
        SELECT COUNT(employee_id) INTO nr
        FROM emp_cpe
        WHERE UPPER(last_name) = UPPER(v_last_name);
        
        IF nr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No such employee');
        ELSE 
            IF nr = 1 THEN
                SELECT employee_id INTO emp_id
                FROM emp_cpe
                WHERE UPPER(last_name) = UPPER(v_last_name);
                
                SELECT min_salary INTO min_salary
                FROM emp_cpe e JOIN jobs j ON(e.job_id = j.job_id)
                WHERE employee_id = emp_id;
                
                SELECT max_salary INTO max_salary
                FROM emp_cpe e JOIN jobs j ON(e.job_id = j.job_id)
                WHERE employee_id = emp_id;
                
                IF(v_salary > max_salary OR v_salary < min_salary) THEN
                    DBMS_OUTPUT.PUT_LINE('Salary out of bounds');
                ELSE
                    UPDATE emp_cpe
                    SET salary = v_salary
                    WHERE employee_id = emp_id;
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('More than one employees with the given names');
            END IF;
        END IF;
    END update_salary;
    
    PROCEDURE employees_for_every_job IS
        old_jobs NUMBER := 0;    
    BEGIN
        FOR j IN all_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('Job Title: ' || j.job_title);
            FOR e IN employees_from_job(j.job_id) LOOP
                SELECT COUNT(*) INTO old_jobs
                FROM job_history
                WHERE job_id = j.job_id AND employee_id = e.employee_id;
                
                IF old_jobs = 0 THEN
                    DBMS_OUTPUT.PUT_LINE(e.first_name || ' ' || e.last_name || ' - ' || 'had this job before');
                ELSE
                    DBMS_OUTPUT.PUT_LINE(e.first_name || ' ' || e.last_name);
                END IF;
                
            END LOOP;
        END LOOP;
    END employees_for_every_job;
    
END pachet_cpe;
/

--------------------------------------------------------------------------------------------------

SELECT * FROM departments;
SELECT * FROM jobs;

--a 
BEGIN 
    pachet_cpe.new_emp('Cosmin', 'Petrescu', '0722222222', 'email', 'steven', 'king', 'executive', 'president');
END;
/

SELECT * FROM emp_cpe
WHERE last_name = 'Petrescu'; --merge

--b 
BEGIN
    pachet_cpe.move_emp('Cosmin', 'Petrescu', 'IT', 'Programmer', 'Alexander', 'Hunold');
END;
/

rollback;

--c
SELECT * FROM emp_cpe
WHERE employee_id = 101;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Neen Kochhar (101) has ' || pachet_cpe.nr_subordinates('Neen', 'Kochhar') || ' subordinates'); 
END;
/

SELECT * FROM jobs; --la AD_PRES min = 20 000 si max = 40 000
--e
BEGIN
    pachet_cpe.update_salary(39999, 'Petrescu');
END;
/
SELECT * FROM emp_cpe
WHERE last_name = 'Petrescu';

--f
BEGIN
    FOR emp IN pachet_cpe.employees_from_job('AD_PRES') LOOP
        DBMS_OUTPUT.PUT_LINE(emp.employee_id || ' ' || emp.last_name);
    END LOOP;
END;
/

--g
BEGIN
    FOR j IN pachet_cpe.all_jobs LOOP
        DBMS_OUTPUT.PUT_LINE(j.job_id || ' ' || j.job_title);
    END LOOP;
END;
/

--h
BEGIN
    pachet_cpe.employees_for_every_job();
END;
/



























