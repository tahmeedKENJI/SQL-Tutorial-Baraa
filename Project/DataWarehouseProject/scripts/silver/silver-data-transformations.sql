/*

Purpose:
Create a Stored Procedure to Transform and Load Data into The Silver Layer

Methods:
-	Truncate Full Table and Load
-	Apply Transformation to The Columns
-	Use Error Handling for Debugging Purposes

Data Modeling:
None

*/

USE medallion_dwh;
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
	DECLARE @StartTime DATETIME2;
	DECLARE @EndTime DATETIME2;
	DECLARE @BatchStartTime DATETIME2;
	DECLARE @BatchEndTime DATETIME2;
	BEGIN TRY

		SET @BatchStartTime = SYSDATETIME();

		PRINT '===============================================================';
		PRINT 'LOADING SILVER LAYER';
		PRINT '===============================================================';

		--====================================================--
		-- Transform and Load into silver.crm_cust_info table --
		--====================================================--

		SET @StartTime = SYSDATETIME();

		PRINT '--------------------------------------------';
		PRINT 'Transform and Load into silver.crm_cust_info';
		PRINT '--------------------------------------------';
		
		PRINT '>> Truncating Table';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Loading into table';
		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			-- Transformation: Remove Unwanted Spaces
			TRIM(cst_firstname) cst_firstname,	-- Remove the
			TRIM(cst_lastname) cst_lastname,	-- unwanted spaces
			-- Transformation: Data Normalization and Standardization
			-- Transformation: Handling Missing Data
			CASE	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'	-- In case the letters are
					WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'	-- not capital
					ELSE 'N/A'
			END AS cst_marital_status,
			CASE	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
					WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
					ELSE 'N/A'
			END AS cst_gndr,
			cst_create_date
		FROM (
			SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) latest_create_dt
			FROM bronze.crm_cust_info
		) t
		-- Transformation: Remove Duplicates
		WHERE latest_create_dt = 1 
		AND cst_id IS NOT NULL; -- Rank the latest cst_id as 1 and keep only that.

		SET @EndTime = SYSDATETIME();
		PRINT 'Duration (ms): ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);

		--===================================================--
		-- Transform and Load into silver.crm_prd_info table --
		--===================================================--

		SET @StartTime = SYSDATETIME();

		PRINT '-------------------------------------------';
		PRINT 'Transform and Load into silver.crm_prd_info';
		PRINT '-------------------------------------------';

		PRINT '>> Truncating Table';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Loading into table'
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			-- Transformation: Derived New Columns
			REPLACE(SUBSTRING(TRIM(prd_key), 1, 5), '-', '_') cat_id,
			SUBSTRING(TRIM(prd_key), 7, LEN(TRIM(prd_key))) prd_key,
			prd_nm,
			-- Transformation: NULL Handling
			COALESCE(prd_cost, 0) prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Sport'
				WHEN 'T' THEN 'Touring'
				ELSE 'N/A'
			END AS prd_line,
			prd_start_dt,
			-- Transformation: Data Enrichment, adding new, relevant data
			DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS prd_end_dt
		FROM bronze.crm_prd_info;

		SET @EndTime = SYSDATETIME();
		PRINT 'Duration (ms): ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);

		--========================================================--
		-- Transform and Load into silver.crm_sales_details table --
		--========================================================--

		SET @StartTime = SYSDATETIME();

		PRINT '------------------------------------------------';
		PRINT 'Transform and Load into silver.crm_sales_details';
		PRINT '------------------------------------------------';

		PRINT '>> Truncating Table';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Loading into table'
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			-- Make Sure Date Ordering is Maintained
			CASE
				WHEN DATEDIFF(day, sls_order_dt, sls_ship_dt) < 0 THEN NULL
				WHEN DATEDIFF(day, sls_order_dt, sls_due_dt) < 0 THEN NULL
				ELSE sls_order_dt
			END sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		FROM (
			SELECT
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				-- Transformation: Handling Invalid Data
				-- Transformation: Performing Appropriate Data Type Casting
				CASE
					WHEN ISDATE(sls_order_dt) = 0 THEN NULL
					ELSE CAST(sls_order_dt AS DATE)
				END sls_order_dt,
				CASE
					WHEN ISDATE(sls_ship_dt) = 0 THEN NULL
					ELSE CAST(sls_ship_dt AS DATE)
				END sls_ship_dt,
				CASE
					WHEN ISDATE(sls_due_dt) = 0 THEN NULL
					ELSE CAST(sls_due_dt AS DATE)
				END sls_due_dt,
				-- Transformation: Handling Invalid and Missing Data
				-- By DERIVING COLUMN from other related columns.
				CASE 
					WHEN sls_sales IS NULL OR sls_sales <= 0
						OR sls_sales != ABS(sls_price) * sls_quantity 
						THEN ABS(sls_price) * sls_quantity
					ELSE sls_sales
				END sls_sales,
				sls_quantity,
				CASE 
					WHEN sls_price IS NULL OR sls_price <= 0 
						THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
					ELSE sls_price
				END sls_price
			FROM bronze.crm_sales_details
		) t

		SET @EndTime = SYSDATETIME();
		PRINT 'Duration (ms): ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);

		--====================================================--
		-- Transform and Load into silver.erp_cust_az12 table --
		--====================================================--

		SET @StartTime = SYSDATETIME();

		PRINT '--------------------------------------------';
		PRINT 'Transform and Load into silver.erp_cust_az12';
		PRINT '--------------------------------------------';

		PRINT '>> Truncating Table';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Loading into table'
		INSERT INTO silver.erp_cust_az12
		(
			cid,
			bdate,
			gen
		)
		SELECT
			-- Transformation: Hanfle Invalid Values
			CASE
				WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
				ELSE cid
			END cid,
			CASE
				WHEN bdate NOT BETWEEN DATEADD(year, -150, GETDATE()) AND GETDATE()
					THEN NULL
				ELSE bdate
			END bdate,
			CASE 
				WHEN UPPER(gen) IN ('M', 'MALE') THEN 'Male'
				WHEN UPPER(gen) IN ('F', 'FEMALE') THEN 'Female'
				ELSE 'N/A'
			END gen
		FROM bronze.erp_cust_az12;

		SET @EndTime = SYSDATETIME();
		PRINT 'Duration (ms): ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);

		--===================================================--
		-- Transform and Load into silver.erp_loc_a101 table --
		--===================================================--

		SET @StartTime = SYSDATETIME();

		PRINT '-------------------------------------------';
		PRINT 'Transform and Load into silver.erp_loc_a101';
		PRINT '-------------------------------------------';

		PRINT '>> Truncating Table';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Loading into table'
		INSERT INTO silver.erp_loc_a101
		(
			cid,
			cntry
		)
		SELECT
			REPLACE(TRIM(cid), '-', '') cid,
			CASE
				WHEN cntry IS NULL OR LEN(TRIM(cntry)) = 0 THEN 'N/A'
				WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
				WHEN UPPER(TRIM(cntry)) IN ('UNITED STATES', 'USA', 'US') THEN 'United States'
				ELSE TRIM(cntry)
			END cntry
		FROM bronze.erp_loc_a101;

		SET @EndTime = SYSDATETIME();
		PRINT 'Duration (ms): ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);

		--======================================================--
		-- Transform and Load into silver.erp_px_cat_g1v2 table --
		--======================================================--

		SET @StartTime = SYSDATETIME();

		PRINT '----------------------------------------------';
		PRINT 'Transform and Load into silver.erp_px_cat_g1v2';
		PRINT '----------------------------------------------';

		PRINT '>> Truncating Table';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Loading into table'
		INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT 
			TRIM(id) id,
			TRIM(cat) cat,
			TRIM(subcat) subcat,
			TRIM(maintenance) maintenance
		FROM   bronze.erp_px_cat_g1v2

		SET @EndTime = SYSDATETIME();
		PRINT 'Duration (ms): ' + CAST(DATEDIFF(millisecond, @StartTime, @EndTime) AS NVARCHAR);

		SET @BatchEndTime = SYSDATETIME();
		PRINT '===============================================================';
		PRINT 'COMPLETED LOADING SILVER LAYER';
		PRINT 'Total Duration (ms): ' + CAST(DATEDIFF(millisecond, @BatchStartTime, @BatchEndTime) AS NVARCHAR);
		PRINT '===============================================================';
	END TRY
	BEGIN CATCH
		PRINT '==================================';
		PRINT 'ERROR: COULD NOT LOAD SILVER LAYER';
		PRINT '==================================';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT 'LINE NUMBER: ' + ERROR_LINE();
	END CATCH
END
