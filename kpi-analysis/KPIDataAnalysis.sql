USE ecom;
DESCRIBE  `procurement kpi analysis dataset`;

-- USING SQL FOR THE `procurement kpi analysis dataset` CLEANING AND ANALYSIS
SELECT *
FROM `procurement kpi analysis dataset`;

ALTER TABLE `procurement kpi analysis dataset`
RENAME TO kpi_file;

SELECT *
FROM kpi_file;
SET SQL_SAFE_UPDATES = 0;
-- HANDLING NULL VALUES

SELECT *
FROM kpi_file
WHERE Delivery_Date IS NULL 
   OR Delivery_Date = '' 
   OR Delivery_Date = ' ';
   
UPDATE kpi_file
SET Delivery_Date='2023-01-01'
WHERE Delivery_Date IS NULL 
   OR Delivery_Date = '' 
   OR Delivery_Date = ' ';

SELECT *
FROM kpi_file
WHERE Order_Date IS NULL 
   OR Order_Date = '' 
   OR Order_Date = ' ';
   

UPDATE kpi_file
SET Order_Date='2023-01-01'
WHERE Order_Date IS NULL 
   OR Order_Date = '' 
   OR Order_Date = ' ';
   
SELECT *
FROM kpi_file
WHERE Defective_Units IS NULL 
   OR  Defective_Units = '' 
   OR Defective_Units = ' ';
   
UPDATE kpi_file
SET Defective_units = '0'
WHERE Defective_Units IS NULL 
   OR  Defective_Units = '' 
   OR Defective_Units = ' ';

-- CONVERTING DATA TYPES
ALTER TABLE kpi_file
MODIFY COLUMN Order_Date DATE,
MODIFY COLUMN Delivery_Date DATE,
MODIFY COLUMN Quantity INT,
MODIFY COLUMN Unit_Price INT,
MODIFY COLUMN Defective_Units INT;

-- DATA ANALYSIS 
-- 1) How many unique purchase order numbers (PO_Number) are in the dataset?
SELECT COUNT(DISTINCT PO_ID)
FROM kpi_file;

-- 2) Which vendor has received the highest total gross amount
SELECT Supplier,SUM(Negotiated_Price) AS GROSS_AMOUNT
FROM kpi_file
WHERE Order_Status = 'Delivered'
GROUP BY Supplier;

-- 3) What is the total quantity of items ordered per material group?
SELECT Item_Category,SUM(Quantity) AS QUANTITY
FROM kpi_file
GROUP BY Item_Category;

-- 4) Which month had the highest total purchase value? (Use PO_Date or Delivery_Date
ALTER TABLE kpi_file
ADD COLUMN `Year_Month` varchar(7);

UPDATE kpi_file 
SET `Year_Month` = DATE_FORMAT(Delivery_Date, '%Y-%m');

SELECT `Year_Month`,SUM(Negotiated_Price) AS TOTAL_SALES
FROM kpi_file
GROUP BY `Year_Month`
ORDER BY TOTAL_SALES DESC;

-- 5) Which material is most frequently ordered?
SELECT Item_Category,COUNT(PO_ID) AS NO_ORDERS
FROM kpi_file
GROUP BY Item_Category
ORDER BY NO_ORDERS DESC;
 
-- 6) Which supplier has the highest number of delayed deliveries? (Delivery date after expected date
SELECT Supplier, COUNT(*) AS Delayed_Deliveries
FROM kpi_file
WHERE Delivery_Date > Order_Date
GROUP BY Supplier
ORDER BY Delayed_Deliveries DESC
LIMIT 1;

-- 7) Are there any items where Unit_Price is greater than Negotiated_Price? How many?
SELECT COUNT(*) AS TOTAL
FROM kpi_file
WHERE Negotiated_Price>Unit_Price;

SELECT COUNT(*) AS TOTAL
FROM kpi_file
WHERE Unit_Price > Negotiated_Price;

-- 8) What percentage of orders are still marked as "Pending" in Order_Status?
SELECT 
    (COUNT(CASE WHEN Order_Status = 'Pending' THEN 1 END) 
    * 100.0 
    / COUNT(*)
    ) AS Pending_Percentage
FROM kpi_file;

-- 9) Which item category has the highest average Negotiated_Price?
SELECT Item_Category,AVG(Negotiated_Price) AVG_Negotiated_Price
FROM kpi_file
GROUP BY Item_Category
ORDER BY AVG_Negotiated_Price DESC;

-- 10) What is the average delay between Order_Date and Delivery_Date
SELECT AVG(DATEDIFF(Delivery_Date, Order_Date)) AS Average_Delay
FROM kpi_file;



