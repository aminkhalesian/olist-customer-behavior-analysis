-- Query: Average First Order Value by State
-- Description: Average first order value grouped by state

WITH first_orders AS (
    SELECT 
        c.customer_unique_id,
        c.customer_state,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        o.order_id AS first_order_id
    FROM olist_customers_dataset c
    INNER JOIN olist_orders_dataset o 
        ON c.customer_id = o.customer_id
        AND o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state
),

first_order_value AS (
    SELECT 
        f.customer_unique_id,
        f.customer_state,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS first_order_value
    FROM first_orders f
    INNER JOIN olist_order_items_dataset oi 
        ON f.first_order_id = oi.order_id
    GROUP BY f.customer_unique_id, f.customer_state
)

SELECT 
    customer_state,
    COUNT(*) AS customer_count,
    ROUND(AVG(first_order_value), 2) AS avg_first_order_value,
    ROUND(MIN(first_order_value), 2) AS min_first_order_value,
    ROUND(MAX(first_order_value), 2) AS max_first_order_value
FROM first_order_value
GROUP BY customer_state
HAVING customer_count >= 100
ORDER BY avg_first_order_value DESC;
