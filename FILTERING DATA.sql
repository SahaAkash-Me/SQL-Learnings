SELECT*
FROM customers;

SELECT *
FROM customers
WHERE country != 'Germany';

SELECT *
FROM customers
WHERE score >= '500';

										-- LOGICAL OPERATORS BELOW  'AND', 'OR', 'NOT'--
SELECT *
FROM customers
WHERE
	country = 'USA' 
	AND
	score > 500;

SELECT *
FROM customers
WHERE
	country = 'USA'
	OR
	score > 500;


											    -- RANGE OPERATORS BELOW  'BETWEEN'--

SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500;		-- WE CAN ALSO USE 'WHERE score >= 100 AND score <= 500'

											    -- MEMBERSHIP OPERATORS BELOW  'IN' ,  'NOT IN'--
 
SELECT *
FROM customers
WHERE country  IN ('Germany', 'USA');
											    -- SEARCH OPERATORS BELOW  'LIKE'--
SELECT *
FROM customers
WHERE first_name LIKE 'M%'

SELECT *
FROM customers
WHERE first_name LIKE '%n'

SELECT *
FROM customers
WHERE first_name LIKE '%r%';

SELECT *
FROM customers
WHERE first_name LIKE '__r%';