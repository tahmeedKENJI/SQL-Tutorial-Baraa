USE SalesDB_3;
GO

-------------------------------------------------------------------------------

CREATE CLUSTERED INDEX idx_OrdersOverviewNoBottle_OrderID
ON Sales.OrdersOverviewNoBottle (OrderID)

DROP INDEX idx_OrdersOverviewNoBottle_OrderID
ON Sales.OrdersOverviewNoBottle

CREATE CLUSTERED INDEX idx_OrdersOverviewNoBottle_FirstName
ON Sales.OrdersOverviewNoBottle (FirstName)

DROP INDEX idx_OrdersOverviewNoBottle_FirstName
ON Sales.OrdersOverviewNoBottle

CREATE NONCLUSTERED INDEX idx_OrdersOverviewNoBottle_FirstName
ON Sales.OrdersOverviewNoBottle (FirstName)

-------------------------------------------------------------------------------

SELECT *
FROM Sales.Customers
WHERE Country = 'USA' AND Score > 200;

CREATE INDEX idx_Customers_Country_Score
ON Sales.Customers (Country, Score)

-------------------------------------------------------------------------------


