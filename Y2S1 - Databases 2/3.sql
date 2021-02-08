--1 a) cursor clasic
CREATE TABLE jobs_cpe AS SELECT * FROM jobs;
SELECT * FROM jobs_cpe;
describe jobs_cpe;
INSERT INTO jobs_cpe VALUES ('TEST', 'TEST', 1000,2000);
--am facut tabelul jobs_cpe sa verific cazul in care nu exista angajati pt anumit job
--si pare ca merge
DECLARE
    titlu jobs.job_title%TYPE;
    nume emp_cpe.last_name%TYPE;
    salariu emp_cpe.salary%TYPE;
    id_job emp_cpe.job_id%TYPE;
    id_job_precedent emp_cpe.job_id%TYPE := ' '; --e varchar2
    CURSOR c IS
        SELECT j.job_id, job_title, last_name, salary
        FROM jobs_cpe j LEFT JOIN emp_cpe e ON(j.job_id = e.job_id); 
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO id_job, titlu, nume, salariu;
        EXIT WHEN c%NOTFOUND;
        IF id_job != id_job_precedent --daca avem un id nou de job, afisam numele jobului
        THEN
            id_job_precedent := id_job;
            DBMS_OUTPUT.PUT_LINE('-------------------');
            DBMS_OUTPUT.PUT_LINE(titlu || ':');
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
        IF nume IS NOT NULL 
        THEN DBMS_OUTPUT.PUT_LINE(nume || ' - ' || salariu);   
        ELSE DBMS_OUTPUT.PUT_LINE('Nu exista angajati');
        END IF;
    END LOOP;
END;
/

--1 b) ciclu cursor
DECLARE
    id_job_precedent emp_cpe.job_id%TYPE := ' ';
    CURSOR c IS
        SELECT j.job_id, job_title, last_name, salary
        FROM jobs_cpe j LEFT JOIN emp_cpe e ON(j.job_id = e.job_id);
BEGIN
    FOR i in c LOOP
        IF i.job_id != id_job_precedent --daca avem un id nou de job, afisam numele jobului
        THEN
            id_job_precedent := i.job_id;
            DBMS_OUTPUT.PUT_LINE('-------------------');
            DBMS_OUTPUT.PUT_LINE(i.job_title || ':');
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
        IF i.last_name IS NOT NULL 
        THEN DBMS_OUTPUT.PUT_LINE(i.last_name || ' - ' || i.salary);   
        ELSE DBMS_OUTPUT.PUT_LINE('Nu exista angajati');
        END IF;
    END LOOP;
END;
/

--1 c) ciclu cursor cu subcerere
DECLARE
    id_job_precedent emp_cpe.job_id%TYPE := ' ';
BEGIN
    FOR i in (SELECT j.job_id, job_title, last_name, salary
              FROM jobs_cpe j LEFT JOIN emp_cpe e ON(j.job_id = e.job_id)) LOOP
        IF i.job_id != id_job_precedent --daca avem un id nou de job, afisam numele jobului
        THEN
            id_job_precedent := i.job_id;
            DBMS_OUTPUT.PUT_LINE('-------------------');
            DBMS_OUTPUT.PUT_LINE(i.job_title || ':');
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
        IF i.last_name IS NOT NULL 
        THEN DBMS_OUTPUT.PUT_LINE(i.last_name || ' - ' || i.salary);   
        ELSE DBMS_OUTPUT.PUT_LINE('Nu exista angajati');
        END IF;
    END LOOP;
END;
/

--1 d) expresii cursor (nested cursor)
DECLARE
    titlu jobs.JOB_TITLE%TYPE;
    angajat employees%ROWTYPE;
    gasit BOOLEAN := FALSE; -- pt cazul fara angajati
    TYPE refcursor IS REF CURSOR;
    CURSOR c IS
        SELECT job_title ,
            CURSOR (SELECT * FROM employees e
                    WHERE e.job_id = j.job_id)            
        FROM jobs_cpe j;
     v_cursor refcursor;
