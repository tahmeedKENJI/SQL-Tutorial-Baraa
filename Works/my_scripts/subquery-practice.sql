USE SalesDB_3;
GO

----------------------------------------------------------

SELECT *
FROM (
	SELECT
	p.ProductID,
	p.Product,
	p.Price,
	AVG(p.Price) OVER () AveragePrice
	FROM Sales.Products as p
) AS SubQuery1
WHERE SubQuery1.Price > SubQuery1.AveragePrice

----------------------------------------------------------

-- rank the customers based on their total amounts of sales
SELECT *,
RANK() OVER (ORDER BY SubQuery1.TotalSales DESC) CustRankByTotSales
FROM(
	SELECT
	o.CustomerID,
	SUM(o.Sales) AS TotalSales
	FROM Sales.Orders AS o
	GROUP BY o.CustomerID
) AS SubQuery1

----------------------------------------------------------

SELECT
p.ProductID,
p.Product,
p.Price,
(
	SELECT
	COUNT(o.OrderID)
	FROM Sales.Orders AS o
) AS TotalOrders
FROM Sales.Products AS p

----------------------------------------------------------

-- show all customer details and find the total orders of each customer
SELECT 
c.*,
CustomerOrder.TotalOrdersPerCustomer
FROM Sales.Customers as c
LEFT JOIN (
	SELECT
	o.CustomerID,
	COUNT(o.OrderID) TotalOrdersPerCustomer
	FROM Sales.Orders AS o
	GROUP BY o.CustomerID
) AS CustomerOrder
ON c.CustomerID = CustomerOrder.CustomerID

----------------------------------------------------------

-- show details of order made by german customers
SELECT
o.*
FROM Sales.Orders AS o
--WHERE CustomerID NOT IN (
WHERE CustomerID = ANY (
	SELECT
	c.CustomerID
	FROM Sales.Customers AS c
	WHERE c.Country = 'Germany'
)

----------------------------------------------------------

-- female employee salaries greater than any male employee salary
SELECT *
FROM Sales.Employees AS e
WHERE e.Gender = 'F' 
AND e.Salary > ANY(
	SELECT 
	Salary
	FROM Sales.Employees as esq
	WHERE esq.Gender = 'M'
)

----------------------------------------------------------
