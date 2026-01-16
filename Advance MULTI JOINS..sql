USE SalesDB;

/*
										-- FULL JOIN EXAMPLE ON 3 TABLES --
SELECT *
FROM customers
FULL JOIN orders
	ON customers.id = orders.customer_id 
FULL JOIN persons
	ON customers.id= persons.id;
	                                    -- INNER JOIN EXAMPLE ON 3 TABLES --
SELECT *
FROM customers
INNER JOIN orders
	ON customers.id = orders.customer_id 
INNER JOIN persons
	ON customers.id= persons.id;
*/

/*Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, 
and employee details. For each order, display:
Order ID, Customer's name, Product name, Sales, Price, Sales person's name */


SELECT *
FROM Sales.orders;
					
SELECT 
	O.OrderID,
	C.FirstName AS CustomerFirst_Name,
	C.LastName AS CustomerLast_Name,
	P.Product AS Product_Name,
	O.Sales,
	P.Price,
	E.FirstName AS SalesPerson_FirstName,
	E.LastName AS SalesPerson_LasttName
FROM Sales.Orders AS O
LEFT JOIN Sales.Customers AS C
ON O.CustomerID = C.CustomerID
LEFT JOIN Sales.Products AS P
ON O.ProductID = P.ProductID
LEFT JOIN Sales.Employees AS E
ON O.SalesPersonID = E.EmployeeID
;							
