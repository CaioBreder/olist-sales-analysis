# Sales Analysis — Olist E-commerce

Exploratory data analysis of a Brazilian e-commerce platform focused on revenue trends, customer satisfaction, and regional performance.

**Tools:** SQL (MySQL) · Power BI · GitHub  
**Dataset:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — ~100,000 orders · 2016–2018

---

## Business Questions

1. How did revenue evolve over time?
2. Which product categories generate the most revenue?
3. Which states have the highest average order value?
4. What is the overall customer satisfaction level?
5. What is the average delivery time by state?
6. Which payment methods are most popular?

---

## Query 1 — Overview

```sql
SELECT
    COUNT(DISTINCT o.order_id)                                      AS total_orders,
    ROUND(SUM(p.payment_value), 2)                                  AS total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2)    AS avg_order_value
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';
```

**Result:**

| total_orders | total_revenue | avg_order_value |
|---|---|---|
| 96,478 | R$ 13,591,643 | R$ 140.88 |

---

## Query 2 — Monthly Revenue Trend

```sql
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id)                        AS total_orders,
    ROUND(SUM(p.payment_value), 2)                    AS total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY month ORDER BY month;
```

**Result (sample):**

| month | total_orders | total_revenue | avg_order_value |
|---|---|---|---|
| 2017-01 | 812 | R$ 108,942.10 | R$ 134.17 |
| 2017-04 | 2,103 | R$ 290,814.50 | R$ 138.28 |
| 2017-07 | 3,894 | R$ 551,482.30 | R$ 141.62 |
| 2017-10 | 4,671 | R$ 672,103.80 | R$ 143.90 |
| 2018-01 | 6,882 | R$ 989,245.60 | R$ 143.74 |
| 2018-05 | 7,214 | R$ 1,051,382.40 | R$ 145.75 |

> Revenue grew **865%** from January 2017 to May 2018, showing strong and consistent growth.

---

## Query 3 — Top 10 Categories by Revenue

```sql
SELECT
    t.product_category_name_english AS category,
    COUNT(DISTINCT oi.order_id)     AS total_orders,
    ROUND(SUM(oi.price), 2)         AS total_revenue,
    ROUND(AVG(oi.price), 2)         AS avg_price
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN product_category_name_translation t
    ON pr.product_category_name = t.product_category_name
GROUP BY category ORDER BY total_revenue DESC LIMIT 10;
```

**Result:**

| category | total_orders | total_revenue | avg_price |
|---|---|---|---|
| health_beauty | 9,672 | R$ 1,258,442.30 | R$ 127.25 |
| watches_gifts | 8,441 | R$ 1,204,810.50 | R$ 139.72 |
| bed_bath_table | 11,129 | R$ 1,022,391.70 | R$ 89.06 |
| sports_leisure | 8,641 | R$ 989,134.20 | R$ 112.14 |
| computers_accessories | 7,823 | R$ 911,284.60 | R$ 114.00 |
| furniture_decor | 8,334 | R$ 876,320.10 | R$ 103.09 |
| housewares | 9,102 | R$ 821,443.80 | R$ 88.51 |
| telephony | 7,641 | R$ 780,291.40 | R$ 99.87 |
| garden_tools | 6,981 | R$ 734,182.30 | R$ 103.39 |
| toys | 8,214 | R$ 698,241.10 | R$ 83.25 |

> **Health & Beauty** leads in revenue. **Bed, Bath & Table** has the highest order volume.

---

## Query 4 — Revenue by State

```sql
SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY state ORDER BY total_revenue DESC;
```

**Result (top 8):**

| state | total_orders | total_revenue | avg_order_value |
|---|---|---|---|
| SP | 41,746 | R$ 5,981,234.10 | R$ 143.28 |
| RJ | 12,852 | R$ 1,923,410.50 | R$ 149.67 |
| MG | 11,635 | R$ 1,632,841.30 | R$ 140.34 |
| RS | 5,466 | R$ 821,302.40 | R$ 150.27 |
| PR | 5,041 | R$ 712,483.20 | R$ 141.34 |
| SC | 3,637 | R$ 534,291.80 | R$ 146.88 |
| BA | 3,380 | R$ 458,102.60 | R$ 135.53 |
| DF | 2,140 | R$ 334,812.40 | R$ 156.45 |

> **SP** accounts for 44% of all revenue. **DF** has the highest average order value at R$ 156.45.

---

## Query 5 — Customer Satisfaction

```sql
SELECT
    review_score AS score,
    COUNT(*) AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM order_reviews
GROUP BY review_score ORDER BY review_score DESC;
```

**Result:**

| score | total_reviews | percentage |
|---|---|---|
| 5 | 57,328 | 57.78% |
| 4 | 19,142 | 19.29% |
| 3 | 8,179 | 8.24% |
| 2 | 3,151 | 3.18% |
| 1 | 11,424 | 11.51% |

> **77.07%** of customers rated their experience 4 or 5 stars.

---

## Query 6 — Delivery Time by State

```sql
SELECT
    c.customer_state AS state,
    ROUND(AVG(DATEDIFF(
        o.order_delivered_customer_date,
        o.order_purchase_timestamp)), 1) AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY state ORDER BY avg_delivery_days ASC;
```

**Result (fastest and slowest):**

| state | avg_delivery_days |
|---|---|
| SP | 8.4 |
| PR | 10.2 |
| MG | 11.3 |
| RJ | 13.1 |
| ... | ... |
| AM | 26.4 |
| RR | 29.1 |

> Delivery varies from **8.4 days (SP)** to **29.1 days (RR)** — a 3.5x difference across regions.

---

## Query 7 — Payment Methods

```sql
SELECT
    payment_type AS payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_value,
    ROUND(AVG(payment_installments), 1) AS avg_installments
FROM order_payments
WHERE payment_type != 'not_defined'
GROUP BY payment_method ORDER BY total_orders DESC;
```

**Result:**

| payment_method | total_orders | total_value | avg_installments |
|---|---|---|---|
| credit_card | 76,795 | R$ 11,088,432.10 | 3.7 |
| boleto | 19,784 | R$ 2,174,892.40 | 1.0 |
| voucher | 5,775 | R$ 274,382.10 | 1.0 |
| debit_card | 1,529 | R$ 217,842.30 | 1.0 |

> **Credit card** dominates with 76% of all orders, with an average of 3.7 installments.

---

## Key Takeaways

- Revenue grew **865%** in 18 months
- **Health & Beauty** and **Watches & Gifts** are the most profitable categories
- **São Paulo** drives 44% of total revenue
- **77%** of customers are satisfied (4–5 stars)
- Delivery time gap between regions is a clear logistics opportunity
- **Credit card in installments** is the dominant payment method

---

## Contact

**Caio Breder Bernardo-de-Lima**  
[LinkedIn](https://www.linkedin.com/in/caio-bernardo-de-lima-6a4010240/?skipRedirect=true) | [GitHub](https://github.com/CaioBreder)
