CREATE TABLE patients (id BIGINT NOT NULL PRIMARY KEY, 
firstName VARCHAR(200), lastName VARCHAR(200),
cnp BIGINT, dateOfBirth VARCHAR(20), phoneNumber VARCHAR(20),
emailAddress VARCHAR(100), password VARCHAR(50))

CREATE TABLE doctors (id BIGINT NOT NULL PRIMARY KEY, 
firstName VARCHAR(200), lastName VARCHAR(200),
cnp BIGINT, dateOfBirth VARCHAR(20), phoneNumber VARCHAR(20),
emailAddress VARCHAR(100), password VARCHAR(50), speciality VARCHAR(200),
salary DOUBLE, hireDate DATE)

CREATE TABLE nurses (id BIGINT NOT NULL PRIMARY KEY, 
firstName VARCHAR(200), lastName VARCHAR(200),
cnp BIGINT, dateOfBirth VARCHAR(20), phoneNumber VARCHAR(20),
emailAddress VARCHAR(100), password VARCHAR(50), hireDate DATE,
salary DOUBLE)

INSERT INTO patients VALUE (1, 'Cosmin', 'Petrescu', 
5000000111111, '05.09.2000', '0728000001', 'cosmin.petrescu@my.fmi.unibuc.ro',
SHA1('password1'));
INSERT INTO patients VALUE (2, 'Tudor', 'Plescaru', 
5000000111121, '09.11.2000', '0728000002', 'tudor.plescaru@my.fmi.unibuc.ro',
SHA1('password2'));
INSERT INTO patients VALUE (3, 'Daniel', 'Vlascenco', 
5000000111131, '29.01.2000', '0728000003', 'daniel.vlascenco@my.fmi.unibuc.ro',
SHA1('password3'));

INSERT INTO doctors VALUE (4, 'Andrei', 'Pantea', 
5000000111141, '29.01.2000', '0728000003', 'andrei.pantea@doctor.ro',
SHA1('password4'), 'Cardio', 5000.0, '2021-05-07');
INSERT INTO doctors VALUE (5, 'Meredith', 'Grey', 
5000000111142, '29.01.2000', '0728000005', 'meredith.grey@doctor.ro',
SHA1('password5'), 'Neuro', 6000.0, '2021-05-07');

INSERT INTO nurses VALUE (6, 'Andreea', 'Ionescu', 
5000000111152, '29.01.2000', '0728000006', 'andreea.ionescu@nurse.ro',
SHA1('password6'), '2021-05-07', 3000.0);
INSERT INTO nurses VALUE (7, 'Ion', 'Popescu', 
5000000111161, '29.01.2000', '0728000007', 'ion.popescu@nurse.ro',
SHA1('password7'), '2021-05-07', 3000.0);