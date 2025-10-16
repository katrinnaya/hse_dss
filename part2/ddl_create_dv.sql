-- ХАБЫ. Бизнес-сущности

-- 1. Хаб сегментов клиентов
CREATE TABLE hub_customer_segment (
    hk_customer_segment_id VARCHAR(32) PRIMARY KEY,
    business_key VARCHAR(500) NOT NULL,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
) DISTRIBUTED BY (hk_customer_segment_id);

COMMENT ON TABLE hub_customer_segment IS 'Хаб сегментов клиентов в локациях';
COMMENT ON COLUMN hub_customer_segment.hk_customer_segment_id IS 'Хэш-ключ сегмента клиентов';
COMMENT ON COLUMN hub_customer_segment.business_key IS 'Бизнес-ключ: Segment+City+State+PostalCode';
COMMENT ON COLUMN hub_customer_segment.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN hub_customer_segment.record_source IS 'Источник данных: файл Superstore';

-- 2. Хаб продуктов
CREATE TABLE hub_product (
    hk_product_id VARCHAR(32) PRIMARY KEY,
    business_key VARCHAR(500) NOT NULL,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
) DISTRIBUTED BY (hk_product_id);

COMMENT ON TABLE hub_product IS 'Хаб товаров';
COMMENT ON COLUMN hub_product.hk_product_id IS 'Хэш-ключ продукта';
COMMENT ON COLUMN hub_product.business_key IS 'Бизнес-ключ: SubCategory+Category';
COMMENT ON COLUMN hub_product.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN hub_product.record_source IS 'Источник данных: файл Superstore';

-- 3. Хаб локаций
CREATE TABLE hub_location (
    hk_location_id VARCHAR(32) PRIMARY KEY,
    business_key VARCHAR(20) NOT NULL,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
) DISTRIBUTED BY (hk_location_id);

COMMENT ON TABLE hub_location IS 'Хаб локаций';
COMMENT ON COLUMN hub_location.hk_location_id IS 'Хэш-ключ локации';
COMMENT ON COLUMN hub_location.business_key IS 'Бизнес-ключ: PostalCode';
COMMENT ON COLUMN hub_location.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN hub_location.record_source IS 'Источник данных: файл Superstore';

-- 4. Хаб способов доставки
CREATE TABLE hub_ship_mode (
    hk_ship_mode_id VARCHAR(32) PRIMARY KEY,
    business_key VARCHAR(50) NOT NULL,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
) DISTRIBUTED BY (hk_ship_mode_id);

COMMENT ON TABLE hub_ship_mode IS 'Хаб способов доставки';
COMMENT ON COLUMN hub_ship_mode.hk_ship_mode_id IS 'Хэш-ключ способа доставки';
COMMENT ON COLUMN hub_ship_mode.business_key IS 'Бизнес-ключ: ShipMode';
COMMENT ON COLUMN hub_ship_mode.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN hub_ship_mode.record_source IS 'Источник данных: файл Superstore';

-- ССЫЛКИ. Связи между сущностями

-- 5. Линк транзакций продаж
CREATE TABLE link_sales_transaction (
    hk_sales_id VARCHAR(32) PRIMARY KEY,
    hk_customer_segment_id VARCHAR(32) NOT NULL,
    hk_product_id VARCHAR(32) NOT NULL,
    hk_location_id VARCHAR(32) NOT NULL,
    hk_ship_mode_id VARCHAR(32) NOT NULL,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
) DISTRIBUTED BY (hk_sales_id);

COMMENT ON TABLE link_sales_transaction IS 'Линк транзакций продаж (связывает все сущности)';
COMMENT ON COLUMN link_sales_transaction.hk_sales_id IS 'Хэш-ключ транзакции';
COMMENT ON COLUMN link_sales_transaction.hk_customer_segment_id IS 'Ссылка на хаб сегмента клиентов';
COMMENT ON COLUMN link_sales_transaction.hk_product_id IS 'Ссылка на хаб товара';
COMMENT ON COLUMN link_sales_transaction.hk_location_id IS 'Ссылка на хаб локации';
COMMENT ON COLUMN link_sales_transaction.hk_ship_mode_id IS 'Ссылка на хаб способа доставки';
COMMENT ON COLUMN link_sales_transaction.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN link_sales_transaction.record_source IS 'Источник данных: файл Superstore';

-- СПУТНИКИ. Описательные атрибуты

-- 6. Спутник деталей сегментов клиентов
CREATE TABLE sat_customer_segment_details (
    hk_customer_segment_id VARCHAR(32),
    load_dts TIMESTAMP,
    segment VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    country VARCHAR(50),
    hash_diff VARCHAR(32),
    record_source VARCHAR(50)
) DISTRIBUTED BY (hk_customer_segment_id);

COMMENT ON TABLE sat_customer_segment_details IS 'Спутник деталей сегментов клиентов';
COMMENT ON COLUMN sat_customer_segment_details.hk_customer_segment_id IS 'Ссылка на хаб сегмента клиентов';
COMMENT ON COLUMN sat_customer_segment_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN sat_customer_segment_details.hash_diff IS 'Хэш всех атрибутов для отслеживания изменений';

-- 7. Спутник деталей продуктов
CREATE TABLE sat_product_details (
    hk_product_id VARCHAR(32),
    load_dts TIMESTAMP,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    hash_diff VARCHAR(32),
    record_source VARCHAR(50)
) DISTRIBUTED BY (hk_product_id);

