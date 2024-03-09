USE atharva ;

SELECT * FROM Cars;

# Distribution of Cars by Fuel type
SELECT COUNT(Model) AS 'Total Models', Fuel
FROM Cars
GROUP BY Fuel;



# What is the average price of cars in each market category
SELECT Category, AVG(Price) AS AvgPrice
FROM Cars
GROUP BY Category;



# Which car models have the highest horsepower (HP)
SELECT DISTINCT(ï»¿Make), Model, HP
FROM Cars
WHERE HP = (SELECT MAX(HP) 
            FROM Cars);



# How many cars are available for each fuel type
SELECT Fuel, COUNT(*) AS 'Num Cars'
FROM Cars
GROUP BY Fuel;



# Which car has the highest price per cylinder
SELECT ï»¿Make, Model, Price / Cylinders AS 'Price Per Cylinder'
FROM Cars
ORDER BY 'Price Per Cylinder' DESC
LIMIT 1;



# How many cars have manual transmission and more than 6 cylinders
SELECT COUNT(*) AS 'Num Cars'
FROM Cars
WHERE Transmission = 'Manual' AND Cylinders > 6;



# Which car model has the highest price among cars with 4 doors and automatic transmission
SELECT ï»¿Make, Model, Price
FROM Cars
WHERE Doors = 4 AND Transmission = 'Automatic'
ORDER BY Price DESC
LIMIT 1;



# What is the total number of cars for each style (e.g., Sedan, SUV, Coupe)
SELECT Style, COUNT(*) AS 'Num Cars'
FROM Cars
GROUP BY Style;



# Which car model has the highest price among cars with 4 doors and automatic transmission
SELECT ï»¿Make, Model, Price
FROM Cars
WHERE Doors = 4 AND Transmission = 'Automatic'
ORDER BY Price DESC
LIMIT 1;



# Which car has the highest price per year
SELECT ï»¿Make, Model, Year, MAX(Price) AS MaxPrice
FROM Cars
GROUP BY Year
ORDER BY MaxPrice DESC;



# What is the average highway MPG for cars with more than 8 cylinders
SELECT AVG('Highway MPG') AS 'Avg Highway MPG'
FROM Cars
WHERE Cylinders > 8;



# Which car models have a price higher than the average price of all cars
SELECT ï»¿Make, Model, Price
FROM Cars
WHERE Price > (SELECT AVG(Price) 
               FROM Cars);



# What is the total number of cars for each size category (e.g., Compact, Midsize, Fullsize)
SELECT Size, COUNT(*) AS NumCars
FROM Cars
GROUP BY Size;



# Which car models have the highest price in each year
SELECT Year, ï»¿Make, Model, Price
FROM (
    SELECT Year, ï»¿Make, Model, Price, 
           ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Price DESC) AS RowNum
    FROM Cars
) AS RankedCars
WHERE RowNum = 1;



# Rank the cars based on their price in each year
SELECT 
    ï»¿Make, Model, Year, Price,
    RANK() OVER (PARTITION BY Year ORDER BY Price DESC) AS Price_Rank
FROM Cars;



# Average price of cars by make and model
SELECT ï»¿Make, Model, Price,
       ROW_NUMBER() OVER(ORDER BY ï»¿Make, Model) AS RowNum,
       AVG(Price) OVER(PARTITION BY ï»¿Make, Model) AS AvgPrice
FROM Cars;



# Total number of cars and the average city MPG by fuel type
SELECT Fuel,
       COUNT(*) AS TotalCars,
       AVG('City MPG') AS AvgCityMPG
FROM Cars
GROUP BY Fuel;



# Creating View which stores Cars with above-average city MPG
CREATE VIEW HighMPGCars AS
SELECT *
FROM Cars
WHERE 'City MPG' > (SELECT AVG('City MPG') 
				  FROM Cars);
                  

                  
# Cars with the highest price in each market category              
SELECT ï»¿Make, Model, Price, Category
FROM Cars C
WHERE Price = (SELECT MAX(Price) 
			   FROM Cars 
               WHERE Category = C.Category);



# Cars with similar specifications but different prices
SELECT C1.ï»¿Make, C1.Model, C1.Year, C1.Fuel, C1.HP, C1.Price AS Price1, 
C2.Price AS Price2, ABS(C1.Price - C2.Price) AS Price_difference
FROM Cars C1
JOIN Cars C2 ON C1.ï»¿Make = C2.ï»¿Make AND C1.Model = C2.Model
WHERE C1.Price <> C2.Price;



# Cars based on their city MPG into different categories
SELECT ï»¿Make, Model, Price,
       CASE
           WHEN 'City MPG' >= 30 THEN 'High MPG'
           WHEN 'City MPG' >= 20 THEN 'Medium MPG'
           ELSE 'Low MPG'
       END AS MPG_Category
FROM Cars;



# Dummy Table with constraints for storing car dealership information
CREATE TABLE Dealerships (
    DealerID INT PRIMARY KEY,
    DealerName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    CONSTRAINT UC_DealerName_Location UNIQUE (DealerName, Location)
);



# Car makes with average price higher than $50,000 and total count greater than 50
SELECT ï»¿Make, AVG(Price) AS AvgPrice, COUNT(*) AS TotalCount
FROM Cars
GROUP BY ï»¿Make
HAVING AVG(Price) > 50000 AND COUNT(*) > 50;



# Create an index on the 'Year' column for faster retrieval of cars manufactured in a specific year
CREATE INDEX IX_Year ON Cars (Year);



# Temporary table to store cars with manual transmission
CREATE TEMPORARY TABLE ManualTransCars AS
SELECT *
FROM Cars
WHERE Transmission = 'Manual';



# Cars with the highest and lowest prices
(SELECT ï»¿Make, Model, Price
 FROM Cars
 ORDER BY Price DESC
 LIMIT 1)
UNION
(SELECT ï»¿Make, Model, Price
 FROM Cars
 ORDER BY Price ASC
 LIMIT 1);
 
 
 
 # Cars that have at least one door and a price greater than $30,000
SELECT ï»¿Make, Model, Price
FROM Cars C
WHERE EXISTS (SELECT 1 
              FROM Cars 
			  WHERE Doors >= 1 AND Price > 30000);
              
 
 
# Common Table Expression (CTE): Find the average price of cars for each year
WITH AvgPricePerYear AS (
    SELECT Year, AVG(Price) AS AvgPrice
    FROM Cars
    GROUP BY Year
)
SELECT Year, AvgPrice
FROM AvgPricePerYear;



# Count of cars by fuel type and transmission type
SELECT Fuel,
       SUM(CASE WHEN Transmission = 'Automatic' THEN 1 ELSE 0 END) AS Automatic_Count,
       SUM(CASE WHEN Transmission = 'Manual' THEN 1 ELSE 0 END) AS Manual_Count
FROM Cars
GROUP BY Fuel;



# All possible combinations of car makes and models
SELECT A.ï»¿Make, A.Model, B.ï»¿Make AS Other_Make, B.Model AS Other_Model
FROM Cars A
CROSS JOIN Cars B
WHERE A.ï»¿Make <> B.ï»¿Make OR A.Model <> B.Model;



# Running total of car prices ordered by year
SELECT ï»¿Make, Model, Year, Price,
       SUM(Price) OVER (PARTITION BY Year ORDER BY ï»¿Make, Model) AS RunningTotal
FROM Cars;



# Cars with prices higher than the average price of their make
SELECT ï»¿Make, Model, Price
FROM Cars A
WHERE Price > (SELECT AVG(Price) 
               FROM Cars  
               WHERE ï»¿Make = A.ï»¿Make);
               
               




















