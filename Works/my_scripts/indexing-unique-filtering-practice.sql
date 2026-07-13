USE SalesDB_3;
GO

--##--

SELECT
*
INTO Sales.Products_RS_C_U
FROM Sales.Products;

--	CREATE UNIQUE CLUSTERED INDEX idx_Products_RS_C_U_Category
--	ON Sales.Products_RS_C_U (Category);

--	CREATE UNIQUE CLUSTERED INDEX idx_Products_RS_C_U_Product
--	ON Sales.Products_RS_C_U (Product);

--##--

SELECT
*
FROM Sales.Products_RS_C_U

INSERT INTO Sales.Products_RS_C_U (ProductID, Product)
VALUES (6, 'Caps'); -- UNIQUE index made using one of the columns, cannot insert duplicate value

--##--

--	CREATE NONCLUSTERED INDEX idx_Customers_Country
--	ON Sales.Customers (Country)
--	WHERE Country = 'USA';

--##--