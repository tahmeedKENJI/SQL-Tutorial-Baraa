USE SalesDB_3;

SELECT 
	o.OrderID,
	c.FirstName,
	c.LastName,
	p.Product,
	p.Price
INTO #OrdersOverview
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID;

SELECT *
INTO Sales.OrdersOverviewNoBottle
FROM #OrdersOverview
WHERE Product != 'Bottle'