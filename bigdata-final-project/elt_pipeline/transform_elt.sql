CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS mart;

-- CLEANING E-COMMERCE

DROP TABLE IF EXISTS staging.ecommerce_clean;

CREATE TABLE staging.ecommerce_clean AS
SELECT *
FROM raw.ecommerce_raw
WHERE item_id IS NOT NULL
  AND status IS NOT NULL;


-- STANDARDIZATION (DATE, NUMERIC)

DROP TABLE IF EXISTS staging.ecommerce_std;

CREATE TABLE staging.ecommerce_std AS
SELECT
    NULLIF(item_id, '')::NUMERIC::BIGINT AS item_id,
    status,
    created_at,
    sku,
    price::NUMERIC,
    qty_ordered::NUMERIC::INT,
    grand_total::NUMERIC,
    increment_id,
    category_name_1,
    sales_commission_code,
    discount_amount::NUMERIC,
    payment_method,

    -- Normalisasi working_date
    CASE
        WHEN working_date ~ '^\d{4}-\d{1,2}$'
            THEN working_date || '-01'
        WHEN working_date ~ '^\d{1,2}/\d{1,2}/\d{4}$'
            THEN TO_CHAR(TO_DATE(working_date,'MM/DD/YYYY'),'YYYY-MM-DD')
        ELSE working_date
    END AS working_date_str,

    bi_status,
    mv,
    NULLIF(year,'')::NUMERIC::INT AS year,
    NULLIF(month,'')::NUMERIC::INT AS month,

    -- Normalisasi customer_since
    CASE
        WHEN customer_since ~ '^\d{4}-\d{1,2}$'
            THEN customer_since || '-01'
        WHEN customer_since ~ '^\d{1,2}/\d{1,2}/\d{4}$'
            THEN TO_CHAR(TO_DATE(customer_since,'MM/DD/YYYY'),'YYYY-MM-DD')
        ELSE customer_since
    END AS customer_since_str,

    m_y,
    fy,
    NULLIF(customer_id,'')::NUMERIC::BIGINT AS customer_id
FROM staging.ecommerce_clean;


-- STANDARDIZE HOLIDAY

DROP TABLE IF EXISTS staging.holiday_std;

CREATE TABLE staging.holiday_std AS
SELECT
    adm_name,
    iso3,
    date::DATE AS holiday_date,
    name AS holiday_name,
    type AS holiday_type
FROM raw.holiday_raw
WHERE date IS NOT NULL;


-- JOIN + FEATURE ENGINEERING

DROP TABLE IF EXISTS mart.ecommerce_featured;

CREATE TABLE mart.ecommerce_featured AS
SELECT
    e.*,

    -- Feature 1
    CASE WHEN h.holiday_date IS NOT NULL THEN 1 ELSE 0 END AS is_holiday,

    -- Feature 2
    CASE
        WHEN h.holiday_date IS NOT NULL THEN 'holiday'
        WHEN EXTRACT(DOW FROM e.working_date_str::DATE) IN (0,6) THEN 'weekend'
        ELSE 'weekday'
    END AS day_type,

    -- Feature 3
    CASE
        WHEN e.grand_total >= 100000 THEN 'high'
        WHEN e.grand_total >= 50000 THEN 'medium'
        ELSE 'low'
    END AS order_value_category,

    -- Feature 4
    (e.working_date_str::DATE - e.customer_since_str::DATE)
        AS customer_tenure_days,

    -- Feature 5
    TO_CHAR(e.working_date_str::DATE,'YYYYMM') AS year_month_key

FROM staging.ecommerce_std e
LEFT JOIN staging.holiday_std h
    ON e.working_date_str::DATE = h.holiday_date;
