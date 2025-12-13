-- Создание схемы dds
CREATE SCHEMA IF NOT EXISTS dds;

-- ===== ХАБЫ (HUBS) =====

-- HUB_CUSTOMER
CREATE TABLE IF NOT EXISTS dds.hub_customer (
    hk_customer_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ клиента',
    customer_bk VARCHAR(50) NOT NULL COMMENT 'Бизнес-ключ клиента (C_CUSTKEY)',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_customer_id)
);

-- HUB_ORDER
CREATE TABLE IF NOT EXISTS dds.hub_order (
    hk_order_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ заказа',
    order_bk VARCHAR(50) NOT NULL COMMENT 'Бизнес-ключ заказа (O_ORDERKEY)',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_order_id)
);

-- HUB_PART
CREATE TABLE IF NOT EXISTS dds.hub_part (
    hk_part_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ товара',
    part_bk VARCHAR(50) NOT NULL COMMENT 'Бизнес-ключ товара (P_PARTKEY)',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_part_id)
);

-- HUB_SUPPLIER
CREATE TABLE IF NOT EXISTS dds.hub_supplier (
    hk_supplier_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ поставщика',
    supplier_bk VARCHAR(50) NOT NULL COMMENT 'Бизнес-ключ поставщика (S_SUPPKEY)',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_supplier_id)
);

-- HUB_NATION
CREATE TABLE IF NOT EXISTS dds.hub_nation (
    hk_nation_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ страны',
    nation_bk VARCHAR(50) NOT NULL COMMENT 'Бизнес-ключ страны (N_NATIONKEY)',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_nation_id)
);

-- HUB_REGION
CREATE TABLE IF NOT EXISTS dds.hub_region (
    hk_region_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ региона',
    region_bk VARCHAR(50) NOT NULL COMMENT 'Бизнес-ключ региона (R_REGIONKEY)',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_region_id)
);

-- ===== ЛИНКИ (LINKS) =====

-- LINK_ORDER (связь заказа с клиентом)
CREATE TABLE IF NOT EXISTS dds.link_order (
    hk_order_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи заказ-клиент',
    hk_order_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ заказа',
    hk_customer_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ клиента',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_order_link_id),
    FOREIGN KEY (hk_order_id) REFERENCES dds.hub_order(hk_order_id),
    FOREIGN KEY (hk_customer_id) REFERENCES dds.hub_customer(hk_customer_id)
);

-- LINK_LINEITEM (связь строки заказа с товаром и поставщиком)
CREATE TABLE IF NOT EXISTS dds.link_lineitem (
    hk_lineitem_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи строки заказа',
    hk_order_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ заказа',
    hk_part_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ товара',
    hk_supplier_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ поставщика',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    line_number INTEGER NOT NULL COMMENT 'Номер строки в заказе',
    PRIMARY KEY (hk_lineitem_link_id),
    FOREIGN KEY (hk_order_id) REFERENCES dds.hub_order(hk_order_id),
    FOREIGN KEY (hk_part_id) REFERENCES dds.hub_part(hk_part_id),
    FOREIGN KEY (hk_supplier_id) REFERENCES dds.hub_supplier(hk_supplier_id)
);

-- LINK_PARTSUPP (связь товара с поставщиком)
CREATE TABLE IF NOT EXISTS dds.link_partsupp (
    hk_partsupp_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи товар-поставщик',
    hk_part_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ товара',
    hk_supplier_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ поставщика',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_partsupp_link_id),
    FOREIGN KEY (hk_part_id) REFERENCES dds.hub_part(hk_part_id),
    FOREIGN KEY (hk_supplier_id) REFERENCES dds.hub_supplier(hk_supplier_id)
);

-- LINK_CUSTOMER_NATION (связь клиента со страной)
CREATE TABLE IF NOT EXISTS dds.link_customer_nation (
    hk_customer_nation_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи клиент-страна',
    hk_customer_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ клиента',
    hk_nation_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ страны',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_customer_nation_link_id),
    FOREIGN KEY (hk_customer_id) REFERENCES dds.hub_customer(hk_customer_id),
    FOREIGN KEY (hk_nation_id) REFERENCES dds.hub_nation(hk_nation_id)
);

-- LINK_SUPPLIER_NATION (связь поставщика со страной)
CREATE TABLE IF NOT EXISTS dds.link_supplier_nation (
    hk_supplier_nation_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи поставщик-страна',
    hk_supplier_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ поставщика',
    hk_nation_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ страны',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_supplier_nation_link_id),
    FOREIGN KEY (hk_supplier_id) REFERENCES dds.hub_supplier(hk_supplier_id),
    FOREIGN KEY (hk_nation_id) REFERENCES dds.hub_nation(hk_nation_id)
);

-- LINK_NATION_REGION (связь страны с регионом)
CREATE TABLE IF NOT EXISTS dds.link_nation_region (
    hk_nation_region_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи страна-регион',
    hk_nation_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ страны',
    hk_region_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ региона',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    PRIMARY KEY (hk_nation_region_link_id),
    FOREIGN KEY (hk_nation_id) REFERENCES dds.hub_nation(hk_nation_id),
    FOREIGN KEY (hk_region_id) REFERENCES dds.hub_region(hk_region_id)
);

-- ===== СПУТНИКИ (SATELLITES) =====

