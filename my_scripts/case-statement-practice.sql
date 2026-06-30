USE SalesDB_3;
GO

WITH SalaryTable AS (
	SELECT	1 AS EmployeeID,
			10000 AS SalaryAmount
	UNION
	SELECT 2, 20000
	UNION
	SELECT 3, 20000
	UNION
	SELECT 4, 60000
	UNION
	SELECT 5, 40000
	UNION
	SELECT 6, 30000
	UNION
	SELECT 7, NULL
	UNION
	SELECT 8, NULL
),
CategorizedData AS (
	SELECT
		EmployeeID,
		SalaryAmount,
		CASE
			WHEN SalaryAmount > 45000
			THEN 'High'
			WHEN SalaryAmount > 25000
			THEN 'Medium'
			WHEN SalaryAmount IS NULL
			THEN 'unknown'
			ELSE 'low'
		END AS Scale
	FROM SalaryTable
)
SELECT
	scale,
	COUNT(SalaryAmount) TotalSalaryCost
FROM CategorizedData
GROUP BY
	scale

----------------------------------------------------------------------
SELECT
	Category,
	COUNT(OrderID) as CategoryCount
FROM(
	SELECT
		OrderID,
		Sales,
		CASE
			WHEN Sales > 50
			THEN 'High'
			WHEN Sales > 20
			THEN 'Medium'
			ELSE 'Low'
		END Category
	FROM Sales.Orders
)t
GROUP BY Category
ORDER BY CategoryCount DESC
----------------------------------------------------------------------
SELECT
	EmployeeID,
	FirstName,
	LastName,
	CASE Gender
		WHEN 'M'
		THEN 'Male'
		WHEN 'F'
		THEN 'Female'
		ELSE 'Not Available'
	END AS GenderFullText
FROM
(SELECT
	*
FROM Sales.Employees
UNION
SELECT
	6, 'Shuvankar', 'Biswas', NULL, '1997-11-29', NULL, 20, NULL
)t
----------------------------------------------------------------------
SELECT
	OrderID,
	CurrentOrderDate,
	PreviousOrderDate,
	DATEDIFF(day, PreviousOrderDate, CurrentOrderDate)
FROM(
	SELECT
		OrderID,
		OrderDate CurrentOrderDate,
		COALESCE(LAG(OrderDate) OVER (ORDER BY OrderDate), '1999-01-01') PreviousOrderDate
	FROM Sales.Orders
)t
ORDER BY CurrentOrderDate
----------------------------------------------------------------------
SELECT
	CustomerID,
	Score,
	CASE
		WHEN Score IS NULL
		THEN 0
		ELSE Score
	END AS ScoreClean,
	AVG(Score) OVER () AvgScore,
	AVG(CASE
			WHEN Score IS NULL
			THEN 0
			ELSE Score
		END) OVER () AS AvgScoreClean
FROM Sales.Customers
----------------------------------------------------------------------
SELECT
	CustomerID,
	SUM(	CASE 
				WHEN Sales > 30
				THEN 1
				ELSE 0
			END) AS SalesFilter,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID
