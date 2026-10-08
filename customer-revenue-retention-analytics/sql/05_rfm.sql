CREATE OR REPLACE VIEW vw_customer_rfm_base AS
SELECT
    customer_unique_id,

    MAX(order_purchase_timestamp)::DATE AS last_order_date,

    COUNT(DISTINCT order_id) AS frequency,

    ROUND(SUM(item_total), 2) AS monetary

FROM fact_orders

WHERE order_status = 'delivered'

GROUP BY customer_unique_id;


CREATE OR REPLACE VIEW vw_customer_rfm AS
SELECT
    customer_unique_id,

    (
        (
            SELECT MAX(order_purchase_timestamp)::DATE
            FROM fact_orders
            WHERE order_status = 'delivered'
        )
        - last_order_date
    ) AS recency,

    frequency,

    monetary

FROM vw_customer_rfm_base;



CREATE OR REPLACE VIEW vw_rfm_scores AS
SELECT
    customer_unique_id,

    recency,
    frequency,
    monetary,

    NTILE(5) OVER (
        ORDER BY recency DESC
    ) AS recency_score,

    NTILE(5) OVER (
        ORDER BY frequency
    ) AS frequency_score,

    NTILE(5) OVER (
        ORDER BY monetary
    ) AS monetary_score

FROM vw_customer_rfm;


CREATE OR REPLACE VIEW vw_rfm_segments AS
SELECT
    customer_unique_id,

    recency,
    frequency,
    monetary,

    recency_score,
    frequency_score,
    monetary_score,

    CASE
        WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
            THEN 'Champions'

        WHEN recency_score >= 3
             AND frequency_score >= 4
            THEN 'Loyal Customers'

        WHEN recency_score >= 4
             AND frequency_score <= 2
            THEN 'New Customers'

        WHEN recency_score <= 2
             AND frequency_score >= 3
            THEN 'At Risk'

        WHEN recency_score <= 2
             AND frequency_score <= 2
             AND monetary_score >= 3
            THEN 'High Value At Risk'

        ELSE 'Potential Customers'
    END AS rfm_segment

FROM vw_rfm_scores;


