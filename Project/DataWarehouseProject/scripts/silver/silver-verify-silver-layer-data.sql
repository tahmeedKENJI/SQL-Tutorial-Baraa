/*

Layer:      Silver
Target:     Silver

*/

USE medallion_dwh;
GO

----------------------------------------
-- explore silver.crm_cust_info table --
----------------------------------------

-- select everything from silver.crm_cust_info
SELECT TOP 1000 *
FROM   silver.crm_cust_info;

SELECT COUNT(*) FROM silver.crm_cust_info;
-- check for duplicates in cst_id
SELECT *
FROM   (SELECT *,
               COUNT(*) OVER (PARTITION BY cst_id) AS repeat_num_cst_id
        FROM   silver.crm_cust_info) AS t
WHERE  repeat_num_cst_id > 1 OR cst_id IS NULL;
-- check for empty spaces in the strings
SELECT * 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT * 
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT * 
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT * 
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- check for Inconsistency
SELECT
    cst_gndr
FROM silver.crm_cust_info
GROUP BY cst_gndr;

SELECT
    cst_marital_status
FROM silver.crm_cust_info
GROUP BY cst_marital_status;

---------------------------------------
-- explore silver.crm_prd_info table --
---------------------------------------

-- select everything from silver.crm_prd_info
SELECT TOP (1000) *
FROM   silver.crm_prd_info; -- check for duplicates in prd_id

SELECT *
FROM   (SELECT *,
               COUNT(*) OVER (PARTITION BY prd_key) AS repeat_num_prd_key
        FROM   silver.crm_prd_info) AS t
WHERE  repeat_num_prd_key > 1;

-- check for duplicates in prd_key
SELECT *
FROM   (SELECT *,
               COUNT(*) OVER (PARTITION BY prd_key) AS repeat_num_prd_key
        FROM   silver.crm_prd_info) AS t
WHERE  prd_key IS NULL;

-- check if prd_nm need trimming or IS NULL
SELECT
*
FROM silver.crm_prd_info
WHERE TRIM(prd_nm) != prd_nm OR prd_nm IS NULL;

-- check for number quality of prd_cost: NULLs or Negatives
SELECT
*
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- check quality of prd_cost: Categories, NULLs
SELECT
prd_line
FROM silver.crm_prd_info
GROUP BY prd_line;

-- start and end date: greater start date
SELECT *,
COUNT(*) OVER (PARTITION BY prd_key) prd_key_reps
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;
-- my prediction was the use of some window function.
-- I was right. Also about completely ditching end_date
-- And lead window function the end date.

--------------------------------------------
-- explore silver.crm_sales_details table --
--------------------------------------------

-- select everything from silver.crm_sales_details
SELECT TOP (1000) *
FROM   silver.crm_sales_details;

-- Check for keys existing
SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);
-- pass

SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);
-- pass

-- Check for unwanted spaces
SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);
-- Pass

SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);
-- Pass

-- Check For NULLs
SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL OR sls_cust_id < 0;
-- Pass

SELECT
	*
FROM silver.crm_sales_details
WHERE sls_sales IS NULL OR sls_sales < 0;
-- ISSUES

SELECT
	*
FROM silver.crm_sales_details
WHERE sls_quantity IS NULL OR sls_quantity < 0;
-- pass

SELECT
	*
FROM silver.crm_sales_details
WHERE sls_price IS NULL OR sls_price < 0;
-- ISSUES

-- check for condition SALES = PRICE * QUANTITY
SELECT *,
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
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity
OR sls_sales IS NULL OR sls_sales < 0
OR sls_quantity IS NULL OR sls_quantity < 0
OR sls_price IS NULL OR sls_price < 0;
-- talk to the source system admins, experts. Depends on the rules.
-- Let's use when bad data
-- Sales = ABS(Price) * Quantity; if not ABS(Price) * Quantity, negative, null, zero
-- Price = Sales / Quantity; null, negative or zero

-- Check for invalid dates
SELECT
	sls_order_dt,
	ISDATE(CAST(sls_order_dt AS NVARCHAR(10))),
	NULLIF(ISDATE(CAST(sls_order_dt AS NVARCHAR(10))), 0)
FROM silver.crm_sales_details
WHERE ISDATE(CAST(sls_order_dt AS NVARCHAR(10))) = 0;
-- ISSUES

SELECT
	sls_ship_dt,
	ISDATE(CAST(sls_ship_dt AS NVARCHAR(10)))
FROM silver.crm_sales_details
WHERE ISDATE(CAST(sls_ship_dt AS NVARCHAR(10))) = 0;
-- Pass

SELECT
	sls_due_dt,
	ISDATE(CAST(sls_due_dt AS NVARCHAR(10)))
FROM silver.crm_sales_details
WHERE ISDATE(CAST(sls_due_dt AS NVARCHAR(10))) = 0;
-- Pass

