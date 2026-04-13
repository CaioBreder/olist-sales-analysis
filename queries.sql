-- ============================================================
-- PROJECT 1: Sales Analysis — Olist E-commerce
-- Dataset: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
-- Tool: MySQL / PostgreSQL / SQLite
-- Author: Caio Breder Bernardo-de-Lima
-- ============================================================


-- ------------------------------------------------------------
-- 1. OVERVIEW: total revenue, orders and average order value
-- ------------------------------------------------------------
SELECT
    COUNT(DISTINCT o.order_id)                                      AS total_orders,
    ROUND(SUM(p.payment_value), 2)                                  AS total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2)    AS avg_order_value
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';


-- ------------------------------------------------------------
-- 2. MONTHLY TREND: revenue and orders over time
-- ------------------------------------------------------------
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id)                        AS total_orders,
    ROUND(SUM(p.payment_value), 2)                    AS total_revenue,
    ROUND(SUM(p.payment_value) /
          COUNT(DISTINCT o.order_id), 2)              AS avg_order_value
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;


-- ------------------------------------------------------------
-- 3. TOP 10 CATEGORIES by revenue and volume
-- ------------------------------------------------------------
SELECT
    t.product_category_name_english     AS category,
    COUNT(DISTINCT oi.order_id)         AS total_orders,
    COUNT(oi.order_item_id)             AS total_items,
    ROUND(SUM(oi.price), 2)             AS total_revenue,
    ROUND(AVG(oi.price), 2)             AS avg_price
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN product_category_name_translation t
    ON pr.product_category_name = t.product_category_name
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 4. REGIONAL ANALYSIS: revenue and avg order value by state
-- ------------------------------------------------------------
SELECT
    c.customer_state                                                AS state,
    COUNT(DISTINCT o.order_id)                                      AS total_orders,
    ROUND(SUM(p.payment_value), 2)                                  AS total_revenue,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2)    AS avg_order_value
FROM orders o
JOIN customers c        ON o.customer_id = c.customer_id
JOIN order_payments p   ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY state
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 5. CUSTOMER SATISFACTION: review score distribution
-- ------------------------------------------------------------
SELECT
    review_score                                                        AS score,
    COUNT(*)                                                            AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2)                 AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;


-- ------------------------------------------------------------
-- 6. SATISFACTION BY CATEGORY: avg score per category
-- ------------------------------------------------------------
SELECT
    t.product_category_name_english     AS category,
    ROUND(AVG(r.review_score), 2)       AS avg_score,
    COUNT(r.review_id)                  AS total_reviews
FROM order_reviews r
JOIN orders o       ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products pr    ON oi.product_id = pr.product_id
JOIN product_category_name_translation t
    ON pr.product_category_name = t.product_category_name
GROUP BY category
HAVING total_reviews > 50
ORDER BY avg_score DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 7. DELIVERY TIME: average delivery days by state
-- ------------------------------------------------------------
SELECT
    c.customer_state                                    AS state,
    COUNT(DISTINCT o.order_id)                          AS total_orders,
    ROUND(AVG(
        DATEDIFF(
            o.order_delivered_customer_date,
            o.order_purchase_timestamp
        )
    ), 1)                                               AS avg_delivery_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY state
ORDER BY avg_delivery_days ASC;


-- ------------------------------------------------------------
-- 8. PAYMENT METHODS: customer preferences
-- ------------------------------------------------------------
SELECT
    payment_type                                        AS payment_method,
    COUNT(DISTINCT order_id)                            AS total_orders,
    ROUND(SUM(payment_value), 2)                        AS total_value,
    ROUND(AVG(payment_installments), 1)                 AS avg_installments
FROM order_payments
WHERE payment_type != 'not_defined'
GROUP BY payment_method
ORDER BY total_orders DESC;
