/* ==============================================================================
   SQL Views
-------------------------------------------------------------------------------
   This script demonstrates various view use cases in SQL Server.
   It includes examples for creating, dropping, and modifying views, hiding
   query complexity, and implementing data security by controlling data access.

   Table of Contents:
     1. Create, Drop, Modify View
     2. USE CASE - HIDE COMPLEXITY
     3. USE CASE - DATA SECURITY
===============================================================================
*/

/* ==============================================================================
   CREATE, DROP, MODIFY VIEW
===============================================================================*/

/* TASK:
   Create a view that summarizes monthly sales by aggregating:
     - OrderMonth (truncated to month)
     - TotalSales, TotalOrders, and TotalQuantities.
*/

-- Create View
CREATE VIEW    V_Monthly_Summary AS
(
    SELECT 
        DATE_TRUNC('month', OrderDate) AS OrderMonth,
        SUM(Sales) AS TotalSales,
        COUNT(OrderID) AS TotalOrders,
        SUM(Quantity) AS TotalQuantities
    FROM    Orders
    GROUP BY DATE_TRUNC('month', OrderDate)
);


-- Query the View
SELECT * FROM    V_Monthly_Summary;

-- Drop View if it exists
DROP VIEW if exists   V_Monthly_Summary;


-- Re-create the view with modified logic
CREATE VIEW    V_Monthly_Summary AS
SELECT 
    DATETRUNC(month, OrderDate) AS OrderMonth,
    SUM(Sales) AS TotalSales,
    COUNT(OrderID) AS TotalOrders
FROM    Orders
GROUP BY DATETRUNC(month, OrderDate);

DROP VIEW if exists   V_Monthly_Summary;
/* ==============================================================================
   VIEW USE CASE | HIDE COMPLEXITY
===============================================================================*/

/* TASK:
   Create a view that combines details from Orders, Product, Customers, and Employees.
   This view abstracts the complexity of multiple table joins.
*/
CREATE VIEW    V_Order_Details AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') || ' ' || COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') || ' ' || COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM    Orders AS o
    LEFT JOIN    Product AS p ON p.ProductID = o.ProductID
    LEFT JOIN    Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN    Employees AS e ON e.EmployeeID = o.SalesPersonID
);


DROP VIEW if exists   V_Order_Details;

/* ==============================================================================
   VIEW USE CASE | DATA SECURITY
===============================================================================*/

/* TASK:
   Create a view for the EU Sales Team that combines details from all tables,
   but excludes data related to the USA.
*/
CREATE VIEW    V_Order_Details_EU AS
(
    SELECT 
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Category,
        COALESCE(c.FirstName, '') || ' ' || COALESCE(c.LastName, '') AS CustomerName,
        c.Country AS CustomerCountry,
        COALESCE(e.FirstName, '') || ' '|| COALESCE(e.LastName, '') AS SalesName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM    Orders AS o
    LEFT JOIN    Product AS p ON p.ProductID = o.ProductID
    LEFT JOIN    Customers AS c ON c.CustomerID = o.CustomerID
    LEFT JOIN    Employees AS e ON e.EmployeeID = o.SalesPersonID
    WHERE c.Country != 'USA'
);
DROP VIEW if exists   V_Order_Details_EU;
