CREATE TABLE utilizatori (
    id_utilizator NUMBER(10) PRIMARY KEY,
    username VARCHAR2(100) NOT NULL, 
    email VARCHAR2(100) NOT NULL,
    parola VARCHAR2(100) NOT NULL,
    telefon VARCHAR2(20)
);

CREATE TABLE intrebari (
    id_intrebare NUMBER(10) PRIMARY KEY,
    titlu VARCHAR2(200) NOT NULL,
    continut VARCHAR2(1000) NOT NULL,
    data DATE NOT NULL,
    id_utilizator NUMBER(10) NOT NULL REFERENCES utilizatori(id_utilizator) ON DELETE CASCADE
);

CREATE TABLE raspunsuri (
    id_raspuns NUMBER(10) PRIMARY KEY,
    id_intrebare NUMBER(10) NOT NULL REFERENCES intrebari(id_intrebare) ON DELETE CASCADE,
    continut VARCHAR2(1000) NOT NULL,
    data DATE NOT NULL,
    id_utilizator NUMBER(10) NOT NULL REFERENCES utilizatori(id_utilizator) ON DELETE CASCADE
);

CREATE TABLE voturi (
    id_vot NUMBER(10) PRIMARY KEY,
    id_raspuns NUMBER(10) NOT NULL REFERENCES raspunsuri(id_raspuns) ON DELETE CASCADE,
    id_utilizator NUMBER(10) NOT NULL REFERENCES utilizatori(id_utilizator) ON DELETE CASCADE
);

CREATE TABLE roluri (
    id_rol NUMBER(2) PRIMARY KEY,
    nume VARCHAR2(100) NOT NULL
); 

CREATE TABLE etichete (
    id_eticheta NUMBER(10) PRIMARY KEY,
    titlu VARCHAR2(100) NOT NULL,
    descriere VARCHAR2(1000) NOT NULL,
    popularitate NUMBER(10)
);

CREATE TABLE roluri_utilizatori (
    id_utilizator NUMBER(10) REFERENCES utilizatori(id_utilizator) ON DELETE CASCADE,
    id_rol NUMBER(2) REFERENCES roluri(id_rol) ON DELETE CASCADE,
    PRIMARY KEY(id_utilizator, id_rol)
);
    
CREATE TABLE etichete_intrebari (
    id_intrebare NUMBER(10) REFERENCES intrebari(id_intrebare) ON DELETE CASCADE,
    id_eticheta NUMBER(10) REFERENCES etichete(id_eticheta) ON DELETE CASCADE,
    PRIMARY KEY(id_intrebare, id_eticheta)
);
/*
drop table etichete_intrebari;
drop table roluri_utilizatori;
drop table etichete;
drop table roluri;
drop table voturi;
drop table raspunsuri;
drop table intrebari;
drop table utilizatori;
*/
----------- utilizatori -----------
INSERT INTO utilizatori
VALUES(1, 'cosmin.petrescu', 'cosmin1998@gmail.com', '138AWDI2rr!sD', '0728125895');
INSERT INTO utilizatori
VALUES(2, 'Maria123', 'maria.ionescu@gmail.com', '13j!dnwd24', '0722389123');
INSERT INTO utilizatori
VALUES(3, 'AndreiPopescu', 'andrei.popescu@gmail.com', 'uhf834Ssf3!13', NULL);
INSERT INTO utilizatori
VALUES(4, 'daniVl', 'dani.vlas@gmail.com', '248jwDE!DIH3rwr', NULL);
INSERT INTO utilizatori
VALUES(5, 'jelea1980', 'vljelea@yahoo.com', '138DYqasd!fr28', NULL);

----------- roluri -----------
INSERT INTO roluri
VALUES(1, 'Beginner');
INSERT INTO roluri
VALUES(2, 'Advanced');
INSERT INTO roluri
VALUES(3, 'Veteran');
INSERT INTO roluri
VALUES(4, 'Moderator');
INSERT INTO roluri
VALUES(5, 'Editor');
INSERT INTO roluri
VALUES(6, 'Admin');

