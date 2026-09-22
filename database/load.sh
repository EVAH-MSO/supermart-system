#!/bin/bash
# load.sh — Loads schema + seed data into the filess.io app database.

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$DIR/../.env.local"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env.local not found at $ENV_FILE"
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

echo "→ Connecting to $APP_DB_HOST:$APP_DB_PORT as $APP_DB_USER → $APP_DB_NAME"

# Base command
BASE_CMD="mysql -h $APP_DB_HOST -P $APP_DB_PORT -u $APP_DB_USER -p$APP_DB_PASS"

# Try SSL REQUIRED first, fall back to DISABLED
if ! $BASE_CMD --ssl-mode=REQUIRED -e "SELECT 1" > /dev/null 2>&1; then
  echo "→ SSL required failed, using DISABLED"
  BASE_CMD="$BASE_CMD --ssl-mode=DISABLED"
else
  BASE_CMD="$BASE_CMD --ssl-mode=REQUIRED"
fi

echo "→ Loading schema..."
$BASE_CMD "$APP_DB_NAME" < "$DIR/app_schema.sql"

echo "→ Loading seed data..."
$BASE_CMD "$APP_DB_NAME" < "$DIR/app_seed.sql"

echo "→ Verifying..."
$BASE_CMD "$APP_DB_NAME" -e "SELECT COUNT(*) AS products FROM products;"
$BASE_CMD "$APP_DB_NAME" -e "SELECT COUNT(*) AS stores FROM stores;"
$BASE_CMD "$APP_DB_NAME" -e "SELECT COUNT(*) AS customers FROM customers;"

echo "✅ Done."
