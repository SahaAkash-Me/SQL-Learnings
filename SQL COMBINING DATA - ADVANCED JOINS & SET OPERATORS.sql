						-- ADVANCED JOINS --
/*
LEFT ANTI JOIN
RIGHT ANTI JOIN
FULL ANTI JOIN
SAME RESULT AS INNER JOIN BUT WITH OUT USING INNER JOIN
CROSS JOIN
*/

SELECT *
FROM customers
FULL JOIN orders
ON customers.id = orders.customer_id;

									-- LEFT ANTI JOIN --
SELECT *
FROM customers AS C
LEFT JOIN orders AS O
ON C.id = O.customer_id
WHERE O.customer_id IS NULL;
									-- RIGHT ANTI JOIN --
SELECT *
FROM customers AS C
RIGHT JOIN orders AS O
ON C.id = O.customer_id
WHERE C.id IS NULL;

/* TASK BELOW
GET ALL ORDERS WITHOUT MATCHING CUSTOMERS USING LEFT ANTI JOIN

SELECT *
FROM orders AS O
LEFT JOIN customers AS C
ON O.customer_id = C.id
WHERE C.id IS NULL
;
*/
									-- FULL ANTI JOIN --
SELECT *
FROM customers AS C
FULL JOIN orders AS O
ON C.id = O.customer_id
WHERE 
	C.id IS NULL
	OR
	O.customer_id IS NULL;

SELECT    -- THIS IS EXAMPLE OF INNER JOIN , BELOW IS SAME RESULT BUT WITHOUT USING INNNER JOIN --
	C.id,
	C.first_name,
	O.order_id,
	O.order_date
FROM customers AS C
INNER JOIN orders AS O
ON C.id = O.customer_id;

SELECT *
FROM customers AS C
LEFT JOIN orders AS O
ON C.id = O.customer_id
WHERE O.customer_id IS NOT NULL;
									-- CROSS JOIN --
SELECT *
FROM customers
CROSS JOIN orders;