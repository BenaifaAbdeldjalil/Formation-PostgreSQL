
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
        Sales

    FROM  Orders
    


SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High'
            WHEN Sales > 20 THEN 'Medium'
            ELSE 'Low'
        END AS Category
    FROM  Orders
    
/* ==============================================================================
   USE CASE: MAPPING
===============================================================================*/

/* TASK: 
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
   CONDITIONAL AGGREGATION
===============================================================================*/

/* TASK: 
   Count how many orders each customer made with sales greater than 30 
*/
SELECT
    CustomerID,
    sales,
    CASE
            WHEN sales > 30 THEN 1
            ELSE 0
        end as grop_orrder
    
FROM  Orders
;


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

