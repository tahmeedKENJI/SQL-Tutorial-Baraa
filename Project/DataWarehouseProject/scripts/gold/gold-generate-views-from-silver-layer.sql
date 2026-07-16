/*
===============================================================
Gold Layer: Object Generation Script
===============================================================

Purpose:
- Generate Gold Layer Objects
- Views for customer and product dimension and sales fact table

Usage:
- The views transform the data from silver layer.
- Format the data into star schema
*/

USE medallion_dwh;
GO

-- Generate view from integrated data from silver layer
-- Customer Dimension Table
CREATE OR ALTER VIEW gold.dim_customers AS (
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
);
GO

-- Product Dimension Table
CREATE OR ALTER VIEW gold.dim_products AS (
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
);
GO

-- Fact Table
CREATE OR ALTER VIEW gold.fact_sales AS (
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
);
GO
