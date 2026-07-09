USE SalesDB_3;
GO

IF OBJECT_ID ('Sales.Overview', 'U') IS NOT NULL
	DROP TABLE Sales.Overview
GO
SELECT
	o.OrderID,
	COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '')  CustomerName,
	c.Country,
	p.Product,
	p.Category,
	p.Price,
	o.Quantity,
	COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '')  SalesPersonName,
	e.Department
INTO Sales.Overview
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
on o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID

SELECT *
FROM Sales.Overview