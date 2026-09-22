# dashboard.py — SuperMart analytics dashboard
# Reads from the warehouse database.
# Run: streamlit run dashboard.py

import streamlit as st
import pandas as pd
import pymysql
from pymysql.cursors import DictCursor
import os

st.set_page_config(
    page_title="SuperMart Analytics",
    page_icon="🛒",
    layout="wide",
)

# ---------- DB connection ----------
@st.cache_resource(ttl=30)
def get_conn():
    return pymysql.connect(
        host=os.environ["WH_DB_HOST"],
        port=int(os.environ.get("WH_DB_PORT", 3307)),
        user=os.environ["WH_DB_USER"],
        password=os.environ["WH_DB_PASS"],
        database=os.environ["WH_DB_NAME"],
        cursorclass=DictCursor,
        connect_timeout=10,
    )

# ---------- Query helper ----------
def q(sql):
    conn = get_conn()
    try:
        cur = conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        cur.close()
        return pd.DataFrame(rows)
    except Exception:
        # Stale connection — reconnect once
        try:
            conn.close()
        except Exception:
            pass
        st.cache_resource.clear()
        conn = get_conn()
        cur = conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        cur.close()
        return pd.DataFrame(rows)

# ---------- Custom CSS ----------
st.markdown("""
<style>
    .main-title {
        font-size: 2.2rem; font-weight: 800;
        color: #046A38; margin-bottom: 0;
    }
    .subtitle { color: #6b7280; margin-bottom: 24px; }
    .kpi {
        background: linear-gradient(135deg, #00A86B, #007A4D);
        color: white; padding: 20px; border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,.08);
    }
    .kpi-label { font-size: .8rem; opacity: .9; }
    .kpi-value { font-size: 1.8rem; font-weight: 700; margin-top: 4px; }
</style>
""", unsafe_allow_html=True)

st.markdown('<p class="main-title">🛒 SuperMart Analytics</p>', unsafe_allow_html=True)
st.markdown('<p class="subtitle">Live data from the warehouse · powered by the ETL pipeline</p>', unsafe_allow_html=True)

# ---------- KPI cards ----------
try:
    rev  = q("SELECT COALESCE(SUM(total),0) AS v FROM fact_sales")["v"][0]
    txn  = q("SELECT COUNT(*) AS v FROM fact_sales")["v"][0]
    cust = q("SELECT COUNT(DISTINCT customer_id) AS v FROM fact_sales")["v"][0]
    prod = q("SELECT COUNT(*) AS v FROM dim_product")["v"][0]

    c1, c2, c3, c4 = st.columns(4)
    for col, label, value in [
        (c1, "Total Revenue", f"KSh {rev:,.0f}"),
        (c2, "Transactions", f"{txn:,}"),
        (c3, "Customers", f"{cust:,}"),
        (c4, "Products", f"{prod:,}"),
    ]:
        col.markdown(f"""
        <div class="kpi">
            <div class="kpi-label">{label}</div>
            <div class="kpi-value">{value}</div>
        </div>
        """, unsafe_allow_html=True)
except Exception as e:
    st.error(f"Could not load KPIs: {e}")

st.divider()

# ---------- Revenue by region ----------
st.subheader("Revenue by Region")
try:
    df = q("""
        SELECT s.region, SUM(f.total) AS revenue
        FROM fact_sales f
        JOIN dim_store s ON f.store_id = s.store_id
        GROUP BY s.region
        ORDER BY revenue DESC
    """)
    if not df.empty:
        st.bar_chart(df.set_index("region"))
    else:
        st.info("No data yet. Place some orders first.")
except Exception as e:
    st.error(f"Query failed: {e}")

# ---------- Two columns ----------
col_a, col_b = st.columns(2)

with col_a:
    st.subheader("Revenue by Category")
    try:
        df = q("""
            SELECT p.category, SUM(f.total) AS revenue
            FROM fact_sales f
            JOIN dim_product p ON f.product_id = p.product_id
            GROUP BY p.category
            ORDER BY revenue DESC
        """)
        if not df.empty:
            st.bar_chart(df.set_index("category"))
    except Exception as e:
        st.error(f"Query failed: {e}")

with col_b:
    st.subheader("Top 10 Products")
    try:
        df = q("""
            SELECT p.name, SUM(f.total) AS revenue
            FROM fact_sales f
            JOIN dim_product p ON f.product_id = p.product_id
            GROUP BY p.name
            ORDER BY revenue DESC
            LIMIT 10
        """)
        if not df.empty:
            st.dataframe(df, width='stretch', hide_index=True)
    except Exception as e:
        st.error(f"Query failed: {e}")

# ---------- Recent orders ----------
st.subheader("Recent Orders")
try:
    df = q("""
        SELECT f.order_id, c.name AS customer, p.name AS product,
               s.name AS store, f.quantity, f.total, d.full_date
        FROM fact_sales f
        JOIN dim_customer c ON f.customer_id = c.customer_id
        JOIN dim_product  p ON f.product_id  = p.product_id
        JOIN dim_store    s ON f.store_id    = s.store_id
        JOIN dim_date     d ON f.date_key    = d.date_key
        ORDER BY f.order_id DESC
        LIMIT 20
    """)
    if not df.empty:
        st.dataframe(df, width='stretch', hide_index=True)
    else:
        st.info("No orders yet.")
except Exception as e:
    st.error(f"Query failed: {e}")

st.divider()
st.caption("Built with Python · Streamlit · PyMySQL · powered by a nightly ETL pipeline")