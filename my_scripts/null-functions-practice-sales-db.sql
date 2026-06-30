USE SalesDB_3;
GO

------------------------------------------------------------------------------------------------
SELECT *
FROM Sales.Orders

SELECT
	OrderID,
	ShipAddress,
	BillAddress,
	ISNULL(BillAddress, ShipAddress),
	COALESCE(ShipAddress, BillAddress, 'unknown')
FROM Sales.Orders
------------------------------------------------------------------------------------------------
SELECT
	AVG(Score)
FROM Sales.Customers

SELECT
	AVG(ISNULL(Score, 0)) OVER ()
FROM Sales.Customers
------------------------------------------------------------------------------------------------
SELECT
	CustomerID,
	ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') FullName,
	Score,
	ISNULL(Score, 0) FixedScore,
	ISNULL(Score, 0) + 10 AddedFixedScore
FROM Sales.Customers
------------------------------------------------------------------------------------------------
SELECT
	CustomerID,
	Score
FROM Sales.Customers
ORDER BY 
	CASE
		WHEN Score IS NULL
		THEN 1
		ELSE 0
	END, 
	Score
------------------------------------------------------------------------------------------------
SELECT
	OrderID,
	Sales,
	Quantity,
	Sales / NULLIF(Quantity, 0) AS Price
FROM Sales.Orders
------------------------------------------------------------------------------------------------
SELECT
	CustomerID,
	Score
FROM Sales.Customers
WHERE Score IS NOT NULL
------------------------------------------------------------------------------------------------
SELECT DISTINCT
	c.CustomerID CC,
	o.CustomerID OC,
	o.OrderID as OO
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL
