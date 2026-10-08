
-- 1. CUSTOMERS
CREATE TABLE raw_customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);


-- 2. GEOLOCATION
CREATE TABLE raw_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat NUMERIC(12, 8),
    geolocation_lng NUMERIC(12, 8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);


-- 3. ORDER ITEMS
CREATE TABLE raw_order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(12, 2),
    freight_value NUMERIC(12, 2)
);


-- 4. ORDER PAYMENTS
CREATE TABLE raw_order_payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(30),
    payment_installments INTEGER,
    payment_value NUMERIC(12, 2)
);


-- 5. ORDER REVIEWS
CREATE TABLE raw_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);


-- 6. ORDERS
CREATE TABLE raw_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);


-- 7. PRODUCTS
CREATE TABLE raw_products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g NUMERIC(12, 2),
    product_length_cm NUMERIC(12, 2),
    product_height_cm NUMERIC(12, 2),
    product_width_cm NUMERIC(12, 2)
);


-- 8. SELLERS
CREATE TABLE raw_sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);


-- 9. CATEGORY TRANSLATION
CREATE TABLE raw_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);



SELECT * FROM raw_customers;

COPY raw_customers
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true)

COPY raw_geolocation
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true);

COPY raw_order_items
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true);

COPY raw_order_payments
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true);

COPY raw_order_reviews
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true);

COPY raw_orders
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true);

COPY raw_products
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true);

COPY raw_sellers
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true);

COPY raw_category_translation
FROM 'D:\Data Analytics Portfolio Project\customer-revenue-retention-analytics\data\raw\product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true);
SELECT
    (SELECT COUNT(*) FROM raw_customers) AS customers,
    (SELECT COUNT(*) FROM raw_geolocation) AS geolocation,
    (SELECT COUNT(*) FROM raw_order_items) AS order_items,
    (SELECT COUNT(*) FROM raw_order_payments) AS payments,
    (SELECT COUNT(*) FROM raw_order_reviews) AS reviews,
    (SELECT COUNT(*) FROM raw_orders) AS orders,
    (SELECT COUNT(*) FROM raw_products) AS products,
    (SELECT COUNT(*) FROM raw_sellers) AS sellers,
    (SELECT COUNT(*) FROM raw_category_translation) AS category_translation;