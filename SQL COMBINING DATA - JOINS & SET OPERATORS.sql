
		                  	  	--JOINS BELOW --
/* INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL JOIN
*/
 

SELECT *							-- NO JOIN --
FROM customers;
SELECT *
FROM orders;

									-- INNER JOIN --
SELECT *
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id;

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;


									-- LEFT JOIN --
SELECT 
	C.id,
	C.first_name,
	O.order_id,
	O.sales,
	O.order_date
FROM customers AS C
LEFT JOIN orders AS O
ON C.id = O.customer_id;
									-- RIGHT JOIN --

SELECT 
	C.id,
	C.first_name,
	O.order_id,
	O.sales,
	O.order_date
FROM customers AS C
RIGHT JOIN orders AS O
ON C.id = O.customer_id;

SELECT 
	C.id,
	C.first_name,
	O.order_id,
	O.sales,
	O.order_date
FROM orders AS O
LEFT JOIN customers AS C
ON O.customer_id = C.id ;
									-- FULL JOIN --
SELECT *
FROM customers
FULL JOIN orders
ON customers.id = orders.customer_id;