BEGIN
    OPEN c;
    LOOP --pt fiecare title
        FETCH c INTO titlu , v_cursor;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------');
        DBMS_OUTPUT.PUT_LINE(titlu || ':');
        DBMS_OUTPUT.PUT_LINE('');
        LOOP --pt fiecare angajat cu acel job 
            FETCH v_cursor INTO angajat;
            EXIT WHEN v_cursor%NOTFOUND;
            IF angajat.last_name IS NOT NULL  
            THEN gasit := TRUE; --daca exista cel putin un ang cu acel job => True
            END IF;
            DBMS_OUTPUT.PUT_LINE(angajat.last_name || ' - ' || angajat.salary); 
        END LOOP;
        IF gasit = FALSE --daca n-am gasit nimic
        THEN DBMS_OUTPUT.PUT_LINE('Nu exista angajati');
        END IF;
        gasit := FALSE;
    END LOOP;
    CLOSE c;
END;
/

-- 2
DECLARE
    nr_ordine NUMBER(10) := 1; --nr de ordine care va fi resetat / job
    venit_lunar_total NUMBER(10);
    nr_total_ang NUMBER(10) := 0;
    venit_lunar_total_2 NUMBER(10) := 0; --indiferent de job
    titlu jobs.JOB_TITLE%TYPE;
    angajat employees%ROWTYPE;
    gasit BOOLEAN := FALSE; -- pt cazul fara angajati
    TYPE refcursor IS REF CURSOR;
    CURSOR c IS
        SELECT job_title ,
            CURSOR (SELECT * FROM employees e
                    WHERE e.job_id = j.job_id)            
        FROM jobs_cpe j;
     v_cursor refcursor;
BEGIN
    OPEN c;
    LOOP --pt fiecare title
        FETCH c INTO titlu , v_cursor;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------');
        DBMS_OUTPUT.PUT_LINE(titlu || ':');
        DBMS_OUTPUT.PUT_LINE('');
        nr_ordine := 1;
        venit_lunar_total := 0;
        LOOP --pt fiecare angajat cu acel job 
            FETCH v_cursor INTO angajat;
            EXIT WHEN v_cursor%NOTFOUND;
            IF angajat.last_name IS NOT NULL  
            THEN gasit := TRUE; --daca exista cel putin un ang cu acel job => True
            END IF;
            DBMS_OUTPUT.PUT_LINE(nr_ordine || ' ' || angajat.last_name || ' - ' || angajat.salary);
            nr_ordine := nr_ordine + 1;
            venit_lunar_total := venit_lunar_total + angajat.salary;
            nr_total_ang := nr_total_ang + 1;
        END LOOP;
        venit_lunar_total_2 := venit_lunar_total_2 + venit_lunar_total;
        IF gasit = TRUE 
        THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('Nr angajati: ' || (nr_ordine-1));
            DBMS_OUTPUT.PUT_LINE('Valoarea lunara a veniturilor: ' || venit_lunar_total);
            DBMS_OUTPUT.PUT_LINE('Venit mediu: ' || venit_lunar_total/(nr_ordine-1));
        END IF;
        
        IF gasit = FALSE --daca n-am gasit nimic
        THEN DBMS_OUTPUT.PUT_LINE('Nu exista angajati');
        END IF;
        gasit := FALSE;
    END LOOP;
    CLOSE c;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('///////////////////');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Nr total anagajati: ' || nr_total_ang);
    DBMS_OUTPUT.PUT_LINE('Total: ' || venit_lunar_total_2); -- 321136
    DBMS_OUTPUT.PUT_LINE('Medie: ' || venit_lunar_total_2/nr_total_ang);
    
END;
/

SELECT SUM(salary) FROM employees; --321136

--3 
DECLARE
    total NUMBER(10);
    x NUMBER(10);
    verif NUMBER(10):=0;
