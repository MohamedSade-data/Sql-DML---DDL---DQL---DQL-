USE Company_SD;

-- Q1 

CREATE FUNCTION GetEmployeeSupervisor (@ID INT)
RETURNS VARCHAR(100)
BEGIN
RETURN	
(  
  SELECT Fname + ' ' + Lname
  FROM Employee
  WHERE SSN =
 (
   SELECT Superssn
   FROM Employee
   WHERE SSN = @ID
 )
)
END

DECLARE @ID_NUM INT = 223344;

SELECT dbo.GetEmployeeSupervisor(@ID_NUM);

--------------------------------------------------------------------------------------
-- Q2
CREATE FUNCTION GetHighSalaryEmployees (@SAL INT)
RETURNS TABLE
AS
RETURN 
( 
	SELECT * FROM Employee WHERE Salary > @SAL
)

DECLARE @SALARY INT = 2000;

SELECT * FROM dbo.GetHighSalaryEmployees(@SALARY);

--------------------------------------------------------------------------------------
-- Q3

CREATE FUNCTION GetProjectAverageHours (@PNUM INT)
RETURNS FLOAT
BEGIN
DECLARE @MORGAN FLOAT

    SELECT @MORGAN = AVG(Hours) 
	FROM Works_for
	WHERE Pno = @PNUM

	RETURN @MORGAN
END

DECLARE @PNUM INT = 100;

SELECT dbo.GetProjectAverageHours(@PNUM);

-- DROP FUNCTION GetProjectAverageHours;

--------------------------------------------------------------------------------------
-- Q4

CREATE FUNCTION GetTotalSalary(@DNUM INT)
RETURNS FLOAT
BEGIN
DECLARE @SALARY FLOAT

	SELECT @SALARY = SUM(Salary)
	FROM Employee, Departments
	WHERE Employee.Dno = Departments.Dnum
	AND Dnum = @DNUM

	RETURN @SALARY
END 

DECLARE @DNUMPER INT = 10;

SELECT dbo.GetTotalSalary(@DNUMPER);

--------------------------------------------------------------------------------------
-- Q5
CREATE FUNCTION GetDepartmentManager(@DNUM INT)
RETURNS TABLE
AS
    RETURN
	(
	    SELECT Fname + ' ' + Lname AS MGR_NAME, Departments.*
		FROM Employee, Departments
		WHERE Employee.SSN = Departments.MGRSSN
		AND Dno = @DNUM
	)

DECLARE @DNUMPER INT = 30;

SELECT * FROM dbo.GetDepartmentManager(@DNUMPER);

-- DROP FUNCTION GetDepartmentManager;