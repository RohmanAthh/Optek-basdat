CREATE INDEX idx_items_order_product
ON order_items (order_id, product_id);