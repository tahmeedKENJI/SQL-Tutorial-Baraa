----##==============##----
----## SQL TRIGGERS ##----	
----##==============##----

USE SalesDB_3;
GO

------------------------------------
---- #### Create Logs table ####----
------------------------------------

CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY(1, 1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDateTime DATETIME
);

--------------------------------
----#### Create Trigger ####----
--------------------------------

DROP TRIGGER IF EXISTS Sales.trg_AfterInsert_Employee;

CREATE TRIGGER trg_AfterInsert_Employee ON Sales.Employees
AFTER INSERT AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDateTime)
	SELECT
		EmployeeID,
		'New Employee Added. ID: '
		+ CAST(EmployeeID AS VARCHAR) 
		+ ', Name: '
		+ FirstName
		+ LastName,
		SYSDATETIME()
	FROM INSERTED
END;

-------------------------------------------
----#### Query From The Logs Table ####----
-------------------------------------------

SELECT * FROM Sales.EmployeeLogs;

-----------------------------------------------------
----#### Insert Shi Into The Employees Table ####----
-----------------------------------------------------

SELECT * FROM Sales.Employees;

INSERT INTO Sales.Employees
VALUES 
	(6, 'Sherlock', 'Holmes', 'Sales Analytics', '1998-08-05', 'M', 200000, NULL);
