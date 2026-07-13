USE SalesDB_3;
GO
---------------------------------------------------------------------------------------
SELECT *,
	ROUND(CAST((CurrentSales - PreviousSales) AS FLOAT) / PreviousSales * 100, 2) MoM_C
FROM (
	SELECT
		DATEPART(month, OrderDate) OrderMonthPart,
		SUM(Sales) CurrentSales,
		LAG(SUM(Sales), 1) OVER (ORDER BY DATEPART(month, OrderDate)) PreviousSales
	FROM Sales.Orders
	GROUP BY DATEPART(month, OrderDate)
)t
---------------------------------------------------------------------------------------
-- rank customers based on the average days between their orders
SELECT 
	CustomerID,
	AvgDayDifference,
	RANK() OVER (ORDER BY NullFiltering, AvgDayDifference) CustomerRank
FROM(
	-- Query 2: Generate average day difference between orders and null filtering 
	SELECT
		CustomerID,
		AVG(DATEDIFF(day, PreviousOrderDate, CurrentOrderDate)) AvgDayDifference,
		CASE
			WHEN AVG(DATEDIFF(day, PreviousOrderDate, CurrentOrderDate)) IS NULL THEN 1
			ELSE 0
		END NullFiltering
	FROM (
		-- Query 1: Generate Previous and Next Order Dates
		SELECT
			CustomerID,
			OrderDate PreviousOrderDate,
			LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) CurrentOrderDate
		FROM Sales.Orders
	)t
	GROUP BY CustomerID
)t