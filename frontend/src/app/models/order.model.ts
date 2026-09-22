// Order — a purchase event
export interface Order {
  customer_id: number;
  product_id: number;
  quantity: number;
  total: number;
  store_id: number;
}
