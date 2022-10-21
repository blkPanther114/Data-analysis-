--Lab 2

--Update sample store with states 
Alter table SAMPLESUPERSTORE add STATES VARCHAR(25)

UPDATE SS
SET SS.STATES = S.State
FROM SampleSuperstore SS
INNER JOIN STATES S ON SS.Order_ID = S.Order_ID

SELECT * FROM SAMPLESUPERSTORE

--Select catagories whose profit lies between 50, 100
Select subcategory 
From SampleSuperstore 
Where Profit BETWEEN 50 AND 100

-- DISPLAY THE COUNT OF EACH SUBCATEGORY WITH PROFIT BETWEEN 50 AND 100
Select subcategory, COUNT(subcategory) as count_of_categroies
From SampleSuperstore 
Where Profit BETWEEN 50 AND 100
Group By subcategory

--Include the name of the state in the above query 
Select States, subcategory, COUNT(subcategory) as count_of_categroies
From SampleSuperstore 
Where Profit BETWEEN 50 AND 100
Group By subcategory,states

-- DISPLAY THE COUNT OF EACH SUBCATEGORY WITH PROFIT BETWEEN 50 AND 100 for each country
Select country, subcategory, COUNT(subcategory) as count_of_categroies
From SampleSuperstore 
Where Profit BETWEEN 50 AND 100
Group By subcategory,country

--Which country has on average higher quantities of dairy and snacks products
Select Country, Category, Avg(quantity) as Average_quantity
From SampleSuperstore
Group By Country,Category


--Find the mode of the products
Select Category, Quantity
From SampleSuperstore 
Group by Category,Quantity 
Order by count(Quantity) DESC




--Calculate the age of someone born on 1992-05-20
select floor((datediff(day,0,getdate()) - datediff(day,0,'1992-05-20')) / 365.2425) as age
