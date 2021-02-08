-- Tema 6 Triggers PL/SQL

--4 
--a
CREATE TABLE info_dept_cpe (
    ID NUMBER(4),
    NUME_DEPT VARCHAR2(20),
    PLATI NUMBER(8),
    CONSTRAINT PK_ID_INFO_DEPT_CPE PRIMARY KEY(ID)
);

--b
INSERT INTO INFO_DEPT_CPE(SELECT D.DEPARTMENT_ID, MAX(D.DEPARTMENT_NAME), NVL(SUM(E.SALARY),0)
                          FROM DEPARTMENTS D, EMPLOYEES E
                          WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID (+)
                          GROUP BY D.DEPARTMENT_ID);

COMMIT;
select * from info_dept_cpe;

--5 (sus)
--a
CREATE TABLE info_emp_cpe (
    ID NUMBER (4) PRIMARY KEY,
    NUME VARCHAR2(20),
    PRENUME VARCHAR2(20),
    SALARIU NUMBER(8),
    ID_DEPT NUMBER(4) REFERENCES info_dept_cpe
);

--b
INSERT INTO info_emp_cpe(SELECT employee_id, first_name, last_name, salary, department_id
                         FROM employees);
                         
COMMIT;

select * from info_emp_cpe;

--c
CREATE OR REPLACE VIEW v_info_cpe AS
  SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, 
         d.nume_dept, d.plati 
  FROM   info_emp_cpe e, info_dept_cpe d
  WHERE  e.id_dept = d.id;
  
--d
SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_cpe');

--e
CREATE OR REPLACE TRIGGER trig5_cpe
    INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_cpe
    FOR EACH ROW
DECLARE
BEGIN
    IF INSERTING THEN 
       IF find_dep(:NEW.id_dept) THEN
          -- daca departamentul exista deja  
           INSERT INTO info_emp_cpe 
           VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu,
                   :NEW.id_dept);       
           UPDATE info_dept_cpe
           SET    plati = plati + :NEW.salariu
           WHERE  id = :NEW.id_dept;
       ELSE 
           IF :NEW.id IS NOT NULL THEN
               -- se adauga un ang intr-un dep nou
               INSERT INTO info_dept_cpe
               VALUES (:NEW.id_dept, :NEW.nume_dept, :NEW.salariu);
               
               INSERT INTO info_emp_cpe 
               VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept);  
           ELSE
              -- se adauga doar departament nou
               INSERT INTO info_dept_cpe
               VALUES (:NEW.id_dept, :NEW.nume_dept, 0);
           END IF;
           
      END IF;
    
    ELSIF DELETING THEN
       -- stergerea unui salariat din vizualizare determina
       -- stergerea din info_emp_cpe si reactualizarea in
       -- info_dept_cpe
       DELETE FROM info_emp_cpe
       WHERE  id = :OLD.id;
         
       UPDATE info_dept_cpe
       SET    plati = plati - :OLD.salariu
       WHERE  id = :OLD.id_dept;
    
    ELSIF UPDATING ('salariu') THEN
       /* modificarea unui salariu din vizualizare determina 
          modificarea salariului in info_emp_cpe si reactualizarea
          in info_dept_cpe    */
            
       UPDATE  info_emp_cpe
       SET     salariu = :NEW.salariu
       WHERE   id = :OLD.id;
            
       UPDATE info_dept_cpe
       SET    plati = plati - :OLD.salariu + :NEW.salariu
       WHERE  id = :OLD.id_dept;
    
    ELSIF UPDATING ('id_dept') THEN
        /* modificarea unui cod de departament din vizualizare
           determina modificarea codului in info_emp_cpe 
           si reactualizarea in info_dept_cpe  */  
        UPDATE info_emp_cpe
        SET    id_dept = :NEW.id_dept
        WHERE  id = :OLD.id;
        
        UPDATE info_dept_cpe
        SET    plati = plati - :OLD.salariu
        WHERE  id = :OLD.id_dept;
            
        UPDATE info_dept_cpe
        SET    plati = plati + :NEW.salariu
        WHERE  id = :NEW.id_dept;
    
    ELSIF UPDATING ('nume') THEN
        UPDATE info_emp_cpe
        SET nume = :NEW.nume
        WHERE id = :NEW.id;
    
    ELSIF UPDATING ('prenume') THEN
        UPDATE info_emp_cpe
        SET prenume = :NEW.prenume
        WHERE id = :NEW.id;
    
    ELSIF UPDATING ('nume_dept') THEN
        UPDATE info_dept_cpe
        SET nume_dept = :NEW.nume_Dept
        WHERE id = :NEW.id_dept;
  END IF;
