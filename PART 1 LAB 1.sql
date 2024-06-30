-- Q1
CREATE OR ALTER VIEW V1 
WITH ENCRYPTION
AS 
SELECT DISTINCT Pname, Pno, SUM(Hours) AS TOTAL
FROM Project, Works_for
WHERE Project.Pnumber = Works_for.Pno
GROUP BY Pno, Pname;

SELECT * FROM V1;

--------------------------------------------------------------------------------------------------------

-- Q2
CREATE OR ALTER VIEW V2
WITH ENCRYPTION
AS
SELECT DISTINCT Pnumber, Pname, Dname
FROM Project, Departments;
-- WHERE Project.
SELECT * FROM V2;

--------------------------------------------------------------------------------------------------------

-- Q3
CREATE OR ALTER VIEW V3
WITH ENCRYPTION
AS
SELECT DISTINCT EMP.Fname + ' ' + EMP.Lname AS FULL_NAME, EMP.Salary
FROM Employee EMP, Employee MGR
WHERE EMP.Superssn = MGR.SSN AND EMP.Superssn IS NOT NULL AND EMP.Salary > MGR.Salary;

SELECT * FROM V3;

-- MUST AD ALIAS NAME FOR COLUMN IF MERGE BETWEEN COLUMN 

--------------------------------------------------------------------------------------------------------

-- Q4
CREATE OR ALTER VIEW V4
WITH ENCRYPTION
AS
SELECT DISTINCT Dnum, Dname, COUNT(SSN) AS EMPLOYEE_COUNT
FROM Departments INNER JOIN Employee
ON 
Departments.Dnum = Employee.Dno 
GROUP BY Dnum, Dname;

SELECT * FROM V4;

--------------------------------------------------------------------------------------------------------

-- Q5
CREATE OR ALTER VIEW V5
WITH ENCRYPTION
AS
SELECT DISTINCT Pname, Plocation, Dname 
FROM Project, Departments
WHERE Project.Dnum = Departments.Dnum;

SELECT * FROM V5;

--------------------------------------------------------------------------------------------------------

-- Q6
CREATE OR ALTER VIEW V6
WITH ENCRYPTION
AS
SELECT DISTINCT Departments.Dname, Departments.Dnum, AVG(Salary) AS AVARAGE_SALARY
FROM Employee, Departments
WHERE Employee.Dno = Departments.Dnum
GROUP BY Departments.Dnum, Departments.Dname;

SELECT * FROM V6;

--------------------------------------------------------------------------------------------------------

-- Q7
CREATE OR ALTER VIEW V7
WITH ENCRYPTION
AS
SELECT DISTINCT Fname + ' ' + Lname AS FULL_NAME, Dependent.Dependent_name
FROM Employee, Dependent 
WHERE Dependent.ESSN = Employee.SSN;

SELECT * FROM V7;

--------------------------------------------------------------------------------------------------------

-- Q8
CREATE OR ALTER VIEW V8
WITH ENCRYPTION
AS
SELECT TOP 100 PERCENT Pname, Plocation, Dname
FROM Project, Departments
WHERE Project.Dnum = Departments.Dnum
ORDER BY Pnumber;

SELECT * FROM V8;

-- CANT USE DISTINCT WITH ORDER BY
-- CANT USE ORDER BY IN VIEW WITHOUT TOP IN SELECT
--------------------------------------------------------------------------------------------------------

-- Q9
CREATE OR ALTER VIEW V9
WITH ENCRYPTION 
AS
SELECT * 
FROM Employee
WHERE Dno =
(
SELECT TOP(1) Dno
FROM Employee 
WHERE Dno IS NOT NULL
GROUP BY Dno
ORDER BY AVG(Salary) DESC
)
 
/*
CREATE VIEW V9
SELECT DISTINCT Fname + ' ' + Lname, Salary, Dname
FROM Employee, Departments
WHERE Employee.Dno = Departments.Dnum
GROUP BY Dnum, Fname, Lname, Salary;

SELECT Fname + ' ' + Lname
FROM Employee, Departments
WHERE Employee.Dno = 
GROUP BY Employee.Dno

SELECT MAX(AVARAGE_SALARY) , DNUM
FROM
 ( 
	SELECT Dnum, AVG(Salary) AVARAGE_SALARY
	FROM Employee, Departments
	WHERE Employee.Dno = Departments.Dnum
	GROUP BY Dnum
 )
AS AVG_SALARY
*/



/*
	 9.	Create a view that displays the full name (first name and last name), salary, 
	 and the name of the department for employees working in the department with the highest average salary.
*/


--------------------------------------------------------------------------------------------------------

-- Q10

CREATE OR ALTER VIEW V10
WITH ENCRYPTION
AS
SELECT DISTINCT Fname + ' ' + Lname AS FULL_NAME, DATEDIFF(YEAR, Employee.Bdate, GETDATE()) AS AGE, Dependent_name
FROM Employee, Dependent
WHERE Employee.SSN = Dependent.ESSN;

SELECT * FROM V10;

--------------------------------------------------------------------------------------------------------

-- Q11
CREATE OR ALTER VIEW V11
WITH ENCRYPTION
AS
SELECT DISTINCT Pnumber, Pname, Plocation, COUNT(SSN) AS EMP_COUNT
FROM Project INNER JOIN Departments
ON Project.Dnum = Departments.Dnum
INNER JOIN Employee 
ON Employee.Dno = Departments.Dnum AND Employee.Dno IS NOT NULL
GROUP BY Pnumber, Pname, Plocation;

SELECT * FROM V11;

--------------------------------------------------------------------------------------------------------

-- Q12
CREATE OR ALTER VIEW V12
WITH ENCRYPTION
AS
SELECT EMP1.Fname + ' ' + EMP1.Lname AS EMP_NAME
FROM Employee EMP1
WHERE EMP1.Salary >
(
	SELECT AVG(Salary)
	FROM Employee EMP2
	WHERE EMP2.Dno = EMP1.Dno
);

SELECT * FROM V12;

--------------------------------------------------------------------------------------------------------

-- Q13

CREATE OR ALTER VIEW V13
WITH ENCRYPTION
AS
SELECT Fname + ' ' + Lname AS FULL_NAME, Salary, COUNT(Dependent.Dependent_name) AS DEPEN_COUN
FROM Employee, Dependent
WHERE Employee.SSN = Dependent.ESSN 
GROUP BY Lname, Fname, Salary;

SELECT * FROM V13;

--------------------------------------------------------------------------------------------------------
/*
--   PART 2 --
-- Q1
CREATE RULE R1 AS @X < 1000

SP_BINDRULE R1 , 'EMPLOYEE.SALARY'


--------------------------------------------------------------------------------------------------------

-- Q2
CREATE DEFAULT D1 AS 'NY'

CREATE TYPE LOC FROM NCHAR(2) 

CREATE RULE R2 AS @Y IN ('NY', 'DS', 'KW')

SP_BINDRULE R2 , 'LOC'

SP_BINDEFAULT D1 , 'LOC'

ALTER TABLE PROJECT
ALTER COLUMN PLOCATION LOC;

--------------------------------------------------------------------------------------------------------

-- Q3
CREATE TABLE NEW_STD
(
	ID_NUM INT PRIMARY KEY,
	LOKA LOC NOT NULL
);

*/