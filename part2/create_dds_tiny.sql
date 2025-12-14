-- Удаляем СПУТНИКИ (satellites)
DROP TABLE IF EXISTS memory.dds.sat_lineitem_details;
DROP TABLE IF EXISTS memory.dds.sat_order_details;
DROP TABLE IF EXISTS memory.dds.sat_customer_details;
DROP TABLE IF EXISTS memory.dds.sat_part_details;
DROP TABLE IF EXISTS memory.dds.sat_supplier_details;
DROP TABLE IF EXISTS memory.dds.sat_partsupp_details;
DROP TABLE IF EXISTS memory.dds.sat_nation_details;
DROP TABLE IF EXISTS memory.dds.sat_region_details;

-- Удаляем ЛИНКИ (links)
DROP TABLE IF EXISTS memory.dds.link_lineitem;
DROP TABLE IF EXISTS memory.dds.link_order;
DROP TABLE IF EXISTS memory.dds.link_partsupp;
DROP TABLE IF EXISTS memory.dds.link_customer_nation;
DROP TABLE IF EXISTS memory.dds.link_supplier_nation;
DROP TABLE IF EXISTS memory.dds.link_nation_region;

-- Удаляем ХАБЫ (hubs)
DROP TABLE IF EXISTS memory.dds.hub_customer;
DROP TABLE IF EXISTS memory.dds.hub_order;
DROP TABLE IF EXISTS memory.dds.hub_part;
DROP TABLE IF EXISTS memory.dds.hub_supplier;
DROP TABLE IF EXISTS memory.dds.hub_nation;
DROP TABLE IF EXISTS memory.dds.hub_region;

-- Создание схемы dds в каталоге memory
CREATE SCHEMA IF NOT EXISTS memory.dds;

-- ===== ХАБЫ (HUBS) =====

