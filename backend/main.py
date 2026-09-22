# main.py — SuperMart backend (PyMySQL)
from fastapi import FastAPI, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from jose import jwt, JWTError
from datetime import datetime, timedelta
import pymysql
from pymysql.cursors import DictCursor
import bcrypt
import os

app = FastAPI(title="SuperMart API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

SECRET_KEY = os.environ.get("JWT_SECRET", "change-this-in-production-please")
ALGO = "HS256"
TOKEN_HOURS = 24

# ---------- Password helpers ----------
def hash_password(p: str) -> str:
    return bcrypt.hashpw(p.encode("utf-8")[:72], bcrypt.gensalt()).decode("utf-8")

def verify_password(p: str, hashed: str) -> bool:
    try:
        return bcrypt.checkpw(p.encode("utf-8")[:72], hashed.encode("utf-8"))
    except Exception:
        return False

# ---------- DB ----------
def db():
    return pymysql.connect(
        host=os.environ["DB_HOST"],
        port=int(os.environ.get("DB_PORT", 3307)),
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASS"],
        database=os.environ["DB_NAME"],
        cursorclass=DictCursor,
        connect_timeout=10,
        autocommit=False,
    )

# ---------- Auth helpers ----------
def create_token(user_id: int, email: str):
    exp = datetime.utcnow() + timedelta(hours=TOKEN_HOURS)
    return jwt.encode({"sub": str(user_id), "email": email, "exp": exp},
                      SECRET_KEY, algorithm=ALGO)

def decode_token(token: str):
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=[ALGO])
    except JWTError:
        return None

def current_user(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(401, "Not authenticated")
    token = authorization.split(" ", 1)[1]
    payload = decode_token(token)
    if not payload:
        raise HTTPException(401, "Invalid token")
    return payload

# ---------- Models ----------
class UserIn(BaseModel):
    email: str
    password: str

class Customer(BaseModel):
    name: str
    city: str

class Order(BaseModel):
    product_id: int
    quantity: int
    total: int
    store_id: int

# ---------- Auth ----------
@app.post("/api/auth/signup", status_code=201)
def signup(u: UserIn):
    if len(u.password) < 6:
        raise HTTPException(400, "Password must be at least 6 characters")
    conn = db()
    cur = conn.cursor()
    cur.execute("SELECT id FROM users WHERE email=%s", (u.email,))
    if cur.fetchone():
        cur.close(); conn.close()
        raise HTTPException(400, "Email already registered")

    hashed = hash_password(u.password)
    cur.execute("INSERT INTO users (email, password_hash) VALUES (%s, %s)",
                (u.email, hashed))
    conn.commit()
    user_id = cur.lastrowid

    # Create customer row
    cur.execute("INSERT INTO customers (name, city) VALUES (%s, %s)",
                (u.email, "Nairobi"))
    conn.commit()
    customer_id = cur.lastrowid

    # Link user -> customer
    cur.execute("UPDATE users SET customer_id=%s WHERE id=%s",
                (customer_id, user_id))
    conn.commit()

    cur.close(); conn.close()
    token = create_token(user_id, u.email)
    return {"token": token, "email": u.email, "customer_id": customer_id}

@app.post("/api/auth/login")
def login(u: UserIn):
    conn = db()
    cur = conn.cursor()
    cur.execute("SELECT id, email, password_hash FROM users WHERE email=%s", (u.email,))
    user = cur.fetchone()
    cur.close(); conn.close()
    if not user or not verify_password(u.password, user["password_hash"]):
        raise HTTPException(401, "Invalid email or password")
    token = create_token(user["id"], user["email"])
    return {"token": token, "email": user["email"]}

@app.get("/api/auth/me")
def me(authorization: str = Header(None)):
    user = current_user(authorization)
    return {"user_id": user["sub"], "email": user["email"]}

# ---------- Health ----------
@app.get("/api/health")
def health():
    return {"status": "ok"}

# ---------- Products ----------
@app.get("/api/products")
def get_products():
    conn = db(); cur = conn.cursor()
    cur.execute("SELECT id, name, category, price, image_url FROM products ORDER BY id")
    rows = cur.fetchall()
    cur.close(); conn.close()
    return rows

@app.get("/api/stores")
def get_stores():
    conn = db(); cur = conn.cursor()
    cur.execute("SELECT id, name, city, region FROM stores ORDER BY id")
    rows = cur.fetchall()
    cur.close(); conn.close()
    return rows

@app.get("/api/customers")
def get_customers():
    conn = db(); cur = conn.cursor()
    cur.execute("SELECT id, name, city FROM customers ORDER BY id")
    rows = cur.fetchall()
    cur.close(); conn.close()
    return rows

@app.post("/api/customers", status_code=201)
def add_customer(c: Customer):
    conn = db(); cur = conn.cursor()
    cur.execute("INSERT INTO customers (name, city) VALUES (%s, %s)",
                (c.name, c.city))
    conn.commit()
    cur.close(); conn.close()
    return {"status": "created"}

# ---------- Orders ----------
@app.post("/api/orders", status_code=201)
def add_order(o: Order, authorization: str = Header(None)):
    user = current_user(authorization)
    user_id = int(user["sub"])

    conn = db(); cur = conn.cursor()
    cur.execute("SELECT customer_id FROM users WHERE id=%s", (user_id,))
    row = cur.fetchone()
    if not row or not row["customer_id"]:
        cur.close(); conn.close()
        raise HTTPException(400, "User has no linked customer")

    customer_id = row["customer_id"]

    cur.execute(
        "INSERT INTO orders (customer_id, product_id, quantity, total, store_id) "
        "VALUES (%s, %s, %s, %s, %s)",
        (customer_id, o.product_id, o.quantity, o.total, o.store_id)
    )
    conn.commit()
    cur.close(); conn.close()
    return {"status": "created"}

@app.get("/api/orders")
def get_orders(authorization: str = Header(None)):
    user = current_user(authorization)
    user_id = int(user["sub"])

    conn = db(); cur = conn.cursor()
    cur.execute("SELECT customer_id FROM users WHERE id=%s", (user_id,))
    row = cur.fetchone()
    if not row or not row["customer_id"]:
        cur.close(); conn.close()
        return []

    customer_id = row["customer_id"]

    cur.execute("""
        SELECT o.id, o.quantity, o.total, o.created_at,
               p.name AS product_name,
               s.name AS store_name
        FROM orders o
        JOIN products p ON o.product_id = p.id
        JOIN stores s ON o.store_id = s.id
        WHERE o.customer_id = %s
        ORDER BY o.id DESC
        LIMIT 100
    """, (customer_id,))
    rows = cur.fetchall()
    cur.close(); conn.close()
    for r in rows:
        if r.get("created_at"):
            r["created_at"] = str(r["created_at"])
    return rows

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