END;
/

--f
SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_cpe');

-- adaugarea unui nou angajat
SELECT * FROM  info_dept_cpe WHERE id=10;

INSERT INTO v_info_cpe 
VALUES (400, 'N1', 'P1', 3000,10, 'Nume dept', 0);

SELECT * FROM  info_emp_cpe  WHERE id=400;
SELECT * FROM  info_dept_cpe WHERE id=10;

-- modificarea salariului unui angajat
UPDATE v_info_cpe
SET    salariu=salariu + 1000
WHERE  id=400;

SELECT * FROM  info_emp_cpe WHERE id=400;
SELECT * FROM  info_dept_cpe WHERE id=10;

-- modificarea departamentului unui angajat
SELECT * FROM  info_dept_cpe WHERE id=90;

UPDATE v_info_cpe
SET    id_dept=90
WHERE  id=400;

SELECT * FROM  info_emp_cpe WHERE id=400;
SELECT * FROM  info_dept_cpe WHERE id IN (10,90);

-- eliminarea unui angajat
DELETE FROM v_info_cpe WHERE id = 400;
SELECT * FROM  info_emp_cpe WHERE id=400;
SELECT * FROM  info_dept_cpe WHERE id = 90;

--g si h 
--adaugare ang cu dep nou
CREATE OR REPLACE FUNCTION find_dep (v_id info_dept_cpe.id%TYPE)
    RETURN BOOLEAN IS
BEGIN
    FOR dep IN 
        (SELECT id FROM info_dept_cpe) LOOP
        IF dep.id = v_id THEN
            RETURN TRUE;
        END IF;
    END LOOP;
    RETURN FALSE;
END;
/

INSERT INTO v_info_cpe 
VALUES (500, 'Petrescu', 'Cosmin', 1500, 101, 'Ceva ', 0);

SELECT * FROM  info_emp_cpe  WHERE id=500;
SELECT * FROM  info_dept_cpe WHERE id=101;
SELECT * FROM  v_info_cpe WHERE id=500;

--adaugare dep nou
INSERT INTO v_info_cpe
VALUES (NULL, NULL, NULL, NULL, 102, 'Ceva 2', NULL);

SELECT * FROM  v_info_cpe WHERE id_dept = 102;
SELECT * FROM  info_dept_cpe WHERE id = 102;

--i
SELECT * FROM v_info_cpe WHERE id = 500;
UPDATE v_info_cpe
SET prenume = 'Cossssss'
WHERE id = 500;
SELECT * FROM info_emp_cpe WHERE id=500;
SELECT * FROM v_info_cpe WHERE prenume = 'Cossssss';
-- nu se modifica nici in view nici in tabelul de baza
-- pentru ca am tratat doar cazurile de update pe salariu si id_dept (cred)

--j si k i guess
UPDATE v_info_cpe
SET prenume = 'Cossssss'
WHERE id = 500;

UPDATE v_info_cpe
SET nume = 'Pet'
WHERE id = 500;

UPDATE v_info_cpe
SET nume_dept = 'Ceva nou'
WHERE id = 500;

SELECT * FROM v_info_cpe WHERE id = 500;
SELECT * FROM info_emp_cpe WHERE id = 500;
SELECT * FROM info_dept_cpe WHERE id = 101;

-- 1
CREATE TABLE dept_cpe AS SELECT * FROM departments;
SELECT * FROM dept_cpe;

CREATE OR REPLACE TRIGGER trig1_cpe
    BEFORE DELETE ON dept_cpe
BEGIN
    IF UPPER(USER) <> 'SCOTT' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Only SCOTT can delete');
    END IF;
END;
/

DELETE FROM dept_cpe WHERE department_id = 10;

--2
SELECT * FROM emp_cpe;

CREATE OR REPLACE TRIGGER trig2_cpe
    BEFORE UPDATE OF commission_pct ON emp_cpe
    FOR EACH ROW
BEGIN
    IF (:NEW.commission_pct > 0.5) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Commission cannot be more than half the salary');
    END IF;
END;
/

UPDATE emp_cpe
SET commission_pct = 0.6
WHERE first_name = 'Steven' AND last_name = 'King';

SELECT * FROM emp_cpe WHERE first_name = 'Steven' AND last_name = 'King';

--3 a
ALTER TABLE info_dept_cpe
ADD numar NUMBER;

