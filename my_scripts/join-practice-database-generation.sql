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
	id INT NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birth_date DATE NULL,
	email VARCHAR(50) NOT NULL,
	phone VARCHAR(50) NOT NULL,
	CONSTRAINT pk_PersonalInfo PRIMARY KEY (id)
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
	customer_id INT NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	order_id INT NOT NULL,
	order_date DATE NULL,
	mailing_address VARCHAR(50) NOT NULL,
)
GO

INSERT INTO OrderInfo
VALUES
	(1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',   1,  '2026-08-04',  '5/E, Bashbari'),
	(1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',   2,  '2026-08-04',  '5/E, Bashbari'),
	(1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',   3,  '2026-08-04',  '5/E, Bashbari'),
	(1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',   4,  '2025-08-04',  '5/E, Bashbari'),
	(1, 'Tahmeed', 'Reza',     'tahmeedreza@gmail.com',   5,  '2025-08-04',  '5/E, Bashbari'),
	(2, 'Sahira', 'Chowdhury', 'sahirarokeya@gmail.com',  6,  '2026-10-25',  'H:5, R:5, B:D'),
	(2, 'Sahira', 'Chowdhury', 'sahirarokeya@gmail.com',  7,  '2025-10-25',  'H:5, R:5, B:D'),
	(2, 'Sahira', 'Chowdhury', 'sahirarokeya@gmail.com',  8,  '2025-10-25',  'H:5, R:5, B:D'),
	(3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',  9,  '2026-04-25',  '5/E, Bashbari'),
	(3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',  10, '2026-04-25',  '5/E, Bashbari'),
	(3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',  11, '2025-04-25',  '5/E, Bashbari'),
	(3, 'Shehreen', 'Reza',    'shehreenreza@gmail.com',  12, '2026-04-25',  '5/E, Bashbari'),
	(4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   13, '2026-09-20',  'Mirpur 10'),
	(4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   14, '2025-09-20',  'Mirpur 10'),
	(4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   15, '2025-09-20',  'Mirpur 10'),
	(4, 'Fardin', 'Shams',     'fardihshams@gmail.com',   16, '2025-09-20',  'Mirpur 10'),
--	(5, 'Albert', 'Rogers',    'albert.rogers@gmail.com', 17, '2026-08-21',  '5 Priceton Ave'),
--	(6, 'Jennifer', 'Gomez',   'gomezjennifer@gmail.com', 18, '2026-11-04',  '13 North Wall Street'),
--	(7, 'Alex', 'Smithson',    'alexsmithson@gmail.com',  19, '2026-05-14',  '43 Hampshire Street')
	(8, 'Saad', 'Chowdhury',   'saadchowdhury@gmail.com', 20, '2026-05-14',  '43 Hampshire Street'),
	(8, 'Saad', 'Chowdhury',   'saadchowdhury@gmail.com', 21, '2026-05-14',  '43 Hampshire Street')
GO