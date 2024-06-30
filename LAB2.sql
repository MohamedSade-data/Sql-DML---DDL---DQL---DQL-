--------------------------------------------------------------------------------------
-- Q1 PART_2
  CREATE FUNCTION Get_Instructors_with_Null()
  RETURNS TABLE 
  AS
  RETURN 
  (
	  SELECT Instructor.INS_ID, INS_NAME, INS_DEGREE, SALARY, DEPT_ID, CRS_ID, EVALUATION

	  FROM Instructor, Ins_Course
	  WHERE Ins_Course.INS_ID = Instructor.INS_ID
	  AND Ins_Course.EVALUATION IS NULL
  )

  SELECT * FROM DBO.Get_Instructors_with_Null();

--------------------------------------------------------------------------------------
-- Q2
	CREATE FUNCTION GET_TOP_STUDENT(@TOP INT)
	RETURNS TABLE
	AS
	RETURN
	(
		SELECT TOP (@TOP) AVG(GRADE) AS AVAREGE
		FROM [dbo].[Stud_Course], [dbo].[Student]
		GROUP BY [dbo].[Stud_Course].ST_ID
		ORDER BY AVG(GRADE) DESC
	)
	
	SELECT * 
	FROM dbo.GET_TOP_STUDENT(4);

--------------------------------------------------------------------------------------
-- Q3
	CREATE FUNCTION Get_Students_without_Courses()
	RETURNS TABLE 
	AS
	RETURN
	(
			SELECT *
			FROM Student
			WHERE St_Id IN 
			(
				SELECT St_Id
				FROM Student
				EXCEPT
				SELECT St_Id
				FROM Stud_Course
			)	

	)

SELECT * FROM dbo.Get_Students_without_Courses();
