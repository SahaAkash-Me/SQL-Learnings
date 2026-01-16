  /*
ROUND
ABS - Absolute (CONVERTS A NEGETIVE NUMBER TO POSITIVE NUMBER.)

Date and Time Functions  >
	PART EXTRACTION {YEAR , MONTH, DATE}

	DATEPART - OUTPUT WILL ALWAYS BE ON "INTEGER".

	DATENAME - RETURNS THE NAME OF A PART ( EXAMPLY 05 - MAY , DAY 2 = TUESDAY ) OUTPUT WILL BE IN "STRING".

	DATETRUNC - TRUNCATE DATE TO SPECIFIC PART. 
		{Time parts gets reset to 00:00 & DatePart Gets reset to 01 AS THERE IS NO SUCH DATE AS 00}

STRUCTURE FOR ABOVE 3 IS { DATEPART/DATENAME/DATETRUNC(part,date) } 

FOMATTING DATES
CUSTOM FORMAT FOR PRACTICE
CONVERT
CAST
SQL TASK

ISDATE

[CALCULATIONS] - DATEADD & DATEDIFF

*/
                                      --ROUND--
SELECT
	3.516,
ROUND(3.516, 2) AS round_2,
ROUND(3.516, 1) AS round_1,
ROUND(3.516, 0) AS round_0;

                                      --ABS--
SELECT
-10,
ABS(-10) AS abs_value;
                                      -- Date and Time Functions  --
SELECT
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime
FROM Sales.Orders;

SELECT
	OrderID,
	CreationTime,
	'2025-09-24' AS HardCoded,
	GETDATE() AS Today
FROM Sales.Orders;
                                      -- PART EXTRACTION  --
SELECT
	OrderID,
	CreationTime,
	YEAR(CreationTime) AS Year,
	MONTH(CreationTime) AS Month,
	DAY(CreationTime) AS Day
FROM Sales.Orders;
                                      -- DATE PART  --
SELECT
	OrderID,
	CreationTime,
	DATEPART(year, CreationTime)  AS DP_Year,
	DATEPART(month, CreationTime)  AS DP_month,
	DATEPART(day, CreationTime)  AS DP_day,
	DATEPART(hour, CreationTime)  AS DP_hour,
	DATEPART(quarter, CreationTime)  AS DP_quarter,
	DATEPART(week, CreationTime)  AS DP_week
FROM Sales.Orders;
                                      -- DATENAME  --
SELECT
	OrderID,
	CreationTime,
	DATENAME(month, CreationTime)  AS DN_month,
	DATENAME(weekday, CreationTime)  AS DN_weekday,
	DATENAME(week, CreationTime)  AS DN_week,
	DATENAME(year, CreationTime)  AS DN_Year,
	DATENAME(hour, CreationTime)  AS DN_hour,
	DATENAME(quarter, CreationTime)  AS DN_quarter
FROM Sales.Orders;
                                      -- DATETRUNC  --
  SELECT
	OrderID,
	CreationTime,
	DATETRUNC(MINUTE, CreationTime)  AS DT_minute,
	DATETRUNC(HOUR, CreationTime)  AS DT_hour,
	DATETRUNC(DAY, CreationTime)  AS DT_day,
	DATETRUNC(WEEK, CreationTime)  AS DT_week,
	DATETRUNC(MONTH, CreationTime)  AS DT_month,
	DATETRUNC(YEAR, CreationTime)  AS DT_year
FROM Sales.Orders;
 
 SELECT
 DATETRUNC(month,CreationTime) AS Creation_Month,
 COUNT(*)
 FROM Sales.Orders
 GROUP BY DATETRUNC(month,CreationTime);

    
                                      -- EO MONTH--
SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) AS EndOfMonth
FROM Sales.Orders;

                                      -- HOW MANY ORDERS PLACE EACH MONTH--
SELECT 
	MONTH(OrderDate),
	COUNT(*) NoOfOrders
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

SELECT 
	DATENAME(MONTH, OrderDate) AS OrderDate,
	COUNT(*) NoOfOrders
FROM Sales.Orders
GROUP BY DATENAME(Month, OrderDate);
                                      -- ORDERS PLACED FEBRUARY MONTH --
SELECT *
FROM Sales.Orders
WHERE  MONTH(ORDERDATE) = 2;


                                      -- SALES BY MONTH --