BEGIN
    SELECT SUM(salary+salary*NVL(commission_pct, 0)) 
    INTO total
    FROM employees;
    DBMS_OUTPUT.PUT_LINE('Total: ' || total);
    DBMS_OUTPUT.PUT_LINE('');

    FOR i IN (SELECT last_name, salary, commission_pct
              FROM employees) LOOP
        x := i.salary + i.salary*NVL(i.commission_pct, 0);
        verif := verif + x*100/total;
        DBMS_OUTPUT.PUT_LINE(i.last_name || ' ' || x*100/total);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(verif);
END;
/

--4 (2 modificat)
DECLARE
    nr_ordine NUMBER(10) := 1; --nr de ordine care va fi resetat / job
    titlu jobs.JOB_TITLE%TYPE;
    angajat employees%ROWTYPE;
    TYPE refcursor IS REF CURSOR;
    CURSOR c IS
        SELECT job_title ,
            CURSOR (SELECT * FROM employees e
                    WHERE e.job_id = j.job_id
                    ORDER BY salary DESC)            
        FROM jobs_cpe j;
     v_cursor refcursor;
BEGIN
    OPEN c;
    LOOP --pt fiecare title
        FETCH c INTO titlu , v_cursor;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------');
        DBMS_OUTPUT.PUT_LINE(titlu || ':');
        DBMS_OUTPUT.PUT_LINE('');
        nr_ordine := 1;
        LOOP --pt fiecare angajat cu acel job 
            FETCH v_cursor INTO angajat;
            EXIT WHEN v_cursor%NOTFOUND OR  v_cursor%ROWCOUNT>5;
            DBMS_OUTPUT.PUT_LINE(nr_ordine || ' ' || angajat.last_name || ' - ' || angajat.salary);
            nr_ordine := nr_ordine + 1;
        END LOOP;
    
        IF nr_ordine-1 != 5 
        THEN DBMS_OUTPUT.PUT_LINE('Mai putin de 5 angajati');
        END IF;
        
    END LOOP;
    CLOSE c;
END;
/

--5
DECLARE
    nr_ordine NUMBER(10); --nr de ordine care va fi resetat / job
    nr NUMBER(2); --sa numaram daca sunt cel putin 5
    salariu_anterior employees.salary%TYPE := -1;
    titlu jobs.JOB_TITLE%TYPE;
    angajat employees%ROWTYPE;
    TYPE refcursor IS REF CURSOR;
    CURSOR c IS
        SELECT job_title ,
            CURSOR (SELECT * FROM employees e
                    WHERE e.job_id = j.job_id
                    ORDER BY salary DESC)            
        FROM jobs_cpe j;
     v_cursor refcursor;
BEGIN
    OPEN c;
    LOOP --pt fiecare title
        FETCH c INTO titlu , v_cursor;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------');
        DBMS_OUTPUT.PUT_LINE(titlu || ':');
        DBMS_OUTPUT.PUT_LINE('');
        nr_ordine := 0;
        nr := 1;
        LOOP --pt fiecare angajat cu acel job 
            FETCH v_cursor INTO angajat;
            EXIT WHEN v_cursor%NOTFOUND OR  nr_ordine>=5;
            IF angajat.salary != salariu_anterior
            THEN
                nr_ordine := nr_ordine + 1; --adica updatam nr de ordine doar daca s-a schimbat salariul
                salariu_anterior := angajat.salary;
            END IF;
            DBMS_OUTPUT.PUT_LINE(nr_ordine || ' ' || angajat.last_name || ' - ' || angajat.salary);
            nr := nr+1; --nr creste indiferent
        END LOOP;
    
        IF nr-1 < 5 
        THEN DBMS_OUTPUT.PUT_LINE('Mai putin de 5 angajati');
        END IF;
        
    END LOOP;
    CLOSE c;
END;
/