-- ================================
-- DATA QUALITY: INVALID VALUES
-- ================================

-- 1. Invalid order statuses
SELECT
    order_status,
    COUNT(*) AS order_count
FROM raw_orders
GROUP BY order_status
ORDER BY order_count DESC;


-- 2. Negative / zero product prices
SELECT
    COUNT(*) AS invalid_price_rows
FROM raw_order_items
WHERE price <= 0;


-- 3. Negative freight values
SELECT
    COUNT(*) AS invalid_freight_rows
FROM raw_order_items
WHERE freight_value < 0;


-- 4. Invalid review scores
SELECT
    review_score,
    COUNT(*) AS review_count
FROM raw_order_reviews
GROUP BY review_score
ORDER BY review_score;


-- 5. Invalid payment values
SELECT
    COUNT(*) AS invalid_payment_rows
FROM raw_order_payments
WHERE payment_value <= 0;


-- 6. Invalid payment installments
SELECT
    COUNT(*) AS invalid_installments
FROM raw_order_payments
WHERE payment_installments <= 0;


-- 7. Invalid product dimensions
SELECT
    COUNT(*) AS invalid_weight
FROM raw_products
WHERE product_weight_g <= 0;

SELECT
    COUNT(*) AS invalid_length
FROM raw_products
WHERE product_length_cm <= 0;

SELECT
    COUNT(*) AS invalid_height
FROM raw_products
WHERE product_height_cm <= 0;

SELECT
    COUNT(*) AS invalid_width
FROM raw_products
WHERE product_width_cm <= 0;

-- ================================
-- INVESTIGATE SUSPICIOUS VALUES
-- ================================

-- 1. Payment values <= 0
SELECT *
FROM raw_order_payments
WHERE payment_value <= 0
ORDER BY payment_value;


-- 2. Payment installments <= 0
SELECT *
FROM raw_order_payments
WHERE payment_installments <= 0
ORDER BY payment_installments;


-- 3. Product weights <= 0
SELECT *
FROM raw_products
WHERE product_weight_g <= 0
ORDER BY product_weight_g;





-- =========================================
-- DATA QUALITY: RELATIONSHIP INTEGRITY
-- =========================================

-- 1. Orders without a matching customer
SELECT COUNT(*) AS orphan_orders
FROM raw_orders o
LEFT JOIN raw_customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 2. Order items without a matching order
SELECT COUNT(*) AS orphan_order_items
FROM raw_order_items oi
LEFT JOIN raw_orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 3. Order items without a matching product
SELECT COUNT(*) AS orphan_products
FROM raw_order_items oi
LEFT JOIN raw_products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 4. Order items without a matching seller
SELECT COUNT(*) AS orphan_sellers
FROM raw_order_items oi
LEFT JOIN raw_sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- 5. Payments without a matching order
SELECT COUNT(*) AS orphan_payments
FROM raw_order_payments p
LEFT JOIN raw_orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 6. Reviews without a matching order
SELECT COUNT(*) AS orphan_reviews
FROM raw_order_reviews r
LEFT JOIN raw_orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;