SELECT 
FORMAT(OrderDate, 'MMM yy') AS OrderDate,
Count(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy');

                                      -- FORMAT --
SELECT
OrderID,
CreationTime,
FORMAT (CreationTime, 'dd') AS DD,
FORMAT (CreationTime, 'ddd') AS DDD,
FORMAT (CreationTime, 'dddd') AS DDDD,
FORMAT (CreationTime, 'MM') AS MM,
FORMAT (CreationTime, 'MMM') AS MMM,
FORMAT (CreationTime, 'MMMM') AS MMMM,
FORMAT (CreationTime, 'MM-dd-yyyy') AS USAFormat,
FORMAT (CreationTime, 'dd-MM-yyyy') AS ISOFormat,
FORMAT (CreationTime, 'yyyy-MM-dd') AS EUROPEFormat
FROM Sales.Orders;


                                      -- CUSTOM FORMAT FOR PRACTICE {DAY Wed Jan Q1 2025 12:34:56 PM} --
SELECT
OrderID,
CreationTime,
'Day ' + 
FORMAT(CreationTime, 'ddd MMM') +
' Q' + DATENAME(quarter, CreationTime) + 
' ' + 
FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders;

                                      -- CONVERT --
SELECT
CONVERT(INT, '123') AS [String to Int CONVERT],
CONVERT(DATE, '2025-08-20') AS [String to Date CONVERT],
CreationTime,
CONVERT(DATE, CreaTionTime) AS [String To Date Convert],
CONVERT (VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
CONVERT (VARCHAR, CreationTime, 34) AS [Eur Std. Style:34]
FROM Sales.Orders;

                                      -- CAST --
SELECT
CAST('123' AS INT) AS [String To Int],
CAST(123 AS VARCHAR) AS [Int To String],
CAST('2025-12-10' AS DATE) AS [String To Date],
CAST('2025-12-10' AS DATETIME2) AS [String To Datetime], -- DATETIME2 Newer, more accurate data type (introduced in SQL 2008) --
CreationTime,
CAST(CreationTime AS DATE) AS [ Datetime AS Date],
CAST(CreationTime AS TIME) AS [ Datetime AS Time]
FROM SALES.ORDERS;

                                      -- Date Add --
SELECT
OrderDate,
DATEADD(YEAR , 2 , OrderDate) AS [Two Years Later],
DATEADD(MONTH , 2 , OrderDate) AS [Two Months Later],
DATEADD(DAY , 2 , OrderDate) AS [Two Days Later],
DATEADD(YEAR , -10 , OrderDate) AS [Ten Years Earlier],
DATEADD(MONTH , -10 , OrderDate) AS [Ten Months Earlier],
DATEADD(DAY , -10 , OrderDate) AS [Ten Days Earlier]
FROM Sales.Orders;

                                      -- Date Diff --
SELECT
EmployeeID,
BirthDate,
DATEDIFF(YEAR, Birthdate, GETDATE()) AS Age
FROM Sales.Employees;
									  -- **Find the average shipping duration in days for each month** --
SELECT
MONTH(OrderDate),
AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS [Average Shipping Duration]
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS [Average Shipping Duration]
FROM Sales.Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;

                                      -- Find the number of days between each order and the previous order --
SELECT
OrderID,
OrderDate AS [Current Order Date],
LAG(OrderDate) OVER(ORDER BY OrderDate) AS [Previous Order Date],
DATEDIFF(DAY, LAG(OrderDate) OVER(ORDER BY OrderDate), OrderDate)
FROM Sales.Orders;

                                      -- ISDATE --
SELECT
ISDATE('123') AS DateCheck1,
ISDATE('2025-12-11') AS DateCheck2,
ISDATE('20-08-2025') AS DateCheck3,
ISDATE('2025') AS DateCheck4,
ISDATE('08') AS DateCheck5

SELECT
	-- CAST(OrderDate AS DATE) OrderDate,
	OrderDate,
	ISDATE(OrderDate),
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST (OrderDate AS DATE)
		ELSE '9999-01-01'
	END NewOrderDate
FROM
(
	SELECT '2025-08-20' AS OrderDate UNION
	SELECT '2025-08-21' UNION,
	SELECT '2025-08-23' UNION
	SELECT '2025-08'
)
-- WHERE ISDATE(OrderDate) = 0
USE SalesDB;

SELECT *
FROM Sales.Orders;