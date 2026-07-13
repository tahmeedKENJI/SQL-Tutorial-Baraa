USE SalesDB_3;
GO

-------------------------------------------------------------------------------
-- Continuation of Sub-Query
-------------------------------------------------------------------------------

SELECT *,
(	
	SELECT 
	COUNT(OrderID) AS TotSales
	FROM Sales.Orders o
	WHERE o.CustomerID = c.CustomerID -- need info from the main query. correlated sub-query
) TotalSales
FROM Sales.Customers c

-------------------------------------------------------------------------------

SELECT *
FROM Sales.Orders o
WHERE EXISTS (
	SELECT *
	FROM Sales.Customers c
	WHERE Country = 'Germany'
	AND c.CustomerID = o.CustomerID
)

--SELECT *
--FROM Sales.Customers
--WHERE Country = 'Germany'

-------------------------------------------------------------------------------
-- CTE
-------------------------------------------------------------------------------

WITH Total_Sales_Per_Customer AS (
	-- Total Orders Per Customer. Standalone CTE.
	SELECT
	CustomerID,
	SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
),
Last_Order AS (
	-- Latest Order Date Of Customer. Standalone CTE.
	SELECT
	CustomerID,
	MAX(OrderDate) LastOrderDate
	FROM Sales.Orders
	GROUP BY CustomerID
),
Customer_Rank AS (
	-- Rank customers based on their total sales. Nested CTE
	SELECT
	*,
	RANK() OVER (ORDER BY TotalSales DESC) CustomerRank
	FROM Total_Sales_Per_Customer -- Which is already a CTE. Customer_Rank is a nested CTE
),
Customer_Segment AS (
	-- Segment customers based on their total sales. Nested CTE
	SELECT *,
	CASE
		WHEN ts.TotalSales > 100 THEN 'High'
		ELSE 'Low'
	END AS Segmented_Data
	FROM Total_Sales_Per_Customer ts
)

SELECT 
c.*,
ts.TotalSales,
lo.LastOrderDate,
cr.CustomerRank,
cs.Segmented_Data
FROM Sales.Customers AS c
LEFT JOIN Total_Sales_Per_Customer AS ts
ON c.CustomerID = ts.CustomerID
LEFT JOIN Last_Order AS lo
ON c.CustomerID = lo.CustomerID
LEFT JOIN Customer_Rank as cr
ON c.CustomerID = cr.CustomerID
LEFT JOIN Customer_Segment as cs
ON c.CustomerID = cs.CustomerID
--WHERE cr.CustomerRank IS NOT NULL
--ORDER BY cr.CustomerRank

-------------------------------------------------------------------------------

-- Generate a sequence of numbers from 1 to 20
WITH Series AS (
	-- Anchor Query
	SELECT
	1 AS MyNumber
	UNION ALL
	-- Recursive Query
	SELECT
	MyNumber + 1
	FROM Series
	WHERE MyNumber < 20
)
-- Main Query
SELECT *
FROM Series
OPTION (MAXRECURSION 10)

-------------------------------------------------------------------------------

-- Show employee hierarchy levels
WITH Employee_Hierarchy AS
(
	-- Anchor Query
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID IS NULL
	UNION ALL
	-- Recursive Query
	SELECT
		rse.EmployeeID,
		rse.FirstName,
		rse.ManagerID,
		Level + 1
	FROM Sales.Employees AS rse
	INNER JOIN Employee_Hierarchy AS eh
	ON rse.ManagerID = eh.EmployeeID
)
SELECT *
FROM Employee_Hierarchy

-------------------------------------------------------------------------------
