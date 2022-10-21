EXEC sp_databases

USE Employee_Data



SELECT * FROM Employees

SELECT EMP.ID,EMP.NAME,EMP.SALARY, DEPT.NAME FROM EMPLOYEES AS EMP
INNER JOIN EMPLOYEE_DEPT AS EMP_DEPT ON
EMP.ID = EMP_DEPT.EMP_ID
LEFT JOIN DEPARTMENTS AS DEPT ON
DEPT.DEPT_ID = EMP_DEPT.DEPT_ID

--UPDATE
ALTER TABLE EMPLOYEES ADD DEPARTMENT varchar(25);
UPDATE EMPLOYEES SET DEPARTMENT = 'Marketing' WHERE ID = 1;
UPDATE EMPLOYEES SET DEPARTMENT = 'Sales' WHERE ID = 2;
UPDATE EMPLOYEES SET DEPARTMENT = 'Finance' WHERE ID = 3;
UPDATE EMPLOYEES SET DEPARTMENT = 'Sales' WHERE ID = 4;
UPDATE EMPLOYEES SET DEPARTMENT = 'HR' WHERE ID = 5;
UPDATE EMPLOYEES SET DEPARTMENT = 'HR' WHERE ID = 6;
UPDATE EMPLOYEES SET DEPARTMENT = 'Sales' WHERE ID = 7;
UPDATE EMPLOYEES SET DEPARTMENT = 'Marketing' WHERE ID = 8;

--UPDATE EMPLOYEES
--SET EMP.DEPARTMENT = DEPT.NAME FROM EMPLOYEES AS EMP
--INNER JOIN EMPLOYEE_DEPT AS EMP_DEPT ON
--EMP.ID = EMP_DEPT.EMP_ID
--LEFT JOIN DEPARTMENTS AS DEPT ON
--DEPT.DEPT_ID = EMP_DEPT.DEPT_ID

Select NAME, DEPARTMENT, Avg(SALARY) 
FROM EMPLOYEES
WHERE DEPARTMENT IS NOT NULL
GROUP BY DEPARTMENT

Select DEPARTMENT, avg(SALARY) 
FROM EMPLOYEES
WHERE DEPARTMENT IS NOT NULL
GROUP BY DEPARTMENT

--OVER()
SELECT Name,Age,Address,Department, 
AVG(SALARY) OVER() AS TOTAL_SALARY
FROM EMPLOYEES

--PARTITION()
SELECT Name,Age,Address,Department, 
AVG(SALARY) OVER(PARTITION BY DEPARTMENT) AS Average_SALARY
FROM EMPLOYEES

--ARRANGING ROWS WITHIN PARTITION
SELECT Name,Age,Address,Department,SALARY,
AVG(SALARY) 
OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC) AS Average_SALARY
FROM EMPLOYEES

--ROWNUMBER
SELECT Name,Age,Address,Department,SALARY, ROW_NUMBER() 
OVER(ORDER BY SALARY) AS ROWNUMBER 
FROM EMPLOYEES

--Limit the partition with ROWNUMBER
SELECT Name,Age,Address,Department,SALARY, ROW_NUMBER() 
OVER(PARTITION BY DEPARTMENT ORDER BY SALARY) 
AS ROWNUMBER FROM EMPLOYEES

--RANK
SELECT Name,Age,Address,Department,SALARY, 
ROW_NUMBER() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY)
AS ROWNUMBER,
RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY) AS RANK_ROW
FROM EMPLOYEES

INSERT INTO EMPLOYEES VALUES (11, 'James' , 31, 'London', 75000, 'Male', 'Steven', 'James Steven', 'Sales')
INSERT INTO EMPLOYEES VALUES (12, 'Aditi' , 36, 'London', 95000, 'Female', 'Austin', 'Aditi Austin', 'Sales')

--DENSE_RANK
SELECT Name,Department,SALARY, 
ROW_NUMBER() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY) AS ROWNUMBER,
RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY) AS RANK_ROW,
DENSE_RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY) AS RANK_ROW
FROM EMPLOYEES


--NTH VALUES
SELECT TOP 2 NAME  
FROM  (SELECT TOP 5 NAME FROM EMPLOYEES ORDER BY SALARY DESC) T


--LEAD FUNCTION
/*Lead values*/
select Name,Department,SALARY,
LEAD(salary, 1) Over(partition by DEPARTMENT order by salary) as sal_next
from EMPLOYEES;

--LAG FUNCTION
/*Lag values*/
select Name,Department,SALARY,
LAG(SALARY, 1) Over(partition by DEPARTMENT order by SALARY) as sal_previous,
SALARY - LAG(SALARY, 1) Over(partition by DEPARTMENT order by SALARY) as sal_diff
from EMPLOYEES;

-----------STORED PROCEDURES---------------
CREATE PROCEDURE UPSKILLprocedure
AS
PRINT 'UPSKILL DIGITAL'

exec UPSKILLprocedure

--Stored procedure to select all employees
CREATE PROCEDURE SelectAllEmployees
AS
SELECT * FROM Employees
GO;

EXEC SelectAllEmployees

--stored procedure to select all employees based in a city
CREATE PROCEDURE SelectAllEmployeesAddress (@Address as varchar(30))
AS
SELECT Name,Address,Salary,Department FROM Employees WHERE Address = @Address
GO

