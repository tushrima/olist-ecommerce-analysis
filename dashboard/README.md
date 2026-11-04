# Olist Power BI Dashboard

This guide describes a four-table **import-mode** Power BI report built from the project's SQLite analysis. It is a dashboard specification, not an existing `.pbix` file. Actual visuals and numbers require downloading the original Olist data and running the queries.

## 1. Prepare the data

From the repository root, after downloading the Olist CSVs into `data/`:

```bash
python -m pip install pandas
python load_data.py --data-dir data --db olist.db
python export_dashboard_data.py --db olist.db --out-dir dashboard/data
```

This produces:

| CSV | Grain | Useful fields |
| --- | --- | --- |
| `monthly_performance.csv` | One month | `order_month`, `delivered_orders`, `product_revenue_brl` |
| `revenue_by_category.csv` | One product category | `category`, `distinct_orders`, `items_sold`, `product_revenue_brl` |
| `delivery_by_state.csv` | One customer state | `customer_state`, `delivered_orders`, `late_orders`, `late_delivery_pct` |
| `delivery_vs_reviews.csv` | One delivery-delay group | `delivery_status`, `reviewed_orders`, `avg_review_score` |

The four CSVs are aggregated **independently**. Do not create relationships between them: combining them would incorrectly multiply counts or suggest unsupported cross-filtering.

## 2. Import into Power BI Desktop

1. Select **Get data → Text/CSV** and import all four exported files.
2. In Power Query, set revenue and review metrics to **Decimal Number**, counts to **Whole Number**, and labels to **Text**.
3. In `monthly_performance`, add a date column from the `order_month` text (format `YYYY-MM`) using **Add Column → Custom Column**:

   ```powerquery
   Date.FromText([order_month] & "-01")
   ```

4. Set the new column's type to **Date**, and sort the report's monthly visuals chronologically.
5. Leave the four tables disconnected. Use separate page-level or visual-level filters for each table.

## 3. Recommended report pages

### Page 1 — Sales overview

- **KPI card:** Total product revenue (BRL), from `monthly_performance`.
- **KPI card:** Delivered orders, from `monthly_performance`.
- **Line chart:** `order_month` date vs. product revenue.
- **Horizontal bar chart:** Category vs. product revenue, sorted descending.
- **Table:** Category, items sold, distinct orders, product revenue, average item price.

### Page 2 — Delivery performance

- **KPI card:** Overall late-delivery rate (weighted by delivered-order counts).
- **Bar chart:** Customer state vs. late-delivery percentage.
- **Scatter plot:** Delivered orders vs. late-delivery percentage, labeled by state.
- **Table:** State, delivered orders, late orders, average days vs. estimate, average days late when late.

For comparisons, consider excluding very-low-volume states with a clearly labeled minimum-order filter; don't silently remove them.

### Page 3 — Customer satisfaction

- **Column chart:** Delivery status vs. average review score.
- **Table:** Delivery status, reviewed orders, average review score.
- **Text note:** Correlation is descriptive, not proof that delays caused lower scores.

## 4. Example DAX measures

Create these measures in the indicated table:

```dax
-- In monthly_performance
Total Product Revenue = SUM(monthly_performance[product_revenue_brl])

Delivered Orders = SUM(monthly_performance[delivered_orders])

-- In delivery_by_state
Late Orders = SUM(delivery_by_state[late_orders])

Delivered Orders (States) = SUM(delivery_by_state[delivered_orders])

Late Delivery Rate = DIVIDE([Late Orders], [Delivered Orders (States)])

-- In delivery_vs_reviews
Weighted Average Review Score =
DIVIDE(
    SUMX(
        delivery_vs_reviews,
        delivery_vs_reviews[reviewed_orders] *
        delivery_vs_reviews[avg_review_score]
    ),
    SUM(delivery_vs_reviews[reviewed_orders])
)
```

Format `Late Delivery Rate` as a percentage; the SQL `late_delivery_pct` column already stores a 0–100 value, so **do not format that column directly as a percentage** without dividing by 100.

The weighted review-score measure uses pre-rounded SQL averages, so it is approximate. For exact results, calculate from unrounded order-level data.

## 5. Validation checks

- Confirm the sum of monthly delivered orders equals the sum of state-level delivered orders when both use the same order population and date completeness criteria.
- Confirm the total category revenue is close to the monthly product revenue total; differences may arise from products missing category information or unmatched product records. Investigate rather than assume equality.
- Check the date range and document any partial months.
- Compare counts and average scores with SQL outputs before sharing screenshots.

## 6. What is not included yet

A Power BI `.pbix` report, published dashboard, and screenshots have not been generated. Power BI Desktop is required to assemble and save the report. The repository excludes generated CSVs and the SQLite database.