CREATE TABLE IF NOT exists memory.dds.hub_customer (
    hk_customer_id VARCHAR(32),
    customer_bk VARCHAR(50),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.hub_customer IS 'Хаб клиентов';
COMMENT ON COLUMN memory.dds.hub_customer.hk_customer_id IS 'Хэш-ключ клиента (MD5 от C_CUSTKEY)';
COMMENT ON COLUMN memory.dds.hub_customer.customer_bk IS 'Бизнес-ключ: C_CUSTKEY';
COMMENT ON COLUMN memory.dds.hub_customer.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.hub_customer.rec_src IS 'Источник данных: tpch.tiny.customer';

CREATE TABLE IF NOT exists memory.dds.hub_order (
    hk_order_id VARCHAR(32),
    order_bk VARCHAR(50),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.hub_order IS 'Хаб заказов';
COMMENT ON COLUMN memory.dds.hub_order.hk_order_id IS 'Хэш-ключ заказа (MD5 от O_ORDERKEY)';
COMMENT ON COLUMN memory.dds.hub_order.order_bk IS 'Бизнес-ключ: O_ORDERKEY';
COMMENT ON COLUMN memory.dds.hub_order.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.hub_order.rec_src IS 'Источник данных: tpch.tiny.orders';

CREATE TABLE IF NOT exists memory.dds.hub_part (
    hk_part_id VARCHAR(32),
    part_bk VARCHAR(50),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.hub_part IS 'Хаб товаров (деталей)';
COMMENT ON COLUMN memory.dds.hub_part.hk_part_id IS 'Хэш-ключ товара (MD5 от P_PARTKEY)';
COMMENT ON COLUMN memory.dds.hub_part.part_bk IS 'Бизнес-ключ: P_PARTKEY';
COMMENT ON COLUMN memory.dds.hub_part.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.hub_part.rec_src IS 'Источник данных: tpch.tiny.part';

CREATE TABLE IF NOT exists memory.dds.hub_supplier (
    hk_supplier_id VARCHAR(32),
    supplier_bk VARCHAR(50),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.hub_supplier IS 'Хаб поставщиков';
COMMENT ON COLUMN memory.dds.hub_supplier.hk_supplier_id IS 'Хэш-ключ поставщика (MD5 от S_SUPPKEY)';
COMMENT ON COLUMN memory.dds.hub_supplier.supplier_bk IS 'Бизнес-ключ: S_SUPPKEY';
COMMENT ON COLUMN memory.dds.hub_supplier.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.hub_supplier.rec_src IS 'Источник данных: tpch.tiny.supplier';

CREATE TABLE IF NOT exists memory.dds.hub_nation (
    hk_nation_id VARCHAR(32),
    nation_bk VARCHAR(50),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.hub_nation IS 'Хаб стран';
COMMENT ON COLUMN memory.dds.hub_nation.hk_nation_id IS 'Хэш-ключ страны (MD5 от N_NATIONKEY)';
COMMENT ON COLUMN memory.dds.hub_nation.nation_bk IS 'Бизнес-ключ: N_NATIONKEY';
COMMENT ON COLUMN memory.dds.hub_nation.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.hub_nation.rec_src IS 'Источник данных: tpch.tiny.nation';

CREATE TABLE IF NOT exists memory.dds.hub_region (
    hk_region_id VARCHAR(32),
    region_bk VARCHAR(50),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.hub_region IS 'Хаб регионов';
COMMENT ON COLUMN memory.dds.hub_region.hk_region_id IS 'Хэш-ключ региона (MD5 от R_REGIONKEY)';
COMMENT ON COLUMN memory.dds.hub_region.region_bk IS 'Бизнес-ключ: R_REGIONKEY';
COMMENT ON COLUMN memory.dds.hub_region.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.hub_region.rec_src IS 'Источник данных: tpch.tiny.region';

-- ===== ЛИНКИ (LINKS) =====

CREATE TABLE IF NOT exists memory.dds.link_order (
    hk_order_link_id VARCHAR(32),
    hk_order_id VARCHAR(32),
    hk_customer_id VARCHAR(32),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.link_order IS 'Линк: связь заказа с клиентом';
COMMENT ON COLUMN memory.dds.link_order.hk_order_link_id IS 'Хэш-ключ связи заказ–клиент';
COMMENT ON COLUMN memory.dds.link_order.hk_order_id IS 'Ссылка на хаб заказа';
COMMENT ON COLUMN memory.dds.link_order.hk_customer_id IS 'Ссылка на хаб клиента';
COMMENT ON COLUMN memory.dds.link_order.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.link_order.rec_src IS 'Источник данных: tpch.tiny.orders';

CREATE TABLE IF NOT exists memory.dds.link_lineitem (
    hk_lineitem_link_id VARCHAR(32),
    hk_order_id VARCHAR(32),
    hk_part_id VARCHAR(32),
    hk_supplier_id VARCHAR(32),
    line_number INTEGER,
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.link_lineitem IS 'Линк: строка заказа (связывает заказ, товар и поставщика)';
COMMENT ON COLUMN memory.dds.link_lineitem.hk_lineitem_link_id IS 'Хэш-ключ строки заказа';
COMMENT ON COLUMN memory.dds.link_lineitem.hk_order_id IS 'Ссылка на хаб заказа';
COMMENT ON COLUMN memory.dds.link_lineitem.hk_part_id IS 'Ссылка на хаб товара';
COMMENT ON COLUMN memory.dds.link_lineitem.hk_supplier_id IS 'Ссылка на хаб поставщика';
COMMENT ON COLUMN memory.dds.link_lineitem.line_number IS 'Номер строки в заказе (L_LINENUMBER)';
COMMENT ON COLUMN memory.dds.link_lineitem.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.link_lineitem.rec_src IS 'Источник данных: tpch.tiny.lineitem';

CREATE TABLE IF NOT exists memory.dds.link_partsupp (
    hk_partsupp_link_id VARCHAR(32),
    hk_part_id VARCHAR(32),
    hk_supplier_id VARCHAR(32),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.link_partsupp IS 'Линк: поставка товара от поставщика';
COMMENT ON COLUMN memory.dds.link_partsupp.hk_partsupp_link_id IS 'Хэш-ключ поставки';
COMMENT ON COLUMN memory.dds.link_partsupp.hk_part_id IS 'Ссылка на хаб товара';
COMMENT ON COLUMN memory.dds.link_partsupp.hk_supplier_id IS 'Ссылка на хаб поставщика';
COMMENT ON COLUMN memory.dds.link_partsupp.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.link_partsupp.rec_src IS 'Источник данных: tpch.tiny.partsupp';

CREATE TABLE IF NOT exists memory.dds.link_customer_nation (
    hk_customer_nation_link_id VARCHAR(32),
    hk_customer_id VARCHAR(32),
    hk_nation_id VARCHAR(32),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.link_customer_nation IS 'Линк: принадлежность клиента к стране';
COMMENT ON COLUMN memory.dds.link_customer_nation.hk_customer_nation_link_id IS 'Хэш-ключ связи клиент–страна';
COMMENT ON COLUMN memory.dds.link_customer_nation.hk_customer_id IS 'Ссылка на хаб клиента';
COMMENT ON COLUMN memory.dds.link_customer_nation.hk_nation_id IS 'Ссылка на хаб страны';
COMMENT ON COLUMN memory.dds.link_customer_nation.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.link_customer_nation.rec_src IS 'Источник данных: tpch.tiny.customer';

CREATE TABLE IF NOT exists memory.dds.link_supplier_nation (
    hk_supplier_nation_link_id VARCHAR(32),
    hk_supplier_id VARCHAR(32),
    hk_nation_id VARCHAR(32),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.link_supplier_nation IS 'Линк: принадлежность поставщика к стране';
COMMENT ON COLUMN memory.dds.link_supplier_nation.hk_supplier_nation_link_id IS 'Хэш-ключ связи поставщик–страна';
COMMENT ON COLUMN memory.dds.link_supplier_nation.hk_supplier_id IS 'Ссылка на хаб поставщика';
COMMENT ON COLUMN memory.dds.link_supplier_nation.hk_nation_id IS 'Ссылка на хаб страны';
COMMENT ON COLUMN memory.dds.link_supplier_nation.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.link_supplier_nation.rec_src IS 'Источник данных: tpch.tiny.supplier';

CREATE TABLE IF NOT exists memory.dds.link_nation_region (
    hk_nation_region_link_id VARCHAR(32),
    hk_nation_id VARCHAR(32),
    hk_region_id VARCHAR(32),
    load_dts TIMESTAMP,
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.link_nation_region IS 'Линк: принадлежность страны к региону';
COMMENT ON COLUMN memory.dds.link_nation_region.hk_nation_region_link_id IS 'Хэш-ключ связи страна–регион';
COMMENT ON COLUMN memory.dds.link_nation_region.hk_nation_id IS 'Ссылка на хаб страны';
COMMENT ON COLUMN memory.dds.link_nation_region.hk_region_id IS 'Ссылка на хаб региона';
COMMENT ON COLUMN memory.dds.link_nation_region.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.link_nation_region.rec_src IS 'Источник данных: tpch.tiny.nation';

-- ===== СПУТНИКИ (SATELLITES) =====

CREATE TABLE IF NOT exists memory.dds.sat_customer_details (
    hk_customer_id VARCHAR(32),
    load_dts TIMESTAMP,
    customer_name VARCHAR(255),
    customer_address VARCHAR(255),
    customer_phone VARCHAR(15),
    customer_acctbal DECIMAL(15,2),
    customer_mktsegment VARCHAR(10),
    customer_comment VARCHAR(117),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_customer_details IS 'Спутник: описательные атрибуты клиента';
COMMENT ON COLUMN memory.dds.sat_customer_details.hk_customer_id IS 'Ссылка на хаб клиента';
COMMENT ON COLUMN memory.dds.sat_customer_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_customer_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';

CREATE TABLE IF NOT exists memory.dds.sat_order_details (
    hk_order_id VARCHAR(32),
    load_dts TIMESTAMP,
    order_status VARCHAR(1),
    order_totalprice DECIMAL(15,2),
    order_date DATE,
    order_priority VARCHAR(15),
    order_clerk VARCHAR(15),
    order_shippriority INTEGER,
    order_comment VARCHAR(79),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_order_details IS 'Спутник: описательные атрибуты заказа';
COMMENT ON COLUMN memory.dds.sat_order_details.hk_order_id IS 'Ссылка на хаб заказа';
COMMENT ON COLUMN memory.dds.sat_order_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_order_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';

CREATE TABLE IF NOT exists memory.dds.sat_lineitem_details (
    hk_lineitem_link_id VARCHAR(32),
    load_dts TIMESTAMP,
    lineitem_quantity DECIMAL(15,2),
    lineitem_extendedprice DECIMAL(15,2),
    lineitem_discount DECIMAL(15,2),
    lineitem_tax DECIMAL(15,2),
    lineitem_returnflag VARCHAR(1),
    lineitem_linestatus VARCHAR(1),
    lineitem_shipdate DATE,
    lineitem_commitdate DATE,
    lineitem_receiptdate DATE,
    lineitem_shipinstruct VARCHAR(25),
    lineitem_shipmode VARCHAR(10),
    lineitem_comment VARCHAR(44),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_lineitem_details IS 'Спутник: метрики и статусы строки заказа';
COMMENT ON COLUMN memory.dds.sat_lineitem_details.hk_lineitem_link_id IS 'Ссылка на линк строки заказа';
COMMENT ON COLUMN memory.dds.sat_lineitem_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_lineitem_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';

CREATE TABLE IF NOT exists memory.dds.sat_part_details (
    hk_part_id VARCHAR(32),
    load_dts TIMESTAMP,
    part_name VARCHAR(55),
    part_mfgr VARCHAR(25),
    part_brand VARCHAR(10),
    part_type VARCHAR(25),
    part_size INTEGER,
    part_container VARCHAR(10),
    part_retailprice DECIMAL(15,2),
    part_comment VARCHAR(23),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_part_details IS 'Спутник: описательные атрибуты товара';
COMMENT ON COLUMN memory.dds.sat_part_details.hk_part_id IS 'Ссылка на хаб товара';
COMMENT ON COLUMN memory.dds.sat_part_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_part_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';

CREATE TABLE IF NOT exists memory.dds.sat_supplier_details (
    hk_supplier_id VARCHAR(32),
    load_dts TIMESTAMP,
    supplier_name VARCHAR(25),
    supplier_address VARCHAR(40),
    supplier_phone VARCHAR(15),
    supplier_acctbal DECIMAL(15,2),
    supplier_comment VARCHAR(101),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_supplier_details IS 'Спутник: описательные атрибуты поставщика';
COMMENT ON COLUMN memory.dds.sat_supplier_details.hk_supplier_id IS 'Ссылка на хаб поставщика';
COMMENT ON COLUMN memory.dds.sat_supplier_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_supplier_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';

CREATE TABLE IF NOT exists memory.dds.sat_partsupp_details (
    hk_partsupp_link_id VARCHAR(32),
    load_dts TIMESTAMP,
    partsupp_availqty INTEGER,
    partsupp_supplycost DECIMAL(15,2),
    partsupp_comment VARCHAR(199),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_partsupp_details IS 'Спутник: атрибуты поставки товара от поставщика';
COMMENT ON COLUMN memory.dds.sat_partsupp_details.hk_partsupp_link_id IS 'Ссылка на линк поставки';
COMMENT ON COLUMN memory.dds.sat_partsupp_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_partsupp_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';

CREATE TABLE IF NOT exists memory.dds.sat_nation_details (
    hk_nation_id VARCHAR(32),
    load_dts TIMESTAMP,
    nation_name VARCHAR(25),
    nation_comment VARCHAR(152),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_nation_details IS 'Спутник: описательные атрибуты страны';
COMMENT ON COLUMN memory.dds.sat_nation_details.hk_nation_id IS 'Ссылка на хаб страны';
COMMENT ON COLUMN memory.dds.sat_nation_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_nation_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';

CREATE TABLE IF NOT exists memory.dds.sat_region_details (
    hk_region_id VARCHAR(32),
    load_dts TIMESTAMP,
    region_name VARCHAR(25),
    region_comment VARCHAR(152),
    hash_diff VARCHAR(32),
    rec_src VARCHAR(50)
);

COMMENT ON TABLE memory.dds.sat_region_details IS 'Спутник: описательные атрибуты региона';
COMMENT ON COLUMN memory.dds.sat_region_details.hk_region_id IS 'Ссылка на хаб региона';
COMMENT ON COLUMN memory.dds.sat_region_details.load_dts IS 'Дата загрузки записи';
COMMENT ON COLUMN memory.dds.sat_region_details.hash_diff IS 'Хэш от всех атрибутов для отслеживания изменений';
