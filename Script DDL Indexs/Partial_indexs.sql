CREATE INDEX idx_orders_pending_date
ON orders (order_date)
WHERE status = 'pending';