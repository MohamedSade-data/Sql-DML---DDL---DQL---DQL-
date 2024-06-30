
------------------------------Window Functions--------------------------
-----------------------Types of Window functions------------------------
--1-Aggregate Window Functions
--SUM(), MAX(), MIN(), AVG(), COUNT()
--Window functions do not cause rows to become grouped into a single output row,
--the rows retain their separate identities and an aggregated value will be added to each row.
SELECT St_Id, St_Fname,AVG(St_Age)OVER(PARTITION BY St_Address) as [average ages per city] ,St_Address
FROM Student
where St_Address is not null

SELECT St_Id, St_Fname,count(St_Id)OVER(PARTITION BY St_Address) as [NumOfStd per city] ,St_Address
FROM Student

SELECT St_Id, St_Fname,Min(St_Age)OVER(PARTITION BY St_Address) as [Min per city] ,St_Address
FROM Student

SELECT St_Id, St_Fname,Max(St_Age)OVER(PARTITION BY St_Address) as [Max per city] ,St_Address
FROM Student

--2-Ranking Window Functions
--RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()
select * , ROW_NUMBER() over (order by st_age desc) as RN
from Student 

select * , DENSE_RANK() over (order by st_age desc) as DR
from Student 

select * , RANK() over (order by st_age desc) as R
from Student 

select * , Ntile(3) over (order by st_age desc) as RN
from Student 

--Find Second aged Student in each department 

select * from 
(
	select * , Dense_rank() over (partition by Dept_id order by st_age desc) as DN
	from Student 
	where Dept_Id is not null

) as newTable
where DN = 2

--Find Second aged Student in each department with repeating

select * from 
(
	select * , Dense_rank() over (partition by Dept_id order by st_age desc) as DN
	from Student 
	where Dept_Id is not null

) as newTable
where DN = 2

--Find Second higets student in each course  

select * from 
(
select s.St_Id , s.St_Fname , c.Crs_Name ,sc.Grade , 
        ROW_NUMBER() over (partition by c.Crs_Name  order by sc.Grade desc) as RN
from Student s , Stud_Course sc ,Course c
where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id
) as NewTabl
where RN = 2




--3-Value Window Functions
--LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()





-----------------------------------CTE---------------------------------
--A Common Table Expression, also called as CTE in short form,
--is a temporary named result set that you can reference within 
--a SELECT, INSERT, UPDATE, or DELETE statement. The CTE can also 
--be used in a View.

-------------------------------CTE Synatx-------------------------------
--WITH expression_name[(column_name [,...])]
--AS
--    (CTE_definition)
--SQL_statement;


--WITH expression_name AS (CTE definition)

with cte 
as 
(
	 select st_fname ,st_age , St_Address
	 from Student
)
select st_fname from cte 
where st_age>20




--Find Top 3 aged student in each each Department 


with cte 
as (
	  SELECT *, ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY st_age desc) AS rk
      FROM student
      ) 

select St_Fname , St_Age , rk
from cte 
where rk<=3

create table test2
(
ID int ,
NAME VARCHAR(10),
AGE INT
)
go
INSERT INTO test2 values (1,'Doaa' , 24),
						(1,'Doaa' , 24),
						(2,'ali' , 25),
                        (2,'ali' , 25)
---------------------------------CTE with insert-----------------------

WITH tab AS (
  select * from test2
)
INSERT INTO test2  
SELECT * FROM tab

select * from test2

-----------------------------------------------------------------------------

--Find Duplicate in Test table 
WITH cte 
AS (
    SELECT  t.ID , t.NAME , t.AGE ,
	        ROW_NUMBER() OVER (PARTITION BY t.ID , t.NAME , t.AGE
            ORDER BY t.ID , t.NAME , t.AGE) row_num
    FROM test t
) 
delete FROM cte 
WHERE row_num > 1;

-----------------------------------

------------------------------------------------------------



--------------------------Cursor----------------------------
 --Create cursor that view student info for alex student 
 declare c1 cursor 
 for
   select St_id , st_Fname 
   from Student
   where St_Address = 'alex'

   for read only 

declare @id int , @name varchar(10)

open c1

fetch c1 into @id , @name

while @@FETCH_STATUS=0
begin

select @id ,@name
fetch c1 into @id , @name

end 
close c1
deallocate c1 

-----------------------------------------------------
--Write cursor query that show student names in one cell

--[ahmed , amr , mona,.............]

declare c1 cursor
for 
    select ST_Fname 
	from Student
	where St_Fname is not null

declare @fname varchar(10) , @allnames varchar(500)=''
open c1

fetch c1 into @fname
while @@FETCH_STATUS=0
begin
   set @allnames = @allnames + ' , ' + @fname
   fetch c1 into @fname
end
select @allnames
close c1
deallocate c1 

--------------------------------------------------------------
declare c1 cursor 
for
   select Salary
   from Employee
for update 

declare @sal int 

open c1
fetch c1 into @sal

while @@FETCH_STATUS=0
begin 
    if (@sal >300)
	   update Employee Set Salary= Salary *1.3
	   where current of c1 
     
	 else 
	    update Employee Set Salary= Salary *1.1
		where current of c1 

		fetch c1 into @sal
end

close c1
deallocate c1 
-----------------------------Students Task----------------------------
--Count times that amr apper after ahmed in srudent table 
--ahmed then amr
Select * from student 
insert into student values (16 , 'Ahmed' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)
insert into student values (17 , 'Amr' , 'Mohmaed' , 'Cairo' , 20 , 20 , NULL)
insert into student values (18 , 'Test' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)

insert into student values (18 , 'Ahmed' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)
insert into student values (19 , 'Test' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)
insert into student values (20 , 'Amr' , 'Mohmaed' , 'Cairo' , 20 , 20 , NULL)



--------------------------------------Clustered Index-----------------------------------------
create table stud
(
id int primary key,
sname nvarchar(50),
sal int,
age int
)

--indexing affect with the existing data
insert into stud(id) values (2)
insert into stud(id) values (1)
insert into stud(id,sal) values (3,100)
insert into stud(id,sal) values (5,50)

select * into studNewTable
from stud

select * from studNewTable where id=3
select * from stud where id=3

--Create clustered on Sal in table Student 
create clustered index cindex
	on stud(sal)

--Create nonclustered on Sal in table Student 
create nonclustered index cindex
	on stud(sal)

--Create uniqe index(nonClustered) not Unique is a constraint
--that executed in old and new data 
create unique index uni_index  
on stud(sal)

drop index stud.cindex



--------------------------Indexed View -----------------
create view VCair
as
select  s.St_Age,St_Address 
from Student s
where St_Address= 'cairo'

select * from VCair
select * from V3

alter view VCairoSch
with schemabinding
as
select  s.St_Fname ,St_Address
from dbo.Student s
where St_Address= 'cairo'

create  unique CLUSTERED index VCairoSch_index  
on VCairoSch(St_Fname)

drop table dbo.Student

select * from VCairoSch where St_Fname='Ali'
------------------SQL sever profiler and tuning advisor---------------

