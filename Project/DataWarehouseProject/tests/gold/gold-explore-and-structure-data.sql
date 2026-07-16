/*
===============================================================
Gold Layer: Testing Script 
===============================================================

Purpose:
- Testing out the modifications and data modeling from silver layer
- Prepare the data and format into Star Schema: Fact and Dimension Tables
*/

USE medallion_dwh;
GO

--============================--
-- Customer Dimension Testing --
--============================--

-- Check if there are any duplicate customer ids
SELECT
	cst_id,
	COUNT(*)
FROM (
	-- Join all the customer tables from the silver layers
	-- Naming: User-friendly names
	-- Ordering: Order columns in a way that improves data presentation
	-- Fact or Dimension? This table describes the customers -> Dimension Table
	-- Dimension tables need a PRIMARY KEYS. NEVER use table keys directly. Build a SURROGATE KEY
	-- Surrogate key naming convention: <table_indentifier>_key
	SELECT
		ROW_NUMBER() OVER (ORDER BY sci.cst_id) customer_key,
		sci.cst_id				AS customer_id,
		sci.cst_key				AS customer_number,
		sci.cst_firstname		AS first_name,
		sci.cst_lastname		AS last_name,
		sca.bdate				AS birth_date,
		sla.cntry				AS country,
		sci.cst_marital_status	AS marital_status,
		CASE
			WHEN sci.cst_gndr != 'N/A' THEN sci.cst_gndr
			ELSE COALESCE(sca.gen, 'N/A')
		END						AS gender,
		sci.cst_create_date		AS creation_date
	FROM		silver.crm_cust_info AS sci
	LEFT JOIN	silver.erp_cust_az12 AS sca
	ON			sci.cst_key = sca.cid
	LEFT JOIN	silver.erp_loc_a101 AS sla
	ON			sci.cst_key = sla.cid
) t
GROUP BY cst_id
HAVING COUNT(*) != 1;

-- Data Integration:
-- Multiple sources: Customer Gender
-- Join all the customer tables from the silver layers
-- From expert insight: Master data source is CRM system.

SELECT DISTINCT
	sci.cst_gndr,
	sca.gen,
	CASE
		WHEN sci.cst_gndr != 'N/A' THEN sci.cst_gndr
		ELSE COALESCE(sca.gen, 'N/A')
	END
FROM		silver.crm_cust_info AS sci
LEFT JOIN	silver.erp_cust_az12 AS sca
ON			sci.cst_key = sca.cid
LEFT JOIN	silver.erp_loc_a101 AS sla
ON			sci.cst_key = sla.cid

-- After customer dimension view is created in the gold layer
-- SELECT * FROM gold.dim_customers;
-- SELECT DISTINCT gender FROM gold.dim_customers;

--===========================--
-- Product Dimension Testing --
--===========================--

SELECT
	product_number,
	COUNT(*)
FROM (
	-- Data Integration: No shared info column. Integration unnecessary.
	-- Logical Ordering
	-- Naming Convention: Give user-friendly names
	-- Fact or Dimension? DIMENSION
	-- Create a surrogate key from source information
	SELECT
		ROW_NUMBER() OVER (ORDER BY spi.prd_start_dt, spi.prd_key)	AS product_key,
		spi.prd_id													AS product_id,
		spi.prd_key													AS product_number,
		spi.prd_nm													AS product_name,
		spi.cat_id													AS category_id,
		epx.cat														AS category_name,
		epx.subcat													AS subcategory_name,
		epx.maintenance												AS maintenance_status,
		spi.prd_cost												AS product_cost,
		spi.prd_line												AS product_line,
		spi.prd_start_dt											AS product_start_date
	FROM		silver.crm_prd_info AS spi
	LEFT JOIN	silver.erp_px_cat_g1v2 AS epx
	ON			spi.cat_id = epx.id
	WHERE spi.prd_end_dt IS NULL -- Filter out all historical data
) t
GROUP BY product_number
HAVING COUNT(*) > 1 -- Check if duplicate data exists

-- After product dimension view is created in the gold layer
-- SELECT * FROM gold.dim_products;

--=================================================--
-- Sales Details Testing For FACT Table Generation --
--=================================================--

-- Fact or Dimension? Contains raw events of sales. FACT 
-- Connect the event table with dim tables using SURROGATE KEYS
-- Give friendly names to columns
SELECT
	csd.sls_ord_num		AS order_number,
	gdp.product_key		AS product_key, 
	gdc.customer_key	AS customer_key,
	csd.sls_order_dt	AS order_date,
	csd.sls_ship_dt		AS shipping_date,
	csd.sls_due_dt		AS due_date,
	csd.sls_sales		AS sales_amount,
	csd.sls_quantity	AS quantity,
	csd.sls_price		AS price
FROM silver.crm_sales_details AS csd
LEFT JOIN gold.dim_products AS gdp
ON csd.sls_prd_key = gdp.product_number
LEFT JOIN gold.dim_customers AS gdc
ON csd.sls_cust_id = gdc.customer_id

-- After sales fact view is created in the gold layer
-- SELECT * FROM gold.fact_sales;

-- Foreign Key Integrity
SELECT *
FROM		gold.fact_sales f
LEFT JOIN	gold.dim_customers c
ON			f.customer_key = c.customer_key
LEFT JOIN	gold.dim_products p
ON			f.product_key = p.product_key
WHERE		c.customer_key IS NULL
OR			p.product_key IS NULL;

