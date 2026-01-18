/* ==============================================================================
   SQL Window Value Functions
-------------------------------------------------------------------------------
   These functions let you reference and compare values from other rows 
   in a result set without complex joins or subqueries, enabling advanced 
   analysis on ordered data.

   Table of Contents:
     1. LEAD
     2. LAG
     3. FIRST_VALUE 
     4. LAST_VALUE
=================================================================================
*/

/* ============================================================
   SQL WINDOW VALUE | LEAD, LAG
   ============================================================ */

/* TASK 1:
   Analyze the Month-over-Month Performance by Finding the Percentage Change in Sales
   Between the Current and Previous Months
*/

SELECT
*,
CurrentMonthSales - PreviousMonthSales AS MoM_Change,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales)AS FLOAT)  / PreviousMonthSales * 100, 2) AS MOM_CHANGE_Percantage
FROM(
SELECT
	MONTH(OrderDate) AS OrderMonth,
	SUM(Sales) CurrentMonthSales,
	LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
FROM Sales.Orders
GROUP BY 
	MONTH(OrderDate)) AS T;

/* TASK 2:
   Customer Loyalty Analysis - Rank Customers Based on the Average Days Between Their Orders
*/
SELECT
	CustomerID,
	AVG(DaysUntilNextOrder) AvgDays,
	RANK()OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) AS RankAVG
FROM(
	SELECT 
		OrderID,
		CustomerID,
		OrderDate AS CurrentOrder,
		LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
		DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM Sales.Orders)AS T
GROUP BY CustomerID;

/* ============================================================
   SQL WINDOW VALUE | FIRST & LAST VALUE
   ============================================================ */

/* TASK 3:
   Find the Lowest and Highest Sales for Each Product,
   and determine the difference between the current Sales and the lowest Sales for each Product.
*/

SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID Order BY Sales) AS Lowest_Sales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS Highest_Sales,
		
		-- ALTERNEATE WAY BELOW FOR HIGHEST & LOWEST
/*	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC)AS Highest_Sales2,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)AS Lowest_Sales2,
		-- ALTERNEATE WAY BELOW FOR HIGHEST & LOWEST USING "MIN || MAX"
	MIN(Sales) OVER(PARTITION BY ProductID) AS Lowest_Sales3,
	MAX(Sales) OVER(PARTITION BY ProductID) AS Highest_Sales3	*/

	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID Order BY Sales) AS SalesDiff
FROM Sales.Orders;