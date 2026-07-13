USE SalesDB_3;
GO
----------------------------------------------------------------
SELECT
OrderID,
CustomerID,
ProductID,
Sales,
SUM(Sales) OVER (PARTITION BY CustomerID) AS TotalSalesByCustomer,
SUM(Sales) OVER (PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders
--ORDER BY CustomerID
ORDER BY ProductID
--WHERE CustomerID = 4
--WHERE ProductID = 104
----------------------------------------------------------------
SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProduct,
	SUM(Sales) OVER (ORDER BY ProductID) CumeSalesByProduct
FROM Sales.Orders
----------------------------------------------------------------
SELECT DISTINCT
	ProductID,
	OrderStatus,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProduct,
	SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) SalesByProductAndStatus,
	SUM(Sales) OVER (ORDER BY ProductID) CumeSalesByProduct
FROM Sales.Orders
----------------------------------------------------------------
SELECT
	OrderID,
	ProductID,
	Sales,
	RANK() OVER (PARTITION BY ProductID ORDER BY Sales DESC) AS Ranked
FROM Sales.Orders
----------------------------------------------------------------
SELECT
	OrderStatus,
	Sales,
--	SUM(Sales) OVER (ORDER BY Sales),
	SUM(Sales) OVER (PARTITION BY OrderStatus
					ORDER BY SALES ROWS BETWEEN
					1 PRECEDING AND 1 FOLLOWING) MovingSum,
	AVG(Sales) OVER (PARTITION BY OrderStatus
					ORDER BY SALES ROWS BETWEEN
					1 PRECEDING AND 1 FOLLOWING) MovingAvg,
	SUM(Sales) OVER (PARTITION BY OrderStatus
					ORDER BY SALES ROWS BETWEEN
					UNBOUNDED PRECEDING AND 
					CURRENT ROW) CumeSales
FROM Sales.Orders
--ORDER BY ProductID
----------------------------------------------------------------
SELECT
	*,
	RANK() OVER (ORDER BY TotalSalesByCustomer)
FROM(
	SELECT
		CustomerID,
		SUM(Sales) TotalSalesByCustomer
	FROM Sales.Orders
	GROUP BY CustomerID
)t
----------------------------------------------------------------
SELECT
	CustomerID,
	SUM(Sales) TotalSalesByCustomer,
	RANK() OVER (ORDER BY SUM(Sales) DESC) RankSalesByCustomer
FROM Sales.Orders
GROUP BY CustomerID