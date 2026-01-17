/* ==============================================================================
   SQL Window Aggregate Functions
-------------------------------------------------------------------------------
   These functions allow you to perform aggregate calculations over a set 
   of rows without the need for complex subqueries. They enable you to compute 
   counts, sums, averages, minimums, and maximums while still retaining access 
   to individual row details.

   Table of Contents:
    1. COUNT
    2. SUM
    3. AVG
    4. MAX / MIN
    5. RUNNING Total | ROLLING Total
===============================================================================
*/

USE SalesDB;

-- COUNT
-- Find the total number of Orders
-- Find the total number of Orders for each customers
-- Additionally provide details such order Id, order date

SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() AS TotalOrders,
	Count(*) OVER(PARTITION BY CustomerID) AS Orders_By_Customers
FROM Sales.Orders;

-- Find the total number of Customers 
-- Additionally provide All customers Details

SELECT
    *,
    COUNT(*) OVER () AS TotalCustomersStar,
    COUNT(1) OVER () AS TotalCustomersOne,
    COUNT(Score) OVER() AS TotalScores,
    COUNT(Country) OVER() AS TotalCountries
FROM Sales.Customers;

-- Check whether the table 'orders' contains any duplicate rows
SELECT
*
FROM(
SELECT
	OrderID,
	COUNT(*)OVER(PARTITION BY OrderID) AS CheckPK
FROM Sales.OrdersArchive) AS T
WHERE CheckPK > 1;

/* ============================================================
   SQL WINDOW AGGREGATION | SUM
   ============================================================ */
-- Compare the current value and aggregated value of window function
SELECT * FROM Sales.Orders;

SELECT
	CustomerID,
	OrderID,
	Sales,
	SUM(Sales)OVER(PARTITION BY CustomerID ORDER BY OrderID ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS Aggregated_Value
FROM Sales.Orders;

SELECT 
	*
FROM
	(SELECT
	CustomerID,
	OrderID,
	Sales,
	SUM(Sales)OVER(PARTITION BY CustomerID ORDER BY OrderID ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS Aggregated_Value
	FROM Sales.Orders) AS T
WHERE Aggregated_Value > 50;

-- Find the percentage contribution of each product's sales to the total sales
SELECT 
	OrderID,
	ProductID,
	SUM(Sales)OVER() AS Total_Sales,
	SALES/SUM(Sales) OVER() * 100 [PERCENTAGE CANNOT BE IN INT FORMAT],
	CAST(SALES AS FLOAT) / SUM(Sales) OVER() * 100 AS [CASTED AS FLOAT],
	ROUND(CAST (SALES AS FLOAT) / SUM(Sales) OVER() * 100, 2)AS [Percantage Of Sales]
 FROM Sales.Orders;

 /* ============================================================
   SQL WINDOW AGGREGATION | AVG
   ============================================================ */
-- Find the average sales across all orders
-- And Find the average sales for each product
-- Additionally provide details such order Id, order date
SELECT * FROM Sales.Orders;

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	AVG(Sales)OVER() AS AvgSls,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AvgSlsByPrdct
FROM Sales.Orders;

-- Find the average scores of customers.
-- Additionally, provide details such as Customer ID and Last Name

SELECT
	CustomerID,
	LastName,
	Score,
	AVG(COALESCE(Score, 0)) OVER() AS AvgScore
FROM Sales.Customers;

--Find all orders where sales are higher than the average sales across all orders
SELECT
	*
FROM
	(SELECT
		*,
		AVG(Sales) OVER() AS AVGSales
	FROM Sales.Orders) AS T
WHERE Sales > AVGSales;

/* ============================================================
   SQL WINDOW AGGREGATION | MAX / MIN
   ============================================================ */
/* TASK 9:
   Find the Highest and Lowest Sales across all orders
   Find the Lowest Sales across all orders and by Product
*/
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() AS HighestSales,
	MIN(Sales) OVER() AS LowestSales,
	MAX(Sales) OVER (PARTITION BY ProductID) AS HighestSalesByProduct,
    MIN(Sales) OVER (PARTITION BY ProductID) AS LowestSalesByProduct
FROM Sales.Orders;
/* TASK 11:
   Show the employees who have the highest salaries
*/
SELECT
*
FROM(
	SELECT
		EmployeeID,
		Salary,
		CONCAT(FirstName, ' ', LastName) AS [Full Name],
		MAX(Salary) OVER() AS HighestSalary
	FROM Sales.Employees) AS T
WHERE Salary = HighestSalary;

/* TASK 12:
   Find the deviation of each Sale from the minimum and maximum Sales
*/
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() AS HighestSales,
	MIN(Sales) OVER() AS LowestSales,
	Sales - MIN(Sales) OVER() AS [Deviation From Min],
	MAX(Sales) OVER() - Sales AS [Deviation From Max]
FROM Sales.Orders;
/* ============================================================
   Use Case | ROLLING SUM & AVERAGE
   ============================================================ */

/* TASK 13:
   Calculate the moving average of Sales for each Product over time
*/

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AS AvgByPrdct,
	AVG(Sales) OVER(PARTITION BY ProductID Order BY OrderDate) MovingAvg
From Sales.Orders;

/* TASK 14:
   Calculate the moving average of Sales for each Product over time,
   including only the next order
*/
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID Order BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) MovingAvg
From Sales.Orders;
