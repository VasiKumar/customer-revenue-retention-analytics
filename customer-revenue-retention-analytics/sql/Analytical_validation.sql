SELECT COUNT(*) AS total_orders
FROM fact_orders;


SELECT COUNT(*) AS delivered_orders
FROM fact_orders
WHERE order_status = 'delivered';

SELECT COUNT(*) AS total_customers
FROM dim_customer;

SELECT
    ROUND(SUM(price), 2) AS product_revenue
FROM fact_order_items;


SELECT
    ROUND(SUM(freight_value), 2) AS freight_revenue
FROM fact_order_items;

SELECT
    ROUND(SUM(payment_value), 2) AS total_payments
FROM fact_payments;

