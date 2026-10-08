CREATE OR REPLACE VIEW vw_customer_cohort AS
WITH customer_first_order AS (

    SELECT
        customer_unique_id,

        DATE_TRUNC(
            'month',
            MIN(order_purchase_timestamp)
        )::DATE AS cohort_month

    FROM fact_orders

    WHERE order_status = 'delivered'

    GROUP BY customer_unique_id
)

SELECT
    o.customer_unique_id,

    c.cohort_month,

    DATE_TRUNC(
        'month',
        o.order_purchase_timestamp
    )::DATE AS order_month

FROM fact_orders o

JOIN customer_first_order c
    ON o.customer_unique_id = c.customer_unique_id

WHERE o.order_status = 'delivered';


CREATE OR REPLACE VIEW vw_customer_cohort_period AS
SELECT
    customer_unique_id,

    cohort_month,

    order_month,

    (
        (
            EXTRACT(YEAR FROM order_month)
            - EXTRACT(YEAR FROM cohort_month)
        ) * 12
        +
        (
            EXTRACT(MONTH FROM order_month)
            - EXTRACT(MONTH FROM cohort_month)
        )
    )::INTEGER AS cohort_month_number

FROM vw_customer_cohort;


CREATE OR REPLACE VIEW vw_cohort_retention AS
WITH cohort_customers AS (

    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS cohort_size

    FROM vw_customer_cohort_period

    GROUP BY cohort_month
),

active_customers AS (

    SELECT
        cohort_month,
        cohort_month_number,
        COUNT(DISTINCT customer_unique_id) AS active_customers

    FROM vw_customer_cohort_period

    GROUP BY
        cohort_month,
        cohort_month_number
)

SELECT
    a.cohort_month,

    a.cohort_month_number,

    c.cohort_size,

    a.active_customers,

    ROUND(
        100.0 * a.active_customers
        / NULLIF(c.cohort_size, 0),
        2
    ) AS retention_rate

FROM active_customers a

JOIN cohort_customers c
    ON a.cohort_month = c.cohort_month

ORDER BY
    a.cohort_month,
    a.cohort_month_number;


