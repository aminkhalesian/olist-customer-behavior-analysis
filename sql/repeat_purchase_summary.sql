-- Query: Repeat Purchase Summary
-- Description: Average orders per customer + percentage of one-time buyers

WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM olist_customers_dataset c
    LEFT JOIN olist_orders_dataset o 
        ON c.customer_id = o.customer_id
        AND o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)

SELECT 
    AVG(order_count) AS avg_orders_per_customer,
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END) AS one_time_buyers,
    ROUND(100.0 * SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_one_time_buyers,
    COUNT(*) AS total_unique_customers
FROM customer_orders;
