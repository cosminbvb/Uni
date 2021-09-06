--1
CREATE TABLE info_cpe (
    utilizator VARCHAR2(50),
    data TIMESTAMP,
    comanda VARCHAR2(100),
    nr_linii NUMBER,
    eroare VARCHAR2(100));
    
describe info_cpe;

--2
SELECT USER
FROM DUAL;

SELECT SYSTIMESTAMP
FROM DUAL;

CREATE OR REPLACE FUNCTION f2_cpe
    (v_nume employees.last_name%TYPE DEFAULT 'Bell')
RETURN NUMBER IS
    nr NUMBER := 0;
    salariu employees.salary%type;
    mesaj VARCHAR2(500);
    BEGIN
        SELECT salary INTO salariu
        FROM employees
        WHERE UPPER(last_name) = UPPER(v_nume);
            
        nr := SQL%ROWCOUNT;
        
        INSERT INTO info_cpe
        VALUES(USER, SYSDATE, 'SELECT', nr, 'Nicio eroare');
        
        RETURN salariu;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
             nr := SQL%ROWCOUNT;
             INSERT INTO info_cpe
             VALUES (USER, SYSDATE, 'SELECT', nr, 'Nu exista angajati cu numele dat');
             --RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
             RETURN -1;
         WHEN TOO_MANY_ROWS THEN
             mesaj := SQLCODE || ' ' || SQLERRM;
             DBMS_OUTPUT.PUT_LINE(MESAJ);
             INSERT INTO info_cpe
             VALUES (USER, SYSDATE, 'SELECT', nr, mesaj);
             RETURN -2;
             --RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
         WHEN OTHERS THEN
             mesaj := SQLERRM;
             INSERT INTO info_cpe
             VALUES (USER, SYSDATE, 'SELECT', nr, mesaj);
             --RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
             RETURN -3;
END f2_cpe;
/

DECLARE 
    sal NUMBER;
BEGIN
    sal := f2_cpe('King');
    DBMS_OUTPUT.PUT_LINE(sal);
END;
/

SELECT *
FROM info_cpe;

--3
CREATE OR REPLACE FUNCTION f3_cpe
    (v_oras locations.city%TYPE)
RETURN NUMBER IS 
    nr NUMBER := 0;
    BEGIN
        -- cazul in care orasul dat nu exista
        SELECT COUNT(*) INTO nr
        FROM locations
        WHERE UPPER(city) = UPPER(v_oras);
        
        IF nr = 0 THEN
            INSERT INTO info_cpe VALUES (USER, SYSDATE, 'ex3', 0, 'Orasul nu exista');
            DBMS_OUTPUT.PUT_LINE('Orasul nu exista');
            RETURN -1;
        
        ELSE
            -- cazul in care in orasul dat nu lucreaza niciun angajat
            SELECT COUNT(employee_id)
            INTO nr
            FROM employees e
            JOIN departments d ON (e.department_id = d.department_id)
            JOIN locations l ON (d.location_id = l.location_id)
            WHERE UPPER(city) = UPPER(v_oras);
            
            IF nr = 0 THEN
                INSERT INTO info_cpe VALUES (USER, SYSDATE, 'ex3', 0, 'Nu exista angajati');
                DBMS_OUTPUT.PUT_LINE('Nu exista angajati');
                RETURN -1;
            ELSE
                SELECT COUNT(employee_id)
                INTO nr
                FROM employees e
                JOIN departments d ON (e.department_id = d.department_id)
                JOIN locations l ON (d.location_id = l.location_id)
                WHERE (
                    SELECT COUNT(DISTINCT job_id)
                    FROM job_history
                    WHERE employee_id = e.employee_id
                ) > 1
                AND UPPER(city) = UPPER(v_oras);
                INSERT INTO info_cpe VALUES (USER, SYSDATE, 'ex3', nr, 'A mers');
                RETURN nr;
            END IF;
        END IF;
END f3_cpe;
/

DECLARE 
    nr NUMBER;
BEGIN
    nr := f3_cpe('Hiroshima');
    DBMS_OUTPUT.PUT_LINE(nr);
END;
/
SELECT * 
FROM locations;
SELECT *
FROM info_cpe;

--4
CREATE OR REPLACE PROCEDURE f4_cpe
    (m employees.employee_id%TYPE)
IS
    nr NUMBER := 0;
    
    FUNCTION are_managerul
        (ang employees.employee_id%TYPE)
    RETURN NUMBER IS
        v_ang employees.employee_id%TYPE;
        BEGIN
            SELECT NVL(manager_id, 0) 
            INTO v_ang
            FROM employees
            WHERE employee_id = ang;
            
            IF v_ang = m THEN
                RETURN 1;
            END IF;
            IF v_ang = 0 THEN
                RETURN -1;
            ELSE
                RETURN are_managerul(v_ang);
            END IF;
    END are_managerul;
        
    BEGIN
    -- cazul in care nu exista niciun manager cu codul dat
        SELECT COUNT(employee_id)
        INTO nr
        FROM employees
        WHERE employee_id = m;
        
        IF nr = 0 THEN
            INSERT INTO info_cpe VALUES (USER, SYSDATE, 'ex4', 0, 'Nu exista managerul');
            DBMS_OUTPUT.PUT_LINE('Nu exista managerul');
        ELSE
            nr := 0;
            -- trebuie sa cautam aplicam o functie recursiva pe fiecare angajat
            FOR i IN (SELECT employee_id
                      FROM employees) LOOP
                IF are_managerul(i.employee_id) = 1 THEN
                    nr := nr + 1;
                    
                    UPDATE emp_cpe
                    SET salary = salary * 1.1
                    WHERE employee_id = i.employee_id;

                END IF;

            END LOOP;
            
            IF nr != 0 THEN
                INSERT INTO info_cpe VALUES (USER, SYSDATE, 'ex4', nr , 'A mers');
                DBMS_OUTPUT.PUT_LINE('Am updatat ' || nr || ' angajati');
            ELSE
                INSERT INTO info_cpe VALUES (USER, SYSDATE, 'ex4', nr , 'Nu am gasit angajati');
                DBMS_OUTPUT.PUT_LINE('Nu am gasit angajati');
            END IF;
            
        END IF;
        
END f4_cpe;
/

BEGIN
    f4_cpe('101');
END;
/

SELECT * FROM info_cpe;
