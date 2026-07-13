USE SalesDB_3;
GO
-----------------------------------------------
----## STEP 1: CREATE A STORED PROCEDURE ##----
-----------------------------------------------

CREATE PROCEDURE CustomerSummary AS
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AverageScore
	FROM Sales.Customers
	WHERE Country = 'USA';
END

--------------------------------------------------
----## STEP 2: EXECURE THE STORED PROCEDURE ##----
--------------------------------------------------

EXEC CustomerSummary

------------------------------------------------------------
----## STEP 3: CREATE A PARAMTERIZED STORED PROCEDURE ##----
------------------------------------------------------------

CREATE PROCEDURE CustomerSummary_p 
@Country VARCHAR(50)
AS
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AverageScore
	FROM Sales.Customers
	WHERE Country = @Country;
END

----------------------------------------------------------------
----## STEP 4: EXECURE THE PARAMETERIZED STORED PROCEDURE ##----
----------------------------------------------------------------

EXEC CustomerSummary

---------------------------------------------------------------
----## STEP 5: ALTER A STORED PROCEDURE, GIVE PARAMETERS ##----
---------------------------------------------------------------

ALTER PROCEDURE CustomerSummary 
@Country VARCHAR(50)
AS
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AverageScore
	FROM Sales.Customers
	WHERE Country = @Country;
END

----------------------------------------------------------
----## STEP 6: EXECURE THE ALTERED STORED PROCEDURE ##----
----------------------------------------------------------

EXEC CustomerSummary @Country = 'USA'

------------------------------------------------------------------
----## STEP 7: ALTER A STORED PROCEDURE, DEFAULT PARAMETERS ##----
------------------------------------------------------------------

ALTER PROCEDURE CustomerSummary 
@Country VARCHAR(50) = 'USA'
AS
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AverageScore
	FROM Sales.Customers
	WHERE Country = @Country;
END

----------------------------------------------------------
----## STEP 8: EXECURE THE ALTERED STORED PROCEDURE ##----
----------------------------------------------------------

EXEC CustomerSummary

-------------------------------------
----## STEP 9: MULTPLE QUERIES ##----
-------------------------------------


ALTER PROCEDURE CustomerSummary 
@Country VARCHAR(50) = 'USA'
AS
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AverageScore
	FROM Sales.Customers
	WHERE Country = @Country;

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	INNER JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	WHERE c.Country = @Country;
END

-----------------------------------------------------------
----## STEP 10: EXECURE THE ALTERED STORED PROCEDURE ##----
-----------------------------------------------------------

EXEC CustomerSummary @Country = 'Germany'

---------------------------------------------------------
----## STEP 11: VARIABLES INSIDE STORED PROCEDURES ##----
---------------------------------------------------------

ALTER PROCEDURE CustomerSummary 
@Country VARCHAR(50) = 'USA'
AS
BEGIN
	DECLARE
	@TotalCustomers INT = 0,
	@AvgScore FLOAT = 0;

	SELECT 
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;

	PRINT 'Total customers from ' + @Country + ' is ' + CAST(@TotalCustomers AS VARCHAR(50));
	PRINT 'Average Score from ' + @Country + ' is ' + CAST(@AvgScore AS VARCHAR(50));

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	INNER JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	WHERE c.Country = @Country;
END;

-----------------------------------------------------------
----## STEP 12: EXECURE THE ALTERED STORED PROCEDURE ##----
-----------------------------------------------------------

EXEC CustomerSummary;
EXEC CustomerSummary @Country = 'Germany';

-----------------------------------
----## STEP 13: CONTROL FLOW ##----
-----------------------------------

ALTER PROCEDURE CustomerSummary 
@Country VARCHAR(50) = 'USA'
AS
BEGIN
	DECLARE
	@TotalCustomers INT = 0,
	@AvgScore FLOAT = 0;

	-- Prepare and Clean-up Data
	-- Check first if a column has NULLs. Update it to 0.
	IF EXISTS (
		SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country
	)
	BEGIN
		PRINT('Correcting NULLs from country: ' + @Country);
		UPDATE Sales.Customers
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country;
	END

	ELSE
	BEGIN
		PRINT ('No NULLs found for country: ' + @Country);
	END;

	-- Reporting Section
	SELECT 
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;

	PRINT 'Total customers from ' + @Country + ' is ' + CAST(@TotalCustomers AS VARCHAR(50));
	PRINT 'Average Score from ' + @Country + ' is ' + CAST(@AvgScore AS VARCHAR(50));

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	INNER JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	WHERE c.Country = @Country;
END;

-----------------------------------------------------------
----## STEP 14: EXECURE THE ALTERED STORED PROCEDURE ##----
-----------------------------------------------------------

EXEC CustomerSummary;
EXEC CustomerSummary @Country = 'Germany';

-------------------------------------
----## STEP 15: ERROR HANDLING ##----
-------------------------------------

ALTER PROCEDURE CustomerSummary 
@Country VARCHAR(50) = 'USA'
AS
BEGIN
	BEGIN TRY
		DECLARE
		@TotalCustomers INT = 0,
		@AvgScore FLOAT = 0;

		--	==========================
		--	Prepare and Clean-up Data
		--	==========================

		-- Check first if a column has NULLs. Update it to 0.
		IF EXISTS (
			SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country
		)
		BEGIN
			PRINT('Correcting NULLs from country: ' + @Country);
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE
		BEGIN
			PRINT ('No NULLs found for country: ' + @Country);
		END;

		--	==================
		--	Reporting Section
		--	==================

		SELECT 
			@TotalCustomers = COUNT(*),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total customers from ' + @Country + ' is ' + CAST(@TotalCustomers AS VARCHAR(50));
		PRINT 'Average Score from ' + @Country + ' is ' + CAST(@AvgScore AS VARCHAR(50));

		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		INNER JOIN Sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE c.Country = @Country;
	END TRY
	BEGIN CATCH
		--	======================
		--	Error Handling Section
		--	======================

		PRINT('An error occurred');
		PRINT('Error Message  : ' + ERROR_MESSAGE());
		PRINT('Error Number   : ' + CAST(ERROR_NUMBER() AS VARCHAR(50)));
		PRINT('Error Line     : ' + CAST(ERROR_LINE() AS VARCHAR(50)));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH;
END;

-----------------------------------------------------------
----## STEP 16: EXECURE THE ALTERED STORED PROCEDURE ##----
-----------------------------------------------------------

EXEC CustomerSummary;
EXEC CustomerSummary @Country = 'Germany';