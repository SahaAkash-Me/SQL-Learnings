/*
Window Aggregate
	COUNT
*/

USE SalesDB;

-- COUNT

SELECT
	COUNT(*) OVER()
FROM Sales.Customers