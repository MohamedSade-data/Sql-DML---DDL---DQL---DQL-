-- Q1 
CREATE PROC P1 
AS
SELECT St_Id
FROM Student

P1;

---------------------------------------------------------------------------------------------
-- Q2 
CREATE OR ALTER PROC P2 
AS
DECLARE @NUM INT;
SELECT @NUM = COUNT (SSN)
FROM  Employee INNER JOIN Works_for
ON Works_for.ESSn = Employee.SSN
INNER JOIN Project
ON Project.Pnumber = Works_for.Pno AND Pno = 300
IF @NUM > 3 PRINT 'MORE THAN 3'
ELSE SELECT 'The following employees work for the project 100', Fname + ' ' + Lname FROM Employee 

P2;
/*--
CREATE OR ALTER PROC P2 
AS
RETURN
(
	SELECT COUNT (SSN)
	FROM  Employee INNER JOIN Works_for
	ON Works_for.ESSn = Employee.SSN
	INNER JOIN Project
	ON Project.Pnumber = Works_for.Pno AND Pno = 200
)

DECLARE @NUM INT;
EXECUTE @NUM = P2
IF @NUM > 3 PRINT 'MORE THAN 3'
ELSE SELECT 'The following employees work for the project 100', Fname + ' ' + Lname 
FROM Employee 

P2;
*/
---------------------------------------------------------------------------------------------
-- Q3
CREATE OR ALTER PROC P3 (@NEW_ID INT, @OLD_ID INT, @P_NUMPER INT)
AS
IF EXISTS (SELECT SSN FROM Employee WHERE SSN = @NEW_ID)
BEGIN
	IF EXISTS (SELECT ESSn FROM Works_for WHERE ESSn = @OLD_ID)
	BEGIN
		UPDATE Works_for
		SET ESSn = @NEW_ID
		WHERE ESSn = @OLD_ID AND Pno = @P_NUMPER
	END
	ELSE
	PRINT 'NOT EXIST IN WORKS FOR'
END
ELSE 
PRINT 'NOT EXIST IN EMPLOYEE'

EXECUTE P3 223344, 112233, 100;

SELECT * FROM Works_for;
--------------------------------------------------------------------------------------------------
-- Q4

CREATE TABLE AUDT (PNUM INT, USERNAME VARCHAR(100), MODDATE DATE, OLD_H INT, NEW_H INT);

USE Company_SD;
CREATE TABLE ADT (PNUM INT, USERNAME VARCHAR(100), MODDATE DATE, OLD_H INT, NEW_H INT);


CREATE OR ALTER TRIGGER T1
ON WORKS_FOR 
AFTER UPDATE
AS
IF UPDATE(HOURS)
BEGIN
DECLARE @OH INT, @NH INT, @P INT
SELECT @NH = HOURS, @P = Pno FROM deleted
SELECT @OH = HOURS FROM inserted
INSERT INTO ADT VALUES (@P, SUSER_NAME(), GETDATE(), @NH, @OH)
END

UPDATE Works_for
SET Hours = 11
WHERE ESSn = 112233 AND Pno = 200; 

SELECT * FROM ADT;

--------------------------------------------------------------------------------------------------
-- Q5

CREATE OR ALTER TRIGGER T2
ON Department
INSTEAD OF INSERT
AS
PRINT 'YOU CANT INSERT IN THIS TABLE';

INSERT INTO Department VALUES (80, 'MS', 'MOHAMED', 'CAIRO', 2, '2008-05-04')

SELECT * FROM Department

--------------------------------------------------------------------------------------------------
-- Q6

CREATE OR ALTER TRIGGER T3
ON EMPLOYEE 
AFTER INSERT
AS
IF (SELECT MONTH(GETDATE())) = 5
PRINT 'CANT INSERT IN MAY'
ROLLBACK
PRINT 'INSERTED SUCSSES'

INSERT INTO Employee VALUES ('MOH', 'SKIJS', 1254, '1965-09-30 00:00:00.000', '250 st Maadi Cairo', 'M', 1535, 223344, 30);

SELECT * FROM Employee;

--------------------------------------------------------------------------------------------------
-- Q7

CREATE OR ALTER TRIGGER T4
ON DATABASE
FOR ALTER_TABLE
AS
PRINT 'NOT ALLOWED'

--------------------------------------------------------------------------------------------------
-- Q8

CREATE TABLE AUDIT_TABLE (SRVER_NAME VARCHAR(200), DATE DATE, NOTE VARCHAR(400));

CREATE OR ALTER TRIGGER T5
ON Student
AFTER INSERT
AS
DECLARE @ID INT;
SELECT @ID = St_Id FROM inserted;
INSERT INTO AUDIT_TABLE 
VALUES (CONVERT(VARCHAR(200),@@SERVERNAME), CONVERT(DATE,GETDATE()), SUSER_NAME() + ' Insert New Row with Key ' +  CONVERT(varchar,@ID) + 'IN TABLE STUDENT')

INSERT INTO Student VALUES (16, 'MOHAMED', 'SADEQ', 'QENA', 23, 10, 6);

SELECT * FROM Student

SELECT * FROM AUDIT_TABLE