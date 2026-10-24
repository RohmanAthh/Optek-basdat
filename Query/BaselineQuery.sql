-- Tiga query utama tanpa indeks tambahan (baseline).
-- File ini hanya mendefinisikan query sebagai referensi;

-- QUERY 1 — Riwayat transaksi pelanggan (customer_id = 100)
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount
FROM customers AS c
JOIN orders AS o
    ON o.customer_id = c.customer_id
WHERE c.customer_id = 100
ORDER BY o.order_date DESC
LIMIT 20;

-- QUERY 2 — Analisis penjualan produk (completed, 180-90 hari lalu)
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders AS o
JOIN order_items AS oi
    ON oi.order_id = o.order_id
JOIN products AS p
    ON p.product_id = oi.product_id
WHERE o.status = 'completed'
  AND o.order_date >= CURRENT_DATE - INTERVAL '180 days'
  AND o.order_date <  CURRENT_DATE - INTERVAL '90 days'
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC
LIMIT 10;

-- QUERY 3 — Transaksi pending lebih dari 7 hari
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    o.total_amount
FROM orders AS o
JOIN customers AS c
    ON c.customer_id = o.customer_id
WHERE o.status = 'pending'
  AND o.order_date < CURRENT_DATE - INTERVAL '7 days'
ORDER BY o.order_date ASC
LIMIT 100;