EXEC SelectAllEmployeesAddress @Address = 'Reading';
EXEC SelectAllEmployeesAddress @Address = 'London';

--stored procedure to select all employees based in multiple cities
CREATE PROCEDURE EmployeesAddresses
@Address1 as varchar(30), @Address2 as varchar(30)
AS
SELECT  Name,Address,Salary,Department FROM Employees 
WHERE Address = @Address1 OR Address = @Address2 
GO

EXEC EmployeesAddresses @Address1 = 'London', @Address2 = 'Reading';
--OR
EXEC EmployeesAddresses 'London', 'Reading';

--ALTER A STOED PROCEDURE 
ALTER PROCEDURE EmployeesAddresses 
@Address1 as varchar(30), @Address2 as varchar(30)
AS
SELECT Name,Address,Salary,Department FROM Employees
WHERE Address = @Address1 OR Address = @Address2 
ORDER BY SALARY
GO

EXEC EmployeesAddresses 'London', 'Reading';
--DELETE A PROCEDURE 
DROP PROCEDURE IF EXISTS EmployeesAddresses

--ACTIVITY 2
--Create a stored procedure to show the record of male employees who works in London OR reading, age > 30
-- and salary is between 35000 to 75000, where all the parameters are passed as an  argument.  
-- Later using the same stored procedure change the Gender to Female, while keeping the rest of the paremeters same
CREATE PROCEDURE activity2 @Gender as varchar(25),@Address1 as varchar(30), @Address2 as varchar(30), 
@Age as INT, @MIN_SALARY AS INT, @MAX_SALARY AS INT
AS
SELECT * FROM Employees WHERE GENDER = @GENDER AND (Address = @Address1 OR Address = @Address2)
AND AGE > @AGE AND (SALARY >= @MAX_SALARY AND SALARY <= @MIN_SALARY)
GO

EXEC activity2 'Male', 'London','Reading', 30 , 75000, 35000
EXEC activity2 'Female', 'London','Reading', 30 , 95000, 35000

--FUNCTIONS
CREATE FUNCTION upskillfunction()
RETURNS varchar(130)
AS 
BEGIN
  RETURN 'Welcome to UPSKILL DIGITAL'
END

SELECT dbo.upskillfunction() AS 'Message'
GO


--Get department records
CREATE FUNCTION GetDeptRecords (
    @DEPT_NAME VARCHAR(50)
)
RETURNS TABLE
AS
RETURN SELECT name, Department FROM EMPLOYEES
       WHERE Department = @DEPT_NAME


SELECT * FROM dbo.GetDeptRecords('Sales')
GO

--return the name and salary of employees from marketing department
CREATE FUNCTION activity3 (
    @DEPT_NAME VARCHAR(50)
)
RETURNS TABLE
AS
RETURN SELECT name,Salary, Department FROM EMPLOYEES
       WHERE Department = @DEPT_NAME
	
SELECT * FROM dbo.activity3('Marketing')
Order by 1


--UPDATE Function
ALTER FUNCTION GetDeptRecords (
    @DEPT_NAME VARCHAR(50),
	@GENDER VARCHAR(50)
)
RETURNS TABLE
AS
RETURN SELECT name, SALARY,GENDER, Department FROM EMPLOYEES
       WHERE Department = @DEPT_NAME AND GENDER = @GENDER

SELECT * FROM GetDeptRecords('Sales','Female')
GO

--Delete a function
DROP FUNCTION IF EXISTS GetDeptRecords

--TRIGGERS
CREATE TRIGGER display_salary_changes ON EMPLOYEES 
AFTER INSERT, DELETE
AS
FOR EACH ROW 
WHEN (NEW.ID > 0) 
DECLARE 
   @sal_diff ; 
BEGIN 
   sal_diff := :NEW.salary  - :OLD.salary; 
   dbms_output.put_line('Old salary: ' || :OLD.salary); 
   dbms_output.put_line('New salary: ' || :NEW.salary); 
   dbms_output.put_line('Salary difference: ' || sal_diff); 
END; 
/ 


CREATE TRIGGER display_salary_change ON EMPLOYEES 
AFTER DELETE , INSERT , UPDATE
AS 
BEGIN
  DECLARE @sal_diff INT
	BEGIN 
		sal_diff = NEW.salary  - OLD.salary; 
		print  OLD.salary; 
		print NEW.salary; 
		print  sal_diff; 
	END
END;
/



--VIEWS
CREATE VIEW EMPLOYEE_VIEW AS
SELECT NAME,AGE,ADDRESS
FROM  EMPLOYEES;

SELECT * FROM EMPLOYEE_VIEW

--ACTIVITY 
CREATE VIEW HIGHEST_SALARIES AS
SELECT NAME,AGE,ADDRESS,SALARY 
FROM  EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)

SELECT * FROM HIGHEST_SALARIES

--WITH CHECK OPTION
CREATE VIEW SALARY_CHECK AS
SELECT NAME,AGE,ADDRESS,SALARY
FROM  EMPLOYEES
WHERE SALARY IS NOT NULL
WITH CHECK OPTION;

SELECT * FROM SALARY_CHECK

--UPDATE
UPDATE SALARY_CHECK
SET ADDRESS = NULL
WHERE NAME = 'SARA'

--DELETE
DELETE FROM SALARY_CHECK
WHERE NAME = 'SARA'

--DROP A VIEW
DROP VIEW SALARY_CHECK;