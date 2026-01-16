USE MyDatabase; -- USING MY DATABSE --

SELECT
	first_name,
	country,
	score
FROM dbo.customers
ORDER BY 
	country ASC,
	score DESC;

SELECT					-- GROUP BY COMMAND / ALIAS AS total score--
	country,
	SUM(score) AS total_score
FROM dbo.customers
GROUP BY country
--ORDER BY total_score DESC;

							-- Find the total score and total number of customers for each country
SELECT
	country,
	SUM(score) AS total_score,
	COUNT(id) AS total_number_of_customer
FROM dbo.customers
GROUP BY country;

							-- HAVING CLAUES --
SELECT
	country,
	AVG(score) AS avg_score
FROM dbo.customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

SELECT DISTINCT
	country
FROM dbo.customers;

SELECT 	TOP 3
score
FROM dbo.customers
ORDER BY score DESC;

SELECT 	TOP 2
score
FROM dbo.customers
ORDER BY score;

SELECT *
FROM dbo.customers;

						-- STATIC VALUE EXAMPLEL BELOW --
SELECT 
	id,
	first_name,
	'static_column' AS Static_Value_Example
FROM customers;

SELECT *
FROM dbo.orders;

SELECT TOP 2*
FROM dbo.orders
ORDER BY order_date DESC;