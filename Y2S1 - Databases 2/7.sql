-- Tema PL/SQL 7 - Exceptii

--1
CREATE TABLE error_cpe
    (cod NUMBER,
     mesaj VARCHAR2(100));
     
-- Varianta 1
DECLARE
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    exceptie EXCEPTION;
    x NUMBER := &x;
BEGIN
    IF x<0 THEN RAISE exceptie;
    ELSE 
        x := SQRT(x);
        DBMS_OUTPUT.PUT_LINE(x);
    END IF;
EXCEPTION
    WHEN exceptie THEN
        v_cod := -20001;
        v_mesaj := 'Numarul nu e pozitiv';
        INSERT INTO error_cpe
        VALUES (v_cod, v_mesaj);
END;
/

SELECT * FROM error_cpe;

-- Varianta 2
DECLARE 
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    x NUMBER := &x;
BEGIN
    x := SQRT(x);
    DBMS_OUTPUT.PUT_LINE(x);
EXCEPTION
    WHEN VALUE_ERROR THEN
        v_cod := SQLCODE;
        v_mesaj := SUBSTR(SQLERRM, 1, 100);
        INSERT INTO error_cpe
        VALUES (v_cod, v_mesaj);
END;
/ 

SELECT * FROM error_cpe;

--2
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DECLARE
    salariu NUMBER := &salariu;
    nume emp_cpe.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO nume
    FROM emp_cpe
    WHERE salary = salariu;
    DBMS_OUTPUT.PUT_LINE('Angajatul care castiga '||salariu||' are numele '||nume);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista salariati care sa castige '||salariu);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multi salariati care castiga '||salariu);
END;
/

SELECT COUNT(*), salary FROM emp_cpe GROUP BY salary;

--3
ALTER TABLE dept_cpe
ADD CONSTRAINT c_pr_cpe PRIMARY KEY(department_id);
ALTER TABLE emp_cpe
ADD CONSTRAINT c_ex_cpe FOREIGN KEY(department_id)
    REFERENCES dept_cpe;
    
SELECT * FROM emp_cpe WHERE department_id = 110;

UPDATE dept_cpe
SET department_id = 280
WHERE department_id = 110; -- => ORA-02292: integrity constraint (GRUPA243.C_EX_CPE) violated - child record found

ACCEPT p_cod_vechi PROMPT 'Codul pe care vreti sa il schimbati: ';
ACCEPT p_cod_nou PROMPT 'Noul cod: ';
DECLARE
    exceptie EXCEPTION;
    PRAGMA EXCEPTION_INIT(exceptie, -02292);
BEGIN
    UPDATE dept_cpe
    SET department_id = &p_cod_nou
    WHERE department_id = &p_cod_vechi;
EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE('Nu puteti schimba codul unui departament in care lucreaza angajati');
END;
/

--4
ACCEPT ang_min PROMPT 'Numarul minim de angajati: ';
ACCEPT ang_max PROMPT 'Numarul maxim de angajati: ';

DECLARE
    exceptie EXCEPTION;
    nume dept_cpe.department_name%TYPE;
    numar_ang NUMBER;
BEGIN
    SELECT department_name
    INTO nume
    FROM dept_cpe
    WHERE department_id = 10;
    
    SELECT COUNT(*) 
    INTO numar_ang
    FROM emp_cpe
    WHERE department_id = 10;
    
    IF numar_ang >= &ang_min AND numar_ang <= &ang_max THEN
        DBMS_OUTPUT.PUT_LINE(nume);
    ELSE
        RAISE exceptie;
    END IF;
EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE('Numarul de angajati nu se afla in intervalul ['||&ang_min||', '||&ang_max||']');
END;
/

--5
ACCEPT cod_dep PROMPT 'Introduceti codul departamentului: ';
BEGIN
    UPDATE dept_cpe
    SET department_name = 'Nume nou'
    WHERE department_id = &cod_dep;
    
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Departamentul nu exista');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Departamentul '||&cod_dep||' se numeste acum "Nume nou"');
    END IF;
END;
/

--6 
-- Varianta 1 - cu numar de ordine
ACCEPT locatie PROMPT 'Introduceti codul locatiei: '
ACCEPT departament PROMPT 'Introduceti codul departamentului: '

DECLARE
    v_nr NUMBER(1) := 1;
    v_nume1 dept_cpe.department_name%TYPE;
    v_nume2 dept_cpe.department_name%TYPE;
BEGIN
    SELECT department_name
    INTO v_nume1
    FROM dept_cpe
    WHERE location_id = &locatie;
    
    v_nr := 2;
    SELECT department_name
    INTO v_nume2
    FROM dept_cpe
    WHERE department_id = &departament;
    
    DBMS_OUTPUT.PUT_LINE(v_nume1);
    DBMS_OUTPUT.PUT_LINE(v_nume2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Comanda SELECT cu numarul ' ||v_nr|| ' nu returneaza nimic');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Prima comana SELECT a returnat mai multe linii');
END;
/
select * from dept_cpe; --1800 2000 1700 / 10 280

-- Varianta 2 - fiecare comanda e inclusa intr-un subbloc
DECLARE
    v_nume1 dept_cpe.department_name%TYPE;
    v_nume2 dept_cpe.department_name%TYPE;
BEGIN
    BEGIN
        SELECT department_name
        INTO v_nume1
        FROM dept_cpe
        WHERE location_id = &locatie;
        DBMS_OUTPUT.PUT_LINE(v_nume1);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Prima comana SELECT a returnat mai multe linii');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Prima comanda SELECT nu returneaza nimic');
    END;
    
    BEGIN
        SELECT department_name
        INTO v_nume2
        FROM dept_cpe
        WHERE department_id = &departament;
        DBMS_OUTPUT.PUT_LINE(v_nume2);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('A doua comanda SELECT nu returneaza nimic');
    END; 
END;
/

SET VERIFY ON;
SET SERVEROUTPUT OFF;









