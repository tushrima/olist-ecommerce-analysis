import sqlite3
import pandas as pd
import glob

conn = sqlite3.connect("olist.db")

for filepath in glob.glob("*.csv"):
    table_name = filepath.replace("olist_", "").replace("_dataset.csv", "").replace(".csv", "")
    df = pd.read_csv(filepath)
    df.to_sql(table_name, conn, if_exists="replace", index=False)
    print(f"Loaded {table_name}: {len(df)} rows")

conn.close()
