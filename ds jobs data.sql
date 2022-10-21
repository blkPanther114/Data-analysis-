CREATE DATABASE DSJobs;
EXEC sp_databases

USE DSJobs


ALTER TABLE DS_all
DROP COLUMN column1;--drop the unnecessary column which shows the number of rows,because SQL will display the indexs in the output

SELECT * FROM DS_all



UPDATE DS_all--Change the labels displayed for "experience_level"
SET experience_level = REPLACE(experience_level, 'EN', 'Junior');
UPDATE DS_all
SET experience_level = REPLACE(experience_level, 'MI', 'Intermediate');
UPDATE DS_all
SET experience_level = REPLACE(experience_level, 'SE', 'Senior');
UPDATE DS_all
SET experience_level = REPLACE(experience_level, 'EX', 'Director');

SELECT *FROM DS_all



UPDATE DS_all--Change the confusing names displayed for "employment_type"
SET employment_type = REPLACE(employment_type, 'CT', 'Contract');
UPDATE DS_all
SET employment_type = REPLACE(employment_type, 'FL', 'Freelance');

--show the job titles and salary for those contract and freelance employment types
CREATE VIEW CTandFL_Jobs AS
SELECT employment_type,job_title,salary_in_GBP FROM DS_all
WHERE employment_type = 'Contract' or employment_type ='Freelance'

SELECT * FROM CTandFL_Jobs;



--add a column to exchange the salary in USD to GBP
ALTER TABLE DS_all ADD salary_in_GBP int;
UPDATE DS_all SET salary_in_GBP = salary_in_usd * 0.82;

SELECT salary_in_usd, salary_in_GBP FROM DS_all



--Count the number of different job titles
Select job_title, COUNT(job_title) as no_of_position
From DS_all 
Group By job_title
ORDER BY no_of_position DESC;



--find the average salary of different job title
SELECT job_title, AVG(salary_in_GBP) as average_salary  FROM DS_all
GROUP BY job_title
ORDER BY average_salary DESC;



--create a scalar function to find the average salary of a job title
CREATE or ALTER FUNCTION GetAvgSalary(@jobtitle VARCHAR(50))  
RETURNS float   --returns float type value
    AS 
    BEGIN
        
        DECLARE @avgSal float = 0; --declares float variable 
    
        -- retrieves average salary and assign it to a variable 
        SELECT @avgSal =  AVG(salary_in_GBP) FROM DS_all
        WHERE job_title = @jobtitle
    
        RETURN @avgSal; --returns a value
    END

SELECT dbo.GetAvgSalary('Data Scientist') As Average_salary; --choose data scientist as the job title in this case
SELECT dbo.GetAvgSalary('Machine Learning Engineer') As Average_salary;--choose another job title to calculate


--alter a function to list down all the senior level jobs with salary etc
ALTER FUNCTION dbo.DSJobs(@exp_level VARCHAR(50))

RETURNS TABLE
AS
RETURN
SELECT job_title,salary_in_GBP,company_location,experience_level FROM DS_all
       WHERE experience_level = @exp_level
--execute the function:	
SELECT * FROM dbo.DSJobs('Senior')
   Order by salary_in_GBP DESC;



--average salary of different full-time and entry-level job roles 
SELECT job_title,experience_level,company_location,salary_in_GBP,employment_type,
AVG(salary_in_GBP)  OVER(PARTITION BY job_title)AS Average_SALARY
FROM DS_all
WHERE employment_type='FT'and experience_level='Junior'
ORDER BY average_salary DESC;



--which country pays the highest overall average salary?
SELECT company_location, AVG(salary_in_GBP) as average_salary  FROM DS_all
GROUP BY company_location
ORDER BY average_salary DESC;


--average salary for a data analyst job in different country
Select company_location, job_title, AVG(salary_in_GBP) AS Average_SALARY
From DS_all 
WHERE job_title='Data Analyst' 
Group By company_location,job_title
ORDER BY  Average_SALARY DESC;


--average salary for different full-time job roles in the UK
SELECT job_title,experience_level,company_location,salary_in_GBP,employment_type,
AVG(salary_in_GBP) OVER(PARTITION BY job_title) AS Average_SALARY
FROM DS_all
WHERE employment_type='FT' and company_location = 'GB'
ORDER BY average_salary DESC;


--create a procedure to show the overall info summary of a certain country
CREATE PROCEDURE CountrySummary (@com_loca as varchar(30))
AS

SELECT company_location,AVG(salary_in_GBP) AS AVERAGE_SALARY,
 MAX(salary_in_GBP) AS MAXIMUM_SALARY,MIN(salary_in_GBP) AS MINIMUM_SALARY, AVG(remote_ratio)AS AVG_Remote_Ratio
 FROM DS_all 
 WHERE company_location = 'GB'
 GROUP BY company_location
 GO
EXEC CountrySummary @com_loca = 'GB';


--make change to the procedure
ALTER PROCEDURE CountrySummary (@com_loca as varchar(30))
AS

SELECT TOP 1 company_size AS mode_companySize_in_GB--find the mode of company size in GB
FROM DS_all  WHERE company_location = 'GB'

SELECT company_location,AVG(salary_in_GBP) AS AVERAGE_SALARY,
 MAX(salary_in_GBP) AS MAXIMUM_SALARY,MIN(salary_in_GBP) AS MINIMUM_SALARY, AVG(remote_ratio)AS AVG_Remote_Ratio
 FROM DS_all 
 WHERE company_location = 'GB'
 GROUP BY company_location
 GO

EXEC CountrySummary @com_loca = 'GB';






