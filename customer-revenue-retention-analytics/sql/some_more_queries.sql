-- ================================
-- DATA QUALITY: DUPLICATE CHECKS
-- ================================

-- Customers
SELECT customer_id, COUNT(*) AS duplicate_count
FROM raw_customers
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Orders
SELECT order_id, COUNT(*) AS duplicate_count
FROM raw_orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Products
SELECT product_id, COUNT(*) AS duplicate_count
FROM raw_products
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Sellers
SELECT seller_id, COUNT(*) AS duplicate_count
FROM raw_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;