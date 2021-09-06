CREATE TABLE centers (id BIGINT NOT NULL PRIMARY KEY,
name VARCHAR(200), city VARCHAR(200), address VARCHAR(200),
capacity INT);

INSERT INTO centers VALUE(1, 'Spitalul Judetean', 'Ploiesti',
'Strada Spitalului nr 1', 1000);
INSERT INTO centers VALUE(2, 'Clinica Petrolul', 'Ploiesti',
'Bulevardul Republicii nr 21', 150);
