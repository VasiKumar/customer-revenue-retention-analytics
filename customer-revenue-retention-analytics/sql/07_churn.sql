CREATE OR REPLACE VIEW vw_customer_churn AS
WITH customer_last_order AS (

    SELECT
        customer_unique_id,

        MAX(order_purchase_timestamp)::DATE AS last_order_date

    FROM fact_orders

    WHERE order_status = 'delivered'

    GROUP BY customer_unique_id
),

dataset_end AS (

    SELECT
        MAX(order_purchase_timestamp)::DATE AS dataset_end_date

    FROM fact_orders

    WHERE order_status = 'delivered'
)

SELECT
    c.customer_unique_id,

    c.last_order_date,

    d.dataset_end_date,

    (
        d.dataset_end_date - c.last_order_date
    ) AS days_since_last_order,

    CASE

        WHEN
            d.dataset_end_date - c.last_order_date >= 180
        THEN 'Churned'

        ELSE 'Active / Not Observable'

    END AS churn_status

FROM customer_last_order c

CROSS JOIN dataset_end d;


SELECT
    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE churn_status = 'Churned'
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS churn_rate_percentage
FROM vw_customer_churn;



CREATE OR REPLACE VIEW vw_customer_risk AS
SELECT
    r.customer_unique_id,

    r.recency,
    r.frequency,
    r.monetary,

    r.rfm_segment,

    c.days_since_last_order,
    c.churn_status,

    CASE

        WHEN c.churn_status = 'Churned'
             AND r.monetary >= (
                 SELECT PERCENTILE_CONT(0.75)
                 WITHIN GROUP (ORDER BY monetary)
                 FROM vw_rfm_segments
             )
            THEN 'Critical Risk'

        WHEN c.churn_status = 'Churned'
            THEN 'High Risk'

        WHEN r.rfm_segment IN (
            'At Risk',
            'High Value At Risk'
        )
            THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS risk_level

FROM vw_rfm_segments r

JOIN vw_customer_churn c
    ON r.customer_unique_id = c.customer_unique_id;



SELECT
    risk_level,
    COUNT(*) AS customers,
    ROUND(SUM(monetary), 2) AS revenue
FROM vw_customer_risk
GROUP BY risk_level
ORDER BY
    CASE risk_level
        WHEN 'Critical Risk' THEN 1
        WHEN 'High Risk' THEN 2
        WHEN 'Medium Risk' THEN 3
        WHEN 'Low Risk' THEN 4
    END;


SELECT
    ROUND(
        SUM(monetary) FILTER (
            WHERE risk_level IN (
                'Critical Risk',
                'High Risk'
            )
        ),
        2
    ) AS revenue_at_risk
FROM vw_customer_risk;


SELECT
    ROUND(
        100.0 *
        SUM(monetary) FILTER (
            WHERE risk_level IN (
                'Critical Risk',
                'High Risk'
            )
        )
        / NULLIF(SUM(monetary), 0),
        2
    ) AS revenue_at_risk_percentage
FROM vw_customer_risk;