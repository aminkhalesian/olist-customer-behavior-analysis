-- Query: First Order Value Buckets
-- Description: Distribution of first order value in buckets

WITH first_orders AS (
    SELECT 
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        o.order_id AS first_order_id
    FROM olist_customers_dataset c
    INNER JOIN olist_orders_dataset o 
        ON c.customer_id = o.customer_id
        AND o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),

first_order_value AS (
    SELECT 
        f.customer_unique_id,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS first_order_value
    FROM first_orders f
    INNER JOIN olist_order_items_dataset oi 
        ON f.first_order_id = oi.order_id
    GROUP BY f.customer_unique_id
)

SELECT 
    CASE 
        WHEN first_order_value <= 50   THEN '0-50'
        WHEN first_order_value <= 100  THEN '51-100'
        WHEN first_order_value <= 150  THEN '101-150'
        WHEN first_order_value <= 200  THEN '151-200'
        WHEN first_order_value <= 300  THEN '201-300'
        WHEN first_order_value <= 500  THEN '301-500'
        ELSE '>500'
    END AS value_bucket,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM first_order_value), 2) AS percentage,
    ROUND(AVG(first_order_value), 2) AS avg_value_in_bucket
FROM first_order_value
GROUP BY value_bucket
ORDER BY 
    CASE value_bucket
        WHEN '0-50'     THEN 1
        WHEN '51-100'   THEN 2
        WHEN '101-150'  THEN 3
        WHEN '151-200'  THEN 4
        WHEN '201-300'  THEN 5
        WHEN '301-500'  THEN 6
        ELSE 7
    END;
