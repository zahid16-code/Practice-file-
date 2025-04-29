-- CREATING DATABASE

CREATE DATABASE ECOM;
USE ECOM;

ALTER TABLE project1_df
RENAME TO project;

SELECT *
FROM project;

SET SQL_SAFE_UPDATES = 0;


-- DATA CLEANING IN SQL

DESCRIBE project;

SELECT COUNT(DISTINCT CID)
FROM project;

SELECT *
FROM project
WHERE `DISCOUNT NAME` ='';

UPDATE project
SET `Discount Name`='Unknown'
WHERE `Discount Name`='';

-- CONVERTING DATA TYPE
UPDATE project
SET `Purchase Date` = STR_TO_DATE(`Purchase Date`, '%d/%m/%Y %H:%i:%s');

ALTER TABLE project
MODIFY COLUMN `Purchase Date` datetime;
--
SELECT *
FROM project
ORDER BY `Purchase Date`;


-- DATA ANALYSIS USING SQL
SELECT COUNT(*)
FROM project;

-- Calculate the average discount amount availed by each age group. Which age group tends to avail the highest discounts on average?
SELECT `Age Group`,AVG(`Discount Amount (INR)`) AS AVERAGE_DISCOUNT
FROM project
GROUP BY `Age Group`
LIMIT 0,300;

-- How many unique product categories are present in the dataset? Which category has the highest total sales?
SELECT DISTINCT `Product Category`
FROM project;

SELECT `Product Category`,SUM(`Gross Amount`) AS TOTAL_AMOUNT
FROM project
GROUP BY `Product Category`
ORDER BY TOTAL_AMOUNT DESC
LIMIT 1;

-- Analyze the dataset to find out which month had the highest number of purchases. You can derive this from the "Purchase Date" column
ALTER TABLE project ADD COLUMN `Year_Month` VARCHAR(7);

UPDATE project 
SET `Year_Month` = DATE_FORMAT(`Purchase Date`, '%Y-%m');

SELECT `Year_Month`,SUM(`Gross Amount`) AS TOTAL_SALES
FROM project
GROUP BY `Year_Month`
ORDER BY `Year_Month` DESC
LIMIT 1;

-- How do purchase patterns vary across different regions or cities? Which location has the highest revenue?
SELECT `Location`,SUM(`Gross Amount`) AS TOTAL_SALES
FROM project
GROUP BY location
ORDER BY Location DESC
LIMIT 1;

-- Top 5 customers by total spend
SELECT CID,SUM(`Gross Amount`) AS TOTAL_SPENT
FROM project
GROUP BY CID
ORDER BY TOTAL_SPENT
LIMIT 5;



