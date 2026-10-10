# Customer Revenue, Retention & Churn Analytics

> Turning e-commerce transaction data into revenue insights and customer retention strategies.

**Tools:** Power BI · PostgreSQL · SQL · Python · Customer Analytics

## Project Overview

This project analyzes customer purchasing behavior using the Brazilian Olist e-commerce dataset. The goal was to understand revenue performance, repeat purchasing, customer segments, cohort retention, and churn risk.

The analysis transforms raw transaction data into an interactive Power BI dashboard supported by PostgreSQL analytical views and Python validation notebooks.

## Key Business Results

| Metric | Result |
|---|---:|
| Total delivered revenue | **R$13.22M** |
| Average order value | **R$137.04** |
| Repeat customers | **2,801** |
| Rule-based churn rate | **59.32%** |
| Revenue associated with high-risk customers | **R$7.74M** |
| Revenue from São Paulo | **R$5.07M** |

## Important Findings

- Revenue increased from approximately **R$40K in 2016** to **R$7.22M in 2018**.
- **November 2017** was the strongest month, generating approximately **R$987.8K**.
- **São Paulo** was the leading revenue-generating state.
- Only **2.91%** of the customer population were identified as repeat buyers.
- The **At Risk** segment generated approximately **R$4.71M** from **22,033 customers**.
- **Potential Customers** were the largest RFM segment, with **33,776 customers**.
- The churn model classified **55,381 customers** as churned using a 180-day inactivity rule.
- Cohort retention generally decreased as the number of months after the first purchase increased.

## Tools and Techniques

### PostgreSQL and SQL

Created analytical views for:

- Customer 360 analysis
- Monthly revenue
- RFM segmentation
- Cohort retention
- Churn classification
- Customer risk analysis

### Python

Used Python notebooks to validate:

- Customer counts
- Duplicate customer IDs
- Revenue totals
- RFM scores
- Churn results
- Analytical outputs

### Power BI

Built an interactive dashboard showing:

- Revenue trends
- Revenue by state and category
- Repeat-customer behavior
- RFM segments
- Cohort retention
- Customer risk
- Revenue exposure

## Business Recommendations

1. Improve first-to-second purchase conversion through personalized follow-up campaigns.
2. Prioritize At Risk and High Value At Risk customers with targeted win-back campaigns.
3. Build retention strategies for high-revenue states, beginning with São Paulo.
4. Track movement from Potential Customers into Loyal Customers and Champions.
5. Compare customer retention by product category before making investment decisions.

## Project Links

- [View the GitHub repository](https://github.com/VasiKumar/customer-revenue-retention-analytics)
- [View the Power BI dashboard](https://github.com/VasiKumar/customer-revenue-retention-analytics/blob/main/Project/Dasboards.pbix)
