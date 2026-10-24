\set ON_ERROR_STOP on

BEGIN;

SELECT setseed(0.42);

-- CUSTOMERS ---------------------------------------------------------------
INSERT INTO customers (customer_id, customer_name, email, city, created_at)
SELECT
    g AS customer_id,
    'Customer ' || g AS customer_name,
    'customer' || g || '@example.com' AS email,           -- unik by construction
    (ARRAY['Jakarta','Bandung','Surabaya','Medan','Semarang',
           'Yogyakarta','Makassar','Denpasar','Palembang','Bekasi'])[1 + floor(random()*10)]
        AS city,
    (TIMESTAMPTZ '2023-01-01' + (random() * INTERVAL '700 days')) AS created_at
FROM generate_series(1, 20000) AS g;

-- PRODUCTS ----------------------------------------------------------------
INSERT INTO products (product_id, product_name, category, price, stock, created_at)
SELECT
    g AS product_id,
    'Product ' || g AS product_name,
    (ARRAY['Elektronik','Pakaian','Makanan','Minuman','Peralatan Rumah',
           'Olahraga','Kecantikan','Otomotif','Buku','Mainan'])[1 + floor(random()*10)]
        AS category,
    round((5000 + random() * 4995000)::numeric, 2) AS price,
    floor(random() * 500)::int AS stock,
    (TIMESTAMPTZ '2023-01-01' + (random() * INTERVAL '700 days')) AS created_at
FROM generate_series(1, 5000) AS g;

-- ORDERS ------------------------------------------------------------------
-- Distribusi status: ~60% completed, ~15% pending, ~15% processing, ~10% cancelled
-- Tanggal order: acak dalam 365 hari terakhir.
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount, created_at)
SELECT
    g AS order_id,
    1 + floor(random() * 20000)::bigint AS customer_id,
    d::date AS order_date,
    CASE
        WHEN r < 0.60 THEN 'completed'
        WHEN r < 0.75 THEN 'pending'
        WHEN r < 0.90 THEN 'processing'
        ELSE 'cancelled'
    END AS status,
    0 AS total_amount,  -- diisi ulang setelah order_items dibuat
    (d + (random() * INTERVAL '1 day')) AS created_at
FROM (
    SELECT g, (CURRENT_DATE - (floor(random() * 365))::int) AS d, random() AS r
    FROM generate_series(1, 100000) AS g
) s;

-- ORDER_ITEMS -------------------------------------------------------------
-- Tepat 3 item per order (v = 1..3) => 300.000 baris.
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, subtotal)
SELECT
    ((o.order_id - 1) * 3 + v.v) AS order_item_id,
    o.order_id,
    p.product_id,
    q.quantity,
    p.price AS unit_price,
    round(q.quantity * p.price, 2) AS subtotal
FROM orders o
CROSS JOIN generate_series(1, 3) AS v(v)
JOIN LATERAL (
    SELECT product_id, price
    FROM products
    WHERE product_id = 1 + floor(random() * 5000)::bigint
) p ON true
CROSS JOIN LATERAL (
    SELECT 1 + floor(random() * 5)::int AS quantity
) q;

-- Isi total_amount orders = jumlah subtotal itemnya
UPDATE orders o
SET total_amount = t.total
FROM (
    SELECT order_id, SUM(subtotal) AS total
    FROM order_items
    GROUP BY order_id
) t
WHERE t.order_id = o.order_id;

COMMIT;

ANALYZE customers;
ANALYZE products;
ANALYZE orders;
ANALYZE order_items;

-- VERIFIKASI --------------------------------------------------------------
SELECT 'customers'  AS tabel, COUNT(*) FROM customers
UNION ALL
SELECT 'products',    COUNT(*) FROM products
UNION ALL
SELECT 'orders',      COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;

-- Integritas FK: harus 0 semua
SELECT
    (SELECT COUNT(*) FROM orders o
      WHERE NOT EXISTS (SELECT 1 FROM customers c WHERE c.customer_id = o.customer_id))
        AS orders_tanpa_customer,
    (SELECT COUNT(*) FROM order_items oi
      WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.order_id = oi.order_id))
        AS items_tanpa_order,
    (SELECT COUNT(*) FROM order_items oi
      WHERE NOT EXISTS (SELECT 1 FROM products p WHERE p.product_id = oi.product_id))
        AS items_tanpa_product;

-- Distribusi status dan rentang tanggal
SELECT status, COUNT(*) AS jumlah,
       round(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS persen
FROM orders GROUP BY status ORDER BY status;

SELECT MIN(order_date) AS tanggal_awal, MAX(order_date) AS tanggal_akhir FROM orders;

-- Tepat 3 item per order: harus 0
SELECT COUNT(*) AS orders_tidak_3_item
FROM (
    SELECT order_id FROM order_items GROUP BY order_id HAVING COUNT(*) <> 3
) x;
