 /*
 DATA MANIPULATION >
	CONACT - COMBINE MULTIPLE STRINGS INTO ONE
	LOWER  - CONVERTS EVERYTHING TO LOWER CASE
						& 
	UPPER - CONVERTS EVERYTHING TO UPPER CASE
	TRIM - REMOVES LEADING AND TRAINLING SPACES IN A STRING VALUE
	REPLACE - REPLACES SPECIFIC CHARACTER WITH A NEW CHARACTER

CALCULATION >
	LENGTH - COUNTS HOW MANY CHARACTERS ARE IN  ONE VALUE

STING EXTRACTION >
	LEFT - EXTRACTS SPECIFIC NUMBER OF CHARACTIERS FROM THE START
	&
	RIGHT - EXTRACTS SPECIFIC NUMBER OF CHARACTIERS FROM THE END.
	SUBSTRING -EXTRACTS A PART OF STRING AT A SPECIFIC POSITION
 */
													-- CONACT --
SELECT
	first_name,
	country,
CONCAT ( first_name,' ', country ) AS Name_Country
FROM customers;
													-- LOWER & UPPER --
SELECT
	first_name,
	country,
CONCAT ( first_name,' ', country ) AS Name_Country,
LOWER (first_name) AS LOWER_FIRST_NAME
FROM customers;

SELECT
	first_name,
	country,
CONCAT ( first_name,' ', country ) AS Name_Country,
UPPER (first_name) AS UPPER_FIRST_NAME
FROM customers;
													-- TRIM --
SELECT
	first_name
FROM 
	customers
WHERE 
	first_name != TRIM(first_name);  -- THIS IS HOW WE CAN CHECK THE STRING VALUE WITH SPACES , WE CAN ALSO CHECK SPACES BY 'LENGTH FUNCTION'--

 SELECT
	first_name AS FN,
	TRIM(first_name) AS Trimmed_Name,
	LEN(first_name) AS LEN_NAME,
	LEN(TRIM(first_name)) AS LEN_AFTR_TRMD,
	LEN(first_name) - LEN(TRIM(first_name)) AS Trimmed_Value
FROM customers;
													-- REPLACE --
SELECT
	'123-456-7890'AS STATIC_VALUE,
REPLACE ('123-456-7890', '-', '') AS CLEAN_NUMBER;

SELECT
	'report.txt' AS old_file_name,
REPLACE ('report.txt', 'txt', 'csv') AS new_file_name;
													-- LENGTH --
SELECT
	first_name,
	LEN(first_name) AS Length_Count
From customers;
													-- LEFT & RIGHT--
SELECT
	LEFT(first_name, 2) AS first_2_characters
FROM customers;

SELECT
	LEFT(TRIM(first_name), 2) AS first_2_characters
FROM customers;

SELECT
LEFT(TRIM(first_name), 2) AS first_2_characters,
	RIGHT(first_name, 2) AS last_2_characters
FROM customers;
													-- SUBSTRING --
SELECT
	SUBSTRING(first_name,3,2)		   -- SUBSTRING ( VALUE, STARTING POSITION, LENGTH ) --
FROM customers;

SELECT
	SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS SUB_NAME	   -- SUBSTRING ( VALUE, STARTING POSITION, LENGTH ) --
FROM customers;