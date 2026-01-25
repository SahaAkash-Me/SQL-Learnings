/* ==============================================================================
   SQL Views
-------------------------------------------------------------------------------
   This script demonstrates various view use cases in SQL Server.
   It includes examples for creating, dropping, and modifying views, hiding
   query complexity, and implementing data security by controlling data access.

   Table of Contents:
     1. Create, Drop, Modify View
     2. USE CASE - HIDE COMPLEXITY
     3. USE CASE - DATA SECURITY
===============================================================================
*/

USE SalesDB;

/* ==============================================================================
   CREATE, DROP, MODIFY VIEW
===============================================================================*/

-- Find the running total of sales for each month

WITH CTE_Monthly_Summary AS
(
SELECT
	DATETRUNC(month, OrderDate) AS OrderMonth,
	SUM(Sales) AS TotalSales,
	COUNT(OrderID) AS TotalOrders,
	SUM(Quantity) AS TotalQuantities
FROM Sales.Orders
GROUP BY DATETRUNC(month, OrderDate)
)
SELECT
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER(Order BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary;

/* ==============================================================================
   CREATE, DROP, MODIFY VIEW
===============================================================================*/

/* TASK:
   Create a view that summarizes monthly sales by aggregating:
     - OrderMonth (truncated to month)
     - TotalSales, TotalOrders, and TotalQuantities.
*/
-- Create View
CREATE VIEW Sales.V_Monthly_Summary AS
(
    SELECT 
        DATETRUNC(month, OrderDate) AS OrderMonth,
        SUM(Sales) AS TotalSales,
        COUNT(OrderID) AS TotalOrders,
        SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)
GO

SELECT * FROM Sales.V_Monthly_Summary;


-- IN MSSQL WE USE BELOW Process [T-SQL -- Transact SQL]
-- Drop View if it exists
IF OBJECT_ID ('Sales.V_Monthly_Summary', 'V') IS NOT NULL   -- IN Postgree SQL We can use " CREATE OR REPLACE VIEW ales.V_Monthly_Summary AS " - To replace the name
	DROP VIEW Sales.V_Monthly_Summary;
GO
-- Re-create the view with modified logic
CREATE VIEW Sales.V_Monthly_Summary AS			
(
    SELECT 
        DATETRUNC(month, OrderDate) AS OrderMonth,
        SUM(Sales) AS TotalSales,
        COUNT(OrderID) AS TotalOrders,
        SUM(Quantity) AS TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)
GO
/* ==============================================================================
   VIEW USE CASE | HIDE COMPLEXITY
===============================================================================*/

/* TASK:
   Create a view that combines details from Orders, Products, Customers, and Employees.
   This view abstracts the complexity of multiple table joins.
*/
CREATE VIEW Sales.V_Order_Details AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e ON e.EmployeeID = o.SalesPersonID
);
GO
/* ==============================================================================
   VIEW USE CASE | DATA SECURITY
===============================================================================*/

/* TASK:
   Create a view for the EU Sales Team that combines details from all tables,
   but excludes data related to the USA.
*/
 
CREATE VIEW Sales.V_Order_Details_EU AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders AS o
    LEFT JOIN Sales.Products AS p ON p.ProductID = o.ProductID
    LEFT JOIN Sales.Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN Sales.Employees AS e ON e.EmployeeID = o.SalesPersonID
    WHERE c.Country != 'USA'
);
GO

/*
    VIEWS
    - Virtual Table based on result of Query without storing data.
    - We use Views to persist Complex SQL Query in Database.
    - Views are better than CTE - improves reusability in multiple Queries.
    - Views are better than Tables - Flexible & ease to maintain.

    USE CASES
    - Store central Complex Business logic to be reused.
    - Hide Complexity by offering friendly views to users.
    - Data Security by hiding sensitive rows & columns.
    - Flexibility & Dynamic.
    - Offer your objects in Multiple Languages.
    - Virtual layer (Data Marts) in Data warehouses.
*/
