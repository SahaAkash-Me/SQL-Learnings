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
, CTE_Customer_RANK AS
(
SELECT
	CustomerID,
	Total_Sales,
	RANK() OVER(Order BY Total_Sales DESC) AS Ranks
FROM CTE_Total_Sales
)
-- Step4: segment customers based on their total sales (Nested CTE)
, CTE_Customer_Sgegment AS
(
SELECT
	CustomerID,
	Total_Sales,
	CASE 
		WHEN Total_Sales > 100 THEN 'HIGH'
		WHEN Total_Sales > 50 THEN 'MEDIUM'
		ELSE 'LOW'
	END CustomerSegments
FROM CTE_Total_Sales
)

-- Main Query
SELECT
	C.CustomerID,
	CONCAT(C.FirstName, ' ', C.LastName) AS Full_Name,
	CTS.Total_Sales,
	CLO.Last_Order,
	CCR.Ranks
FROM Sales.Customers AS C
LEFT JOIN CTE_Total_Sales AS CTS		
ON CTS.CustomerID = C.CustomerID
LEFT JOIN CTE_Last_Order AS CLO
ON C.CustomerID = CLO.CustomerID
LEFT JOIN CTE_Customer_Rank AS CCR
ON C.CustomerID = CCR.CustomerID
LEFT JOIN CTE_Customer_Sgegment AS CCS
ON C.CustomerID = CCS.CustomerID;

/* ==============================================================================
   RECURSIVE CTE | GENERATE SEQUENCE
===============================================================================*/

/* TASK 2:
   Generate a sequence of numbers from 1 to 20.
*/
WITH Series AS (
    -- Anchor Query
    SELECT 1 AS MyNumber
    UNION ALL
    -- Recursive Query
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 20
)
-- Main Query
SELECT *
FROM Series

/* TASK 3:
   Generate a sequence of numbers from 1 to 1000.
*/
WITH Series AS
(
    -- Anchor Query
    SELECT 1 AS MyNumber
    UNION ALL
    -- Recursive Query
    SELECT MyNumber + 1
    FROM Series
    WHERE MyNumber < 1000
)
-- Main Query
SELECT *
FROM Series
OPTION (MAXRECURSION 5000);

/* ==============================================================================
   RECURSIVE CTE | BUILD HIERARCHY
===============================================================================*/

/* TASK 4:
   Build the employee hierarchy by displaying each employee's level within the organization.
   - Anchor Query: Select employees with no manager.
   - Recursive Query: Select subordinates and increment the level.
 */

WITH CTE_Emp_Hierarchy AS
(
    -- Anchor Query: Top-level employees (no manager)
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 AS Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive Query: Get subordinate employees and increment level
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    FROM Sales.Employees AS e
    INNER JOIN CTE_Emp_Hierarchy AS ceh
        ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT *
FROM CTE_Emp_Hierarchy;