DESC info_dept_cpe;
SELECT * FROM info_dept_cpe;

DECLARE 
    nr NUMBER;
BEGIN
    FOR dept IN (SELECT id FROM info_dept_cpe) LOOP
        SELECT COUNT(*) 
        INTO nr
        FROM info_emp_cpe
        WHERE id_dept = dept.id;
        
        UPDATE info_dept_cpe
        SET numar = nr
        WHERE id = dept.id;
    END LOOP;
END;
/

--3 b
CREATE OR REPLACE TRIGGER trig3_cpe
    AFTER INSERT OR UPDATE OR DELETE ON info_emp_cpe
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE info_dept_cpe
        SET numar = numar + 1
        WHERE id = :NEW.id_dept;
    ELSIF UPDATING THEN
        IF (:NEW.id_dept != :OLD.id_dept) THEN
            -- daca s-a modificat dep 
            UPDATE info_dept_cpe 
            SET numar = numar + 1
            WHERE id = :NEW.id_dept;
            UPDATE info_dept_cpe 
            SET numar = numar - 1
            WHERE id = :OLD.id_dept;
        END IF;
    ELSIF DELETING THEN
        UPDATE info_dept_cpe 
        SET numar = numar - 1
        WHERE id = :OLD.id_dept;
    END IF;
END;
/

-- angagat nou
SELECT numar FROM info_dept_cpe WHERE id = 90; --3
INSERT INTO info_emp_cpe 
VALUES (503, 'A', 'B', 1, 90);
SELECT numar FROM info_dept_cpe WHERE id = 90; --4

-- modificare dept
SELECT numar FROM info_dept_cpe WHERE id = 70; --1
UPDATE info_emp_cpe
SET id_dept = 70
WHERE id = 503;
SELECT numar FROM info_dept_cpe WHERE id = 70; --2
SELECT numar FROM info_dept_cpe WHERE id = 90; --3

-- stergere ang
DELETE FROM info_emp_cpe
WHERE id = 503;
SELECT numar FROM info_dept_cpe WHERE id = 70; --1


--4
CREATE OR REPLACE TRIGGER trig4_cpe
    BEFORE INSERT ON emp_cpe
    FOR EACH ROW
DECLARE
    nr NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO nr
    FROM emp_cpe
    WHERE department_id = :NEW.department_id;
    
    IF nr = 45 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Cannot have more than 45 employees / department');
    END IF;
END;
/

--nu am testat aici 

--5 a
DESC employees;
CREATE TABLE emp_test_cpe
    (employee_id NUMBER(6) PRIMARY KEY,
     first_name VARCHAR2(20),
     last_name VARCHAR2(20),
     department_id NUMBER(4)
     );
     
INSERT INTO emp_test_cpe 
    (SELECT employee_id, first_name, last_name, department_id
     FROM emp_cpe);  
     
DESC departments;
CREATE TABLE dept_test_cpe
    (department_id NUMBER(4) PRIMARY KEY,
     department_name VARCHAR2(30)
     );

INSERT INTO dept_test_cpe 
    (SELECT department_id, department_name
     FROM dept_cpe);
     
--5 b
CREATE OR REPLACE TRIGGER trig5b_cpe
    AFTER DELETE OR UPDATE ON dept_test_cpe
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        DELETE FROM emp_test_cpe
        WHERE department_id = :OLD.department_id;
    ELSE
        UPDATE emp_test_cpe
        SET department_id = :NEW.department_id
        WHERE department_id = :OLD.department_id;
    END IF;
END;
/

INSERT INTO dept_test_cpe 
VALUES (999, 'test');
INSERT INTO emp_test_cpe
VALUES (208, 'Test', 'Test', 999);

-- modificarea unui departament
UPDATE dept_test_cpe
SET department_id = 998
WHERE department_id = 999;

SELECT * FROM dept_test_cpe;
SELECT * FROM emp_test_cpe;

--stergerea unui dep
DELETE FROM dept_test_cpe
WHERE department_id = 998;

SELECT * FROM emp_test_cpe WHERE department_id = 998;

-- nu am facut si restul liniilor

--6 a
CREATE TABLE error_log_cpe
    (user_id VARCHAR2(20),
     nume_bd VARCHAR2(20),
     erori NUMBER,
     data DATE);
     
--6 b
CREATE OR REPLACE TRIGGER trig6_cpe
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO error_log_cpe
    VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, DBMS_UTILITY.FORMAT_ERROR_STACK, SYSDATE);
END;
/

