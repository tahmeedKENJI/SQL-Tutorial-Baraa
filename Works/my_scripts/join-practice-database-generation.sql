USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'JoinPractice_1')
BEGIN
	ALTER DATABASE JoinPractice_1
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE JoinPractice_1
END
GO

CREATE DATABASE JoinPractice_1;
GO

USE JoinPractice_1;
GO

CREATE TABLE PersonalInfo (
	personal_id INT NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birth_date DATE NULL,
	email VARCHAR(50) NOT NULL,
	phone VARCHAR(50) NOT NULL,
	CONSTRAINT pk_PersonalInfo PRIMARY KEY (personal_id)
)
GO

INSERT INTO PersonalInfo
VALUES
	(1, 'Tahmeed', 'Reza', '2001-08-04', 'tahmeedreza@gmail.com', '01766021655'),
	(2, 'Sahira', 'Chowdhury', '2001-10-25', 'sahirarokeya@gmail.com', '01346141025'),
	(3, 'Shehreen', 'Reza', '2003-04-25', 'shehreenreza@gmail.com', '01798385577'),
	(4, 'Fardin', 'Shams', '2007-09-20', 'fardihshams@gmail.com', '01713892001'),
	(5, 'Albert', 'Rogers', '1997-08-21', 'albert.rogers@gmail.com', '5582561109'),
	(6, 'Jennifer', 'Gomez', '2005-11-04', 'gomezjennifer@gmail.com', '5682240192'),
	(7, 'Alex', 'Smithson', '2001-05-14', 'alexsmithson@gmail.com', '5440019234')
GO

CREATE TABLE OrderInfo (
	order_id INT NOT NULL,
	personal_id INT NOT NULL,
	usr_id INT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	order_date DATE NULL,
	mailing_address VARCHAR(50) NOT NULL,
	CONSTRAINT pk_OrderInfo PRIMARY KEY (order_id)
)
GO

INSERT INTO OrderInfo
VALUES
	(1,  1, 1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',    '2026-08-04',  '5/E, Bashbari'),
	(2,  1, 1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',    '2026-08-04',  '5/E, Bashbari'),
	(3,  1, 1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',    '2026-08-04',  '5/E, Bashbari'),
	(4,  1, 1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',    '2025-08-04',  '5/E, Bashbari'),
	(5,  1, 1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',    '2025-08-04',  '5/E, Bashbari'),
	(6,  2, 2, 'Sahira', 'Chowdhury', 'sahirarokeya@gmail.com',   '2026-10-25',  'H:5, R:5, B:D'),
	(7,  2, 2, 'Sahira', 'Chowdhury', 'sahirarokeya@gmail.com',   '2025-10-25',  'H:5, R:5, B:D'),
	(8,  2, 2, 'Sahira', 'Chowdhury', 'sahirarokeya@gmail.com',   '2025-10-25',  'H:5, R:5, B:D'),
	(9,  3, 3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',   '2026-04-25',  '5/E, Bashbari'),
	(10, 3, 3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',  '2026-04-25',  '5/E, Bashbari'),
	(11, 3, 3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',  '2025-04-25',  '5/E, Bashbari'),
	(12, 3, 3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',  '2026-04-25',  '5/E, Bashbari'),
	(13, 4, 4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   '2026-09-20',  'Mirpur 10'),
	(14, 4, 4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   '2025-09-20',  'Mirpur 10'),
	(15, 4, 4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   '2025-09-20',  'Mirpur 10'),
	(16, 4, 4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   '2025-09-20',  'Mirpur 10'),
	(17, 8, 5, 'Saad', 'Chowdhury',   'saadchowdhury@gmail.com', '2026-05-14',  '43 Hampshire Street'),
	(18, 8, 5, 'Saad', 'Chowdhury',   'saadchowdhury@gmail.com', '2026-05-14',  '43 Hampshire Street'),
	(19, 5, NULL, 'Albert', 'Rogers',    'albert.rogers@gmail.com', '2026-08-21',  '5 Priceton Ave')
--	(20, 6, 1, 'Jennifer', 'Gomez',   'gomezjennifer@gmail.com', '2026-11-04',  '13 North Wall Street'),
--	(21, 7, 1, 'Alex', 'Smithson',    'alexsmithson@gmail.com',  '2026-05-14',  '43 Hampshire Street')
GO

CREATE SCHEMA Accounts
GO

CREATE TABLE Accounts.AccountInfo (
	usr_id INT NOT NULL,
	username VARCHAR(50) NOT NULL,
	u_password VARCHAR(250) NOT NULL,
	email VARCHAR(50) NOT NULL,
	CONSTRAINT pk_AccountInfo PRIMARY KEY (usr_id)
)
GO

INSERT INTO Accounts.AccountInfo
VALUES
	(1, 'tahmeedreza', '12345678', 'tahmeedreza@gmail.com'),
	(2, 'sahirarokeya', '12345678', 'sahirarokeya@gmail.com'),
	(3, 'shehreenreza', '12345678', 'shehreenreza@gmail.com'),
	(4, 'fardihshams', '12345678', 'fardihshams@gmail.com'),
	(5, 'saadchow', '12345678', 'saadchowdhury@gmail.com')
GO

INSERT INTO PersonalInfo
VALUES
	(8, 'Saad', 'Chowdhury', '2009-08-30', 'saadchowdhury@gmail.com', '5440019664')
GO