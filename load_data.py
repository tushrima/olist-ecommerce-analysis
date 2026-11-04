"""Load the Olist CSV datasets into a local SQLite database.

Usage:
    python load_data.py --data-dir data --db olist.db
"""
import argparse
from pathlib import Path
import sqlite3

import pandas as pd

TABLE_FILES = {
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "products": "olist_products_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "order_reviews": "olist_order_reviews_dataset.csv",
    "product_category_name_translation": "product_category_name_translation.csv",
}


def main():
    parser = argparse.ArgumentParser(description="Load Olist CSV files into SQLite.")
    parser.add_argument("--data-dir", type=Path, default=Path("data"),
                        help="Directory containing the original Olist CSV files")
    parser.add_argument("--db", type=Path, default=Path("olist.db"),
                        help="SQLite output path")
    args = parser.parse_args()

    missing = [filename for filename in TABLE_FILES.values()
               if not (args.data_dir / filename).is_file()]
    if missing:
        parser.error("Missing required CSV files in {}: {}".format(
            args.data_dir, ", ".join(missing)))

    args.db.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(args.db) as conn:
        for table, filename in TABLE_FILES.items():
            data = pd.read_csv(args.data_dir / filename)
            data.to_sql(table, conn, if_exists="replace", index=False)
            print("Loaded {}: {:,} rows".format(table, len(data)))

    print("SQLite database ready: {}".format(args.db))


if __name__ == "__main__":
    main()
