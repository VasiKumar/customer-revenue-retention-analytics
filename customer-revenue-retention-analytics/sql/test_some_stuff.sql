SELECT
    cohort_month,
    cohort_month_number,
    retention_rate
FROM vw_cohort_retention
ORDER BY cohort_month, cohort_month_number
LIMIT 20;



SELECT pg_get_viewdef(
    'public.vw_cohort_retention'::regclass,
    true
);


SELECT
    cohort_month,
    cohort_month_number,
    cohort_size,
    active_customers,
    retention_rate
FROM vw_cohort_retention
ORDER BY cohort_month, cohort_month_number
LIMIT 15;


SELECT
    cohort_month,
    cohort_month_number,
    COUNT(DISTINCT customer_unique_id) AS active_customers
FROM vw_customer_cohort_period
WHERE cohort_month = DATE '2017-01-01'
GROUP BY cohort_month, cohort_month_number
ORDER BY cohort_month_number;


SELECT *
FROM vw_customer_cohort_period
WHERE cohort_month = DATE '2017-01-01'
ORDER BY cohort_month_number
LIMIT 20;


SELECT pg_get_viewdef(
    'vw_customer_cohort_period',
    true
);


SELECT
table_schema,
table_name,
column_name,
data_type
FROM information_schema.columns
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
ORDER BY table_schema, table_name, ordinal_position;