COMMENT ON TABLE sat_product_details IS 'Спутник деталей продуктов';
COMMENT ON COLUMN sat_product_details.hk_product_id IS 'Ссылка на хаб товара';
COMMENT ON COLUMN sat_product_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN sat_product_details.hash_diff IS 'Хэш всех атрибутов для отслеживания изменений';

-- 8. Спутник деталей локаций
CREATE TABLE sat_location_details (
    hk_location_id VARCHAR(32),
    load_dts TIMESTAMP,
    city VARCHAR(100),
    state VARCHAR(100),
    region VARCHAR(20),
    country VARCHAR(50),
    hash_diff VARCHAR(32),
    record_source VARCHAR(50)
) DISTRIBUTED BY (hk_location_id);

COMMENT ON TABLE sat_location_details IS 'Спутник деталей локаций';
COMMENT ON COLUMN sat_location_details.hk_location_id IS 'Ссылка на хаб локации';
COMMENT ON COLUMN sat_location_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN sat_location_details.hash_diff IS 'Хэш всех атрибутов для отслеживания изменений';

-- 9. Спутник деталей способов доставки
CREATE TABLE sat_ship_mode_details (
    hk_ship_mode_id VARCHAR(32),
    load_dts TIMESTAMP,
    ship_mode VARCHAR(50),
    hash_diff VARCHAR(32),
    record_source VARCHAR(50)
) DISTRIBUTED BY (hk_ship_mode_id);

COMMENT ON TABLE sat_ship_mode_details IS 'Спутник деталей способов доставки';
COMMENT ON COLUMN sat_ship_mode_details.hk_ship_mode_id IS 'Ссылка на хаб способа доставки';
COMMENT ON COLUMN sat_ship_mode_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN sat_ship_mode_details.hash_diff IS 'Хэш всех атрибутов для отслеживания изменений';

-- 10. Спутник деталей продаж
CREATE TABLE sat_sales_details (
    hk_sales_id VARCHAR(32),
    load_dts TIMESTAMP,
    sales NUMERIC(10,2),
    quantity INTEGER,
    discount NUMERIC(5,2),
    profit NUMERIC(10,2),
    hash_diff VARCHAR(32),
    record_source VARCHAR(50)
) DISTRIBUTED BY (hk_sales_id);

COMMENT ON TABLE sat_sales_details IS 'Спутник деталей продаж (метрики транзакций)';
COMMENT ON COLUMN sat_sales_details.hk_sales_id IS 'Ссылка на линк транзакции';
COMMENT ON COLUMN sat_sales_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN sat_sales_details.sales IS 'Сумма продажи';
COMMENT ON COLUMN sat_sales_details.quantity IS 'Количество товара';
COMMENT ON COLUMN sat_sales_details.discount IS 'Размер скидки';
COMMENT ON COLUMN sat_sales_details.profit IS 'Прибыль от продажи';
COMMENT ON COLUMN sat_sales_details.hash_diff IS 'Хэш всех атрибутов для отслеживания изменений';

-- ВНЕШНИЕ КЛЮЧИ

ALTER TABLE link_sales_transaction 
ADD CONSTRAINT fk_link_sales_customer 
FOREIGN KEY (hk_customer_segment_id) 
REFERENCES hub_customer_segment(hk_customer_segment_id);

ALTER TABLE link_sales_transaction 
ADD CONSTRAINT fk_link_sales_product 
FOREIGN KEY (hk_product_id) 
REFERENCES hub_product(hk_product_id);

ALTER TABLE link_sales_transaction 
ADD CONSTRAINT fk_link_sales_location 
FOREIGN KEY (hk_location_id) 
REFERENCES hub_location(hk_location_id);

ALTER TABLE link_sales_transaction 
ADD CONSTRAINT fk_link_sales_ship_mode 
FOREIGN KEY (hk_ship_mode_id) 
REFERENCES hub_ship_mode(hk_ship_mode_id);

ALTER TABLE sat_customer_segment_details 
ADD CONSTRAINT fk_sat_customer_hub 
FOREIGN KEY (hk_customer_segment_id) 
REFERENCES hub_customer_segment(hk_customer_segment_id);

ALTER TABLE sat_product_details 
ADD CONSTRAINT fk_sat_product_hub 
FOREIGN KEY (hk_product_id) 
REFERENCES hub_product(hk_product_id);

ALTER TABLE sat_location_details 
ADD CONSTRAINT fk_sat_location_hub 
FOREIGN KEY (hk_location_id) 
REFERENCES hub_location(hk_location_id);

ALTER TABLE sat_ship_mode_details 
ADD CONSTRAINT fk_sat_ship_mode_hub 
FOREIGN KEY (hk_ship_mode_id) 
REFERENCES hub_ship_mode(hk_ship_mode_id);

ALTER TABLE sat_sales_details 
ADD CONSTRAINT fk_sat_sales_link 
FOREIGN KEY (hk_sales_id) 
REFERENCES link_sales_transaction(hk_sales_id);

-- ИНДЕКСЫ (оптимизация запросов)


CREATE INDEX idx_hub_customer_business_key ON hub_customer_segment(business_key);
CREATE INDEX idx_hub_product_business_key ON hub_product(business_key);
CREATE INDEX idx_hub_location_business_key ON hub_location(business_key);
CREATE INDEX idx_hub_ship_mode_business_key ON hub_ship_mode(business_key);

CREATE INDEX idx_link_sales_customer ON link_sales_transaction(hk_customer_segment_id);
CREATE INDEX idx_link_sales_product ON link_sales_transaction(hk_product_id);
CREATE INDEX idx_link_sales_location ON link_sales_transaction(hk_location_id);
CREATE INDEX idx_link_sales_ship_mode ON link_sales_transaction(hk_ship_mode_id);
