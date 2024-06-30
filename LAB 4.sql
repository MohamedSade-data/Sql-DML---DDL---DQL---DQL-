-- Q1
USE Company_SD;
CREATE INDEX IND1
ON DEPARTMENTS (MGRStart_Date);

-- WILL RETRIVE DATA FROM TABLES VERY FAST AND THE SPEED OF SEARCH WILL BE INCREASE BASED ON THIS INDEX

----------------------------------------------------------------------------------------------------------------------
-- Q2
USE ITI_new;
CREATE UNIQUE INDEX IND2 
ON STUDENT (St_Age);

--CANT WORK BEACAUSE AGE HAVE DUBLICATE 

----------------------------------------------------------------------------------------------------------------------
-- Q3
USE ITI_new;
CREATE UNIQUE NONCLUSTERED INDEX IND3
ON DEPARTMENT (Dept_Manager);

----------------------------------------------------------------------------------------------------------------------
-- Q4
USE Company_SD;

DECLARE CR1 CURSOR
FOR
SELECT Dname,  SUM(Salary) TOTAL_SAL
FROM Employee, Departments
WHERE Employee.Dno = Departments.Dnum
GROUP BY Dno, Dname

FOR READ ONLY

DECLARE @NAME VARCHAR(50), @SALARY INT
OPEN CR1

FETCH CR1 INTO @NAME, @SALARY
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @NAME AS DEPT_NAME, @SALARY AS SALARY
	FETCH CR1 INTO @NAME, @SALARY
END
CLOSE CR1
DEALLOCATE CR1

----------------------------------------------------------------------------------------------------------------------
-- Q5
DECLARE CR2 CURSOR
FOR

SELECT Dno
FROM Employee

FOR UPDATE
DECLARE @DNUM INT

OPEN CR2
FETCH CR2 INTO @DNUM

WHILE @@FETCH_STATUS = 0
BEGIN
	IF (@DNUM = 10)
	UPDATE Employee
	SET Salary = Salary * 1.2
	WHERE CURRENT OF CR2
	ELSE IF (@DNUM = 20)
	UPDATE Employee
	SET Salary = Salary * 1.5
	WHERE CURRENT OF CR2
	ELSE
	UPDATE Employee
	SET Salary = Salary * 1.2
	WHERE CURRENT OF CR2
	
FETCH CR2 INTO @DNUM
END

CLOSE CR2
DEALLOCATE CR2

----------------------------------------------------------------------------------------------------------------------
-- Q6
DECLARE CR3 CURSOR
FOR 

SELECT  Fname + ' ' + Lname, AVG(Hours) HOURS
FROM Employee, Works_for
WHERE Employee.SSN = Works_for.ESSn
GROUP BY Fname, Lname


FOR READ ONLY

DECLARE @FULLNAME VARCHAR(50), @HOURS INT
OPEN CR3

FETCH CR3 INTO @FULLNAME, @HOURS

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @FULLNAME AS FULL_NAME, @HOURS AS AVG
	FETCH CR3 INTO @FULLNAME, @HOURS
END

CLOSE CR3
DEALLOCATE CR3

----------------------------------------------------------------------------------------------------------------------
-- Q7


DECLARE CR4 CURSOR
FOR 
SELECT Fname, Sex
FROM Employee

FOR UPDATE

DECLARE @EMPNAME VARCHAR(60), @SEX NVARCHAR(50)
OPEN CR4

FETCH CR4 INTO @EMPNAME, @SEX
WHILE @@FETCH_STATUS = 0
BEGIN
	IF (@SEX = 'M')
	UPDATE Employee
	SET Fname = 'MR ' + Fname
	WHERE CURRENT OF CR4
	ELSE
	UPDATE Employee
	SET Fname = 'MRS ' + Fname
	WHERE CURRENT OF CR4
FETCH CR4 INTO @EMPNAME, @SEX
END

CLOSE CR4
DEALLOCATE CR4

----------------------------------------------------------------------------------------------------------------------
-- Q7
	DECLARE CR5 CURSOR
	FOR
	SELECT St_Fname
	FROM Student

	FOR READ ONLY

	DECLARE @STFNAME VARCHAR(50), @NEXTVAL VARCHAR(50), @COUNT INT = 0

	OPEN CR5

	FETCH CR5 INTO @STFNAME

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@STFNAME = 'AHMED')
		BEGIN
		FETCH NEXT FROM CR5 INTO @NEXTVAL
		IF (@NEXTVAL = 'AMR')
		SET @COUNT += 1
		END
		FETCH CR5 INTO @STFNAME
	END

	SELECT @COUNT AS COUNT
	CLOSE CR5
	DEALLOCATE CR5
----------------------------------------------------------------------------------------------------------------------
-- Q8   WINDOW FUNCTION

USE ITI_new;
WITH CTE AS
(
SELECT Topic.Top_Id, COUNT(Crs_Name) CORSE_COUNT
FROM Course, Topic
WHERE Course.Top_Id = Topic.Top_Id
GROUP BY Topic.Top_Id
)

SELECT *, ROW_NUMBER() OVER (ORDER BY CORSE_COUNT DESC) AS H_NUMPER_OF_COURSE
FROM CTE;

----------------------------------------------------------------------------------------------------------------------
-- Q9

USE ITI_new;
WITH CTE AS
(
SELECT St_Id, SUM(Grade) AS TOTAL
FROM Stud_Course
GROUP BY St_Id
)

SELECT *, ROW_NUMBER() OVER (ORDER BY TOTAL DESC) AS TOTAL 
FROM CTE;