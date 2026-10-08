# Python Analysis Findings

Analysis source: the PostgreSQL analytical views queried by the notebooks in the `python/` folder. Results below were produced from the latest successful notebook execution.

## Validation Results

- `vw_customer_360` returned 96,096 customer records.
- `vw_rfm_segments`, `vw_customer_churn`, and `vw_customer_risk` each returned 93,358 customers.
- The difference is expected: the customer 360 view includes customers without a delivered order, while RFM, churn, and risk analysis use delivered orders only.
- Duplicate customer IDs: 0.
- Negative revenue values: 0.
- Negative order counts: 0.
- Negative average order values: 0.
- Recency, frequency, and monetary scores all contain values from 1 through 5.
- The customer 360 view contains 2,738 null average order values, consistent with customers who have no delivered-order value.

## Customer And Revenue Outcomes

- Total customers: 96,096.
- Total orders: 99,441.
- Total revenue: 13,221,504.68.
- Average revenue per customer: 137.59.
- Highest customer revenue: 13,440.00.
- The top 10% of customers generated 41.68% of total revenue, indicating meaningful customer concentration.
- November 2017 was the strongest revenue month, with revenue of 987,765.37 from 7,289 orders.
- December 2016 was the weakest month, with only one order and revenue of 10.90. This is a partial-period observation and should not be compared directly with full months.
- The top-revenue states were SP, RJ, MG, RS, and PR.

## RFM And Retention Outcomes

- The RFM population contains 93,358 customers.
- Six RFM segments were identified: Potential Customers, At Risk, Champions, New Customers, Loyal Customers, and High Value At Risk.
- Potential Customers was the largest customer segment in the executed output.
- At Risk generated the largest RFM revenue total in the executed output, making it a priority segment for retention activity.
- Cohort retention declines as the number of months since first purchase increases. The cohort heatmap is available in `03_rfm_analysis.ipynb`.

## Churn And Revenue Risk

- Churned customers: 55,381, or 59.32% of the churn analysis population.
- Active / Not Observable customers: 40.68%.
- Revenue at risk from Critical Risk and High Risk customers: 7,735,155.87.
- Revenue at risk as a share of customer revenue: 58.50%.
- The risk output shows Low Risk as the largest revenue category, followed by Critical Risk and High Risk.

## Recommended Actions

1. Prioritize retention campaigns for At Risk and High Value At Risk customers before their inactivity reaches the churn threshold.
2. Create a separate acquisition or first-order conversion workflow for customers present in customer 360 but absent from the delivered-order RFM population.
3. Monitor revenue concentration because a relatively small customer group contributes a large share of revenue.
4. Treat December 2016 as a partial-period data point when presenting monthly trends.
5. Use the cohort heatmap to identify acquisition months with stronger repeat-purchase behavior.

## Reproducibility

Run the notebooks after configuring `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_HOST`, `POSTGRES_PORT`, and `POSTGRES_DB`. The analysis exports derived datasets to `data/processed/` and does not reload raw CSV files.
