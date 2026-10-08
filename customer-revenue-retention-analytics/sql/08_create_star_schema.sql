-- ============================================
-- STEP 4: ANALYTICAL STAR SCHEMA
-- ============================================


-- ============================================
-- 1. DIM_CUSTOMER
-- Grain: One row per unique customer
-- ============================================

CREATE TABLE dim_customer (
    customer_unique_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);


INSERT INTO dim_customer (
    customer_unique_id,
    customer_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT DISTINCT ON (customer_unique_id)
    customer_unique_id,
    customer_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM raw_customers
ORDER BY customer_unique_id, customer_id;


-- ============================================
-- 2. DIM_PRODUCT
-- Grain: One row per product
-- ============================================

CREATE TABLE dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100),
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g NUMERIC(12, 2),
    product_length_cm NUMERIC(12, 2),
    product_height_cm NUMERIC(12, 2),
    product_width_cm NUMERIC(12, 2)
);


INSERT INTO dim_product (
    product_id,
    product_category_name,
    product_category_name_english,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    p.product_id,
    p.product_category_name,
    ct.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM raw_products p
LEFT JOIN raw_category_translation ct
    ON p.product_category_name = ct.product_category_name;


-- ============================================
-- 3. DIM_SELLER
-- Grain: One row per seller
-- ============================================

CREATE TABLE dim_seller (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);


INSERT INTO dim_seller (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM raw_sellers;



-- ============================================
-- 4. DIM_DATE
-- Grain: One row per calendar date
-- ============================================

CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name VARCHAR(20),
    month_short VARCHAR(3),
    week INTEGER,
    day INTEGER,
    day_name VARCHAR(20),
    day_of_week INTEGER,
    is_weekend BOOLEAN
);


INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    month_short,
    week,
    day,
    day_name,
    day_of_week,
    is_weekend
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER AS date_key,
    d::DATE AS full_date,
    EXTRACT(YEAR FROM d)::INTEGER AS year,
    EXTRACT(QUARTER FROM d)::INTEGER AS quarter,
    EXTRACT(MONTH FROM d)::INTEGER AS month,
    TO_CHAR(d, 'Month') AS month_name,
    TO_CHAR(d, 'Mon') AS month_short,
    EXTRACT(WEEK FROM d)::INTEGER AS week,
    EXTRACT(DAY FROM d)::INTEGER AS day,
    TO_CHAR(d, 'Day') AS day_name,
    EXTRACT(ISODOW FROM d)::INTEGER AS day_of_week,
    EXTRACT(ISODOW FROM d)::INTEGER IN (6,7) AS is_weekend
FROM generate_series(
    (
        SELECT MIN(order_purchase_timestamp)::DATE
        FROM raw_orders
    ),
    (
        SELECT MAX(order_purchase_timestamp)::DATE
        FROM raw_orders
    ),
    INTERVAL '1 day'
) AS d;


-- ============================================
-- 5. FACT_ORDERS
-- Grain: One row per order
-- ============================================

CREATE TABLE fact_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    order_date_key INTEGER,
    order_status VARCHAR(30),

    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    item_total NUMERIC(14, 2),
    freight_total NUMERIC(14, 2),
    payment_total NUMERIC(14, 2),

    CONSTRAINT fk_fact_orders_customer
        FOREIGN KEY (customer_unique_id)
        REFERENCES dim_customer(customer_unique_id),

    CONSTRAINT fk_fact_orders_date
        FOREIGN KEY (order_date_key)
        REFERENCES dim_date(date_key)
);



INSERT INTO fact_orders (
    order_id,
    customer_unique_id,
    order_date_key,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    item_total,
    freight_total,
    payment_total
)
SELECT
    o.order_id,
    c.customer_unique_id,

    TO_CHAR(
        o.order_purchase_timestamp::DATE,
        'YYYYMMDD'
    )::INTEGER AS order_date_key,

    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    COALESCE(i.item_total, 0),
    COALESCE(i.freight_total, 0),
    COALESCE(p.payment_total, 0)

FROM raw_orders o

JOIN raw_customers c
    ON o.customer_id = c.customer_id

LEFT JOIN (
    SELECT
        order_id,
        SUM(price) AS item_total,
        SUM(freight_value) AS freight_total
    FROM raw_order_items
    GROUP BY order_id
) i
    ON o.order_id = i.order_id

LEFT JOIN (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM raw_order_payments
    GROUP BY order_id
) p
    ON o.order_id = p.order_id;




-- ============================================
-- 6. FACT_ORDER_ITEMS
-- Grain: One row per order item
-- ============================================

CREATE TABLE fact_order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),

    order_date_key INTEGER,

    shipping_limit_date TIMESTAMP,
    price NUMERIC(12, 2),
    freight_value NUMERIC(12, 2),

    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id),

    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES dim_product(product_id),

    CONSTRAINT fk_items_seller
        FOREIGN KEY (seller_id)
        REFERENCES dim_seller(seller_id),

    CONSTRAINT fk_items_date
        FOREIGN KEY (order_date_key)
        REFERENCES dim_date(date_key)
);


