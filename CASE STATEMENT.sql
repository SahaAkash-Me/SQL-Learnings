/*
CASE STATEMENT

CASE
	WHEN condition1 THEN result1
	WHEN condition2 THEN result 2
	. . .
	ELSE result
END

*/
USE SalesDB;

SELECT * FROM Sales.Orders;

SELECT 
	OrderID,
	ProductID,
	Quantity,
	CASE
		WHEN Quantity > 2 THEN 20
		WHEN Quantity > 1 THEN 10
		ELSE 5
	END AS [Points Added]
FROM Sales.Orders;

												-- CATEGORIZING DATA --
/*												Generate a report showing the total sales for each category:

													- High: If the sales higher than 50

													- Medium: If the sales between 20 and 50

													- Low: If the sales equal or lower than 20

													Sort the result from lowest to highest. */
SELECT 
Category,
SUM(Sales) AS [Total Sales]
FROM
	(SELECT
	OrderID,
	Sales,
	CASE
		WHEN Sales > 50 THEN 'Highest'
		WHEN Sales > 20 THEN 'Medium'
		ELSE 'Lowest'
	END AS [Category]
	FROM Sales.Orders) AS T
GROUP BY Category
ORDER BY [Total Sales] ASC;

													-- Retrive employee details with gender displayed as full text --
SELECT * FROM
	(SELECT *,
		CASE
			WHEN Gender = 'M' THEN 'Male'
			WHEN Gender = 'F' THEN 'Female'
			ELSE 'Not Available'
		End AS GenderText
	FROM Sales.Employees) AS T;

												-- Retrieve customer details with abbreviated country code --

SELECT 
	DISTINCT Country -- TO CHECK HOW MANY Distinct Values IN Country Column
FROM Sales.Customers;


SELECT * FROM (
SELECT *,
		CASE
			WHEN Country = 'Germany' THEN 'GE'
			WHEN Country = 'USA' THEN 'US'
			ELSE 'NOT FOUND'
		END AS [Country Code]
FROM Sales.Customers) AS T;

							-- ALSO --
SELECT * FROM (
	SELECT *,
			CASE Country					-- COLUMN NAME
				WHEN 'Germany' THEN 'GE'	-- COLUMN VALUE
				WHEN 'USA' THEN 'US'
				Else 'Not Found'
			END AS [Country Code]
	FROM Sales.Customers) AS T;
											-- HANDLING NULLS WITH CASE STATEMENT --
									 -- Find the average scores of customers and treat Nulls as 0 
									 --And additional provide details such CustomerID & LastName 
SELECT 
	CustomerID,
	LastName,
	Score,
	AVG(
		CASE 
			WHEN Score IS NULL THEN 0
			ELSE Score
		END) 
	OVER() AS [AVG Customer Clean]
FROM Sales.Customers;

												-- SQL TASK: Count how many times each customer has made an order with sales greater than 30.
SELECT *
FROM Sales.Orders;

SELECT 
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
		END) AS [Total Orders High Sales],
	Count(*) AS [Total Orders]
FROM Sales.Orders
GROUP BY CustomerID;