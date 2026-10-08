CREATE OR REPLACE VIEW vw_customer_360 AS
SELECT
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT CASE
        WHEN o.order_status = 'delivered'
        THEN o.order_id
    END) AS delivered_orders,

    ROUND(
        SUM(
            CASE
                WHEN o.order_status = 'delivered'
                THEN o.item_total
                ELSE 0
            END
        ),
        2
    ) AS total_revenue,

    ROUND(
        AVG(
            CASE
                WHEN o.order_status = 'delivered'
                THEN o.item_total
            END
        ),
        2
    ) AS average_order_value,

    MIN(o.order_purchase_timestamp) AS first_order_date,

    MAX(o.order_purchase_timestamp) AS last_order_date

FROM dim_customer c

LEFT JOIN fact_orders o
    ON c.customer_unique_id = o.customer_unique_id

GROUP BY
    c.customer_unique_id,
    c.customer_city,
    c.customer_state;




CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    DATE_TRUNC('month', order_purchase_timestamp)::DATE AS month,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT customer_unique_id) AS total_customers,

    ROUND(SUM(item_total), 2) AS revenue,

    ROUND(
        SUM(item_total) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value

FROM fact_orders

WHERE order_status = 'delivered'

GROUP BY
    DATE_TRUNC('month', order_purchase_timestamp)

ORDER BY month;

SELECT *
FROM vw_monthly_revenue
ORDER BY month;



CREATE OR REPLACE VIEW vw_customer_order_type AS
WITH customer_orders AS (
    SELECT
        customer_unique_id,
        order_id,
        order_purchase_timestamp,

        ROW_NUMBER() OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp
        ) AS order_number

    FROM fact_orders

    WHERE order_status = 'delivered'
)

SELECT
    customer_unique_id,
    order_id,
    order_purchase_timestamp,

    CASE
        WHEN order_number = 1 THEN 'New Customer'
        ELSE 'Repeat Customer'
    END AS customer_type

FROM customer_orders;


