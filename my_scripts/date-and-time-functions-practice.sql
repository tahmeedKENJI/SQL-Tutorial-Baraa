SELECT
	OrderID,
	CreationTime,
	DAY(CreationTime) Day,
	MONTH(CreationTime) Month,
	YEAR(CreationTime) Year,
	--DATEPART(second, CreationTime) Second_dp,
	--DATEPART(minute, CreationTime) Minute_dp,
	--DATEPART(hour, CreationTime) Hour_dp,
	--DATEPART(day, CreationTime) Day_dp,
	--DATEPART(weekday, CreationTime) Weekday_dp,
	--DATEPART(week, CreationTime) Week_dp,
	--DATEPART(quarter, CreationTime) Quarter_dp,
	--DATEPART(month, CreationTime) Month_dp,
	--DATEPART(year, CreationTime) Year_dp,
	--DATENAME(second, CreationTime) Second_dn,
	--DATENAME(minute, CreationTime) Minute_dn,
	--DATENAME(hour, CreationTime) Hour_dn,
	--DATENAME(day, CreationTime) Day_dn,
	--DATENAME(weekday, CreationTime) Weekday_dn,
	--DATENAME(week, CreationTime) Week_dn,
	--DATENAME(quarter, CreationTime) Quarter_dn,
	--DATENAME(month, CreationTime) Month_dn,
	--DATENAME(year, CreationTime) Year_dn
	DATETRUNC(day, CreationTime) CreationTimeMonth
FROM Sales.Orders

SELECT
	DATETRUNC(month, CreationTime) CreationMonth,
	COUNT(OrderID) EntryCount
FROM Sales.Orders
GROUP BY DATETRUNC(month, CreationTime)

SELECT
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) EndOfMonth,
	CAST(EOMONTH(CreationTime) AS DATETIME2) EndOfMonth_2,
	DATETRUNC(month, EOMONTH(CreationTime)) StartOfMonth,
	CAST(DATETRUNC(month, CreationTime) AS DATE) StartOfMonth_2
FROM Sales.Orders
