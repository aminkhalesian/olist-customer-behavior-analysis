-- Query: Monthly Order Trend
-- Description: Number of orders by month and year

SELECT 
    strftime('%Y-%m', order_purchase_timestamp) AS purchase_month,
    COUNT(*) AS order_count
FROM olist_orders_dataset
GROUP BY purchase_month
ORDER BY purchase_month;
