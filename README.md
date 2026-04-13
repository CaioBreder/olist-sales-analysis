# Sales Analysis — Olist E-commerce

Exploratory data analysis of a Brazilian e-commerce platform focused on revenue trends, customer satisfaction, and regional performance.

---

## Objective

Identify sales patterns, most profitable product categories, regional behavior, and customer satisfaction levels across a Brazilian marketplace, generating actionable business insights.

---

## Dataset

- **Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Period:** 2016 to 2018
- **Size:** ~100,000 orders across 8 relational tables
- **Type:** Real anonymized data

---

## Tools

| Tool | Usage |
|---|---|
| SQL (MySQL) | Data extraction, cleaning and transformation |
| Power BI | Interactive dashboard and data visualization |
| GitHub | Version control and documentation |

---

## Business Questions

1. How did revenue evolve over time?
2. Which product categories generate the most revenue?
3. Which states have the highest average order value?
4. What is the overall customer satisfaction level?
5. Which categories have the best and worst reviews?
6. What is the average delivery time by state?
7. Which payment methods are most popular?

---

## Repository Structure

```
olist-sales-analysis/
│
├── queries.sql        # All SQL queries used in the analysis
├── README.md          # Project documentation
└── dashboard/         # Power BI dashboard screenshots
```

---

## Key Insights

> Fill in with the real numbers found in your analysis

- Revenue grew **X%** between [start month] and [end month]
- The **top 3 categories** by revenue were: [category 1], [category 2], and [category 3]
- The state with the highest average order value was **[state]**, at $[value]
- **X%** of customers gave ratings of 4 or 5 stars (positive reviews)
- Average delivery time was **X days**, ranging from [min] to [max] days by state
- The most used payment method was **[type]**, accounting for X% of all orders

---

## Dashboard — Power BI

The dashboard is divided into 4 pages:

**Page 1 — Overview**
- KPI cards: Total Revenue, Total Orders, Avg Order Value, Avg Rating
- Line chart: Monthly revenue over time

**Page 2 — Products**
- Bar chart: Top 10 categories by revenue
- Treemap: Category share of total sales

**Page 3 — Customers & Regions**
- Map of Brazil with revenue by state
- Bar chart: Average order value by state

**Page 4 — Satisfaction**
- Donut chart: Review score distribution (1 to 5)
- KPI: Percentage of positive reviews (score ≥ 4)
- Category ranking by average score

---

## How to Reproduce

1. Go to [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and download the dataset
2. Import the `.csv` files into a MySQL (or SQLite) database
3. Run the queries in `queries.sql` in order
4. Import the results into Power BI and build the dashboard

---

## Contact

**Caio Breder Bernardo-de-Lima**  
[LinkedIn](https://www.linkedin.com/in/caio-bernardo-de-lima-6a4010240/?skipRedirect=true) | [GitHub](https://github.com/CaioBreder)
