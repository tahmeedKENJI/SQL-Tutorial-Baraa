USE MyDatabase;
GO

DROP TABLE IF EXISTS employee

CREATE TABLE employee(
	id INT NOT NULL,
	full_name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	birth_date DATE,
	CONSTRAINT pk_employee PRIMARY KEY (id)
)
GO

INSERT INTO employee (id, full_name, email, birth_date)
VALUES
	(1, 'Tahmeed', 'tahmeedreza@gmail.com', '2001-08-04'),
	(2, 'Sahira', 'sahirarokeya@gmail.com', '2001-10-25'),
	(3, 'Fardin', 'fardinshams@gmail.com', '2007-09-20')
