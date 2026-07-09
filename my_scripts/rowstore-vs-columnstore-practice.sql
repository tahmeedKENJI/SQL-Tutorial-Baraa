USE AdventureWorksDW2022;
GO

--##--

--	Create copy and store as heap...
--	SELECT *
--	INTO dbo.FactInternetSaler_HEAP
--	FROM dbo.FactInternetSales

--##--

--	Create copy and Rowstore (Clustered vs Nonclustered)
SELECT *
INTO dbo.FactInternetSaler_RS_C
FROM dbo.FactInternetSales

CREATE CLUSTERED INDEX idx_FactInternetSales_RS_C_SalesOrderNumber
ON dbo.FactInternetSaler_RS_C (SalesOrderNumber)

--	DROP INDEX idx_r_c_FactInternetSales_SalesOrderNumber
--	ON dbo.FactInternetSaler_RS_C

--##--

--	Create copy and Columnstore (Clustered vs Nonclustered)
SELECT *
INTO dbo.FactInternetSaler_CS_C
FROM dbo.FactInternetSales

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_C_SalesOrderNumber
ON dbo.FactInternetSaler_CS_C

--	DROP INDEX idx_FactInternetSales_CS_C_SalesOrderNumber
--	ON dbo.FactInternetSaler_CS_C

--##--

--	Create copy and Columnstore (Clustered vs Nonclustered)
SELECT *
INTO dbo.FactInternetSaler_CS_N
FROM dbo.FactInternetSales

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_N_SalesOrderNumber
ON dbo.FactInternetSaler_CS_N (SalesOrderNumber)

--	DROP INDEX idx_FactInternetSales_CS_C_SalesOrderNumber
--	ON dbo.FactInternetSaler_CS_C

--##--