-- SAT_CUSTOMER_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_customer_details (
    hk_customer_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ клиента',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    customer_name VARCHAR(255) COMMENT 'Имя клиента',
    customer_address VARCHAR(255) COMMENT 'Адрес клиента',
    customer_phone VARCHAR(15) COMMENT 'Телефон клиента',
    customer_acctbal DECIMAL(15,2) COMMENT 'Баланс счета клиента',
    customer_mktsegment VARCHAR(10) COMMENT 'Сегмент рынка клиента',
    customer_comment VARCHAR(117) COMMENT 'Комментарий о клиенте',
    PRIMARY KEY (hk_customer_id, load_dts),
    FOREIGN KEY (hk_customer_id) REFERENCES dds.hub_customer(hk_customer_id)
);

-- SAT_ORDER_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_order_details (
    hk_order_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ заказа',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    order_status CHAR(1) COMMENT 'Статус заказа',
    order_totalprice DECIMAL(15,2) COMMENT 'Общая стоимость заказа',
    order_date DATE COMMENT 'Дата заказа',
    order_priority VARCHAR(15) COMMENT 'Приоритет заказа',
    order_clerk VARCHAR(15) COMMENT 'Клерк, обработавший заказ',
    order_shippriority INTEGER COMMENT 'Приоритет доставки',
    order_comment VARCHAR(79) COMMENT 'Комментарий к заказу',
    PRIMARY KEY (hk_order_id, load_dts),
    FOREIGN KEY (hk_order_id) REFERENCES dds.hub_order(hk_order_id)
);

-- SAT_LINEITEM_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_lineitem_details (
    hk_lineitem_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи строки заказа',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    lineitem_quantity DECIMAL(15,2) COMMENT 'Количество',
    lineitem_extendedprice DECIMAL(15,2) COMMENT 'Расширенная цена',
    lineitem_discount DECIMAL(15,2) COMMENT 'Скидка',
    lineitem_tax DECIMAL(15,2) COMMENT 'Налог',
    lineitem_returnflag CHAR(1) COMMENT 'Флаг возврата',
    lineitem_linestatus CHAR(1) COMMENT 'Статус строки',
    lineitem_shipdate DATE COMMENT 'Дата отгрузки',
    lineitem_commitdate DATE COMMENT 'Дата подтверждения',
    lineitem_receiptdate DATE COMMENT 'Дата получения',
    lineitem_shipinstruct VARCHAR(25) COMMENT 'Инструкции по отгрузке',
    lineitem_shipmode VARCHAR(10) COMMENT 'Способ отгрузки',
    lineitem_comment VARCHAR(44) COMMENT 'Комментарий к строке заказа',
    PRIMARY KEY (hk_lineitem_link_id, load_dts),
    FOREIGN KEY (hk_lineitem_link_id) REFERENCES dds.link_lineitem(hk_lineitem_link_id)
);

-- SAT_PART_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_part_details (
    hk_part_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ товара',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    part_name VARCHAR(55) COMMENT 'Название товара',
    part_mfgr VARCHAR(25) COMMENT 'Производитель',
    part_brand VARCHAR(10) COMMENT 'Бренд',
    part_type VARCHAR(25) COMMENT 'Тип товара',
    part_size INTEGER COMMENT 'Размер',
    part_container VARCHAR(10) COMMENT 'Контейнер',
    part_retailprice DECIMAL(15,2) COMMENT 'Розничная цена',
    part_comment VARCHAR(23) COMMENT 'Комментарий о товаре',
    PRIMARY KEY (hk_part_id, load_dts),
    FOREIGN KEY (hk_part_id) REFERENCES dds.hub_part(hk_part_id)
);

-- SAT_SUPPLIER_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_supplier_details (
    hk_supplier_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ поставщика',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    supplier_name VARCHAR(25) COMMENT 'Имя поставщика',
    supplier_address VARCHAR(40) COMMENT 'Адрес поставщика',
    supplier_phone VARCHAR(15) COMMENT 'Телефон поставщика',
    supplier_acctbal DECIMAL(15,2) COMMENT 'Баланс счета поставщика',
    supplier_comment VARCHAR(101) COMMENT 'Комментарий о поставщике',
    PRIMARY KEY (hk_supplier_id, load_dts),
    FOREIGN KEY (hk_supplier_id) REFERENCES dds.hub_supplier(hk_supplier_id)
);

-- SAT_PARTSUPP_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_partsupp_details (
    hk_partsupp_link_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ связи товар-поставщик',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    partsupp_availqty INTEGER COMMENT 'Доступное количество',
    partsupp_supplycost DECIMAL(15,2) COMMENT 'Стоимость поставки',
    partsupp_comment VARCHAR(199) COMMENT 'Комментарий о поставке',
    PRIMARY KEY (hk_partsupp_link_id, load_dts),
    FOREIGN KEY (hk_partsupp_link_id) REFERENCES dds.link_partsupp(hk_partsupp_link_id)
);

-- SAT_NATION_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_nation_details (
    hk_nation_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ страны',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    nation_name VARCHAR(25) COMMENT 'Название страны',
    nation_comment VARCHAR(152) COMMENT 'Комментарий о стране',
    PRIMARY KEY (hk_nation_id, load_dts),
    FOREIGN KEY (hk_nation_id) REFERENCES dds.hub_nation(hk_nation_id)
);

-- SAT_REGION_DETAILS
CREATE TABLE IF NOT EXISTS dds.sat_region_details (
    hk_region_id VARCHAR(32) NOT NULL COMMENT 'Хеш-ключ региона',
    load_dts TIMESTAMP NOT NULL COMMENT 'Дата загрузки',
    rec_src VARCHAR(50) NOT NULL COMMENT 'Источник записи',
    region_name VARCHAR(25) COMMENT 'Название региона',
    region_comment VARCHAR(152) COMMENT 'Комментарий о регионе',
    PRIMARY KEY (hk_region_id, load_dts),
    FOREIGN KEY (hk_region_id) REFERENCES dds.hub_region(hk_region_id)
);
