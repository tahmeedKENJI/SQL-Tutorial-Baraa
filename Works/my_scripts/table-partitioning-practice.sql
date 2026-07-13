USE SalesDB_3;
GO
 
-------------------------------------------------
----## CREATE PARTITION FUNCTION ##----
-------------------------------------------------

CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31')

----####----

SELECT
	pf.name,
	pf.type_desc,
	pf.function_id,
	pf.type,
	pf.boundary_value_on_right
FROM sys.partition_functions AS pf

-------------------------------------------------
----## CREATE FILEGROUP ##----
-------------------------------------------------

--	ALTER DATABASE SalesDB_3
--	ADD FILEGROUP FG_2023;
--	ALTER DATABASE SalesDB_3
--	ADD FILEGROUP FG_2024;
--	ALTER DATABASE SalesDB_3
--	ADD FILEGROUP FG_2025;
--	ALTER DATABASE SalesDB_3
--	ADD FILEGROUP FG_2026;

SELECT * FROM sys.filegroups WHERE type = 'FG';

-------------------------------------------------
----## CREATE DATA FILES ##----
-------------------------------------------------

ALTER DATABASE SalesDB_3
ADD FILE (
	NAME = P_2023, -- logical name
	FILENAME = 'E:\Softwares\Microsoft SQL Server Directory\SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;
ALTER DATABASE SalesDB_3
ADD FILE (
	NAME = P_2024, -- logical name
	FILENAME = 'E:\Softwares\Microsoft SQL Server Directory\SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;
ALTER DATABASE SalesDB_3
ADD FILE (
	NAME = P_2025, -- logical name
	FILENAME = 'E:\Softwares\Microsoft SQL Server Directory\SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;
ALTER DATABASE SalesDB_3
ADD FILE (
	NAME = P_2026, -- logical name
	FILENAME = 'E:\Softwares\Microsoft SQL Server Directory\SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

----####----

SELECT
	fg.name FilegroupName,
	mf.name LogicalFilename,
	mf.physical_name PhysicalFilePath,
	mf.size / 128 SizeInMB
FROM		sys.filegroups fg
INNER JOIN	sys.master_files mf
ON			fg.data_space_id = mf.data_space_id
WHERE		mf.database_id = DB_ID('SalesDB_3')

-------------------------------------------------
----## CREATE PARTITION SCHEMA ##----
-------------------------------------------------

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026) -- 3 boundaries -> 4 partitions -> 4 filegroups

----####----

SELECT
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFucntionName,
	ds.destination_id AS PartitionNumber,
	fg.name as FileGroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id

-------------------------------------------------
----## CREATE PARTITIONED TABLE ##----
-------------------------------------------------

CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)

-------------------------------------------------
----## INSERT DATA INTO PARTITIIONED TABLE ##----
-------------------------------------------------

INSERT INTO Sales.Orders_Partitioned
VALUES	(1, '2023-02-11', 50),
		(2, '2025-11-30', 70);

----####----

SELECT
	p.partition_number AS PartitionNumber,
	f.name AS PartitionFIleGroup,
	p.rows AS NumberOfRows
FROM sys.partitions AS p
JOIN sys.destination_data_spaces AS dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups AS f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned'

----####----
