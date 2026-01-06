CREATE SCHEMA IF NOT EXISTS raw;

-- SOURCE 1: E-COMMERCE

DROP TABLE IF EXISTS raw.ecommerce_raw;

CREATE TABLE raw.ecommerce_raw (
    item_id TEXT,
    status TEXT,
    created_at TEXT,
    sku TEXT,
    price TEXT,
    qty_ordered TEXT,
    grand_total TEXT,
    increment_id TEXT,
    category_name_1 TEXT,
    sales_commission_code TEXT,
    discount_amount TEXT,
    payment_method TEXT,
    working_date TEXT,
    bi_status TEXT,
    mv TEXT,
    year TEXT,
    month TEXT,
    customer_since TEXT,
    m_y TEXT,
    fy TEXT,
    customer_id TEXT
);

COPY raw.ecommerce_raw
FROM 'C:/UAS/raw/source1/ecommerce_raw.csv'
DELIMITER ','
CSV HEADER;


-- SOURCE 2: HOLIDAY

DROP TABLE IF EXISTS raw.holiday_raw;

CREATE TABLE raw.holiday_raw (
    adm_name TEXT,
    iso3 TEXT,
    date TEXT,
    name TEXT,
    type TEXT
);

COPY raw.holiday_raw
FROM 'C:/UAS/raw/source2/holiday_raw.csv'
DELIMITER ','
CSV HEADER;
