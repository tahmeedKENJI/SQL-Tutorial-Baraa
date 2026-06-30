USE SalesDB_3;
GO

SELECT
	OrderID,
	OrderDate,
	DATEADD(year, 3, OrderDate) order_date_3_yrs,
	DATEADD(quarter, 2, OrderDate) order_date_2_quarters,
	DATEADD(month, 10, OrderDate) order_date_10_months,
	DATEADD(day, 13, OrderDate) order_date_13_days
FROM Sales.Orders

SELECT
	OrderID,
	OrderDate,
	ShipDate,
	DATEDIFF(day, OrderDate, ShipDate) AS ShipDurationDays,
	DATEDIFF(month, OrderDate, ShipDate) AS ShipDurationMonths,
	DATEDIFF(year, OrderDate, ShipDate) AS ShipDurationYears
FROM Sales.Orders

SELECT
	EmployeeID,
	FirstName,
	LastName,
	BirthDate,
	DATEDIFF(year, BirthDate, GETDATE()) Age
FROM Sales.Employees

SELECT
	--DATEPART(year, OrderDate) OrderYear,
	DATENAME(month, OrderDate) OrderMonth,
	AVG(DATEDIFF(day, OrderDate, ShipDate)) AvgShippingDurationDays
FROM Sales.Orders
--GROUP BY DATENAME(month, OrderDate)
GROUP BY DATENAME(month, OrderDate)

SELECT
	OrderID,
	LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
	OrderDate PresentOrderDate,
	DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate)
FROM Sales.Orders
ORDER BY OrderDate

SELECT
	OrderDate,
	ISDATE(CONVERT(VARCHAR, OrderDate)),
	'2025-31-31',
	ISDATE('2025-31-31')
FROM Sales.Orders

SELECT
	OrderDate,
	ISDATE(OrderDate) DateValidation,
	CASE
		WHEN ISDATE(OrderDate) = 1
		THEN CAST(OrderDate AS DATE)
		ELSE '1899-01-01'
	END AS OrderDateDate
FROM (
	SELECT '2026-12-01' as OrderDate
	UNION
	SELECT '2026-12-11' as OrderDate
	UNION
	SELECT '2026-01' as OrderDate
	UNION
	SELECT '2026-09-01' as OrderDate
)t