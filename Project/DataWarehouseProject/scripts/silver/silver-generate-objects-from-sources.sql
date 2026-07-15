/*

Create Tables For the Silver Layer
Table Names:
    silver.crm_cust_info
    silver.crm_prd_info
    silver.crm_sales_details
    silver.erp_cust_az12
    silver.erp_loc_a101
    silver.erp_px_cat_g1v2

Metadata Columns Are Added...
-   dwh_create_date: all tables

Notes:
-   DATEs loaded as NVARCHAR(20) will be restored.
-   Keep it in mind during transformation.

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
-- Re-create the tables

DROP TABLE IF EXISTS medallion_dwh.silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    -- create crm_cust_info table
    cst_id             INT          ,
    cst_key            NVARCHAR (50),
    cst_firstname      NVARCHAR (50),
    cst_lastname       NVARCHAR (50),
    cst_marital_status NVARCHAR (10),
    cst_gndr           NVARCHAR (10),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS medallion_dwh.silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    -- create crm_prd_info table
    prd_id       INT          ,
    cat_id       NVARCHAR (50),
    prd_key      NVARCHAR (50),
    prd_nm       NVARCHAR (50),
    prd_cost     INT          ,
    prd_line     NVARCHAR (10),
    prd_start_dt DATE,
    prd_end_dt   DATE,
    dwh_create_date    DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS medallion_dwh.silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    -- create crm_sales_details table
    sls_ord_num  NVARCHAR (50),
    sls_prd_key  NVARCHAR (50),
    sls_cust_id  INT          ,
    sls_order_dt DATE,
    sls_ship_dt  DATE,
    sls_due_dt   DATE,
    sls_sales    INT          ,
    sls_quantity INT          ,
    sls_price    INT          ,       
    dwh_create_date    DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS medallion_dwh.silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    -- create erp_cust_az12 table
    cid   NVARCHAR (50),
    bdate DATE,
    gen   NVARCHAR (10),
    dwh_create_date    DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS medallion_dwh.silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    -- create erp_loc_a101 table
    cid   NVARCHAR (50),
    cntry NVARCHAR (50),
    dwh_create_date    DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS medallion_dwh.silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    -- create erp_px_cat_g1v2 table
    id          NVARCHAR (10),
    cat         NVARCHAR (50),
    subcat      NVARCHAR (50),
    maintenance NVARCHAR (10),
    dwh_create_date    DATETIME2 DEFAULT SYSDATETIME()
);