CREATE TABLE persons(
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY(id)
);
										
ALTER TABLE persons
ADD 
	email VARCHAR(50) NOT NULL;

ALTER TABLE persons
DROP COLUMN phone;

DROP TABLE persons;

SELECT *
FROM customers;

INSERT INTO customers
(id, first_name, country, score)
VALUES
	(6, 'Anna', 'USA', NULL),
	(7, 'Sam', NULL, 100);
													--INSERTING DATA INTO TABLE FROM ANOTHER TABLE--

INSERT INTO persons (id, person_name, birth_date, phone)
SELECT
id,
first_name,
NULL,
'Unknown'
FROM customers;

SELECT *
FROM persons;

													-- UPDATE COMMAND BELOW --
SELECT *
FROM customers;

/*
SELECT *
FROM customers
WHERE id = 6
*/

UPDATE customers
SET score = 0
WHERE id = 6;


UPDATE customers
SET score = 0 , 
	country = 'UK'
WHERE id = 7;

UPDATE customers
SET score = 0
WHERE score IS NULL;

UPDATE customers
SET country = 'Unknown'
WHERE country IS NULL;

													-- DELETE COMMAND BELOW --
DELETE FROM customers
WHERE ID > 5; 

			-- WE CAN USE "TRUNCATE TABLE customers" - TTUNCATE Deletes the data inside a table. And Delete deletes the entire Table--