<div align="center">

# Customer Revenue, Retention & Churn Analytics

<p>
  <strong>From raw e-commerce transactions to actionable customer retention strategy.</strong>
</p>

<p>
  <img src="https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=111111" alt="Power BI">
  <img src="https://img.shields.io/badge/PostgreSQL-SQL%20Analytics-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Python-Notebooks-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/Status-Completed-22C55E?style=for-the-badge" alt="Project status">
</p>

<p>
  <a href="#executive-summary">Executive Summary</a> •
  <a href="#key-performance-indicators">KPIs</a> •
  <a href="#business-insights">Insights</a> •
  <a href="#project-structure">Project Structure</a> •
  <a href="#how-to-use">How to Use</a>
</p>

</div>

---

## Executive Summary

This project analyzes customer revenue, repeat purchasing, RFM segments, cohort retention, and churn risk using the Brazilian Olist e-commerce dataset.

The analysis combines:

- **PostgreSQL** views for repeatable business logic and analytical modeling.
- **Python notebooks** for validation, customer analysis, and RFM exploration.
- **Power BI** for interactive dashboards and business storytelling.

The central business question is:

> **How can the company convert more first-time buyers into loyal customers while protecting revenue from customers who are at risk of churning?**

<div align="center">

| Revenue | Repeat Customers | Churned Customers | Revenue at Risk |
|:---:|:---:|:---:|:---:|
| **R$13.22M** | **2,801** | **55,381** | **R$7.74M** |
| Delivered revenue | 2.91% of customer population | 59.32% of churn population | Critical + High Risk |

</div>

## Key Performance Indicators

<table>
  <tr>
    <td align="center" width="25%">
      <h3>R$13.22M</h3>
      <p>Total delivered revenue</p>
    </td>
    <td align="center" width="25%">
      <h3>R$137.04</h3>
      <p>Average order value</p>
    </td>
    <td align="center" width="25%">
      <h3>2,801</h3>
      <p>Repeat customers</p>
    </td>
    <td align="center" width="25%">
      <h3>59.32%</h3>
      <p>Rule-based churn rate</p>
    </td>
  </tr>
</table>

## Business Insights

### Revenue

- Revenue grew from **R$40,470.98 in 2016** to **R$7,218,125.12 in 2018**.
- **November 2017** was the strongest month, generating **R$987,765.37**.
- **São Paulo (SP)** was the leading revenue-generating state, contributing approximately **R$5.07M**.
- The AOV was **R$137.04**, calculated from delivered revenue and delivered orders.

### Customers

- Only **2,801 customers** were repeat buyers, representing **2.91%** of the 96,096-customer population.
- Repeat customers generated approximately **R$728,408.75**.
- The top 10 customers generated approximately **R$67,565.60**.
- The highest-value customer generated approximately **R$13,440.00**.

### Segmentation and retention

- **Potential Customers** was the largest segment with **33,776 customers**.
- **At Risk** was the highest-revenue RFM segment, generating approximately **R$4.71M** from **22,033 customers**.
- The cohort analysis shows retention generally declines as the number of months since first purchase increases.
- The 2016 cohort is a partial period beginning in September and should not be compared directly with complete years.

### Churn and risk

- **55,381 customers** were classified as churned using the project's 180-day inactivity rule.
- **114 customers** were classified as High Value At Risk.
- Approximately **R$7.74M** is associated with Critical Risk and High Risk customers.
- Risk revenue is an exposure measure, not a guaranteed future loss.

## Customer Segment Snapshot

| RFM Segment | Customers | Revenue | Recommended action |
|---|---:|---:|---|
| Potential Customers | 33,776 | R$1,955,592.52 | Convert first purchase into a second purchase |
| At Risk | 22,033 | R$4,711,065.64 | Launch targeted win-back campaigns |
| Champions | 14,934 | R$4,073,968.48 | Protect loyalty and encourage advocacy |
| New Customers | 14,583 | R$577,297.85 | Improve onboarding and cross-selling |
| Loyal Customers | 7,918 | R$1,895,059.83 | Reward repeat behavior |
| High Value At Risk | 114 | R$8,513.79 | Apply high-touch retention actions |

