CREATE DATABASE Lab1;
EXEC sp_databases

USE Lab1

--Select all the record where Region = South
SELECT Order_ID,Country, Region
FROM SampleSuperstore
WHERE Region = 'South';



--How many records South region has? Set column name as 'South_Region'
SELECT COUNT(Region) as South_Region
FROM SampleSuperstore
WHERE Region='South';



-- Count of sales of all Regions

SELECT Region, COUNT(Sales) as Total_sales  FROM SampleSuperstore 
GROUP BY Region



--Count of sales of all regions by category 

SELECT Category,Region, COUNT(Sales) as Total_Sales  FROM SampleSuperstore
GROUP BY Category,Region 




--Sort the sales in DESC order 
Select * from SampleSuperstore 
ORDER BY Sales DESC;




--Display the category and subcategory where profit is negative
Select Category, Subcategory, Profit
FROM SampleSuperstore
WHERE Profit <0 


-- Total Sales of all the states
SELECT State, COUNT(Sales) as Total_sales  FROM SampleSuperstore 
GROUP BY State



--Which State has the most number of negative profit

Select State, COUNT(Profit) as total_negative FROM SampleSuperstore
WHERE Profit <-1 
GROUP BY state
ORDER BY total_negative DESC;



--Which Region has the most number of negative profit

Select Region, COUNT(Profit) as total_negative FROM SampleSuperstore
WHERE Profit <0 
GROUP BY Region
ORDER BY total_negative DESC;