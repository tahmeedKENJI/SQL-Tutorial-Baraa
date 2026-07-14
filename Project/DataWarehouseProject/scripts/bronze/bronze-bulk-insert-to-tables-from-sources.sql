/*

Create Stored Procedure for 
- Loading data 
- From CRM and ERP csv files to Bronze Layer Tables

Notes: 
-	When running this script inside SQL Server Mgmnt Studio,
	Enable Query -> SQLCMD Mode. 
	Then, after setvar, provide the path to the sources on your local device

*/

-- Set Environment Variable
--	:setvar CRM_CUST_INFO_PATH		"your\path\goes\here"
--	:setvar CRM_PRD_INFO_PATH		"your\path\goes\here"
--	:setvar CRM_SALES_DETAILS_PATH	"your\path\goes\here"
--	:setvar ERP_CUST_AZ12_PATH		"your\path\goes\here"
--	:setvar ERP_LOC_A101_PATH		"your\path\goes\here"
--	:setvar ERP_PX_CAT_G1V2_PATH	"your\path\goes\here"

-- Set Dateformat
-- SET DATEFORMAT dmy;	-- source dates are formatted this way
						-- Only alters the parsing rules
						-- NOT storing mechanism, NOT server configuration

-- SWITCH TO medallion_dwh
USE medallion_dwh;
GO

