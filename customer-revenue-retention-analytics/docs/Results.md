# Customer Revenue, Retention & Churn Analytics — Key Findings

## 1. Revenue Analysis

### How is revenue trending?

Revenue increased significantly over the available data period.

- **2016 revenue:** R$40,470.98 (September–December data period)
- **2017 revenue:** R$5,962,902.01
- **2018 revenue:** R$7,218,125.12

November 2017 recorded the highest monthly revenue at **R$987,765.37**. Revenue remained strong from March to May 2018, reaching R$953,356.25 in March, R$973,534.09 in April, and R$977,544.69 in May.

### Which product categories generate the most revenue?

The dashboard identified the following leading categories:

- **Health & Beauty:** R$1,258,681
- **Watches & Gifts:** R$1,205,005

These category figures should be confirmed against the final SQL output. Revenue measures sales value, not profit.

### Which states generate the most revenue?

**São Paulo (SP)** is the leading revenue-generating state, contributing approximately **R$5,068,589.63** in the processed customer-level analysis.

### What's the average order value?

The average order value (AOV) is **R$137.04**, calculated by dividing total delivered revenue by the number of delivered orders.

---

## 2. Customer Analysis

### How many customers are repeat buyers?

The analysis identified **2,801 repeat customers**, approximately **2.91%** of the 96,096-customer population used in the calculation.

Repeat customers are defined as customers who placed more than one qualifying order.

### How much revenue comes from repeat customers?

Repeat customers generated approximately **R$728,408.75** in the processed customer analysis.

### Who are our highest-value customers?

The top 10 customers generated approximately **R$67,565.60** in total revenue.

The highest-value customer in the processed data is `0a0a92112bd4c708ca5fde585afaa872`, with approximately **R$13,440.00** in revenue.

São Paulo also leads in customer revenue among the states.

### Which customer segments generate the most revenue?

The **At Risk** RFM segment generated the most revenue, approximately **R$4.71 million**, across 22,033 customers.

| Customer Segment | Customers | Revenue |
|---|---:|---:|
| Potential Customers | 33,776 | R$1,955,592.52 |
| At Risk | 22,033 | R$4,711,065.64 |
| Champions | 14,934 | R$4,073,968.48 |
| New Customers | 14,583 | R$577,297.85 |
| Loyal Customers | 7,918 | R$1,895,059.83 |
| High Value At Risk | 114 | R$8,513.79 |

---

## 3. Customer Retention Analysis

### How quickly do customers return?

The cohort analysis suggests that repeat purchasing is low in the months following a customer's first purchase. However, the exact cohort-retention percentages require validation against the final SQL output.

Cohort retention measures the percentage of customers from an initial purchase cohort who purchase again in a subsequent month. It is different from the overall repeat-customer rate.

### Which cohorts retain best?

The initial analysis indicates differences in retention between the 2016, 2017, and 2018 cohorts.

The 2016 data begins in September, making it a partial year. Cohorts also have different lengths of observable follow-up. For a fair comparison, retention should be compared at equivalent months since the first purchase.

### Where does retention drop sharply?

The current analysis does not establish that retention dropped from 0.6% to 0.2% within a few days in April. The cohort analysis uses monthly periods, so changes should be described by month rather than by individual days.

---

## 4. Churn and Customer Risk

### How many customers are churned?

The churn analysis identified **55,381 churned customers**, representing approximately **59.32%** of the 93,358-customer population used in the churn calculation.

The project's rule-based definition classifies customers as churned when they have no subsequent delivered purchase and at least 180 days have elapsed since their last qualifying purchase.

### How many customers are at risk?

The RFM analysis identified **22,033 customers** in the At Risk segment.

This is different from the total churn population because RFM risk classification and churn status are separate analytical measures.

### How much revenue is associated with at-risk customers?

Approximately **R$7.74 million** is associated with customers classified as Critical Risk or High Risk in the customer-risk analysis.

This represents revenue associated with these customer groups, not a guaranteed amount of future revenue loss.

### Which high-value customers are at risk?

The analysis identified **114 customers** in the High Value At Risk segment. These customers are potential priorities for targeted retention campaigns.

### Which customer segments have the highest churn?

Potential Customers form the largest RFM segment, with **33,776 customers**, followed by the At Risk segment with 22,033 customers.

The largest segment does not necessarily have the highest churn rate. A proper comparison requires calculating the proportion of churned customers within each segment.

---

## 5. Business Recommendations

### 1. Improve first-to-second purchase conversion

With only 2,801 identified repeat customers, improving repeat purchasing is an important opportunity.

- Test post-purchase email campaigns and personalized product recommendations.
- Offer targeted second-purchase incentives where economically justified.
- Track second-purchase conversion and repeat revenue.

### 2. Prioritize valuable customers at risk

The At Risk segment contributes approximately R$4.71 million in revenue.

- Prioritize valuable customers who have not purchased recently.
- Test personalized win-back campaigns.
- Measure recovered customers and revenue after each campaign.

### 3. Focus on strong geographic markets

São Paulo is the leading revenue-generating state.

- Investigate purchasing patterns and category preferences in São Paulo.
- Compare repeat-purchase rates across states.
- Evaluate targeted campaigns in major revenue-generating markets.

### 4. Investigate leading product categories

Health & Beauty and Watches & Gifts appear among the leading categories in the dashboard analysis.

- Validate category revenue against the final SQL results.
- Compare category-level order volume, repeat purchases, and average order value.
- Evaluate profit margins and costs before making investment decisions.

### 5. Convert new customers into loyal customers

Potential Customers represent the largest RFM segment, with 33,776 customers.

- Identify customers most likely to make another purchase.
- Use relevant cross-selling and product recommendations.
- Track movement from Potential Customers to Loyal Customers or Champions.

### 6. Validate product performance before cutting categories

The analysis measures revenue and purchasing behavior, but it does not establish customer age or prove that any category is operating at a loss.

Before reducing investment in children's products or expanding furniture sales, investigate revenue, order volume, returns, product costs, and margins where available.

---

## 6. Overall Conclusion

The analysis highlights substantial revenue growth across the observed period, with São Paulo as the leading revenue-generating state and November 2017 as the highest-revenue month.

Customer retention is an important area for improvement. The processed analysis identifies 2,801 repeat customers, while the rule-based churn model identifies 55,381 churned customers. The At Risk RFM segment contains 22,033 customers and contributes approximately R$4.71 million in revenue. The customer-risk analysis associates approximately R$7.74 million with Critical Risk and High Risk customers.

The business should focus on improving first-to-second purchase conversion, re-engaging valuable inactive customers, and evaluating retention across customer segments and geographic markets.

**Note:** These findings are based on the available dataset and the project's current analytical definitions. Cohort-retention percentages and category-level revenue figures require validation against the final SQL outputs. All reported metrics should also be cross-checked to identify potential calculation errors before being treated as definitive conclusions.