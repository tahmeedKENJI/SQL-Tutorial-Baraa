USE SalesDB_3;
GO

SELECT
c.*,
o.TotalSales
FROM Sales.Customers AS c
LEFT JOIN (
    SELECT
    CustomerID,
    SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) AS o
ON c.CustomerID = o.CustomerID