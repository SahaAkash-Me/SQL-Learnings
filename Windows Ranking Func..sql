/* ==============================================================================
   SQL Window Ranking Functions
-------------------------------------------------------------------------------
   These functions allow you to rank and order rows within a result set 
   without the need for complex joins or subqueries. They enable you to assign 
   unique or non-unique rankings, group rows into buckets, and analyze data 
   distributions on ordered data.

   Table of Contents:
     1. ROW_NUMBER: Unique Rank, Does NOT handle Ties, No Gaps in Ranks
	 2. RANK: Shared Rank, Handles Ties, Gaps in Ranks
	 3. DENSE_RANK: Shared Rank, Handles Ties, No Gaps in Ranks
     4. NTILE
     5. CUME_DIST - CUMILITIVE DISTRIBUTION
	 6. PERCENT_RANK.

	 CUME_DIST:
- Formula: Position Nr / Number of Rows
- Inclusive (The current row is included)

	 PERCENT_RANK:
- Formula: (Position Nr - 1) / (Number of Rows - 1)
- Exclusive (The current row is excluded)
=================================================================================
*/

/* ============================================================
   SQL WINDOW RANKING | ROW_NUMBER, RANK, DENSE_RANK
   ============================================================ */
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) AS SalesRank_RowNumber,
	RANK() OVER(ORDER BY Sales DESC) AS SalesRank_Rank,
	DENSE_RANK() OVER(ORDER BY Sales DESC) AS SalesRank_DenseRank
FROM Sales.Orders; 

/* TASK 2:
   Use Case | Top-N Analysis: Find the Highest Sale for Each Product
*/
SELECT *
FROM(
SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS [Rank By Product]
FROM Sales.Orders) AS T
WHERE [Rank By Product] = 1;

/* TASK 3:
   Use Case | Bottom-N Analysis: Find the Lowest 2 Customers Based on Their Total Sales
*/
SELECT *
FROM (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales,
        ROW_NUMBER() OVER (ORDER BY SUM(Sales)) AS RankCustomers
    FROM Sales.Orders
    GROUP BY CustomerID
) AS BottomCustomerSales
WHERE RankCustomers <= 2;

/* TASK 4:
   Use Case | Assign Unique IDs to the Rows of the 'Order Archive'
*/
SELECT
	ROW_NUMBER()OVER(ORDER BY OrderID) AS Unique_ID,
	*
FROM Sales.OrdersArchive;
/* TASK 5:
   Use Case | Identify Duplicates:
   Identify Duplicate Rows in 'Order Archive' and return a clean result without any duplicates
*/
SELECT * 
FROM(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY CreationTime) AS RN,
		*
	FROM Sales.OrdersArchive) AS T
WHERE RN > 1;

/* ============================================================
   SQL WINDOW RANKING | NTILE
   ============================================================ */

/* TASK 6:
   Divide Orders into Groups Based on Sales
*/

SELECT
	OrderID,
	ProductID,
	Sales,
	NTILE(1) OVER(ORDER BY Sales DESC) AS OneBucket,
	NTILE(2) OVER(ORDER BY Sales DESC) AS TwoBucket,
	NTILE(3) OVER(ORDER BY Sales DESC) AS ThreeBucket,
	NTILE(4) OVER(ORDER BY Sales DESC) AS FourBucket
FROM Sales.Orders;

/* TASK 7:
   Segment all Orders into 3 Categories: High, Medium, and Low Sales.
*/

SELECT 
	*,
	CASE WHEN Bucket = 1 THEN 'HIGH'
		 WHEN Bucket = 2 THEN 'Medium'
		 WHEN Bucket = 3 THEN 'Low'
	END SalesSegmentations
	FROM
	(SELECT
		OrderID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) AS Bucket
	FROM Sales.Orders) AS B;

/* TASK 8:
   Divide Orders into Groups for Processing
*/
SELECT
	NTILE(2) OVER(ORDER BY OrderID)AS GFP,
	*
FROM Sales.Orders;

/* ============================================================
   SQL WINDOW RANKING | CUME_DIST
   ============================================================ */

/* TASK 9:
   Find Products that Fall Within the Highest 40% of the Prices
*/

SELECT
	*
FROM Sales.Products;

SELECT 
    Product,
    Price,
    DistRank,
    CONCAT(DistRank * 100, '%') AS DistRankPerc
FROM (
    SELECT
        Product,
        Price,
        CUME_DIST() OVER (ORDER BY Price DESC) AS DistRank
    FROM Sales.Products
) AS PriceDistribution
WHERE DistRank <= 0.4;