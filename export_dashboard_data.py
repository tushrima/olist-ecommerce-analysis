"""Export validated SQL query outputs as Power BI-ready CSV tables.

Usage: python export_dashboard_data.py --db olist.db --out-dir dashboard/data
"""
import argparse
import csv
from pathlib import Path
import sqlite3

QUERIES = {
    "revenue_by_category": "02_revenue_by_category.sql",
    "delivery_vs_reviews": "03_delivery_vs_reviews.sql",
    "delivery_by_state": "04_delivery_by_state.sql",
    "monthly_performance": "05_monthly_performance.sql",
}


def main():
    parser = argparse.ArgumentParser(description="Export Olist dashboard tables.")
    parser.add_argument("--db", type=Path, default=Path("olist.db"))
    parser.add_argument("--out-dir", type=Path, default=Path("dashboard/data"))
    args = parser.parse_args()

    if not args.db.is_file():
        parser.error("Database not found: {}. Run load_data.py first.".format(args.db))

    sql_dir = Path(__file__).resolve().parent / "sql"
    args.out_dir.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(args.db) as connection:
        for name, filename in QUERIES.items():
            query = (sql_dir / filename).read_text(encoding="utf-8")
            try:
                cursor = connection.execute(query)
                columns = [item[0] for item in cursor.description]
                output = args.out_dir / (name + ".csv")
                with output.open("w", newline="", encoding="utf-8") as handle:
                    writer = csv.writer(handle)
                    writer.writerow(columns)
                    rows = 0
                    for row in cursor:
                        writer.writerow(row)
                        rows += 1
                print("{}: {} rows -> {}".format(name, rows, output))
            except sqlite3.Error as error:
                parser.exit(1, "Query {} failed: {}\n".format(filename, error))


if __name__ == "__main__":
    main()
