USE SalesDB_3;
GO

SELECT 
	OrderID,
	BillAddress,
	DATALENGTH(BillAddress),
	NULLIF(TRIM(BillAddress), '') UpdatedBillAddress
FROM Sales.Orders
--WHERE NULLIF(TRIM(BillAddress), '') IS NOT NULL
ORDER BY NULLIF(TRIM(BillAddress), '')


WITH DataTable AS (
	SELECT 1 AS ID, 'A' AS Category
	UNION
	SELECT 2 , NULL
	UNION
	SELECT 3 , ''
	UNION
	SELECT 4, '  '
)
SELECT *,
	DATALENGTH(Category) CategoryL,
	TRIM(Category) Policy1,
	--DATALENGTH(TRIM(Category)) CategoryLen,
	NULLIF(TRIM(Category), '') Policy2,
	COALESCE(NULLIF(TRIM(Category), ''), 'unknown') Policy3
FROM DataTable