-----------------------------------------
-- Create Stored Procedure For Loading --
-----------------------------------------
CREATE OR ALTER PROCEDURE bronze.load_bronze_csv_to_table
AS
BEGIN
	DECLARE @StartTime DATETIME2;
	DECLARE @EndTime DATETIME2;
	DECLARE @BatchStartTime DATETIME2;
	DECLARE @BatchEndTime DATETIME2;

	BEGIN TRY
		-----------------------------------
		-- BULK INSERT DATA FROM SOURCES --
		-----------------------------------

		PRINT '================================================================';
		PRINT 'LOADING THE BRONZE LAYER';
		PRINT '================================================================';

		SET @BatchStartTime = SYSDATETIME();

		PRINT '------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------';

		SET @StartTime = SYSDATETIME(); -- Start Time of Loading
		-- Empty the table crm_cust_info.
		PRINT '>> Truncating bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		-- insert into the crm_cust_info table in bulk
		PRINT '>> Bulk Inserting to bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM "$(CRM_CUST_INFO_PATH)"
		WITH (
			FIRSTROW = 2, -- Row 1 of csv files contains the column names. not actual data
			FIELDTERMINATOR = ',', -- comma separated values. field terminator/delimiter is ','
			ROWTERMINATOR = '\n', -- New starts after 'newline' or '\n' character
			TABLOCK,
			KEEPNULLS
		);
		SET @EndTime = SYSDATETIME(); -- End Time of Loading
		PRINT 'Loading Time in s : ' + CAST(DATEDIFF(second, @StartTime, @EndTime) AS NVARCHAR);
		PRINT 'Loading Time in ms: ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);
		PRINT '----------------';

		SET @StartTime = SYSDATETIME(); -- Start Time of Loading
		-- Empty the table crm_prd_info.
		PRINT '>> Truncating bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		-- insert into the crm_prd_info table in bulk
		PRINT '>> Bulk Inserting to bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM "$(CRM_PRD_INFO_PATH)"
		WITH (
			FIRSTROW = 2, -- Row 1 of csv files contains the column names. not actual data
			FIELDTERMINATOR = ',', -- comma separated values. field terminator/delimiter is ','
			ROWTERMINATOR = '\n', -- New starts after 'newline' or '\n' character
			TABLOCK,
			KEEPNULLS
		);
		SET @EndTime = SYSDATETIME(); -- End Time of Loading
		PRINT 'Loading Time in s : ' + CAST(DATEDIFF(second, @StartTime, @EndTime) AS NVARCHAR);
		PRINT 'Loading Time in ms: ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);
		PRINT '----------------';

		SET @StartTime = SYSDATETIME(); -- Start Time of Loading
		-- Empty the table crm_sales_details.
		PRINT '>> Truncating bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		-- insert into the crm_sales_details table in bulk
		PRINT '>> Bulk Inserting to bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM "$(CRM_SALES_DETAILS_PATH)"
		WITH (
			FIRSTROW = 2, -- Row 1 of csv files contains the column names. not actual data
			FIELDTERMINATOR = ',', -- comma separated values. field terminator/delimiter is ','
			ROWTERMINATOR = '\n', -- New starts after 'newline' or '\n' character
			TABLOCK,
			KEEPNULLS
		);
		SET @EndTime = SYSDATETIME(); -- End Time of Loading
		PRINT 'Loading Time in s : ' + CAST(DATEDIFF(second, @StartTime, @EndTime) AS NVARCHAR);
		PRINT 'Loading Time in ms: ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);
		PRINT '----------------';

		PRINT '------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------';

		SET @StartTime = SYSDATETIME(); -- Start Time of Loading
		-- Empty the table erp_cust_az12.
		PRINT '>> Truncating bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		-- insert into the erp_cust_az12 table in bulk
		PRINT '>> Bulk Inserting to bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM "$(ERP_CUST_AZ12_PATH)"
		WITH (
			FIRSTROW = 2, -- Row 1 of csv files contains the column names. not actual data
			FIELDTERMINATOR = ',', -- comma separated values. field terminator/delimiter is ','
			ROWTERMINATOR = '\n', -- New starts after 'newline' or '\n' character
			TABLOCK,
			KEEPNULLS
		);
		SET @EndTime = SYSDATETIME(); -- End Time of Loading
		PRINT 'Loading Time in s : ' + CAST(DATEDIFF(second, @StartTime, @EndTime) AS NVARCHAR);
		PRINT 'Loading Time in ms: ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);
		PRINT '----------------';

		SET @StartTime = SYSDATETIME(); -- Start Time of Loading
		-- Empty the table erp_loc_a101.
		PRINT '>> Truncating bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		-- insert into the erp_loc_a101 table in bulk
		PRINT '>> Bulk Inserting to bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM "$(ERP_LOC_A101_PATH)"
		WITH (
			FIRSTROW = 2, -- Row 1 of csv files contains the column names. not actual data
			FIELDTERMINATOR = ',', -- comma separated values. field terminator/delimiter is ','
			ROWTERMINATOR = '\n', -- New starts after 'newline' or '\n' character
			TABLOCK,
			KEEPNULLS
		);
		SET @EndTime = SYSDATETIME(); -- End Time of Loading
		PRINT 'Loading Time in s : ' + CAST(DATEDIFF(second, @StartTime, @EndTime) AS NVARCHAR);
		PRINT 'Loading Time in ms: ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);
		PRINT '----------------';

		SET @StartTime = SYSDATETIME(); -- Start Time of Loading
		-- Empty the table erp_px_cat_g1v2.
		PRINT '>> Truncating bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		-- insert into the erp_px_cat_g1v2 table in bulk
		PRINT '>> Bulk Inserting to bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM "$(ERP_PX_CAT_G1V2_PATH)"
		WITH (
			FIRSTROW = 2, -- Row 1 of csv files contains the column names. not actual data
			FIELDTERMINATOR = ',', -- comma separated values. field terminator/delimiter is ','
			ROWTERMINATOR = '\n', -- New starts after 'newline' or '\n' character
			TABLOCK,
			KEEPNULLS
		);
		SET @EndTime = SYSDATETIME(); -- End Time of Loading
		PRINT 'Loading Time in s : ' + CAST(DATEDIFF(second, @StartTime, @EndTime) AS NVARCHAR);
		PRINT 'Loading Time in ms: ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);
		PRINT '----------------';

		SET @BatchEndTime = SYSDATETIME();
		PRINT '================================================================';
		PRINT 'FINISHED LOADING BRONZE LAYER';
		PRINT 'Duration (seconds): ' + CAST(DATEDIFF(second, @BatchStartTime, @BatchEndTime) AS VARCHAR);
		PRINT '================================================================';

	END TRY
	BEGIN CATCH
		PRINT '==================================';
		PRINT 'ERROR: COULD NOT LOAD BRONZE LAYER';
		PRINT '==================================';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT 'LINE NUMBER: ' + ERROR_LINE();
	END CATCH
END