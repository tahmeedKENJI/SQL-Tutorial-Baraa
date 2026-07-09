USE SalesDB_3;
GO

--# INDEX MONITORING #--

sp_helpindex 'SalesDB_3.Sales.Customers';

SELECT
tbl.name TableName,
sch.name SchemaName,
idx.name,
idx.index_id,
idx.type_desc,
idx.is_unique,
idx.is_primary_key,
dmv.*
FROM sys.tables tbl
LEFT JOIN sys.schemas sch
ON tbl.schema_id = sch.schema_id
LEFT JOIN sys.indexes idx
ON tbl.object_id = idx.object_id
LEFT JOIN sys.dm_db_index_usage_stats dmv
ON idx.object_id = dmv.object_id
AND idx.index_id = dmv.index_id
ORDER BY tbl.name, idx.name;

SELECT *
FROM sys.tables

SELECT *
FROM sys.dm_db_index_usage_stats

--##--

--	To use the index, you must limit your queries to the columns
--	that were used in making the query.
--	Otherwise, the index is skipped entirely.
SELECT
Country
FROM Sales.Customers
WHERE Country = 'USA'

--# MONITOR MISSING INDEXES #--

USE AdventureWorksDW2022
GO

SELECT
	fs.SalesOrderNumber,
	dp.EnglishProductName,
	dp.Color
FROM		dbo.FactInternetSales	AS fs
INNER JOIN	dbo.DimProduct			AS dp
ON			fs.ProductKey = dp.ProductKey
WHERE		dp.Color = 'Black'
AND			fs.OrderDateKey BETWEEN 20101229 AND 20101231

SELECT *
FROM sys.dm_db_missing_index_details

--# MONITOR DUPLICATE INDEXES #--

USE SalesDB_3;
GO

SELECT
	tbl.name										AS TableName,
	col.name										AS ColumnName,
	idx.name										AS IndexName,
	idx.type_desc									AS IndexType,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) AS ColumnCount
FROM sys.indexes		AS idx
JOIN sys.tables			AS tbl	ON idx.object_id = tbl.object_id
JOIN sys.index_columns	AS ic	ON idx.object_id = ic.object_id	AND idx.index_id = ic.index_id
JOIN sys.columns		AS col	ON col.object_id = ic.object_id	AND col.column_id = ic.column_id
ORDER BY ColumnCount DESC

--# UPDATE STATISTICS #--

SELECT
	st.object_id ObjectID,
	st.name StatsName,
	tbl.name TableName,
	sch.name SchemaName,
	sp.last_updated AS LastUpdated,
	DATEDIFF(day, sp.last_updated, GETDATE()) LastUpdateDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS ModificationCounter
FROM sys.stats AS st
INNER JOIN sys.tables AS tbl
ON st.object_id = tbl.object_id
INNER JOIN sys.schemas AS sch
ON tbl.schema_id = sch.schema_id
CROSS APPLY sys.dm_db_stats_properties(st.object_id, st.stats_id) AS sp
ORDER BY sp.modification_counter DESC;

SELECT
tbl.name,
tbl.schema_id
FROM sys.tables AS tbl

--	UPDATE STATISTICS Sales.OrdersAndProducts _WA_Sys_0000000E_01142BA1 

--#	MONITORING INDEX FRAGMENTATION #--

SELECT
	tbl.name TableName,
	idx.name IndexName,
	s.avg_fragmentation_in_percent,
	s.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s-- This is a TVF - Table Valued Function
INNER JOIN sys.tables tbl
ON s.object_id = tbl.object_id
INNER JOIN sys.indexes idx
ON idx.object_id = s.object_id
AND idx.index_id= s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC

-- REORGANIZE FRAGMENTED INDEX --
ALTER INDEX idx_Products_RS_C_U_Product ON Sales.Products_RS_C_U 
REORGANIZE;

ALTER INDEX idx_Products_RS_C_U_Product ON Sales.Products_RS_C_U 
REBUILD;

--##--