-- Aggregate reviews to one record per order to avoid duplicate join rows.
WITH review_per_order AS (
    SELECT order_id, AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
),
delivered AS (
    SELECT
        o.order_id,
        julianday(o.order_delivered_customer_date)
          - julianday(o.order_estimated_delivery_date) AS delay_days
    FROM orders AS o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    CASE
        WHEN d.delay_days <= 0 THEN 'On time or early'
        WHEN d.delay_days <= 3 THEN '1-3 days late'
        ELSE 'More than 3 days late'
    END AS delivery_status,
    COUNT(*) AS reviewed_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM delivered AS d
JOIN review_per_order AS r ON r.order_id = d.order_id
GROUP BY delivery_status
ORDER BY CASE delivery_status
    WHEN 'On time or early' THEN 1
    WHEN '1-3 days late' THEN 2
    ELSE 3 END;
