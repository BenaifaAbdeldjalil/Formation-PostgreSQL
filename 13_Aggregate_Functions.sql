/* ============================================================================== 
   SQL Aggregate Functions
   Basic Aggregate Functions
        - COUNT
        - SUM
        - AVG
        - MAX
        - MIN

=================================================================================
*/

/* ============================================================================== 
   BASIC AGGREGATE FUNCTIONS
=============================================================================== */
SELECT *  FROM customers;

-- Find the total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(customerid) AS total_customers
FROM customers;

SELECT COUNT(firstname ) AS total_customers
FROM customers;

SELECT COUNT(lastname  ) AS total_customers
FROM customers;

SELECT country, COUNT(*) AS total_customers
FROM customers
group by country;

SELECT *  FROM orders;
-- Find the total sales of all orders
SELECT SUM(sales) AS total_sales
FROM orders;

SELECT orderstatus, SUM(sales) AS total_sales
FROM orders

SELECT orderstatus, SUM(sales) AS total_sales
FROM orders
group by orderstatus;

-- Find the average sales of all orders
SELECT AVG(sales) AS avg_sales
FROM orders

-- Find the highest score among customers
SELECT MAX(score) AS max_score
FROM customers

-- Find the lowest score among customers
SELECT MIN(score) AS min_score
FROM customers

/* ============================================================================== 
   GROUPED AGGREGATIONS - GROUP BY
=============================================================================== */

-- Find the number of orders, total sales, average sales, highest sales, and lowest sales per customer
SELECT
    customerid,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    AVG(sales) AS avg_sales,
    MAX(sales) AS highest_sales,
    MIN(sales) AS lowest_sales
FROM orders
GROUP BY customerid
