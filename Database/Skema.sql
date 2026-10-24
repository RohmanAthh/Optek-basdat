CREATE TABLE customers (
    customer_id   BIGINT       PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    city          VARCHAR(50)  NOT NULL,
    created_at    TIMESTAMPTZ  NOT NULL
);

CREATE TABLE products (
    product_id   BIGINT        PRIMARY KEY,
    product_name VARCHAR(150)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    price        NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    stock        INTEGER       NOT NULL DEFAULT 0,
    created_at   TIMESTAMPTZ   NOT NULL
);

CREATE TABLE orders (
    order_id     BIGINT        PRIMARY KEY,
    customer_id  BIGINT        NOT NULL REFERENCES customers(customer_id),
    order_date   DATE          NOT NULL,
    status       VARCHAR(20)   NOT NULL CHECK (status IN ('completed','pending','processing','cancelled')),
    total_amount NUMERIC(14,2) NOT NULL CHECK (total_amount >= 0),
    created_at   TIMESTAMPTZ   NOT NULL
);

CREATE TABLE order_items (
    order_item_id BIGINT        PRIMARY KEY,
    order_id      BIGINT        NOT NULL REFERENCES orders(order_id),
    product_id    BIGINT        NOT NULL REFERENCES products(product_id),
    quantity      INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    subtotal      NUMERIC(14,2) NOT NULL CHECK (subtotal >= 0)
);

COMMIT;

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
