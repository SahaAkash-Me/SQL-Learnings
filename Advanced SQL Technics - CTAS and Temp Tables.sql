/* ==============================================================================
   SQL Temporary Tables
-------------------------------------------------------------------------------
   This script provides a generic example of data migration using a temporary
   table. 
=================================================================================
*/

/* ==============================================================================
   Step 1: Create Temporary Table (#Orders)
============================================================================== */
SELECT
    *
INTO #Orders
FROM Sales.Orders;
  
/* ==============================================================================
   Step 2: Clean Data in Temporary Table
============================================================================== */
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';
  
/* ==============================================================================
   Step 3: Load Cleaned Data into Permanent Table (Sales.OrdersTest)
============================================================================== */
SELECT
    *
INTO Sales.OrdersTest
FROM #Orders;
 /*=============================================================================== */

														 /* ==============================================================================
																				 CTAS = Create Table As Select
														============================================================================== */

 -- IF DATA GETS UPDATED INSIDE MAIN TABLE, THIS TABLE'S DATA WONT BE CHANGED 

SELECT
	DATENAME(month, OrderDate) AS OrderMonth,
	COUNT(OrderID) AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);
 
DROP TABLE Sales.MonthlyOrders;

 -- BUT TO UPDATE DATA ON Temporry Table 

 IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrders;
GO
 SELECT
	DATENAME(month, OrderDate) AS OrderMonth,
	COUNT(OrderID) AS TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

/*
===============================================================================
PHYSICAL DATA MART NOTE
===============================================================================
Physical Data Mart
Persisting the Data Marts of a DWH (Data Warehouse)
improves the speed of data retrieval
compared to using views.
*/


/*
The 'U' stands for User-defined Table.
SQL Server uses these short codes to distinguish between different types of objects in your database. Without that 'U', 
SQL wouldn't know if you were looking for a table, a view, or a stored procedure named "MonthlyOrders."

U	User-defined Table (Your physical data tables)
V	View (Like the virtual tables we just discussed)
P	Stored Procedure
FN	SQL Scalar Function
TF	Table-valued Function
S	System Table
*/