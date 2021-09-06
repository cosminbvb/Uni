CREATE TABLE drugs (id BIGINT NOT NULL PRIMARY KEY,
name VARCHAR(200), manufacturer VARCHAR(200), 
price DOUBLE, prospect VARCHAR(5000));

INSERT INTO drugs VALUE (1, 'Nurofan', 'Pfozar', 20.0,
'Nurofan 400 mg drajeuri calmează eficace un spectru larg de dureri acute.');
INSERT INTO drugs VALUE (2, 'Aspantar', 'Pfozar', 30.0,
'Aspantar actioneaza prin prevenirea formarii cheagurilor de 
sange si este utilizat pentru prevenirea repetarii infarctului 
miocardic si a accidentului vascular cerebral');

CREATE TABLE drugs_ingredients (id BIGINT NOT NULL PRIMARY KEY,
id_drug BIGINT, ingredient VARCHAR(200), quantity DOUBLE,
FOREIGN KEY (id_drug) REFERENCES drugs(id) ON DELETE CASCADE ON UPDATE CASCADE);

INSERT INTO drugs_ingredients VALUE(1, 1, 'Zahar', 0.0);
INSERT INTO drugs_ingredients VALUE(2, 1, 'Glucoza', 0.0);
INSERT INTO drugs_ingredients VALUE(3, 1, 'Ibuprofen', 400.0);
INSERT INTO drugs_ingredients VALUE(4, 2, 'Acid acetilsalicilic', 75.0);
INSERT INTO drugs_ingredients VALUE(5, 2, 'Celuloza microcristalina', 5.0);
INSERT INTO drugs_ingredients VALUE(6, 2, 'Amidon pregelatinizat', 3.0);

SELECT * FROM drugs d JOIN drugs_ingredients di ON (d.id = di.id_drug)
WHERE d.id = 1;