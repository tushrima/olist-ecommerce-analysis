# Olist E-Commerce Business Analysis

Business analytics project exploring product sales, delivery performance, and customer satisfaction using the [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

## Questions

1. Which product categories generate the most product revenue and order volume?
2. How do delivery delays relate to customer review scores?
3. Which customer states have the highest late-delivery rates?

## Setup

Install Python 3 and pandas:

```bash
python -m pip install pandas
```

Download the Olist dataset from Kaggle and place these original CSV files in `data/`:

- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_products_dataset.csv`
- `olist_customers_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `product_category_name_translation.csv`

Then build the SQLite database from the repository root:

```bash
python load_data.py --data-dir data --db olist.db
```

The loader checks that all six inputs exist before replacing tables. The downloaded data and generated database are intentionally excluded from version control.

## Run the analyses

Use any SQLite client, or run the queries with the SQLite command-line utility:

```bash
sqlite3 -header -csv olist.db < sql/02_revenue_by_category.sql > revenue_by_category.csv
sqlite3 -header -csv olist.db < sql/03_delivery_vs_reviews.sql > delivery_vs_reviews.csv
sqlite3 -header -csv olist.db < sql/04_delivery_by_state.sql > delivery_by_state.csv
```

The generated CSV outputs are ignored by Git.

| Query | Output |
| --- | --- |
| `sql/02_revenue_by_category.sql` | Revenue, items, and distinct orders by product category |
| `sql/03_delivery_vs_reviews.sql` | Average review score by delivery-delay group |
| `sql/04_delivery_by_state.sql` | Late-delivery rate and delay metrics by customer state |

## Metric definitions

- **Product revenue (BRL):** Sum of item `price`, excluding freight, for delivered orders.
- **Items sold:** Count of order-item rows for delivered orders.
- **Distinct orders by category:** Unique delivered order IDs containing that category. One order can contribute to several categories.
- **Late delivery:** Actual customer delivery timestamp after the estimated delivery timestamp.
- **Late-delivery rate:** Late delivered orders divided by delivered orders with both dates present.
- **Review score:** Average of available reviews per order, then averaged across orders in each delay group.

These definitions describe the current queries; other definitions (such as gross merchandise value including shipping) may produce different totals.

## Findings

See [report.md](report.md) for preliminary results. The figures in that report were produced before this pipeline cleanup and **have not yet been revalidated** using the revised queries. Re-run the SQL against the downloaded dataset before citing them as final results.

## Limitations

The data is historical, not live. The analysis is descriptive: delivery delay and review score association does not by itself establish causation. A dashboard and validated business recommendations are planned but not included yet.

## Development

AI assistance was used to help structure and debug the analysis. Queries and outputs should be checked against the original dataset before publication.
