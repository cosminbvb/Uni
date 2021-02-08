CREATE TABLE emp_cpe AS SELECT * FROM employees;

--1 (cu index by table)
DECLARE
    TYPE table_ang IS TABLE OF emp_cpe.employee_id%TYPE
    INDEX BY BINARY_INTEGER;
    t table_ang;
    salariu emp_cpe.salary%TYPE; --pt a retine salariul inainte de modificare
BEGIN
    SELECT employee_id
    BULK COLLECT INTO t
    FROM (SELECT *
          FROM emp_cpe
          WHERE commission_pct IS NULL
          ORDER BY salary)
    WHERE ROWNUM<=5;
    --am pus in t primii 5 angajati care nu castiga comision
    --si au cel mai mic salariu
    FOR i IN t.FIRST..t.LAST LOOP
        --pentru fiecare angajat din t
        --ii aflam salariul vechi
        SELECT salary
        INTO salariu
        FROM emp_cpe
        WHERE employee_id = t(i); 
        --afisam salariu vechi si cel nou
        DBMS_OUTPUT.PUT_LINE(t(i) || ':' || salariu || '->' || (salariu+salariu*0.05));
        --ii updatam salariul
        UPDATE emp_cpe 
        SET salary = salary + salary * 0.05
        WHERE employee_id = t(i);
    END LOOP;
END;
/
rollback;

--1 (cu varray)
DECLARE
    TYPE table_ang IS VARRAY(5) OF emp_cpe.employee_id%TYPE;
    t table_ang;
    salariu emp_cpe.salary%TYPE; --pt a retine salariul inainte de modificare
BEGIN
    SELECT employee_id
    BULK COLLECT INTO t
    FROM (SELECT *
          FROM emp_cpe
          WHERE commission_pct IS NULL
          ORDER BY salary)
    WHERE ROWNUM<=5;
    --am pus in t primii 5 angajati care nu castiga comision
    --si au cel mai mic salariu
    FOR i IN t.FIRST..t.LAST LOOP
        --pentru fiecare angajat din t
        --ii aflam salariul vechi
        SELECT salary
        INTO salariu
        FROM emp_cpe
        WHERE employee_id = t(i); 
        --afisam salariu vechi si cel nou
        DBMS_OUTPUT.PUT_LINE(t(i) || ':' || salariu || '->' || (salariu+salariu*0.05));
        --ii updatam salariul
        UPDATE emp_cpe 
        SET salary = salary + salary * 0.05
        WHERE employee_id = t(i);
    END LOOP;
END;
/

--1 (cu nested table)
DECLARE
    TYPE table_ang IS TABLE OF emp_cpe.employee_id%TYPE;
    t table_ang;
    salariu emp_cpe.salary%TYPE; --pt a retine salariul inainte de modificare
BEGIN
    SELECT employee_id
    BULK COLLECT INTO t
    FROM (SELECT *
          FROM emp_cpe
          WHERE commission_pct IS NULL
          ORDER BY salary)
    WHERE ROWNUM<=5;
    --am pus in t primii 5 angajati care nu castiga comision
    --si au cel mai mic salariu
    FOR i IN t.FIRST..t.LAST LOOP
        --pentru fiecare angajat din t
        --ii aflam salariul vechi
        SELECT salary
        INTO salariu
        FROM emp_cpe
        WHERE employee_id = t(i); 
        --afisam salariu vechi si cel nou
        DBMS_OUTPUT.PUT_LINE(t(i) || ':' || salariu || '->' || (salariu+salariu*0.05));
        --ii updatam salariul
        UPDATE emp_cpe 
        SET salary = salary + salary * 0.05
        WHERE employee_id = t(i);
    END LOOP;
END;
/

--2
CREATE TYPE tip_orase_cpe IS VARRAY(100) OF VARCHAR2(20);

CREATE TABLE excursie_cpe (
    cod_excursie NUMBER(4),
    denumire VARCHAR2(20),
    orase tip_orase_cpe,
    status VARCHAR2(12)
);

DECLARE
    cod_b1 NUMBER(4);
    orase_b1 tip_orase_cpe;
    
    oras1_b3 VARCHAR2(20);
    oras2_b3 VARCHAR2(20);
    indice1 NUMBER;
    indice2 NUMBER;
    
    oras_b4 VARCHAR2(20);
    indice_b4 NUMBER;
    orase_b4 tip_orase_cpe := tip_orase_cpe();
    
    cod_c NUMBER(4);
    orase_c tip_orase_cpe;
    
    TYPE tablou IS TABLE OF excursie_cpe%ROWTYPE
    INDEX BY BINARY_INTEGER;
    table_d tablou;
    
    minim_orase NUMBER(4) := 9999;
