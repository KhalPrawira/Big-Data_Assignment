-- 1. Monthly Sales
DROP TABLE IF EXISTS mart.agg_monthly_sales;

CREATE TABLE mart.agg_monthly_sales AS
SELECT
    year_month_key,
    COUNT(*) AS total_orders,
    SUM(grand_total) AS total_revenue,
    AVG(grand_total) AS avg_order_value
FROM mart.ecommerce_featured
GROUP BY year_month_key
ORDER BY year_month_key;


-- 2. Holiday vs Non-Holiday
DROP TABLE IF EXISTS mart.agg_holiday_vs_nonholiday;

CREATE TABLE mart.agg_holiday_vs_nonholiday AS
SELECT
    is_holiday,
    COUNT(*) AS total_orders,
    SUM(grand_total) AS total_revenue,
    AVG(grand_total) AS avg_order_value
FROM mart.ecommerce_featured
GROUP BY is_holiday;


-- 3. Day Type
DROP TABLE IF EXISTS mart.agg_day_type;

CREATE TABLE mart.agg_day_type AS
SELECT
    day_type,
    COUNT(*) AS total_orders,
    SUM(grand_total) AS total_revenue
FROM mart.ecommerce_featured
GROUP BY day_type;


-- 4. Order Value Category
DROP TABLE IF EXISTS mart.agg_order_value_category;

CREATE TABLE mart.agg_order_value_category AS
SELECT
    order_value_category,
    COUNT(*) AS total_orders,
    SUM(grand_total) AS total_revenue
FROM mart.ecommerce_featured
GROUP BY order_value_category;


-- 5. Customer Tenure Segment
DROP TABLE IF EXISTS mart.agg_customer_tenure;

CREATE TABLE mart.agg_customer_tenure AS
SELECT
    CASE
        WHEN customer_tenure_days < 30 THEN 'new_customer'
        WHEN customer_tenure_days < 180 THEN 'medium_customer'
        ELSE 'long_term_customer'
    END AS customer_segment,
    COUNT(*) AS total_orders,
    SUM(grand_total) AS total_revenue,
    AVG(grand_total) AS avg_order_value
FROM mart.ecommerce_featured
WHERE customer_tenure_days IS NOT NULL
GROUP BY customer_segment;
