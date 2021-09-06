CREATE TABLE responses(id BIGINT NOT NULL PRIMARY KEY,
description VARCHAR(2000), bill_id BIGINT,
FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE ON UPDATE CASCADE);

INSERT INTO responses VALUE(1, 'Nothing abnormal, just take some nurofan', 1);

CREATE TABLE responses_treatments(
response_id BIGINT, drug_id BIGINT, hours INT,
PRIMARY KEY (response_id, drug_id),
FOREIGN KEY (response_id) REFERENCES responses(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (drug_id) REFERENCES drugs(id) ON DELETE CASCADE ON UPDATE CASCADE);

INSERT INTO responses_treatments VALUE (1, 1, 12);


CREATE TABLE appointments (id BIGINT NOT NULL PRIMARY KEY,
patient_id BIGINT, doctor_id BIGINT, nurse_id BIGINT, 
date DATE, center_id BIGINT, issueDescription VARCHAR(2000),
response_id BIGINT, status VARCHAR(10),
FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (nurse_id) REFERENCES nurses(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (center_id) REFERENCES centers(id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (response_id) REFERENCES responses(id) ON DELETE CASCADE ON UPDATE CASCADE);


INSERT INTO appointments VALUE (1, 1, 4, 6, '2022-01-01', 1,
'Headache', 1, 'completed');
INSERT INTO appointments VALUE (2, 1, NULL, NULL, '2021-05-08', 1,
'Stomach ache', NULL, 'pending');