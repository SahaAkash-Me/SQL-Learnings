/* ==============================================================================
   SQL Triggers
-------------------------------------------------------------------------------
   This script demonstrates the creation of a logging table, a trigger, and
   an insert operation into the Sales.Employees table that fires the trigger.
   The trigger logs details of newly added employees into the Sales.EmployeeLogs table.
=================================================================================
*/

-- Step 1: Create Log Table

CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY (1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
);

-- Step 2: Create Trigger on Employees Table

CREATE TRIGGER tgr_AfterInsertEmployee ON Sales.Employees 
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added =' + CAST (EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END

DROP TRIGGER IF EXISTS tgr_AfterInsertEmployee;

-- Step 3: Insert New Data Into Employees
INSERT INTO Sales.Employees
VALUES (6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);
GO

-- Check the Logs
SELECT *
FROM Sales.EmployeeLogs;
GO

SELECT * FROM Sales.Employees;

/* ==============================================================================
My Own Practice While Learning
=================================================================================
*/

CREATE TABLE Sales.Customer_Logs (
	Log_Number INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID INT,
	Log_Message VARCHAR(200),
	Log_Date DATE
)

DROP TABLE IF EXISTS Sales.Customer_Logs;

CREATE TRIGGER trgr_Customer_Logs_Trigger ON Sales.Customers AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.Customer_Logs (CustomerID, Log_Message, Log_Date)
		SELECT
		CustomerID,
		'New Customer Added Today = ' + CAST (CustomerID AS VARCHAR),
		GETDATE()
		FROM INSERTED
END

SELECT * FROM Sales.Customers;
SELECT* FROM Sales.Customer_Logs; -- Log_Table

INSERT INTO Sales.Customers
	VALUES
		(7, 'Akash', 'Saha', 'India', '400');

	DELETE FROM Sales.Customers WHERE FirstName = 'Akash'

	SELECT 
		CONCAT (C.FirstName, ' ', C.LastName) AS [Full Name],
		C.Score,
		COALESCE(CAST(Log_Date AS VARCHAR), 'Log Table Was Not Created') AS [Log Date]
	FROM Sales.Customers AS C
	LEFT JOIN Sales.Customer_Logs AS L
	ON C.CustomerID = L.CustomerID
	WHERE SCORE >= 400;