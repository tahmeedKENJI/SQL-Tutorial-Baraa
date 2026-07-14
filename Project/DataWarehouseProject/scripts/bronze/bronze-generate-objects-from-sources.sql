/*

Create Tables For the Bronze Layer
Table Names:
    bronze.crm_cust_info
    bronze.crm_prd_info
    bronze.crm_sales_details
    bronze.erp_cust_az12
    bronze.erp_loc_a101
    bronze.erp_px_cat_g1v2

Notes:
-   All dates are being loaded as NVARCHAR(20)
-   Please remind yourself this when working in the "silver" layer

!!WARNING!!
ALL TABLES WILL BE DELETED BEFORE RECREATING THEM
PROCEED WITH CAUTION

*/

-- SWITCH TO medallion_dwh
USE medallion_dwh;
GO

-----------------------
-- CREATE THE TABLES --
-----------------------

-- Drop tables if they exist
DROP TABLE IF EXISTS medallion_dwh.bronze.crm_cust_info;

DROP TABLE IF EXISTS medallion_dwh.bronze.crm_prd_info;

DROP TABLE IF EXISTS medallion_dwh.bronze.crm_sales_details;

DROP TABLE IF EXISTS medallion_dwh.bronze.erp_cust_az12;

DROP TABLE IF EXISTS medallion_dwh.bronze.erp_loc_a101;

DROP TABLE IF EXISTS medallion_dwh.bronze.erp_px_cat_g1v2;

-- Re-create the tables
-- We do not know if the values are NULL or not for any column
CREATE TABLE bronze.crm_cust_info (
    -- create crm_cust_info table
    cst_id             INT          ,
    cst_key            NVARCHAR (50),
    cst_firstname      NVARCHAR (50),
    cst_lastname       NVARCHAR (50),
    cst_marital_status NVARCHAR (10),
    cst_gndr           NVARCHAR (10),
    cst_create_date    NVARCHAR (20)         
);

CREATE TABLE bronze.crm_prd_info (
    -- create crm_prd_info table
    prd_id       INT          ,
    prd_key      NVARCHAR (50),
    prd_nm       NVARCHAR (50),
    prd_cost     INT          ,
    prd_line     NVARCHAR (10),
    prd_start_dt NVARCHAR (20),
    prd_end_dt   NVARCHAR (20)
);

CREATE TABLE bronze.crm_sales_details (
    -- create crm_sales_details table
    sls_ord_num  NVARCHAR (50),
    sls_prd_key  NVARCHAR (50),
    sls_cust_id  INT          ,
    sls_order_dt NVARCHAR (20),
    sls_ship_dt  NVARCHAR (20),
    sls_due_dt   NVARCHAR (20),
    sls_sales    INT          ,
    sls_quantity INT          ,
    sls_price    INT          
);

CREATE TABLE bronze.erp_cust_az12 (
    -- create erp_cust_az12 table
    cid   NVARCHAR (50),
    bdate NVARCHAR (20),
    gen   NVARCHAR (10)
);

CREATE TABLE bronze.erp_loc_a101 (
    -- create erp_loc_a101 table
    cid   NVARCHAR (50),
    cntry NVARCHAR (50)
);

CREATE TABLE bronze.erp_px_cat_g1v2 (
    -- create erp_px_cat_g1v2 table
    id          NVARCHAR (10),
    cat         NVARCHAR (50),
    subcat      NVARCHAR (50),
    maintenance NVARCHAR (10)
);