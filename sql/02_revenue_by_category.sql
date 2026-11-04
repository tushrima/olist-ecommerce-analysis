-- Product revenue is the sum of item prices, excluding freight.
-- An order may contain items in multiple categories; category order counts
-- therefore should not be added together to calculate total unique orders.
SELECT
    COALESCE(t.product_category_name_english,
             p.product_category_name,
             'unknown') AS category,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS distinct_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue_brl,
    ROUND(AVG(oi.price), 2) AS avg_item_price_brl
FROM order_items AS oi
JOIN orders AS o ON o.order_id = oi.order_id
JOIN products AS p ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation AS t
    ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY product_revenue_brl DESC;