BEGIN
    
    --a
    INSERT INTO excursie_cpe VALUES 
    (1,'Germania',tip_orase_cpe('Munchen','Berlin','Dortmund'),'disponibila');
    INSERT INTO excursie_cpe VALUES
    (2, 'Spania', tip_orase_cpe('Madrid','Barcelona'),'disponibila');
    INSERT INTO excursie_cpe VALUES
    (3, 'Austria', tip_orase_cpe('Ischgl', 'Solden', 'Innsbruck'), 'disponibila');
    INSERT INTO excursie_cpe VALUES
    (4, 'Italia', tip_orase_cpe('Milan', 'Roma'), 'disponibila');
    INSERT INTO excursie_cpe VALUES
    (5, 'Romania', tip_orase_cpe('Sinaia', 'Busteni', 'Azuga', 'Predeal'), 'disponibila');
    
    --b1
    cod_b1 := &cod_b1;
    SELECT orase
    INTO orase_b1
    FROM excursie_cpe
    WHERE cod_excursie = cod_b1;
    orase_b1.EXTEND;
    orase_b1(orase_b1.COUNT) := 'Frankfurt';
    UPDATE excursie_cpe
    SET orase = orase_b1
    WHERE cod_excursie = cod_b1;
    
    --b2
    orase_b1.EXTEND;
    FOR i IN REVERSE (orase_b1.FIRST + 2)..orase_b1.LAST LOOP
        orase_b1(i) := orase_b1(i-1);
    END LOOP;
    orase_b1(2) := 'Aachen';
    UPDATE excursie_cpe
    SET orase = orase_b1
    WHERE cod_excursie = cod_b1;
    
    --b3
    oras1_b3 := '&oras1_b3';
    oras2_b3 := '&oras2_b3';
    FOR i IN orase_b1.FIRST..orase_b1.LAST LOOP
        IF orase_b1(i) = oras1_b3 THEN indice1 := i;
        END IF;
        IF orase_b1(i) = oras2_b3 THEN indice2 := i;
        END IF;
    END LOOP;
    orase_b1(indice1):=oras2_b3;
    orase_b1(indice2):=oras1_b3;
    UPDATE excursie_cpe
    SET orase = orase_b1
    WHERE cod_excursie = cod_b1;
    
    --b4
    oras_b4 := '&oras_b4';
    FOR i IN orase_b1.FIRST..orase_b1.LAST LOOP
        IF orase_b1(i) <> oras_b4 THEN
            orase_b4.EXTEND;
            orase_b4(orase_b4.LAST):=orase_b1(i);
        END IF;
    END LOOP;
    UPDATE excursie_cpe
    SET orase = orase_b4
    WHERE cod_excursie = cod_b1; 
    
    --c
    cod_c := &cod_c;
    SELECT orase
    INTO orase_c
    FROM excursie_cpe
    WHERE cod_excursie = cod_c;
    DBMS_OUTPUT.PUT_LINE('Excursia ' || cod_c ||' are '||orase_c.COUNT||' orase');
    FOR i IN orase_c.FIRST..orase_c.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(orase_c(i));
    END LOOP;
    
    --d
    SELECT * 
    BULK COLLECT INTO table_d
    FROM excursie_cpe;
    FOR i IN table_d.FIRST..table_d.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Excursia '||table_d(i).cod_excursie||':');
        FOR j IN table_d(i).orase.FIRST..table_d(i).orase.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(table_d(i).orase(j));
        END LOOP;
    END LOOP;
    
    --e
    FOR i IN table_d.FIRST..table_d.LAST LOOP
        IF table_d(i).orase.COUNT < minim_orase THEN
            minim_orase := table_d(i).orase.COUNT;
        END IF;
    END LOOP;
    FOR i IN table_d.FIRST..table_d.LAST LOOP
        IF table_d(i).orase.COUNT = minim_orase THEN
            UPDATE excursie_cpe
            SET status = 'anulat'
            WHERE cod_excursie = table_d(i).cod_excursie;
        END IF;
    END LOOP;
    
END; 
/

rollback;
SELECT * FROM excursie_cpe;
