
/* ==============================================================================
   USE CASE: CATEGORIZE DATA
===============================================================================*/

/*Create a report showing total sales for each category:
	   - High: Sales over 50
	   - Medium: Sales between 20 and 50
	   - Low: Sales 20 or less
*/
select * from Orders;

SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High'
            WHEN Sales > 20 THEN 'Medium'
            ELSE 'Low'
        END AS Category
    FROM  Orders
    
-----
SELECT
    Category,
    SUM(Sales) AS TotalSales
FROM (
    SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High'
            WHEN Sales > 20 THEN 'Medium'
            ELSE 'Low'
        END AS Category
    FROM  Orders
) AS t
GROUP BY Category
ORDER BY TotalSales DESC;

/* ==============================================================================
   USE CASE: MAPPING
===============================================================================*/

/* TASK 2: 
   Retrieve customer details with abbreviated country codes 
*/
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE 
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA'     THEN 'US'
        ELSE 'n/a'
    END AS CountryCode
FROM  Customers;

/* ==============================================================================
   QUICK FORM SYNTAX
===============================================================================*/

/* TASK 3: 
   Retrieve customer details with abbreviated country codes using quick form 
*/
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE 
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA'     THEN 'US'
        ELSE 'n/a'
    END AS Countrycountry,
    CASE Country
        WHEN 'Germany' THEN 'DE'
        WHEN 'USA'     THEN 'US'
        ELSE 'n/a'
    END AS Countrycountry_2
FROM  Customers;

/* ==============================================================================
   HANDLING NULLS
===============================================================================*/

/* TASK 4: 
   Calculate the average score of customers, treating NULL as 0,
   and provide CustomerID and LastName details.
*/
SELECT
    CustomerID,
    LastName,
    Score,
    CASE
        WHEN Score IS NULL THEN 0
        ELSE Score
    END AS ScoreClean,
    AVG(
        CASE
            WHEN Score IS NULL THEN 0
            ELSE Score
        END
    ) OVER () AS AvgCustomerClean,
    AVG(Score) OVER () AS AvgCustomer
FROM  Customers;

/* ==============================================================================
   CONDITIONAL AGGREGATION
===============================================================================*/

/* TASK 5: 
   Count how many orders each customer made with sales greater than 30 
*/
SELECT
    CustomerID,
    sales,
    CASE
            WHEN sales > 30 THEN 1
            ELSE 0
        end as grop_orrder,
    SUM(
        CASE
            WHEN sales > 30 THEN 1
            ELSE 0
        END
    ) AS TotalOrdersHighSales,
    COUNT(*) AS TotalOrders
FROM  Orders
GROUP BY CustomerID,grop_orrder,sales;


------------------
SELECT
    CustomerID,
    SUM(
        CASE
            WHEN sales > 30 THEN 1
            ELSE 0
        END
    ) AS TotalOrdersHighSales,
    COUNT(*) AS TotalOrders
FROM  Orders
GROUP BY CustomerID;

-------------------------
SELECT
    CASE
            WHEN sales > 30 THEN 1
            ELSE 0
        end as grop_orrder,
    SUM(
        CASE
            WHEN sales > 30 THEN 1
            ELSE 0
        END
    ) AS TotalOrdersHighSales,
    COUNT(*) AS TotalOrders
FROM  Orders
GROUP BY grop_orrder;
