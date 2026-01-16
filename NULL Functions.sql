/*
NULL FUNCTIONS :

ISNULL - Replace NULL with a specific value  [ SYNTAX - ISNULL(VALUE,replacement_value) ]
COALESCE - Returns the first non_null value from a list [ SYNTAX - COALESCE(value1, value2,value3, ...) ]
TASK Find the average score of the customers
TASK Display the dull name of the customers ina single field.

HANDLING NULLS - JOINS
NULLIF()
IS NULL // IS NOT NULL
*/
USE SalesDB;
												--COALESCE--
SELECT 
	   [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
	  , COALESCE ( ShipAddress, BillAddress, 'Unknown') AS [Unable To Ship]
FROM Sales.Orders
-- WHERE COALESCE ( ShipAddress, BillAddress, 'Unknown') = 'Unknown';
								
												--Find the average score of the customers--
SELECT * FROM Sales.Customers;

SELECT
CustomerID,
Score,
COALESCE (Score, 0) AS [Score Without Null],
AVG(Score) OVER () [Avg Score With Null],
AVG(COALESCE (Score, 0)) OVER() AS [Average Score Without Null]
FROM Sales.Customers;

												-- Display the Full name of the customers in a single field --
												     -- Add 10 Bonus Points To Each Customer's Scores --
SELECT
CustomerID,
FirstName,
LastName,
COALESCE (LastName, ' ') AS [Null Replaced By Space],
FirstName + ' ' + LastName AS [Full Name With Null On Last Name],
FirstName + ' ' + (COALESCE (LastName, ' ')) AS [Full Name With-Out Null On Last Name],
Score AS [Score Without Bonus],
COALESCE(Score, 0) + 10 AS [Score With Bonus & Without Null]
FROM Sales.Customers;

												-- HANDLING NULLS - JOINS --
SELECT *
FROM Sales.Orders;

SELECT 
	A.OrderID,
	A.OrderStatus,
	COALESCE (A.ShipAddress, 'N.A.') AS [Ship Address Without Null],
	COALESCE (A.BillAddress, 'N.A.') AS [Bill Address Without Null]
FROM Sales.Orders AS A
LEFT JOIN Sales.Orders AS B
ON A.ShipAddress = B.ShipAddress
AND
	ISNULL(A.ShipAddress, 'N.A.') = ISNULL(B.ShipAddress, 'N.A.');

													-- Sort the customers from lowest tto hghest scores || With nulls appearing last --
SELECT
CustomerID,
Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END AS [Flag]
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score ; -- First CASE WHEN EXECUTES AND THEN SCORE --
	
														--NULL IF--
SELECT * FROM Sales.Orders;

SELECT
OrderID,
NULLIF(Quantity, 0) AS [Null Detected]
FROM Sales.Orders;
									-- Find the sales price for each order by dividing sales by quantity --
SELECT
*
FROM Sales.Orders;

SELECT
OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity, 0)  AS [ Sales Price]
FROM Sales.Orders;
														-- IS NULL // IS NOT NULL --

														-- IS NULL Use Case --
														-- Identify the customers who have no scores --
SELECT
*
FROM Sales.Customers
WHERE Score IS NULL;

SELECT
*
FROM Sales.Customers
WHERE Score IS NOT NULL;

														--list all details for customers who have not placed any orders --

SELECT 
C.*,
O.OrderID
FROM Sales.Customers AS C
LEFT JOIN Sales.Orders AS O
ON C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL;
														-- NULL VS EMPTY SPACE --
WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2,   NULL  UNION
SELECT 3,   ''    UNION
SELECT 4,   ' ' UNION
SELECT 5,   '  '
)
SELECT *,
DATALENGTH(Category) AS [Category-Len],
DATALENGTH(TRIM(Category)) AS [Policy 1],
NULLIF(TRIM(Category), '') AS [Policy 2],
COALESCE(NULLIF(TRIM(Category), ''), 'Unknown') AS [Policy 1]
FROM ORDERS;