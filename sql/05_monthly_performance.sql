-- Monthly delivered-order volume and product revenue (excluding freight).
-- Join item-level revenue to a single row per order before monthly aggregation.
WITH order_revenue AS (
    SELECT order_id, SUM(price) AS product_revenue_brl
    FROM order_items
    GROUP BY order_id
)
SELECT
    substr(o.order_purchase_timestamp, 1, 7) AS order_month,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(COALESCE(r.product_revenue_brl, 0)), 2) AS product_revenue_brl
FROM orders AS o
LEFT JOIN order_revenue AS r ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY order_month
ORDER BY order_month;