----------- roluri_utilizatori -----------
INSERT INTO roluri_utilizatori
VALUES(1, 3);
INSERT INTO roluri_utilizatori
VALUES(1, 4);
INSERT INTO roluri_utilizatori
VALUES(1, 5);
INSERT INTO roluri_utilizatori
VALUES(1, 6);
INSERT INTO roluri_utilizatori
VALUES(2, 1);
INSERT INTO roluri_utilizatori
VALUES(2, 2);
INSERT INTO roluri_utilizatori
VALUES(3, 1);
INSERT INTO roluri_utilizatori
VALUES(4, 1);
INSERT INTO roluri_utilizatori
VALUES(5, 3);
INSERT INTO roluri_utilizatori
VALUES(5, 4);

----------- etichete -----------
INSERT INTO etichete
VALUES(1, 'C', 'C is a general-purpose, procedural computer programming language supporting structured programming, 
lexical variable scope, and recursion, with a static type system. By design, C provides constructs that map 
efficiently to typical machine instructions.', 2);

INSERT INTO etichete
VALUES(2, 'C++', 'C++ is a general-purpose programming language created by Bjarne Stroustrup as an extension 
of the C programming language, or "C with Classes". The language has expanded significantly over time, 
and modern C++ now has object-oriented, generic, and functional features in addition to facilities for 
low-level memory manipulation.', NULL);

INSERT INTO etichete 
VALUES(3, 'Python 3', 'Python is an interpreted, high-level and general-purpose programming language. 
Python''s design philosophy emphasizes code readability with its notable use of significant whitespace. 
Its language constructs and object-oriented approach aim to help programmers write clear, logical code 
for small and large-scale projects', 1);

INSERT INTO etichete
VALUES(4, 'OOP', 'Object-oriented programming (OOP) is a programming paradigm based on the concept of "objects", 
which can contain data and code: data in the form of fields (often known as attributes or properties), 
and code, in the form of procedures (often known as methods).', NULL);

INSERT INTO etichete
VALUES(5, 'Java', 'Java (programming language) is a class-based, object-oriented programming language that is designed 
to have as few implementation dependencies as possible.', 3);

INSERT INTO etichete
VALUES(6, 'Android Studio', 'Android Studio is the official integrated development environment for Google''s Android 
operating system, built on JetBrains'' IntelliJ IDEA software and designed specifically for Android development.', 2);

INSERT INTO etichete
VALUES(7, 'UI', 'User interface', 1);

INSERT INTO etichete
VALUES(8, 'Multithreading', 'Multithreading specifically refers to the concurrent execution of more than one 
sequential set (thread) of instructions. Multithreaded programming is programming multiple, concurrent 
execution threads. These threads could run on a single processor. Or there could be multiple threads running 
on multiple processor cores.', 1);

INSERT INTO etichete
VALUES(9, 'Process', 'In computing, a process is the instance of a computer program that is being executed by one or 
many threads. It contains the program code and its activity. Depending on the operating system (OS), a process 
may be made up of multiple threads of execution that execute instructions concurrently.', 1);

----------- intrebari -----------
INSERT INTO intrebari
VALUES(1, 'Processes in C', 'Can anyone please explain how to create processes in C?', SYSDATE, 3);
INSERT INTO intrebari
VALUES(2, 'Multithreading in C', 'Hi! I am taking a course about operating systems at Uni and we are currently talking
about threads in C but i am having trouble understanding. Can i please get some help?', SYSDATE, 5);
INSERT INTO intrebari
VALUES(3, 'Best language for a beginner', 'Hello! I want to get into programming but i am not sure how to get started.
What language should i start learning first? I was thinking about Python or Java. Also how long will it take?
Thank you!', SYSDATE, 4);
INSERT INTO intrebari
VALUES(4, 'Activity Switch Android', 'How do you switch between activities in Android?', SYSDATE, 2);
INSERT INTO intrebari
VALUES(5, 'Android Layouts', 'What type of layout is the best in Android?', SYSDATE, 3);

----------- etichete_intrebari -----------
INSERT INTO etichete_intrebari
VALUES(1, 1);
INSERT INTO etichete_intrebari
VALUES(1, 9);
INSERT INTO etichete_intrebari
VALUES(2, 1);
INSERT INTO etichete_intrebari
VALUES(2, 8);
INSERT INTO etichete_intrebari
VALUES(3, 3);
INSERT INTO etichete_intrebari
VALUES(3, 5);
INSERT INTO etichete_intrebari
VALUES(4, 5);
INSERT INTO etichete_intrebari
VALUES(4, 6);
INSERT INTO etichete_intrebari
VALUES(5, 5);
INSERT INTO etichete_intrebari
VALUES(5, 6);
INSERT INTO etichete_intrebari
VALUES(5, 7);

----------- raspunsuri -----------
INSERT INTO raspunsuri
VALUES(1, 1, 'In UNIX you can use the syscall fork(2) which creates a "child" process and returns the process id. 
It should look like this: pit_t pid = fork(); ', SYSDATE, 2);
INSERT INTO raspunsuri
VALUES(2, 1, 'Also, if you want to write instructions for the child process you should use something like this:
if(pid == 0) /*child instructions*/ else /*parent instructions*/', SYSDATE, 1);
INSERT INTO raspunsuri
VALUES(3, 2, 'Ok so basically you need create the thread with the pthread_create function which will call
a function taken as argument. Then, to wait for the execution and get the results, you need to call 
pthread_join. Check the manual for more information about those functions./', SYSDATE, 2);
INSERT INTO raspunsuri
VALUES(4, 3, 'I would recommend starting with C++ because it will cover more details than the rest. For example,
in Python, memory managemend is not really your concern, which is not the case in C++. Java has something 
called "garbage collector" which basically automatically destroys unreachable object from the heap. 
On the other hand, Python is easier to learn.', SYSDATE, 1);
INSERT INTO raspunsuri
VALUES(5, 4, 'What you need to do is to create an instance of an intent and then call startActivityForResult(intent).
Here is an example: Intent intent = new Intent(MainActivity.this, NewActivity.class);
startActivityForResult(intent, REQUEST_CODE);. And here is the code for the second activity:
Intent intent = new Intent(); setResult(Activity.RESULT_OK, intent); For more info check the
documentation.' , SYSDATE, 5);
INSERT INTO raspunsuri
VALUES(6, 5, 'In my opinion the best is LinearLayout', SYSDATE, 5);
INSERT INTO raspunsuri
VALUES(7, 5, 'I would recomment using LinearLayout for simple UI and ConstraintLayout for something more complex', SYSDATE, 1);

----------- voturi -----------
INSERT INTO voturi
VALUES(1, 1, 1);
INSERT INTO voturi
VALUES(2, 1, 3);
INSERT INTO voturi
VALUES(3, 2, 2);
INSERT INTO voturi
VALUES(4, 3, 1);
INSERT INTO voturi
VALUES(5, 3, 5);
INSERT INTO voturi
VALUES(6, 4, 4);
INSERT INTO voturi
VALUES(7, 5, 1);
INSERT INTO voturi
VALUES(8, 7, 2);
INSERT INTO voturi
VALUES(9, 7, 3);
INSERT INTO voturi
VALUES(10, 7, 4);

COMMIT;

------------------------- Exercitiul 6
-- Procedura care primeste ca parametru id-ul unui utilizator si afiseaza date despre intrebarile compuse ce ii apartin
-- o intrebare e compusa daca are cel putin 2 etichete -- test cu 3
CREATE OR REPLACE PROCEDURE intrebarile_compuse
    (v_id utilizatori.id_utilizator%TYPE)
IS
    TYPE record_intrebari IS RECORD
        (titlu intrebari.titlu%TYPE,
         continut intrebari.continut%TYPE,
         nr_etichete NUMBER);
    TYPE table_intrebari IS TABLE OF record_intrebari;
    t table_intrebari;
    exceptie EXCEPTION;
BEGIN
    SELECT titlu, continut, COUNT(id_eticheta)
    BULK COLLECT INTO t
    FROM intrebari i JOIN etichete_intrebari e ON(i.id_intrebare = e.id_intrebare)
    WHERE id_utilizator = v_id
    GROUP BY i.id_intrebare, titlu, continut
    HAVING COUNT(id_eticheta)>=2;
    
    IF SQL%NOTFOUND THEN
        RAISE exceptie;
    END IF; 
    DBMS_OUTPUT.PUT_LINE('Intrebarile compuse ale utilizatorului cu id ' || v_id); 
    FOR i IN t.FIRST..t.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Intrebarea ' || i || ': ');
        DBMS_OUTPUT.PUT_LINE('Titlu: ' || t(i).titlu);
        DBMS_OUTPUT.PUT_LINE('Continut: ' || t(i).continut);
        DBMS_OUTPUT.PUT_LINE('Nr etichete: ' || t(i).nr_etichete);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
EXCEPTION
    WHEN exceptie THEN
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id ' || v_id || ' nu are nicio intrebare compusa');
END;
/

SET SERVEROUTPUT ON;
BEGIN
    intrebarile_compuse(3);
    intrebarile_compuse(1);
END;
/


------------------------- Exercitiul 7
-- Procedura afiseaza karma utilizatorilor, unde karma = totalul voturilor primite pe raspunsuri 
-- (nu date, de aceea nu folosesc legatura directa dintre utilizatori si voturi) + numarul de intrebari publicate
CREATE OR REPLACE PROCEDURE get_karma IS
    nr_intrebari NUMBER;
    karma NUMBER;
    CURSOR c1 IS
        SELECT u.id_utilizator utiliz, COUNT(v.id_raspuns) voturi
        FROM raspunsuri r JOIN voturi v ON(r.id_raspuns = v.id_raspuns) 
                          RIGHT JOIN utilizatori u ON(u.id_utilizator = r.id_utilizator)
        GROUP BY u.id_utilizator --grupam dupa utilizatorul care a dat raspunsul
        ORDER BY id_utilizator;
BEGIN
    FOR i IN c1 LOOP --ciclu cursor
        karma := i.voturi;
        SELECT COUNT(id_intrebare)
        INTO nr_intrebari
        FROM intrebari
        WHERE id_utilizator = i.utiliz;
        karma := karma + nr_intrebari;
        
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul ' || i.utiliz || ' are karma = ' || karma);
    END LOOP;
END;
/

BEGIN
   get_karma();
END;
/

------------------------- Exercitiul 8 
-- Functia primeste ca argument titlul unei intrebari si intoarce 
-- numarul total de voturi ale comentariilor ce apartin acelei intrebari
CREATE OR REPLACE FUNCTION intrebare_nr_voturi
    (v_titlu intrebari.titlu%TYPE)
RETURN NUMBER IS
    nr INT;
    v_id intrebari.id_intrebare%TYPE;
BEGIN
    SELECT id_intrebare
    INTO v_id
    FROM intrebari
    WHERE UPPER(titlu) = UPPER(v_titlu);
    --aici pot aparea: TOO_MANY_ROWS / NO_DATA_FOUND
    
    SELECT COUNT(id_vot)
    INTO nr
    FROM intrebari i JOIN raspunsuri r ON(i.id_intrebare = r.id_intrebare)
                     JOIN voturi v ON(v.id_raspuns = r.id_raspuns)
    WHERE i.id_intrebare = v_id;
    
    RETURN nr;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Sunt mai multe intrebari cu acest titlu');
        RETURN -1;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu am gasit intrebarea');
        RETURN -1;
END;
/

DECLARE
    ex1 NUMBER;
BEGIN
    INSERT INTO intrebari
    VALUES(6, 'For in python', 'How do you write a for in Python?', SYSDATE, 3);
    INSERT INTO intrebari
    VALUES(7, 'for in Python', 'How does for in Python work?', SYSDATE, 3);
    INSERT INTO intrebari
    VALUES(8, 'Test', 'Test?', SYSDATE, 3);
    ex1 := intrebare_nr_voturi('processes in c'); -- 3 voturi
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ex1 := intrebare_nr_voturi('processes in d'); -- nu exista titlul
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ex1 := intrebare_nr_voturi('for in python'); -- exista mai multe titluri la fel
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ex1 := intrebare_nr_voturi('test'); -- exista dar nu are voturi
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ROLLBACK;
END;
/


------------------------- Exercitiul 9
-- Procedura afiseaza pentru un rol dat ca parametru prin titlu numarul total de intrebari puse si 
-- numarul total de raspunsuri date
CREATE OR REPLACE PROCEDURE rol_intrebari_raspunsuri
    (v_nume roluri.nume%TYPE) IS
    nr_intrebari NUMBER := 0;
    nr_raspunsuri NUMBER := 0;
    rol_id roluri.id_rol%TYPE;
BEGIN

    SELECT id_rol
    INTO rol_id
    FROM roluri
    WHERE UPPER(nume) = UPPER(v_nume);
    
    FOR i IN(SELECT u.id_utilizator utiliz, COUNT(i.id_intrebare) nr
             FROM roluri r JOIN roluri_utilizatori ro ON(r.id_rol = ro.id_rol)
                           JOIN utilizatori u ON(u.id_utilizator = ro.id_utilizator)
                           LEFT JOIN intrebari i ON(i.id_utilizator = u.id_utilizator)
             WHERE ro.id_rol = rol_id
             GROUP BY u.id_utilizator) LOOP
             
             nr_intrebari := nr_intrebari + i.nr;
             FOR j IN(SELECT COUNT(id_raspuns) nr2
                      FROM raspunsuri WHERE id_utilizator = i.utiliz) LOOP
                      nr_raspunsuri := nr_raspunsuri + j.nr2;
             END LOOP;
    END LOOP;   
    
    DBMS_OUTPUT.PUT_LINE('Utilizatorii cu rolul ' || v_nume || ' au in total:');
    DBMS_OUTPUT.PUT_LINE(nr_intrebari || ' intrebari si ' || nr_raspunsuri || ' raspunsuri');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun rol cu acest nume');
END;
/
BEGIN
    rol_intrebari_raspunsuri('beginner');
    rol_intrebari_raspunsuri('admin');
    rol_intrebari_raspunsuri('test');
END;
/

------------------------- Exercitiul 10
-- Trigger de tip LMD la nivel de comanda care nu lasa decat utilizatorul Admin sa stearga utilizatori
CREATE OR REPLACE TRIGGER trigger_delete_utilizatori
    BEFORE DELETE ON utilizatori
BEGIN
    IF UPPER(USER) <> 'Admin' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Only the Admin can delete');
    END IF;
END;
/
DELETE FROM utilizatori WHERE id_utilizator = 1;


------------------------- Exercitiul 11
-- Trigger de tip LMD la nivel de linie care la inserarea in etichete_intrebari updateaza popularitatea etichetelor
CREATE OR REPLACE TRIGGER update_popularitate
    AFTER INSERT ON etichete_intrebari
    FOR EACH ROW
BEGIN
    UPDATE etichete
    SET popularitate = NVL(popularitate, 0) + 1
    WHERE id_eticheta = :NEW.id_eticheta;
END;
/

BEGIN
    INSERT INTO intrebari
    VALUES(6, 'test', 'test', SYSDATE, 4);
    INSERT INTO etichete_intrebari
    VALUES(6, 2); -- pt intrebarea 6 adaugam eticheta c++
    INSERT INTO etichete_intrebari
    VALUES(6, 8); -- si multithreading
END;
/
select * from etichete;
rollback; --rollback pentru cele 3 insert-uri

-- restauram si valorile modificate de trigger
update etichete
set popularitate = null 
where id_eticheta = 2;

update etichete
set popularitate = 1
where id_eticheta = 8;

------------------------- Exercitiul 12 
-- facut dupa exemplul din curs 
-- Trigger-ul insereaza in tabelul audit_user contextul in care s-a facut o operatie de tip LDD.
CREATE TABLE audit_user (
    nume_bd             VARCHAR2(50),
    user_logat          VARCHAR2(30),
    eveniment           VARCHAR2(20),
    tip_obiect_referit  VARCHAR2(30),
    nume_obiect_referit VARCHAR2(30),
    data                TIMESTAMP(3)
);

DESC audit_user;

CREATE OR REPLACE TRIGGER audit_schema
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO audit_user
    VALUES (
        SYS.DATABASE_NAME,
        SYS.LOGIN_USER,
        SYS.SYSEVENT,
        SYS.DICTIONARY_OBJ_TYPE,
        SYS.DICTIONARY_OBJ_NAME,
        SYSTIMESTAMP(3)
    );
END;
/

CREATE TABLE test_ex12
    (id_testt NUMBER(2) PRIMARY KEY,
     ceva_test VARCHAR2(10));
SELECT * FROM audit_user;


------------------------- Exercitiul 13
CREATE OR REPLACE PACKAGE pachet_proiect AS
    PROCEDURE intrebarile_compuse (v_id utilizatori.id_utilizator%TYPE);
    PROCEDURE get_karma;
    FUNCTION intrebare_nr_voturi (v_titlu intrebari.titlu%TYPE) RETURN NUMBER;
    PROCEDURE rol_intrebari_raspunsuri (v_nume roluri.nume%TYPE);
END pachet_proiect;
/

CREATE OR REPLACE PACKAGE BODY pachet_proiect AS

    -- Procedura care primeste ca parametru id-ul unui utilizator si afiseaza date despre intrebarile compuse ce ii apartin
    -- o intrebare e compusa daca are cel putin 2 etichete -- test cu 3
    PROCEDURE intrebarile_compuse
        (v_id utilizatori.id_utilizator%TYPE)
    IS
        TYPE record_intrebari IS RECORD
            (titlu intrebari.titlu%TYPE,
             continut intrebari.continut%TYPE,
             nr_etichete NUMBER);
        TYPE table_intrebari IS TABLE OF record_intrebari;
        t table_intrebari;
        exceptie EXCEPTION;
    BEGIN
        SELECT titlu, continut, COUNT(id_eticheta)
        BULK COLLECT INTO t
        FROM intrebari i JOIN etichete_intrebari e ON(i.id_intrebare = e.id_intrebare)
        WHERE id_utilizator = v_id
        GROUP BY i.id_intrebare, titlu, continut
        HAVING COUNT(id_eticheta)>=2;
        
        IF SQL%NOTFOUND THEN
            RAISE exceptie;
        END IF; 
        DBMS_OUTPUT.PUT_LINE('Intrebarile compuse ale utilizatorului cu id ' || v_id); 
        FOR i IN t.FIRST..t.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('Intrebarea ' || i || ': ');
            DBMS_OUTPUT.PUT_LINE('Titlu: ' || t(i).titlu);
            DBMS_OUTPUT.PUT_LINE('Continut: ' || t(i).continut);
            DBMS_OUTPUT.PUT_LINE('Nr etichete: ' || t(i).nr_etichete);
            DBMS_OUTPUT.PUT_LINE('---------------------------');
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    EXCEPTION
        WHEN exceptie THEN
            DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id ' || v_id || ' nu are nicio intrebare compusa');
    END;
    
    -- Procedura afiseaza karma utilizatorilor, unde karma = totalul voturilor primite pe raspunsuri 
    -- (nu date, de aceea nu folosesc legatura directa dintre utilizatori si voturi) + numarul de intrebari publicate
    PROCEDURE get_karma IS
        nr_intrebari NUMBER;
        karma NUMBER;
        CURSOR c1 IS
            SELECT u.id_utilizator utiliz, COUNT(v.id_raspuns) voturi
            FROM raspunsuri r JOIN voturi v ON(r.id_raspuns = v.id_raspuns) 
                              RIGHT JOIN utilizatori u ON(u.id_utilizator = r.id_utilizator)
            GROUP BY u.id_utilizator --grupam dupa utilizatorul care a dat raspunsul
            ORDER BY id_utilizator;
    BEGIN
        FOR i IN c1 LOOP --ciclu cursor
            karma := i.voturi;
            SELECT COUNT(id_intrebare)
            INTO nr_intrebari
            FROM intrebari
            WHERE id_utilizator = i.utiliz;
            karma := karma + nr_intrebari;
            
            DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul ' || i.utiliz || ' are karma = ' || karma);
        END LOOP;
    END;
    
    -- Functia primeste ca argument titlul unei intrebari si intoarce 
    -- numarul total de voturi ale comentariilor ce apartin acelei intrebari
    FUNCTION intrebare_nr_voturi
        (v_titlu intrebari.titlu%TYPE)
    RETURN NUMBER IS
        nr INT;
        v_id intrebari.id_intrebare%TYPE;
    BEGIN
        SELECT id_intrebare
        INTO v_id
        FROM intrebari
        WHERE UPPER(titlu) = UPPER(v_titlu);
        --aici pot aparea: TOO_MANY_ROWS / NO_DATA_FOUND
        
        SELECT COUNT(id_vot)
        INTO nr
        FROM intrebari i JOIN raspunsuri r ON(i.id_intrebare = r.id_intrebare)
                         JOIN voturi v ON(v.id_raspuns = r.id_raspuns)
        WHERE i.id_intrebare = v_id;
        
        RETURN nr;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Sunt mai multe intrebari cu acest titlu');
            RETURN -1;
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu am gasit intrebarea');
            RETURN -1;
    END;
    
    -- Procedura afiseaza pentru un rol dat ca parametru prin titlu numarul total de intrebari puse si 
    -- numarul total de raspunsuri date
    PROCEDURE rol_intrebari_raspunsuri
        (v_nume roluri.nume%TYPE) IS
        nr_intrebari NUMBER := 0;
        nr_raspunsuri NUMBER := 0;
        rol_id roluri.id_rol%TYPE;
    BEGIN
    
        SELECT id_rol
        INTO rol_id
        FROM roluri
        WHERE UPPER(nume) = UPPER(v_nume);
        
        FOR i IN(SELECT u.id_utilizator utiliz, COUNT(i.id_intrebare) nr
                 FROM roluri r JOIN roluri_utilizatori ro ON(r.id_rol = ro.id_rol)
                               JOIN utilizatori u ON(u.id_utilizator = ro.id_utilizator)
                               LEFT JOIN intrebari i ON(i.id_utilizator = u.id_utilizator)
                 WHERE ro.id_rol = rol_id
                 GROUP BY u.id_utilizator) LOOP
                 
                 nr_intrebari := nr_intrebari + i.nr;
                 FOR j IN(SELECT COUNT(id_raspuns) nr2
                          FROM raspunsuri WHERE id_utilizator = i.utiliz) LOOP
                          nr_raspunsuri := nr_raspunsuri + j.nr2;
                 END LOOP;
        END LOOP;   
        
        DBMS_OUTPUT.PUT_LINE('Utilizatorii cu rolul ' || v_nume || ' au in total:');
        DBMS_OUTPUT.PUT_LINE(nr_intrebari || ' intrebari si ' || nr_raspunsuri || ' raspunsuri');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun rol cu acest nume');
    END;
    
END pachet_proiect;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Din pachet');
    DBMS_OUTPUT.PUT_LINE('');
    pachet_proiect.intrebarile_compuse(3);
    pachet_proiect.intrebarile_compuse(1);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Din pachet');
    DBMS_OUTPUT.PUT_LINE('');
    pachet_proiect.get_karma();
END;
/

DECLARE
    ex1 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Din pachet');
    DBMS_OUTPUT.PUT_LINE('');
    INSERT INTO intrebari
    VALUES(6, 'For in python', 'How do you write a for in Python?', SYSDATE, 3);
    INSERT INTO intrebari
    VALUES(7, 'for in Python', 'How does for in Python work?', SYSDATE, 3);
    INSERT INTO intrebari
    VALUES(8, 'Test', 'Test?', SYSDATE, 3);
    ex1 := pachet_proiect.intrebare_nr_voturi('processes in c'); -- 3 voturi
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ex1 := pachet_proiect.intrebare_nr_voturi('processes in d'); -- nu exista titlul
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ex1 := pachet_proiect.intrebare_nr_voturi('for in python'); -- exista mai multe titluri la fel
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ex1 := pachet_proiect.intrebare_nr_voturi('test'); -- exista dar nu are voturi
    IF ex1 != -1 THEN
        DBMS_OUTPUT.PUT_LINE('Intrebarea cu acest titlu contine in total ' || ex1 || ' voturi');
    END IF;
    ROLLBACK;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Din pachet');
    DBMS_OUTPUT.PUT_LINE('');
    pachet_proiect.rol_intrebari_raspunsuri('beginner');
    pachet_proiect.rol_intrebari_raspunsuri('admin');
    pachet_proiect.rol_intrebari_raspunsuri('test');
END;
/


------------------------- Exercitiul 14
CREATE OR REPLACE PACKAGE pachet_ex14 AS
    TYPE table_etichete IS TABLE OF etichete.titlu%TYPE; -- table care retine numele etichetelor folosite
    TYPE table_raspunsuri IS TABLE OF raspunsuri%ROWTYPE; -- table care retine raspunsurile
    TYPE record_complet IS RECORD ( -- record care retine titlul, continutul, etichete si raspunsurile unei intrebari
        titlu intrebari.titlu%TYPE,
        continut intrebari.continut%TYPE,
        t_etichete table_etichete,
        t_raspunsuri table_raspunsuri);
    TYPE table_complet IS TABLE OF record_complet;
    
    intrebari_raspunsuri_etichete table_complet;
    
    PROCEDURE inserare_generala; -- Insereaza in tabloul intrebari_raspunsuri_etichete datele tuturor intrebarilor apeland 
    -- procedura inserare(id) pe fiecare id.
    PROCEDURE inserare(id_intreb intrebari.id_intrebare%TYPE);
    PROCEDURE afisare; -- afiseaza continutul intregului tablou
    
END pachet_ex14;
/

CREATE OR REPLACE PACKAGE BODY pachet_ex14 AS
    
    PROCEDURE inserare(id_intreb intrebari.id_intrebare%TYPE) IS
    v_titlu intrebari.titlu%TYPE;
    v_continut intrebari.continut%TYPE;
    BEGIN
        
        SELECT titlu, continut 
        INTO v_titlu, v_continut
        FROM intrebari
        WHERE id_intrebare = id_intreb;
        
        intrebari_raspunsuri_etichete.EXTEND;
        intrebari_raspunsuri_etichete(intrebari_raspunsuri_etichete.LAST).titlu := v_titlu;
        intrebari_raspunsuri_etichete(intrebari_raspunsuri_etichete.LAST).continut := v_continut;
        intrebari_raspunsuri_etichete(intrebari_raspunsuri_etichete.LAST).t_etichete := table_etichete();
        intrebari_raspunsuri_etichete(intrebari_raspunsuri_etichete.LAST).t_raspunsuri := table_raspunsuri();
        
        SELECT titlu 
        BULK COLLECT INTO intrebari_raspunsuri_etichete(intrebari_raspunsuri_etichete.LAST).t_etichete 
        FROM etichete JOIN etichete_intrebari USING(id_eticheta)
        WHERE id_intrebare = id_intreb;
        
        SELECT *
        BULK COLLECT INTO intrebari_raspunsuri_etichete(intrebari_raspunsuri_etichete.LAST).t_raspunsuri
        FROM raspunsuri
        WHERE id_intrebare = id_intreb;
    END;
    
    PROCEDURE afisare IS
    BEGIN
        FOR i IN intrebari_raspunsuri_etichete.FIRST..intrebari_raspunsuri_etichete.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('Titlu:');
            DBMS_OUTPUT.PUT_LINE(intrebari_raspunsuri_etichete(i).titlu);
            DBMS_OUTPUT.PUT_LINE('Continut:');
            DBMS_OUTPUT.PUT_LINE(intrebari_raspunsuri_etichete(i).continut);
            DBMS_OUTPUT.PUT_LINE('Etichete:');
            FOR j IN intrebari_raspunsuri_etichete(i).t_etichete.FIRST..intrebari_raspunsuri_etichete(i).t_etichete.LAST LOOP
                DBMS_OUTPUT.PUT_LINE(intrebari_raspunsuri_etichete(i).t_etichete(j));
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('Raspunsuri:');
            FOR j IN intrebari_raspunsuri_etichete(i).t_raspunsuri.FIRST..intrebari_raspunsuri_etichete(i).t_raspunsuri.LAST LOOP
                DBMS_OUTPUT.PUT_LINE(intrebari_raspunsuri_etichete(i).t_raspunsuri(j).continut);
                DBMS_OUTPUT.PUT_LINE('------');
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('======================================');
        END LOOP;
    END;

    PROCEDURE inserare_generala IS
    
    BEGIN
        intrebari_raspunsuri_etichete := table_complet();
        FOR i IN (SELECT id_intrebare FROM intrebari) LOOP
            inserare(i.id_intrebare);
        END LOOP;
    END;
    
END;
/

SET SERVEROUTPUT ON;
BEGIN
    pachet_ex14.inserare_generala();
    pachet_ex14.afisare();
END;
/
































