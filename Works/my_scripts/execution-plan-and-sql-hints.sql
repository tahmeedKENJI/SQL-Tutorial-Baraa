USE AdventureWorksDW2022;
GO

----####----

--	SELECT *
--	INTO dbo.FactResellerSales_HEAP
--	FROM dbo.FactResellerSales

----####----

SELECT *
FROM dbo.FactResellerSales_HEAP
ORDER BY SalesOrderNumber;


----####----

SELECT *
FROM dbo.FactResellerSales
ORDER BY SalesOrderNumber;

SELECT *
FROM dbo.FactResellerSales
ORDER BY OrderDateKey;

----####----

SELECT
*
FROM dbo.FactResellerSales
WHERE OrderDateKey = 20101229;

SELECT
*
FROM dbo.FactResellerSales_HEAP
WHERE OrderDateKey = 20101229;

SELECT
OrderDateKey
FROM dbo.FactResellerSales
WHERE OrderDateKey = 20101229;

--	CREATE NONCLUSTERED INDEX idx_FactResellerSales_OrderDateKey
--	ON dbo.FactResellerSales (OrderDateKey)

----####----

SELECT
DueDateKey,
OrderDateKey,
ShipDateKey
FROM dbo.FactResellerSales
WHERE OrderDateKey = 20101229;

--	CREATE NONCLUSTERED INDEX idx_FactResellerSales_OrderDateKey_DueDateKey_ShipDateKey
--	ON dbo.FactResellerSales (OrderDateKey, DueDateKey, ShipDateKey)

--	DROP INDEX idx_FactResellerSales_OrderDateKey
--	ON dbo.FactResellerSales;

----####----

WITH DistinctResellerKey AS (
	SELECT DISTINCT
		ResellerKey
	FROM dbo.FactResellerSales_HEAP
)
SELECT
COUNT(*)
FROM DistinctResellerKey;

CREATE NONCLUSTERED COLUMNSTORE INDEX
idx_FactResellerSales_HEAP_ResellerKey
ON dbo.FactResellerSales_HEAP (ResellerKey)

CREATE CLUSTERED INDEX
idx_FactResellerSales_HEAP_ResellerKey_c
ON dbo.FactResellerSales_HEAP (SalesOrderNumber)

DROP INDEX idx_FactResellerSales_HEAP_ResellerKey
ON dbo.FactResellerSales_HEAP

DROP INDEX idx_FactResellerSales_HEAP_ResellerKey_c
ON dbo.FactResellerSales_HEAP;

----####----

SELECT
	ResellerKey,
	COUNT(*) _Histogram
FROM dbo.FactResellerSales_HEAP
GROUP BY ResellerKey;

----####----

SELECT
	p.EnglishProductName ProductName,
	SUM(s.SalesAmount) TotalSales
FROM FactResellerSales_HEAP s
INNER JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName

CREATE NONCLUSTERED COLUMNSTORE INDEX
idx_FactResellerSales_HEAP_SalesAmount_col
ON FactResellerSales_HEAP (SalesAmount)

CREATE CLUSTERED COLUMNSTORE INDEX
idx_FactResellerSales_HEAP_SalesAmount_col
ON FactResellerSales_HEAP

DROP INDEX idx_FactResellerSales_HEAP_SalesAmount_col
ON FactResellerSales_HEAP

----####----

USE SalesDB_3;
GO

SELECT
	o.Sales,
	c.Country
FROM Sales.Orders AS o
LEFT JOIN	Sales.Customers AS c WITH (INDEX ([idx_Customers_Country_Score]))
ON			o.CustomerID = c.CustomerID
OPTION (HASH JOIN);