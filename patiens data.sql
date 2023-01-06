

--First I will create some tables for code implement purpose
CREATE DATABASE EXL;
EXEC sp_databases

Use EXL;


CREATE TABLE patients(
   patient_id   INT              NOT NULL,
   first_name VARCHAR (20)     NOT NULL,
   last_name VARCHAR (20)     NOT NULL,
   birth_date  DATE, 
   city VARCHAR (20), 
   province_id INT           NOT NULL,
   weight  INT              NOT NULL,
       
   PRIMARY KEY (patient_id)
);

--Insert a record 
INSERT INTO patients 
VALUES (1, 'Kate', 'Apple', '1999-03-16', 'London',1,50 );
INSERT INTO patients
VALUES (2, 'James', 'Banana', '1997-06-07', 'Durham',2,70 );
INSERT INTO patients
VALUES (3, 'Tom', 'Melon', '1996-05-04', 'York',3,95 );
INSERT INTO patients
VALUES (4, 'Anna', 'Orange', '1997-02-15', 'Manchester',4,62);
INSERT INTO patients
VALUES (5, 'Jack', 'Grapes', '1996-09-22', 'London',5,85 );
INSERT INTO patients
VALUES (6, 'Amy', 'Strawberry', '1996-07-22', 'Birmingham',6,45 );

select* From patients


CREATE TABLE admissions(
   patient_id   INT              NOT NULL,
   diagnosis VARCHAR (20)     NOT NULL,   
);

INSERT INTO admissions 
VALUES (1, 'Depression' );
INSERT INTO admissions
VALUES (2, 'Dementia' );
INSERT INTO admissions
VALUES (3, 'Dementia' );
INSERT INTO admissions
VALUES (4, 'Back Pain');
INSERT INTO admissions
VALUES (5,'Diabetes' );
INSERT INTO admissions
VALUES (6, 'Chest Pain');

select* From admissions


CREATE TABLE province_names(
   province_id   INT              NOT NULL,
   province_name VARCHAR (20)     NOT NULL,   
);

INSERT INTO province_names 
VALUES (1, 'Greater London');
INSERT INTO province_names
VALUES (2, 'Durham');
INSERT INTO province_names
VALUES (3, 'Yorkshire');
INSERT INTO province_names
VALUES (4, 'Greater Manchester');
INSERT INTO province_names
VALUES (5, 'Greater London' );
INSERT INTO province_names
VALUES (6, 'Birmingham');

select* From province_names

--a.       Show unique birth years from patients and order them in ascending order.
 Select DISTINCT (YEAR(birth_date) )AS Unique_BirthYear,
 first_name  from patients
 ORDER BY Unique_BirthYear ASC;


 
--b.       Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
 
SELECT
  P.patient_id,
  P.first_name,
  P.last_name
FROM patients 
AS P
  INNER JOIN admissions 
AS A 
ON P.patient_id = A.patient_id
WHERE
 A.diagnosis = 'Dementia'
 
 
 
--c.       Display the total number of patients for each province.
 
SELECT
  P.province_id
FROM patients 
AS P
  INNER JOIN province_names
AS PN 
ON P.province_id = PN.province_id
 
SELECT
 province_name, COUNT(province_name) 
as
 Total_patient  FROM province_names
GROUP BY province_name;
 
 
 
--d.      Group all patients into 10 Kg weight groups. For example, 
--if they weight 100 to 109 they are placed in the 100 weight group, 110 to 119 = 110 weight group, etc.
--Assume weight is already in Kg.
 
--Show the total amount of patients in each weight group.

SELECT COUNT (weight) AS number_of_patient,
CASE
WHEN weight < 10 THEN 0
WHEN weight >= 10 AND weight < 20 THEN 10
WHEN weight >= 20 AND weight < 30 THEN 20
WHEN weight >= 30 AND weight < 40 THEN 30
WHEN weight >= 40 AND weight < 50 THEN 40
WHEN weight >= 50 AND weight < 60 THEN 50
WHEN weight >= 60 AND weight < 70 THEN 60
WHEN weight >= 70 AND weight < 80 THEN 70
WHEN weight >= 80 AND weight < 90 THEN 80
WHEN weight >= 90 AND weight < 100 THEN 90
WHEN weight >= 100 AND weight < 110 THEN 100
WHEN weight >= 110 AND weight < 120 THEN 110
WHEN weight >= 120 AND weight < 130 THEN 120
WHEN weight >= 130 THEN 130 
END weight
FROM patients
GROUP BY weight
ORDER BY weight DESC
 
 
--e.       Show the city and the total number of patients in the city.
 
SELECT city, COUNT(*) 
AS total_patients
FROM patients
GROUP BY city
