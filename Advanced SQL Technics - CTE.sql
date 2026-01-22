/* ==============================================================================
   SQL Common Table Expressions (CTEs)
-------------------------------------------------------------------------------
   This script demonstrates the use of Common Table Expressions (CTEs) in SQL Server.
   It includes examples of non-recursive CTEs for data aggregation and segmentation,
   as well as recursive CTEs for generating sequences and building hierarchical data.

   Table of Contents:
     1. NON-RECURSIVE CTE
     2. RECURSIVE CTE | GENERATE SEQUENCE
     3. RECURSIVE CTE | BUILD HIERARCHY
=============================================================================== */
/*
		USE SalesDB;

		SELECT
			*
		FROM INFORMATION_SCHEMA.COLUMNS;

		SELECT 
			DISTINCT TABLE_NAME
		FROM INFORMATION_SCHEMA.COLUMNS; 
*/

USE SalesDB;

/* ==============================================================================
   NON-RECURSIVE CTE
===============================================================================*/
-- Step1: Find the total Sales Per Customer (Standalone CTE)

WITH CTE_Total_Sales AS
(
SELECT
	CustomerID,
	SUM(Sales) AS Total_Sales
FROM Sales.Orders
GROUP BY CustomerID
)
-- Step2: Find the last order date for each customer (Standalone CTE)
, CTE_Last_Order AS 
(
SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
)
-- Step3: Rank Customers based on Total Sales Per Customer (Nested CTE)
, CTE_RANK AS
(
SELECT
	CustomerID,
	Total_Sales,
	RANK() OVER(Order BY Total_Sales DESC) AS Ranks
FROM CTE_Total_Sales
)
-- Step4: segment customers based on their total sales (Nested CTE)
, CTE_Customer_Rank AS
(
SELECT
	CustomerID,
	Total_Sales,
	RANK() OVER(ORDER BY Total_Sales DESC) AS CustomerRank
FROM CTE_Total_Sales
)

-- Main Query
SELECT
	C.CustomerID,
	CONCAT(C.FirstName, ' ', C.LastName) AS Full_Name,
	CTS.Total_Sales,
	CLO.Last_Order,
	CCR.CustomerRank
FROM Sales.Customers AS C
LEFT JOIN CTE_Total_Sales AS CTS		
ON CTS.CustomerID = C.CustomerID
LEFT JOIN CTE_Last_Order AS CLO
ON C.CustomerID = CLO.CustomerID
LEFT JOIN CTE_Customer_Rank AS CCR
ON C.CustomerID = CCR.CustomerID;
