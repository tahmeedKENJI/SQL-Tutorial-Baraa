USE SalesDB_3;
GO

-------------------------------------------------------------------------------

-- Find the running total of sales for each month
--	WITH CTE_ORDER_MONTH AS (
--		SELECT
--			OrderID,
--			MONTH(OrderDate) OrderMonth
--		FROM Sales.Orders
--	)
--	SELECT
--		o.OrderID,
--		o.OrderDate,
--		o.Sales,
--		SUM(o.Sales) OVER (	PARTITION BY om.OrderMonth 
--							ORDER BY o.Sales
--							ROWS UNBOUNDED PRECEDING)
--	FROM Sales.Orders AS o
--	INNER JOIN CTE_ORDER_MONTH as om
--	ON o.OrderID = om.OrderID
-- This is not what was required

-------------------------------------------------------------------------------

-- Find the running total of sales for each month
WITH Monthly_Summary AS (
	SELECT
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) TotalSales,
	COUNT(OrderID) TotalOrder,
	SUM(Quantity) TotalQuantity
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
)
SELECT
--OrderMonth,
*,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS MonthlyRunningTotal
FROM Monthly_Summary

-------------------------------------------------------------------------------

-- Let's put the aggregations query into a view
--	CREATE VIEW Sales.SalesAggregations AS 
--	(
--		SELECT
--		MONTH(OrderDate) OrderMonth,
--		SUM(Sales) TotalSales,
--		COUNT(OrderID) TotalOrder,
--		SUM(Quantity) TotalQuantity
--		FROM Sales.Orders
--		GROUP BY MONTH(OrderDate)
--	)
--	Apparently, the create statement likes to be the only statement in a query.
--	For future use, please un-comment it and run. Once done, comment it back. Thank you

-------------------------------------------------------------------------------

--	SELECT 
--	*
--	FROM SalesAggregation
-- For some reason, this query is working in another file. Not here.
-- The view exists. You can query it. But not here (-_-)

-------------------------------------------------------------------------------

--	Let's practice DROP. Let's delete the view in the default schema
--	DROP VIEW dbo.SalesAggregations;
--	DROP can stay among other queries. Not a loner like CREATE.
--	But same instructions as CREATE go here

-------------------------------------------------------------------------------

--	IF OBJECT_ID ('Sales.SalesAggregations', 'V') IS NOT NULL
--		DROP VIEW Sales.SalesAggregations
--	GO -- Aspects of T-SQL
--	CREATE VIEW Sales.SalesAggregations AS 
--	(
--		SELECT
--		MONTH(OrderDate) OrderMonth,
--		SUM(Sales) TotalSales,
--		COUNT(OrderID) TotalOrder
--		FROM Sales.Orders
--		GROUP BY MONTH(OrderDate)
--	)

-------------------------------------------------------------------------------



-------------------------------------------------------------------------------


