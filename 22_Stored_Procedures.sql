/* =============================================================================
   PostgreSQL Stored Function Demo
   This script demonstrates:
   1. Basic Function
   2. Parameters
   3. Multiple Queries
   4. Variables
   5. IF / ELSE Control Flow
   6. Error Handling with EXCEPTION
============================================================================= */

-- =============================================================================
-- 1️⃣ Create Function with Parameter
-- =============================================================================

CREATE OR REPLACE FUNCTION get_customer_summary(p_country TEXT DEFAULT 'USA')
RETURNS VOID
AS $$
DECLARE
    v_total_customers BIGINT;
    v_avg_score NUMERIC;
    v_total_orders BIGINT;
    v_total_sales NUMERIC;
BEGIN

    /* -------------------------------------------------------------------------
       Data Preparation (IF / ELSE)
    ------------------------------------------------------------------------- */
    IF EXISTS (
        SELECT 1
        FROM sales.customers
        WHERE score IS NULL
        AND country = p_country
    ) THEN
        RAISE NOTICE 'Updating NULL scores to 0';
        
        UPDATE sales.customers
        SET score = 0
        WHERE score IS NULL
        AND country = p_country;
    ELSE
        RAISE NOTICE 'No NULL scores found';
    END IF;

    /* -------------------------------------------------------------------------
       Query 1: Customer Summary
    ------------------------------------------------------------------------- */
    SELECT
        COUNT(*),
        AVG(score)
    INTO v_total_customers, v_avg_score
    FROM sales.customers
    WHERE country = p_country;

    RAISE NOTICE 'Total Customers from %: %',
        p_country, v_total_customers;

    RAISE NOTICE 'Average Score from %: %',
        p_country, v_avg_score;

    /* -------------------------------------------------------------------------
       Query 2: Orders Summary
    ------------------------------------------------------------------------- */
    SELECT
        COUNT(o.orderid),
        SUM(o.sales)
    INTO v_total_orders, v_total_sales
    FROM sales.orders o
    JOIN sales.customers c
        ON c.customerid = o.customerid
    WHERE c.country = p_country;

    RAISE NOTICE 'Total Orders from %: %',
        p_country, v_total_orders;

    RAISE NOTICE 'Total Sales from %: %',
        p_country, v_total_sales;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred.';
        RAISE NOTICE 'Error Message: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


-- =============================================================================
-- Execute Function
-- =============================================================================

SELECT get_customer_summary('Germany');
SELECT get_customer_summary('USA');
SELECT get_customer_summary();  -- Default value = 'USA'
