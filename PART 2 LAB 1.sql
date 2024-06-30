USE Company_SD;
-- Q1
CREATE RULE RSALARY AS @SALARY > 1000;

SP_BINDRULE RSALARY, 'EMPLOYEE.SALARY';

-----------------------------------------------------------------------------------
-- Q2 

CREATE TYPE LOC FROM NCHAR(2);

CREATE DEFAULT LOCDEF AS 'NY';

SP_BINDEFAULT LOCDEF, LOC;

CREATE RULE LOCRULE AS @VAL IN ('NY','DS','KW');

SP_BINDRULE LOCRULE, LOC;

SP_BINDRULE LOCRULE, 'EMPLOYEE.ADDRESS';

-----------------------------------------------------------------------------------
-- Q3

CREATE TABLE NEW_STDUDENT (TYP LOC, ID INT PRIMARY KEY);

-----------------------------------------------------------------------------------
-- Q4

 CREATE SEQUENCE S1 START WITH 1 INCREMENT BY 1;
 ----------------------------------------------------------

 INSERT INTO NEW_STDUDENT VALUES ('NY', NEXT VALUE FOR S1);
 
 INSERT INTO NEW_STDUDENT VALUES ('DS', NEXT VALUE FOR S1);
 
 INSERT INTO NEW_STDUDENT VALUES ('KW', NEXT VALUE FOR S1);

 ----------------------------------------------------------
 SELECT * FROM NEW_STDUDENT;

 ---------------------------------------------
 DELETE FROM NEW_STDUDENT WHERE ID = 2;
 ---------------------------------------------

 INSERT INTO NEW_STDUDENT VALUES ('DS', NEXT VALUE FOR S1);
 
 INSERT INTO NEW_STDUDENT VALUES ('KW', NEXT VALUE FOR S1);
 
 ---------------------------------------------
 -- YES I CAN INSERT ANOTHER RECORD WTHOUT USING SEQUENCE
 
 INSERT INTO NEW_STDUDENT VALUES ('KW', 10);

 -- NO I CANT
 ---------------------------------------------
 -- YES I CAN UPDATE REC WITHOUT USING SEQUENCE
 UPDATE NEW_STDUDENT
 SET ID = 15
 WHERE TYP = 'DS';

 -- NO I CANT DO THE SAME WITH IDENTTY
 -------------------------------------------------------
 -- YES I CAN USE SEQUENCE TO INSERT IN ANOTHER TABLE
 CREATE TABLE NEW_NEW_STD (ID INT);

 INSERT INTO NEW_NEW_STD VALUES (NEXT VALUE FOR S1);

 -- BUT IT BEGIN FROM LAST VAL IN SEQUENCE 

 SELECT * FROM NEW_NEW_STD;
 -------------------------------------------------------
 -- TO SKIP VAL FROM SEQUENCE
 SELECT NEXT VALUE FOR S1;
 
 -- NO I CANT DO THE SAME WITH IDENTITY BECAUSE ITS DIFF ALOT
 --------------------------------------------------------------------
 -- ALL OF ABOVE IS DIFF 

 


