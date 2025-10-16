-- Шаг 1: Создаем внешнюю таблицу для чтения csv файла (предварительно создан ключ для сервисного аккаунта и прописан в LOCATION)

DROP EXTERNAL TABLE IF EXISTS ext_superstore_data;

CREATE EXTERNAL TABLE ext_superstore_data (
    ship_mode VARCHAR(50),
    segment VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    sales NUMERIC(12,4),      
    quantity INTEGER,         
    discount NUMERIC(5,4),    
    profit NUMERIC(12,4)
) 
LOCATION ('pxf://hw-for-dss/SampleSuperstore.csv?PROFILE=s3:text&accesskey=YCAJEBTaYB4dYJNXx8nAcr4ey&secretkey=<secretkey>&endpoint=storage.yandexcloud.net') 
FORMAT 'CSV' (HEADER);

-- Шаг 2: Заполняем Хабы

-- HUB_CUSTOMER_SEGMENT
INSERT INTO hub_customer_segment (
    hk_customer_segment_id,
    business_key, 
    load_dts,
    record_source
)
SELECT DISTINCT
    MD5(segment || '|' || city || '|' || state || '|' || postal_code) as hk_customer_segment_id,
    segment || '|' || city || '|' || state || '|' || postal_code as business_key,
    NOW() as load_dts,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- HUB_PRODUCT
INSERT INTO hub_product (
    hk_product_id,
    business_key,
    load_dts, 
    record_source
)
SELECT DISTINCT
    MD5(sub_category || '|' || category) as hk_product_id,
    sub_category || '|' || category as business_key,
    NOW() as load_dts,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- HUB_LOCATION  
INSERT INTO hub_location (
    hk_location_id,
    business_key,
    load_dts,
    record_source
)
SELECT DISTINCT
    MD5(postal_code) as hk_location_id,
    postal_code as business_key,
    NOW() as load_dts,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- HUB_SHIP_MODE
INSERT INTO hub_ship_mode (
    hk_ship_mode_id, 
    business_key,
    load_dts,
    record_source
)
SELECT DISTINCT
    MD5(ship_mode) as hk_ship_mode_id,
    ship_mode as business_key,
    NOW() as load_dts,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- Шаг 3: Заполняем Линк транзакций

INSERT INTO link_sales_transaction (
    hk_sales_id,
    hk_customer_segment_id,
    hk_product_id, 
    hk_location_id,
    hk_ship_mode_id,
    load_dts,
    record_source
)
SELECT
    MD5(
        MD5(segment || '|' || city || '|' || state || '|' || postal_code) || '|' ||
        MD5(sub_category || '|' || category) || '|' ||
        MD5(postal_code) || '|' ||
        MD5(ship_mode) || '|' ||
        row_number() over()::text
    ) as hk_sales_id,
    MD5(segment || '|' || city || '|' || state || '|' || postal_code) as hk_customer_segment_id,
    MD5(sub_category || '|' || category) as hk_product_id,
    MD5(postal_code) as hk_location_id, 
    MD5(ship_mode) as hk_ship_mode_id,
    NOW() as load_dts,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- Шаг 4: Заполняем Спутники

-- SAT_CUSTOMER_SEGMENT_DETAILS
INSERT INTO sat_customer_segment_details (
    hk_customer_segment_id,
    load_dts,
    segment,
    city, 
    state,
    postal_code,
    region,
    country,
    hash_diff,
    record_source
)
SELECT DISTINCT
    MD5(segment || '|' || city || '|' || state || '|' || postal_code) as hk_customer_segment_id,
    NOW() as load_dts,
    segment,
    city,
    state,
    postal_code, 
    region,
    country,
    MD5(
        COALESCE(segment, '') || '|' ||
        COALESCE(city, '') || '|' || 
        COALESCE(state, '') || '|' ||
        COALESCE(postal_code, '') || '|' ||
        COALESCE(region, '') || '|' ||
        COALESCE(country, '')
    ) as hash_diff,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- SAT_PRODUCT_DETAILS
INSERT INTO sat_product_details (
    hk_product_id,
    load_dts,
    category,
    sub_category,
    hash_diff,
    record_source
)
SELECT DISTINCT
    MD5(sub_category || '|' || category) as hk_product_id,
    NOW() as load_dts,
    category,
    sub_category,
    MD5(
        COALESCE(category, '') || '|' || 
        COALESCE(sub_category, '')
    ) as hash_diff,
    'Superstore_CSV' as record_source   
FROM ext_superstore_data;

-- SAT_LOCATION_DETAILS
INSERT INTO sat_location_details (
    hk_location_id,
    load_dts, 
    city,
    state,
    region,
    country,
    hash_diff,
    record_source
)
SELECT DISTINCT
    MD5(postal_code) as hk_location_id,
    NOW() as load_dts,
    city,
    state,
    region,
    country,
    MD5(
        COALESCE(city, '') || '|' ||
        COALESCE(state, '') || '|' || 
        COALESCE(region, '') || '|' ||
        COALESCE(country, '')
    ) as hash_diff,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- SAT_SHIP_MODE_DETAILS
INSERT INTO sat_ship_mode_details (
    hk_ship_mode_id,
    load_dts,
    ship_mode,
    hash_diff,
    record_source
)
SELECT DISTINCT
    MD5(ship_mode) as hk_ship_mode_id,
    NOW() as load_dts,
    ship_mode,
    MD5(COALESCE(ship_mode, '')) as hash_diff,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- SAT_SALES_DETAILS
INSERT INTO sat_sales_details (
    hk_sales_id,
    load_dts,
    sales,
    quantity,
    discount,
    profit, 
    hash_diff,
    record_source
)
SELECT
    MD5(
        MD5(segment || '|' || city || '|' || state || '|' || postal_code) || '|' ||
        MD5(sub_category || '|' || category) || '|' ||
        MD5(postal_code) || '|' ||
        MD5(ship_mode) || '|' ||
        row_number() over()::text
    ) as hk_sales_id,
    NOW() as load_dts,
    sales,
    quantity,
    discount,
    profit,
    MD5(
        COALESCE(sales::text, '') || '|' ||
        COALESCE(quantity::text, '') || '|' || 
        COALESCE(discount::text, '') || '|' ||
        COALESCE(profit::text, '')
    ) as hash_diff,
    'Superstore_CSV' as record_source
FROM ext_superstore_data;

-- Шаг 5: Удаляем внешнюю таблицу, что создали в Шаг 1

DROP EXTERNAL TABLE IF EXISTS ext_superstore_data;
