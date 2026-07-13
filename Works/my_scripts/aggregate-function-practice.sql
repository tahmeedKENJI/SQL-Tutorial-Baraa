USE NewDB;
GO

SELECT
--CustomerID,
ProductID,
--*,
COUNT(*) AS TotalOrders,
SUM(Sales) AS TotalSales,
AVG(Sales) AS AvgSales,
MAX(Sales) AS MaxSales,
MIN(Sales) AS MinSales
FROM Orders
--GROUP BY CustomerID
GROUP BY ProductID
-----------------------------------------------------------------------
SELECT
CustomerID,
--*,
COUNT(*) AS TotalOrders,
SUM(Sales) AS TotalSales,
AVG(Sales) AS AvgSales,
MAX(Sales) AS MaxSales,
MIN(Sales) AS MinSales
FROM Orders
GROUP BY CustomerID
