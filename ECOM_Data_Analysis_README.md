
# 📊 E-Commerce Data Analysis using SQL

This project demonstrates **data cleaning and analysis** performed on an e-commerce sales dataset using SQL. The focus is on transforming raw transactional data into actionable insights.

---

## 📁 Database and Table Setup

```sql
CREATE DATABASE ECOM;
USE ECOM;
```

Renaming the original table:

```sql
ALTER TABLE project1_df RENAME TO project;
```

---

## 🧹 Data Cleaning

1. **Handling Missing Values:**
   ```sql
   UPDATE project
   SET `Discount Name`='Unknown'
   WHERE `Discount Name`='';
   ```

2. **Converting Date Format:**
   ```sql
   UPDATE project
   SET `Purchase Date` = STR_TO_DATE(`Purchase Date`, '%d/%m/%Y %H:%i:%s');

   ALTER TABLE project
   MODIFY COLUMN `Purchase Date` datetime;
   ```

---

## 📊 Data Analysis

### ✅ Basic Stats
- Total records and unique customers.
- Overview of the table schema.

### 📈 Key Insights

1. **Average Discount by Age Group:**
   ```sql
   SELECT `Age Group`, AVG(`Discount Amount (INR)`) AS AVERAGE_DISCOUNT
   FROM project
   GROUP BY `Age Group`;
   ```

2. **Top-Selling Product Category:**
   ```sql
   SELECT `Product Category`, SUM(`Gross Amount`) AS TOTAL_AMOUNT
   FROM project
   GROUP BY `Product Category`
   ORDER BY TOTAL_AMOUNT DESC
   LIMIT 1;
   ```

3. **Highest Revenue Month:**
   ```sql
   ALTER TABLE project ADD COLUMN `Year_Month` VARCHAR(7);

   UPDATE project 
   SET `Year_Month` = DATE_FORMAT(`Purchase Date`, '%Y-%m');

   SELECT `Year_Month`, SUM(`Gross Amount`) AS TOTAL_SALES
   FROM project
   GROUP BY `Year_Month`
   ORDER BY `Year_Month` DESC
   LIMIT 1;
   ```

4. **Top Revenue Location:**
   ```sql
   SELECT `Location`, SUM(`Gross Amount`) AS TOTAL_SALES
   FROM project
   GROUP BY location
   ORDER BY Location DESC
   LIMIT 1;
   ```

5. **Top 5 Customers by Total Spend:**
   ```sql
   SELECT CID, SUM(`Gross Amount`) AS TOTAL_SPENT
   FROM project
   GROUP BY CID
   ORDER BY TOTAL_SPENT
   LIMIT 5;
   ```

---

## 🔧 Tools and Technologies

- **Database:** MySQL
- **SQL Queries:** Data cleaning, transformation, and aggregation
