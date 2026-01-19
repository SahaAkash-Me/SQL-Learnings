/* ==============================================================================
   SQL Subquery Functions
-------------------------------------------------------------------------------
   This script demonstrates various subquery techniques in SQL.
   It covers result types, subqueries in the FROM clause, in SELECT, in JOIN clauses,
   with comparison operators, IN, ANY, correlated subqueries, and EXISTS.
   
   Table of Contents:
     1. SUBQUERY - RESULT TYPES
     2. SUBQUERY - FROM CLAUSE
     3. SUBQUERY - SELECT
     4. SUBQUERY - JOIN CLAUSE
     5. SUBQUERY - COMPARISON OPERATORS 
     6. SUBQUERY - IN OPERATOR
     7. SUBQUERY - ANY OPERATOR
     8. SUBQUERY - CORRELATED 
     9. SUBQUERY - EXISTS OPERATOR
===============================================================================
*/

/* ==============================================================================
   SUBQUERY | RESULT TYPES
===============================================================================*/

/* Scalar Query */
SELECT
    AVG(Sales)
FROM Sales.Orders;

/* Row Query */
SELECT
    CustomerID
FROM Sales.Orders;

/* Table Query */
SELECT
    OrderID,
    OrderDate
FROM Sales.Orders;

/* ==============================================================================
   SUBQUERY | FROM CLAUSE
===============================================================================*/

/* TASK 1:
   Find the products that have a price higher than the average price of all products.
*/

-- Main Query
SELECT
*
FROM (
    -- Subquery
    SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM Sales.Products
) AS t
WHERE Price > AvgPrice;
/* TASK 2:
   Rank Customers based on their total amount of sales.
*/
SELECT
	*,
	RANK() OVER(ORDER BY Total_Sales DESC) AS RANKS
FROM(
	SELECT
		CustomerID,
		SUM(Sales) AS Total_Sales
	FROM Sales.Orders
	GROUP BY CustomerID) AS T;

/* ==============================================================================
   SUBQUERY | SELECT
===============================================================================*/

/* TASK 3:
   Show the product IDs, product names, prices, and the total number of orders.
*/
SELECT
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) AS Total_Orders
FROM Sales.Products;

/* ==============================================================================
   SUBQUERY | JOIN CLAUSE
===============================================================================*/

/* TASK 4:
   Show customer details along with their total sales.
*/

SELECT
	C.*,
	O.TotalOrders
FROM Sales.Customers AS C
LEFT JOIN
(SELECT
	CustomerID,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID) AS O
ON C.CustomerID = O.CustomerID;

/* TASK 5:
   Show all customer details and the total orders of each customer.
*/

SELECT
	C.*,
	O.TotalOrder
FROM Sales.Customers AS C
LEFT JOIN 
(
SELECT 
	CustomerID,
	COUNT(Quantity) AS TotalOrder
FROM Sales.Orders
GROUP BY CustomerID
) AS O
ON C.CustomerID = O.CustomerID;

/* ==============================================================================
   SUBQUERY | COMPARISON OPERATORS
===============================================================================*/

/* TASK 6:
   Find the products that have a price higher than the average price of all products.
*/

SELECT
	ProductID,
	Price,
	(SELECT AVG(PRICE) FROM Sales.Products) AS AVG_PRICE
FROM Sales.Products
WHERE Price > (SELECT AVG(PRICE) FROM Sales.Products);

/* ==============================================================================
   SUBQUERY | IN OPERATOR
===============================================================================*/

/* TASK 7:
   Show the details of orders made by customers in Germany.
*/
SELECT
	*
FROM Sales.Orders
WHERE CustomerID IN 
				(SELECT
					CustomerID
				FROM Sales.Customers
				WHERE Country IN ('Germany'));
/* TASK 8:
   Show the details of orders made by customers not in Germany.
*/
SELECT
	*
FROM Sales.Orders
WHERE CustomerID NOT IN 
				(SELECT
					CustomerID
				FROM Sales.Customers
				WHERE Country = ('Germany'));

/* ==============================================================================
   SUBQUERY | ANY OPERATOR
===============================================================================*/

/* TASK 9:
   Find female employees whose salaries are greater than the salaries of any male employees.
*/
SELECT
	EmployeeID,
	CONCAT(FirstName, ' ', LastName) AS Full_Name,
	Gender,
	Salary
FROM Sales.Employees
WHERE 
	Gender = 'F'
	AND
	Salary > ANY  (SELECT
						Salary
					FROM Sales.Employees
					WHERE Gender = 'M');

/* TASK 10:
   Find female employees whose salaries are greater than the salaries of ALL male employees.
*/

SELECT
	EmployeeID,
	CONCAT(FirstName, ' ', LastName) AS Full_Name,
	Gender,
	Salary
FROM Sales.Employees
WHERE 
	Gender = 'F'
	AND
	Salary > ALL  (SELECT
						Salary
					FROM Sales.Employees
					WHERE Gender = 'M');

/* ==============================================================================
   CORRELATED SUBQUERY
===============================================================================*/

/* TASK 10:
   Show all customer details and the total orders for each customer using a correlated subquery.
*/
SELECT
    *,
    (SELECT COUNT(*)
     FROM Sales.Orders o
     WHERE o.CustomerID = c.CustomerID) AS TotalSales
FROM Sales.Customers AS c;


/* ==============================================================================
   SUBQUERY | EXISTS OPERATOR
===============================================================================*/

/* TASK 11:
   Show the details of orders made by customers in Germany.
*/
SELECT
    *
FROM Sales.Orders AS o
WHERE EXISTS (
    SELECT 1
    FROM Sales.Customers AS c
    WHERE Country = 'Germany'
      AND o.CustomerID = c.CustomerID
);

/* TASK 12:
   Show the details of orders made by customers not in Germany.
*/
SELECT
    *
FROM Sales.Orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Customers AS c
    WHERE Country = 'Germany'
      AND o.CustomerID = c.CustomerID
);