INSERT INTO fact_order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    order_date_key,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,

    fo.order_date_key,

    oi.shipping_limit_date,
    oi.price,
    oi.freight_value

FROM raw_order_items oi
JOIN fact_orders fo
    ON oi.order_id = fo.order_id;



-- ============================================
-- 7. FACT_PAYMENTS
-- Grain: One row per payment record
-- ============================================

CREATE TABLE fact_payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(30),
    payment_installments INTEGER,
    payment_value NUMERIC(12, 2),

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id)
);


INSERT INTO fact_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM raw_order_payments;

-- ============================================
-- 8. FACT_REVIEWS
-- Grain: One row per review
-- ============================================

CREATE TABLE fact_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id)
);


INSERT INTO fact_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM raw_order_reviews;


SELECT
    review_id,
    COUNT(*) AS occurrences
FROM raw_order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids
FROM raw_order_reviews;


SELECT
    review_id,
    COUNT(*) AS rows_count,
    COUNT(DISTINCT order_id) AS order_count
FROM raw_order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY rows_count DESC;

SELECT
    review_id,
    order_id,
    COUNT(*) AS rows_count
FROM raw_order_reviews
GROUP BY review_id, order_id
HAVING COUNT(*) > 1
ORDER BY rows_count DESC;



DROP TABLE fact_reviews;

CREATE TABLE fact_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    PRIMARY KEY (review_id, order_id),

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id)
);

INSERT INTO fact_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM raw_order_reviews;


SELECT COUNT(*) AS fact_review_rows
FROM fact_reviews;

SELECT COUNT(*) AS unique_review_order_pairs
FROM (
    SELECT DISTINCT review_id, order_id
    FROM fact_reviews
) x;


-- Customer lookup
CREATE INDEX idx_dim_customer_state
ON dim_customer(customer_state);

-- Order analysis
CREATE INDEX idx_fact_orders_customer
ON fact_orders(customer_unique_id);

CREATE INDEX idx_fact_orders_date
ON fact_orders(order_date_key);

CREATE INDEX idx_fact_orders_status
ON fact_orders(order_status);

-- Order items analysis
CREATE INDEX idx_fact_order_items_product
ON fact_order_items(product_id);

CREATE INDEX idx_fact_order_items_seller
ON fact_order_items(seller_id);

CREATE INDEX idx_fact_order_items_date
ON fact_order_items(order_date_key);

-- Payment analysis
CREATE INDEX idx_fact_payments_order
ON fact_payments(order_id);

-- Review analysis
CREATE INDEX idx_fact_reviews_order
ON fact_reviews(order_id);

CREATE INDEX idx_fact_reviews_score
ON fact_reviews(review_score);

SELECT
    tablename,
    indexname
FROM pg_indexes
WHERE tablename IN (
    'dim_customer',
    'fact_orders',
    'fact_order_items',
    'fact_payments',
    'fact_reviews'
)
ORDER BY tablename, indexname;


SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count
FROM dim_customer

UNION ALL

SELECT 'dim_product', COUNT(*)
FROM dim_product

UNION ALL

SELECT 'dim_seller', COUNT(*)
FROM dim_seller

UNION ALL

SELECT 'dim_date', COUNT(*)
FROM dim_date

UNION ALL

SELECT 'fact_orders', COUNT(*)
FROM fact_orders

UNION ALL

SELECT 'fact_order_items', COUNT(*)
FROM fact_order_items

UNION ALL

SELECT 'fact_payments', COUNT(*)
FROM fact_payments

UNION ALL

SELECT 'fact_reviews', COUNT(*)
FROM fact_reviews;


SELECT COUNT(*) AS orphan_orders
FROM fact_orders fo
LEFT JOIN dim_customer dc
    ON fo.customer_unique_id = dc.customer_unique_id
WHERE dc.customer_unique_id IS NULL;

SELECT COUNT(*) AS orphan_items
FROM fact_order_items foi
LEFT JOIN fact_orders fo
    ON foi.order_id = fo.order_id
WHERE fo.order_id IS NULL;

SELECT COUNT(*) AS orphan_products
FROM fact_order_items foi
LEFT JOIN dim_product dp
    ON foi.product_id = dp.product_id
WHERE dp.product_id IS NULL;

SELECT COUNT(*) AS orphan_sellers
FROM fact_order_items foi
LEFT JOIN dim_seller ds
    ON foi.seller_id = ds.seller_id
WHERE ds.seller_id IS NULL;


SELECT COUNT(*) AS orphan_reviews
FROM fact_reviews fr
LEFT JOIN fact_orders fo
    ON fr.order_id = fo.order_id
WHERE fo.order_id IS NULL;





SELECT COUNT(*) AS total_orders
FROM fact_orders;