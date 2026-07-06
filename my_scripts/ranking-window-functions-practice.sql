USE SalesDB_3;
GO
--------------------------------------------------------------------------------------------
SELECT
	CustomerID,
	FirstName,
	LastName,
	RANK() OVER (ORDER BY CustomerID) [ID Ranked],
	ROW_NUMBER() OVER (ORDER BY CustomerID) [ID Row Number],
	PERCENT_RANK() OVER (ORDER BY CustomerID) [ID Row Number]
FROM Sales.Customers
--------------------------------------------------------------------------------------------
SELECT
	OrderID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales) [Sales Row Number],
	RANK() OVER (ORDER BY Sales) [Sales Rank],
	DENSE_RANK() OVER (ORDER BY Sales) [Sales Dense Rank]
FROM Sales.Orders
--------------------------------------------------------------------------------------------
SELECT
	*
FROM(	
	SELECT
		CustomerID,
		SUM(Sales) TotalSales,
		ROW_NUMBER() OVER (ORDER BY SUM(Sales)) TotalSalesRank
	FROM Sales.Orders
	GROUP BY CustomerID
)t
WHERE TotalSalesRank <= 2
--------------------------------------------------------------------------------------------
SELECT
	ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) pk,
	*
FROM Sales.OrdersArchive
--------------------------------------------------------------------------------------------
SELECT 
	*
FROM(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
		*
	FROM Sales.OrdersArchive
)t
WHERE rn = 1
--------------------------------------------------------------------------------------------
SELECT
	OrderID,
	Sales,
	NTILE(1) OVER (ORDER BY OrderID DESC) Tile_1,
	NTILE(2) OVER (ORDER BY OrderID DESC) Tile_2,
	NTILE(3) OVER (ORDER BY OrderID DESC) Tile_3,
	NTILE(4) OVER (ORDER BY OrderID DESC) Tile_4
FROM Sales.Orders
--------------------------------------------------------------------------------------------
SELECT
	*,
	CASE 
		WHEN SalesBucket = 1 THEN 'High'
		WHEN SalesBucket = 2 THEN 'Medium'
		ELSE 'Low'
	END Category
FROM(
	SELECT
		OrderID,
		Sales,
		NTILE(3) OVER (ORDER BY Sales DESC) SalesBucket
	FROM Sales.Orders
)t
--------------------------------------------------------------------------------------------
SELECT
	Product,
	Price,
	CONCAT([Price Percent], '%') PricePercent
FROM(
	SELECT
		Product,
		Price,
		ROUND(CUME_DIST() OVER (ORDER BY Price DESC) * 100, 2) [Price Percent]
	FROM Sales.Products
)t
WHERE [Price Percent] <= 40
--------------------------------------------------------------------------------------------
SELECT
	Product,
	Price,
	CONCAT([Price Percent], '%') PricePercent
FROM(
	SELECT
		Product,
		Price,
		ROUND(PERCENT_RANK() OVER (ORDER BY Price DESC) * 100, 2) [Price Percent]
	FROM Sales.Products
)t
WHERE [Price Percent] <= 40