## Recommended Business Actions

1. **Improve first-to-second purchase conversion** with post-purchase messaging, relevant recommendations, and carefully tested incentives.
2. **Prioritize At Risk and High Value At Risk customers** before they cross the churn threshold.
3. **Build state-level retention campaigns**, beginning with São Paulo and other high-revenue markets.
4. **Monitor customer movement between RFM segments** to measure whether retention campaigns create Loyal Customers and Champions.
5. **Use margin data before making product decisions.** This project measures revenue and customer behavior; it does not prove that any product category is profitable or loss-making.

## Dashboard

The Power BI dashboard is available here:

- [Open the Power BI dashboard](../Project/Dasboards.pbix)
- [Read the detailed project results](docs/Results.md)
- [Read the validated findings](docs/findings.md)

The dashboard covers:

- Revenue trend by month and year
- Revenue by product category and state
- Average order value
- Customer repeat-purchase behavior
- RFM segment performance
- Cohort retention
- Customer risk and churn exposure

## Technical Workflow

```text
Raw Olist CSV files
        │
        ▼
PostgreSQL tables and constraints
        │
        ▼
Business views: revenue, customer 360, RFM, cohort, churn, risk
        │
        ├──► Python validation and exploratory analysis
        │
        └──► Power BI dashboard and business recommendations
```

## Project Structure

```text
customer-revenue-retention-analytics/
├── data/
│   ├── raw/                  # Original Olist CSV datasets
│   └── processed/            # Exported analytical outputs
├── docs/
│   ├── Results.md            # Detailed results and interpretation
│   ├── findings.md           # Validated findings and recommendations
│   ├── business_logic.md     # Definitions used in the analysis
│   └── data_dictionary.md    # Dataset and column reference
├── python/
│   ├── 01_data_validation.ipynb
│   ├── 02_customer_analysis.ipynb
│   └── 03_rfm_analysis.ipynb
├── sql/
│   ├── 01_create_tables.sql
│   ├── 04_business_analysis.sql
│   ├── 05_rfm.sql
│   ├── 06_cohort_retention.sql
│   ├── 07_churn.sql
│   └── 08_create_star_schema.sql
└── ../Project/Dasboards.pbix # Power BI dashboard
```

## How to Use

### 1. Load the data

Import the CSV files in `data/raw/` into PostgreSQL using the table and staging logic in `sql/01_create_tables.sql`.

### 2. Create analytical views

Run the SQL files in sequence:

```text
01_create_tables.sql
02_constraints_indexes.sql
03_data_quality.sql
04_business_analysis.sql
05_rfm.sql
06_cohort_retention.sql
07_churn.sql
08_create_star_schema.sql
```

### 3. Validate the analysis

Run the notebooks in the `python/` folder. The notebooks validate row counts, duplicate customers, revenue values, RFM scores, and churn outputs.

### 4. Open the dashboard

Open `Project/Dasboards.pbix` in Power BI Desktop and refresh the data source if your PostgreSQL connection differs from the original environment.

## Analytical Definitions

| Term | Definition |
|---|---|
| Revenue | Sum of item value for delivered orders |
| AOV | Delivered revenue divided by delivered orders |
| Repeat customer | Customer with more than one qualifying delivered order |
| Recency | Days since the customer's last delivered order |
| Frequency | Number of qualifying delivered orders |
| Monetary | Customer revenue from qualifying delivered orders |
| Churned | No subsequent delivered purchase and at least 180 days since the last qualifying purchase |
| Revenue at risk | Revenue associated with Critical Risk and High Risk customers |

## Data Notes

- The data covers a partial period beginning in 2016 and ending in 2018.
- Customer 360 contains **96,096** customers.
- RFM, churn, and risk analysis use **93,358** customers with delivered-order activity.
- Revenue is not profit; product costs, returns, discounts, and margins are outside the current scope.
- Cohort retention should be compared at equivalent months since first purchase.

---

<div align="center">

### Built for data-driven retention decisions

<sub>SQL • Python • PostgreSQL • Power BI • Customer Analytics</sub>

</div>