SELECT
	*
FROM silver.crm_sales_details
WHERE DATEDIFF(day, sls_order_dt, sls_ship_dt) < 0;
-- check occurs in the transformation script

--------------------------------------------
-- explore silver.erp_cust_az12 table --
--------------------------------------------

-- select everything from silver.erp_cust_az12
SELECT TOP (1000) *
FROM   silver.erp_cust_az12;

-- Standard checks: Validity, Duplicacy, NULLs
-- Check: cid is NULL?
SELECT TOP (1000)
	cid, 
	bdate, 
	gen
FROM   silver.erp_cust_az12
WHERE cid IS NULL;

-- Check: Repeating cid
SELECT
	cid_2,
	bdate,
	gen,
	repeats
FROM(
	SELECT
		*,
		COUNT(*) OVER (PARTITION BY cid_2 ORDER BY bdate DESC) repeats
	FROM (
		SELECT
			cid,
			CASE
				WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
				ELSE cid
			END cid_2,
			bdate, 
			gen
		FROM   silver.erp_cust_az12
	)t
)t1 WHERE repeats > 1;
--WHERE cid LIKE 'AW%';
-- Result: cid formatting is different
-- After correct formatting, no duplicate keys

-- check: unique cid exists or not
SELECT
	cid_2,
	bdate,
	gen
FROM (
	SELECT
		cid,
		CASE
			WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
			ELSE cid
		END cid_2,
		bdate, 
		gen
	FROM   silver.erp_cust_az12
)t WHERE cid_2 NOT IN (
	SELECT cst_key FROM silver.crm_cust_info
);

-- Check: valid dates
SELECT TOP (1000)
	cid, 
	bdate,
	ISDATE(CAST(bdate AS NVARCHAR(10))) flag_bdate,
	gen
FROM   silver.erp_cust_az12
WHERE ISDATE(CAST(bdate AS NVARCHAR(10))) = 0 AND bdate IS NOT NULL;

-- Check: Date in feasible range
SELECT
	cid, 
	bdate,
	gen
FROM   silver.erp_cust_az12
WHERE bdate NOT BETWEEN DATEADD(year, -150, GETDATE()) AND GETDATE();

-- Check: data standardization
SELECT
	gen,
	CASE 
		WHEN UPPER(gen) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(gen) IN ('F', 'FEMALE') THEN 'Female'
		ELSE 'N/A'
	END gen_fixed
FROM   silver.erp_cust_az12
GROUP BY gen;

--------------------------------------------
-- explore silver.erp_loc_a101 table --
--------------------------------------------

-- select everything from silver.erp_loc_a101
SELECT TOP (1000) *
FROM   silver.erp_loc_a101;

-- cid is NULL
SELECT TOP (1000) *
FROM   silver.erp_loc_a101
WHERE cid IS NULL;

-- cid format exploration
SELECT TOP (1000) 
COUNT(*)
FROM   silver.erp_loc_a101
WHERE cid LIKE 'AW%';

-- check for unique cid not in crm_cust_info
SELECT
	cid_2
FROM (
	SELECT
		cid,
		REPLACE(TRIM(cid), '-', '') cid_2,
		cntry
	FROM silver.erp_loc_a101
)t
WHERE cid_2 NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Check distinct country names
SELECT
	cntry,
	CASE
		WHEN cntry IS NULL OR LEN(TRIM(cntry)) = 0 THEN 'N/A'
		WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
		WHEN UPPER(TRIM(cntry)) IN ('UNITED STATES', 'USA', 'US') THEN 'United States'
		ELSE TRIM(cntry)
	END cntry_fixed
FROM silver.erp_loc_a101
GROUP BY cntry;

--------------------------------------------
-- explore silver.erp_px_cat_g1v2 table --
--------------------------------------------

-- select everything from silver.erp_px_cat_g1v2
SELECT TOP (1000) *
FROM   silver.erp_px_cat_g1v2;

-- Check: NULL id
SELECT TOP (1000) *
FROM   silver.erp_px_cat_g1v2
WHERE id IS NULL;

--Check: id unique from cat_id in crm_prd_info
SELECT TOP (1000) *
FROM   silver.erp_px_cat_g1v2
WHERE id NOT IN (
	SELECT cat_id FROM silver.crm_prd_info
);

-- check: Unwanted Spaces
SELECT TOP (1000) *
FROM   silver.erp_px_cat_g1v2
WHERE id != TRIM(id)
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance);

-- Check: Standardization & Normalization
SELECT 
	cat
FROM   silver.erp_px_cat_g1v2
GROUP BY cat;

-- Check: Standardization & Normalization
SELECT 
	subcat
FROM   silver.erp_px_cat_g1v2
GROUP BY subcat;

-- Check: Standardization & Normalization
SELECT 
	maintenance
FROM   silver.erp_px_cat_g1v2
GROUP BY maintenance;
