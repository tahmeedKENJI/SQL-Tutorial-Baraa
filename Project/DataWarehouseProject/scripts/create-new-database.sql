/*
(This is a "header comment".
It contains the purpose of this script.
It contains warnings about running the script)

**Create Database and Schema**

Use Case:
- Check first if exists the data warehouse "medallion_dwh".
- Create the data warehouse after deleting the existing one
- Create the schemas for the data warehouse: bronze, silver and gold

!! WARNING !!
Running this script will nuke the entire database. All data will be permanently deleted.
Proceed with caution. Make backups of the database if necessary BEFORE running this script.
*/

-----------------------------
---- Switch To Master DB ----
-----------------------------

USE master;
GO

-------------------------------
---- Create Data Warehouse ----
-------------------------------

-- Check if the database exists first
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'medallion_dwh')
BEGIN
    ALTER DATABASE medallion_dwh SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE medallion_dwh;
END;
GO

-- Create the database
CREATE DATABASE medallion_dwh;
GO

-------------------------------------------------
---- Switch To Data Warehouse: Medallion_DWH ----
-------------------------------------------------

USE medallion_dwh;
GO

----------------------------------------------
---- Create Schemas: Bronze, Silver, Gold ----
----------------------------------------------

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO