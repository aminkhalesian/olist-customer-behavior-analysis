-- Query: Order Status Distribution
-- Description: Count and percentage of each order status

SELECT 
    order_status,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM olist_orders_dataset), 2) AS percentage
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;
