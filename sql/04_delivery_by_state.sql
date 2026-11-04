-- Delivery performance by customer state, for delivered orders only.
-- Positive delay means delivery after the estimated date.
WITH delivered AS (
    SELECT
        o.order_id,
        c.customer_state,
        julianday(o.order_delivered_customer_date)
          - julianday(o.order_estimated_delivery_date) AS delay_days
    FROM orders AS o
    JOIN customers AS c ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    customer_state,
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END)
          / COUNT(*), 2) AS late_delivery_pct,
    ROUND(AVG(delay_days), 2) AS avg_days_vs_estimate,
    ROUND(AVG(CASE WHEN delay_days > 0 THEN delay_days END), 2)
        AS avg_days_late_when_late
FROM delivered
GROUP BY customer_state
ORDER BY late_delivery_pct DESC, delivered_orders DESC;
