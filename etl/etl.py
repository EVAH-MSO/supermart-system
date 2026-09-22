# etl.py — pulls orders from app DB into warehouse DB (PyMySQL)
import os
import pymysql
from pymysql.cursors import DictCursor
from datetime import datetime

def connect(prefix):
    return pymysql.connect(
        host=os.environ[f"{prefix}DB_HOST"],
        port=int(os.environ.get(f"{prefix}DB_PORT", 3307)),
        user=os.environ[f"{prefix}DB_USER"],
        password=os.environ[f"{prefix}DB_PASS"],
        database=os.environ[f"{prefix}DB_NAME"],
        cursorclass=DictCursor,
        connect_timeout=10,
        autocommit=False,
    )

def ensure_warehouse_tables(wh):
    cur = wh.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS fact_sales (
            order_id INT PRIMARY KEY,
            date_key INT,
            customer_id INT,
            product_id INT,
            store_id INT,
            quantity INT,
            total INT,
            loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS dim_customer (
            customer_id INT PRIMARY KEY,
            name VARCHAR(150),
            city VARCHAR(50)
        )
    """)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS dim_product (
            product_id INT PRIMARY KEY,
            name VARCHAR(150),
            category VARCHAR(50)
        )
    """)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS dim_store (
            store_id INT PRIMARY KEY,
            name VARCHAR(150),
            city VARCHAR(50),
            region VARCHAR(50)
        )
    """)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS dim_date (
            date_key INT PRIMARY KEY,
            full_date DATE,
            year INT,
            month INT,
            day INT
        )
    """)
    wh.commit()
    cur.close()

def etl():
    print(f"[{datetime.now()}] ETL starting")

    # EXTRACT
    app = connect("APP_")
    app_cur = app.cursor()
    app_cur.execute("""
        SELECT o.id, o.customer_id, o.product_id, o.quantity,
               o.total, o.store_id, o.created_at,
               c.name AS customer_name, c.city AS customer_city,
               p.name AS product_name, p.category AS product_category,
               s.name AS store_name, s.city AS store_city, s.region
        FROM orders o
        JOIN customers c ON o.customer_id = c.id
        JOIN products p ON o.product_id = p.id
        JOIN stores s ON o.store_id = s.id
    """)
    orders = app_cur.fetchall()
    print(f"  Extracted {len(orders)} orders")
    app_cur.close(); app.close()

    if not orders:
        print("  Nothing to load.")
        return

    # TRANSFORM
    for o in orders:
        d = o["created_at"]
        o["date_key"] = int(d.strftime("%Y%m%d"))
        o["year"] = d.year
        o["month"] = d.month
        o["day"] = d.day

    # LOAD
    wh = connect("WH_")
    ensure_warehouse_tables(wh)
    cur = wh.cursor()

    for o in orders:
        cur.execute("""
            INSERT INTO dim_customer (customer_id, name, city)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE name=VALUES(name), city=VALUES(city)
        """, (o["customer_id"], o["customer_name"], o["customer_city"]))

        cur.execute("""
            INSERT INTO dim_product (product_id, name, category)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE name=VALUES(name), category=VALUES(category)
        """, (o["product_id"], o["product_name"], o["product_category"]))

        cur.execute("""
            INSERT INTO dim_store (store_id, name, city, region)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE name=VALUES(name), city=VALUES(city), region=VALUES(region)
        """, (o["store_id"], o["store_name"], o["store_city"], o["region"]))

        cur.execute("""
            INSERT INTO dim_date (date_key, full_date, year, month, day)
            VALUES (%s, %s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE full_date=VALUES(full_date)
        """, (o["date_key"], o["created_at"].date(),
              o["year"], o["month"], o["day"]))

        cur.execute("""
            INSERT IGNORE INTO fact_sales
            (order_id, date_key, customer_id, product_id, store_id, quantity, total)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (o["id"], o["date_key"], o["customer_id"],
              o["product_id"], o["store_id"], o["quantity"], o["total"]))

    wh.commit()
    cur.close(); wh.close()
    print(f"  Loaded {len(orders)} rows into warehouse")
    print(f"[{datetime.now()}] ETL complete")

if __name__ == "__main__":
    etl()