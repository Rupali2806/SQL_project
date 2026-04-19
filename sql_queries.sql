-- =========================================
-- SALES DATA ANALYSIS PROJECT
-- =========================================
--- 1. creating a database
CREATE DATABASE sales_project;
USE sales_project;
-- =========================================
-- BASIC ANALYSIS
-- =========================================
--- 2. view data
SELECT * FROM `superstore dataset` LIMIT 10;
--- 3. Rename dataset
ALTER TABLE `superstore dataset`
RENAME TO superstore_dataset;
SELECT * FROM superstore_dataset LIMIT 10;
--- 4. finding total number of rows in the dataset
SELECT COUNT(*) FROM superstore_dataset;
--- 5. identifying unique regions
SELECT DISTINCT Region FROM superstore_dataset;
-- =========================================
-- INTERMEDIATE ANALYSIS
-- =========================================
--- 6. total sales by region
SELECT Region, SUM(Sales) AS total_sales
FROM superstore_dataset
GROUP BY Region;
--- 7. Total sales by category
SELECT Category, SUM(Sales) AS total_sales
FROM superstore_dataset
GROUP BY Category;
--- 8. Average sales per customer
SELECT `Customer Name`, AVG(Sales) AS avg_sales
FROM superstore_dataset
GROUP BY `Customer Name`;
--- 9. Identify top 5 products by total sales revenue
SELECT `Product Name`, SUM(Sales) AS revenue
FROM superstore_dataset
GROUP BY `Product Name`
ORDER BY revenue DESC
LIMIT 5;
--- 10. Sales by region after 2020
SELECT Region, SUM(Sales) AS total_sales
FROM superstore_dataset
WHERE `Order Date` > '2020-01-01'
GROUP BY Region;
--- 11. Sales by year
SELECT YEAR(`Order Date`) AS year, SUM(Sales) AS total_sales
FROM superstore_dataset
GROUP BY year;
--- 12. Sales by month
SELECT MONTH(`Order Date`) AS month, SUM(Sales) AS total_sales
FROM superstore_dataset
GROUP BY month;
--- 13. Finding most profitable region
SELECT Region, SUM(Profit) AS profit
FROM superstore_dataset
GROUP BY Region
ORDER BY profit DESC
LIMIT 1;
--- 14. Identifying loss making products
SELECT `Product Name`, SUM(Profit) AS profit
FROM superstore_dataset
GROUP BY `Product Name`
HAVING profit < 0;
-- =========================================
-- ADVANCED ANALYSIS
-- =========================================
--- 15. Sales contribution in percentage
SELECT Region,
       SUM(Sales) AS region_sales,
       (SUM(Sales) / (SELECT SUM(Sales) FROM superstore_dataset)) * 100 AS percentage
FROM superstore_dataset
GROUP BY Region;
--- 16. Top customer names in terms of total sales
SELECT `Customer Name`, SUM(Sales) AS total
FROM superstore_dataset
GROUP BY `Customer Name`
ORDER BY total DESC
LIMIT 1;
--- 17. Top customer per region
SELECT Region, `Customer Name`, total_sales
FROM (
    SELECT Region, `Customer Name`,
           SUM(Sales) AS total_sales,
           RANK() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS rnk
    FROM superstore_dataset
    GROUP BY Region, `Customer Name`
) t
WHERE rnk = 1;
--- 18. Category wise profit margin
SELECT Category,
       SUM(Profit) / SUM(Sales) * 100 AS profit_margin
FROM superstore_dataset
GROUP BY Category
ORDER BY profit_margin DESC;
--- 19. Customer with repeat orders
SELECT `Customer Name`, COUNT(`Order ID`) AS total_orders
FROM superstore_dataset
GROUP BY `Customer Name`
HAVING total_orders > 5
ORDER BY total_orders DESC;
--- 20. Orders with high values
SELECT *
FROM superstore_dataset
WHERE Sales > (
    SELECT AVG(Sales) FROM superstore_dataset
);
--- 21. Monthly sales trend
SELECT YEAR(`Order Date`) AS year,
       MONTH(`Order Date`) AS month,
       SUM(Sales) AS monthly_sales
FROM superstore_dataset
GROUP BY year, month;
--- 22. Year to year growth in sales
SELECT YEAR(`Order Date`) AS year,
       SUM(Sales) AS total_sales
FROM superstore_dataset
GROUP BY year
ORDER BY year;
--- 23. Identifying average order value
SELECT AVG(Sales) AS avg_order_value
FROM superstore_dataset;
-- =========================================
-- DATA CLEANING
-- =========================================

--- 24. Check missing values in key columns
SELECT 
    COUNT(CASE WHEN Profit IS NULL THEN 1 END) AS missing_profit,
    COUNT(CASE WHEN Sales IS NULL THEN 1 END) AS missing_sales,
    COUNT(CASE WHEN `Customer Name` IS NULL THEN 1 END) AS missing_customers
FROM superstore_dataset;
-- =========================================
-- JOIN FUNCTION
-- =========================================
--- 25. Create a customer table with unique customer details
CREATE TABLE customers AS
SELECT DISTINCT 
    `Customer Name`,
    Segment,
    Region
FROM superstore_dataset;
--- 26. Calculate total sales for each region using JOIN
SELECT c.Region,
       SUM(s.Sales) AS total_sales
FROM superstore_dataset s
JOIN customers c
ON s.`Customer Name` = c.`Customer Name`
GROUP BY c.Region;
--- 27. Calculate total sales by customer segment using LEFT JOIN
SELECT s.`Customer Name`,
       s.Sales,
       c.Segment
FROM superstore_dataset s
LEFT JOIN customers c
ON s.`Customer Name` = c.`Customer Name`;
--- 28. Display all customers along with their sales and segment using RIGHT JOIN
SELECT s.`Customer Name`,
       s.Sales,
       c.Segment
FROM superstore_dataset s
RIGHT JOIN customers c
ON s.`Customer Name` = c.`Customer Name`;
--- 29. Display customer segment information for each sale
SELECT c.Segment,
       SUM(s.Sales) AS total_sales
FROM superstore_dataset s
LEFT JOIN customers c
ON s.`Customer Name` = c.`Customer Name`
GROUP BY c.Segment;