CREATE INDEX idx_orders_cust_date
ON orders (customer_id, order_date DESC);

CREATE INDEX idx_orders_status_date
ON orders (status, order_date);

CREATE INDEX idx_items_order_product
ON order_items (order_id, product_id);

CREATE INDEX idx_orders_pending_date
ON orders (order_date)
WHERE status = 'pending';