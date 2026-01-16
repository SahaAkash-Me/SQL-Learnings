/*
UNION
UNION ALL
EXCEPT
INTERSECT
*/
												-- UNION OPERATOR --
SELECT
	FirstName AS FN,
	LastName AS LN
FROM Sales.Customers
UNION
SELECT
	FirstName,
	LastName
FROM Sales.Employees
ORDER BY FirstName;
												-- UNION ALL OPERATOR {Deosn'T Remove Duplicates} --
SELECT
	FirstName AS FN,
	LastName AS LN
FROM Sales.Customers
UNION ALL
SELECT
	FirstName,
	LastName
FROM Sales.Employees;
												-- EXCEPT OPERATOR --
 
 SELECT
	FirstName AS FN,
	LastName AS LN
FROM Sales.Employees
EXCEPT
SELECT
	FirstName,
	LastName
FROM Sales.Customers;


 SELECT
	FirstName AS FN,
	LastName AS LN
FROM Sales.Customers
EXCEPT
SELECT
	FirstName,
	LastName
FROM Sales.Employees;
												-- INTERSECT OPERATOR --
SELECT
	FirstName AS FN,
	LastName AS LN
FROM Sales.Employees
INTERSECT
SELECT
	FirstName,
	LastName
FROM Sales.Customers;

SELECT 
		'Orders' AS Source_Table,      -- THIS IS A STATIC COLUMN IN ORDER TO SEE THE SOURCE OF THE TABLE --
		[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT
	'Orders_Archive' AS Source_Table,    -- THIS IS A STATIC COLUMN IN ORDER TO SEE THE SOURCE OF THE TABLE --
	[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID;