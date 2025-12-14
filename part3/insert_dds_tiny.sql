-- ========================================================
-- Полная загрузка данных
-- ========================================================

-- ХАБЫ
INSERT INTO memory.dds.hub_customer (
    hk_customer_id, customer_bk, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS hk_customer_id,
    CAST(custkey AS VARCHAR) AS customer_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.customer' AS rec_src
FROM tpch.tiny.customer;

INSERT INTO memory.dds.hub_order (
    hk_order_id, order_bk, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS hk_order_id,
    CAST(orderkey AS VARCHAR) AS order_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.orders' AS rec_src
FROM tpch.tiny.orders;

INSERT INTO memory.dds.hub_part (
    hk_part_id, part_bk, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR)))) AS hk_part_id,
    CAST(partkey AS VARCHAR) AS part_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.part' AS rec_src
FROM tpch.tiny.part;

INSERT INTO memory.dds.hub_supplier (
    hk_supplier_id, supplier_bk, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(suppkey AS VARCHAR)))) AS hk_supplier_id,
    CAST(suppkey AS VARCHAR) AS supplier_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.supplier' AS rec_src
FROM tpch.tiny.supplier;

INSERT INTO memory.dds.hub_nation (
    hk_nation_id, nation_bk, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(nationkey AS VARCHAR)))) AS hk_nation_id,
    CAST(nationkey AS VARCHAR) AS nation_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.nation' AS rec_src
FROM tpch.tiny.nation;

INSERT INTO memory.dds.hub_region (
    hk_region_id, region_bk, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(regionkey AS VARCHAR)))) AS hk_region_id,
    CAST(regionkey AS VARCHAR) AS region_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.region' AS rec_src
FROM tpch.tiny.region;

-- ЛИНКИ
INSERT INTO memory.dds.link_order (
    hk_order_link_id, hk_order_id, hk_customer_id, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(orderkey AS VARCHAR),
        CAST(custkey AS VARCHAR)
    )))) AS hk_order_link_id,
    TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS hk_order_id,
    TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS hk_customer_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.orders' AS rec_src
FROM tpch.tiny.orders;

INSERT INTO memory.dds.link_lineitem (
    hk_lineitem_link_id, hk_order_id, hk_part_id, hk_supplier_id, line_number, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(orderkey AS VARCHAR),
        CAST(partkey AS VARCHAR),
        CAST(suppkey AS VARCHAR),
        CAST(linenumber AS VARCHAR)
    )))) AS hk_lineitem_link_id,
    TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS hk_order_id,
    TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR)))) AS hk_part_id,
    TO_HEX(MD5(TO_UTF8(CAST(suppkey AS VARCHAR)))) AS hk_supplier_id,
    linenumber AS line_number,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.lineitem' AS rec_src
FROM tpch.tiny.lineitem;

INSERT INTO memory.dds.link_partsupp (
    hk_partsupp_link_id, hk_part_id, hk_supplier_id, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(partkey AS VARCHAR),
        CAST(suppkey AS VARCHAR)
    )))) AS hk_partsupp_link_id,
    TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR)))) AS hk_part_id,
    TO_HEX(MD5(TO_UTF8(CAST(suppkey AS VARCHAR)))) AS hk_supplier_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.partsupp' AS rec_src
FROM tpch.tiny.partsupp;

INSERT INTO memory.dds.link_customer_nation (
    hk_customer_nation_link_id, hk_customer_id, hk_nation_id, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(custkey AS VARCHAR),
        CAST(nationkey AS VARCHAR)
    )))) AS hk_customer_nation_link_id,
    TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS hk_customer_id,
    TO_HEX(MD5(TO_UTF8(CAST(nationkey AS VARCHAR)))) AS hk_nation_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.customer' AS rec_src
FROM tpch.tiny.customer;

INSERT INTO memory.dds.link_supplier_nation (
    hk_supplier_nation_link_id, hk_supplier_id, hk_nation_id, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(suppkey AS VARCHAR),
        CAST(nationkey AS VARCHAR)
    )))) AS hk_supplier_nation_link_id,
    TO_HEX(MD5(TO_UTF8(CAST(suppkey AS VARCHAR)))) AS hk_supplier_id,
    TO_HEX(MD5(TO_UTF8(CAST(nationkey AS VARCHAR)))) AS hk_nation_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.supplier' AS rec_src
FROM tpch.tiny.supplier;

INSERT INTO memory.dds.link_nation_region (
    hk_nation_region_link_id, hk_nation_id, hk_region_id, load_dts, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(nationkey AS VARCHAR),
        CAST(regionkey AS VARCHAR)
    )))) AS hk_nation_region_link_id,
    TO_HEX(MD5(TO_UTF8(CAST(nationkey AS VARCHAR)))) AS hk_nation_id,
    TO_HEX(MD5(TO_UTF8(CAST(regionkey AS VARCHAR)))) AS hk_region_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.nation' AS rec_src
FROM tpch.tiny.nation;

-- СПУТНИКИ
INSERT INTO memory.dds.sat_customer_details (
    hk_customer_id, load_dts, customer_name, customer_address, customer_phone,
    customer_acctbal, customer_mktsegment, customer_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS hk_customer_id,
    CURRENT_TIMESTAMP AS load_dts,
    name,
    address,
    phone,
    acctbal,
    mktsegment,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        COALESCE(name, ''),
        COALESCE(address, ''),
        COALESCE(phone, ''),
        CAST(acctbal AS VARCHAR),
        COALESCE(mktsegment, ''),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.customer' AS rec_src
FROM tpch.tiny.customer;

INSERT INTO memory.dds.sat_order_details (
    hk_order_id, load_dts, order_status, order_totalprice, order_date,
    order_priority, order_clerk, order_shippriority, order_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS hk_order_id,
    CURRENT_TIMESTAMP AS load_dts,
    orderstatus,
    totalprice,
    orderdate,
    orderpriority,
    clerk,
    shippriority,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        COALESCE(orderstatus, ''),
        CAST(totalprice AS VARCHAR),
        CAST(orderdate AS VARCHAR),
        COALESCE(orderpriority, ''),
        COALESCE(clerk, ''),
        CAST(shippriority AS VARCHAR),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.orders' AS rec_src
FROM tpch.tiny.orders;

INSERT INTO memory.dds.sat_lineitem_details (
    hk_lineitem_link_id, load_dts, lineitem_quantity, lineitem_extendedprice,
    lineitem_discount, lineitem_tax, lineitem_returnflag, lineitem_linestatus,
    lineitem_shipdate, lineitem_commitdate, lineitem_receiptdate,
    lineitem_shipinstruct, lineitem_shipmode, lineitem_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(orderkey AS VARCHAR),
        CAST(partkey AS VARCHAR),
        CAST(suppkey AS VARCHAR),
        CAST(linenumber AS VARCHAR)
    )))) AS hk_lineitem_link_id,
    CURRENT_TIMESTAMP AS load_dts,
    quantity,
    extendedprice,
    discount,
    tax,
    returnflag,
    linestatus,
    shipdate,
    commitdate,
    receiptdate,
    shipinstruct,
    shipmode,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(quantity AS VARCHAR),
        CAST(extendedprice AS VARCHAR),
        CAST(discount AS VARCHAR),
        CAST(tax AS VARCHAR),
        COALESCE(returnflag, ''),
        COALESCE(linestatus, ''),
        CAST(shipdate AS VARCHAR),
        CAST(commitdate AS VARCHAR),
        CAST(receiptdate AS VARCHAR),
        COALESCE(shipinstruct, ''),
        COALESCE(shipmode, ''),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.lineitem' AS rec_src
FROM tpch.tiny.lineitem;

INSERT INTO memory.dds.sat_part_details (
    hk_part_id, load_dts, part_name, part_mfgr, part_brand, part_type,
    part_size, part_container, part_retailprice, part_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR)))) AS hk_part_id,
    CURRENT_TIMESTAMP AS load_dts,
    name,
    mfgr,
    brand,
    type,
    size,
    container,
    retailprice,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        COALESCE(name, ''),
        COALESCE(mfgr, ''),
        COALESCE(brand, ''),
        COALESCE(type, ''),
        CAST(size AS VARCHAR),
        COALESCE(container, ''),
        CAST(retailprice AS VARCHAR),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.part' AS rec_src
FROM tpch.tiny.part;

INSERT INTO memory.dds.sat_supplier_details (
    hk_supplier_id, load_dts, supplier_name, supplier_address, supplier_phone,
    supplier_acctbal, supplier_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(suppkey AS VARCHAR)))) AS hk_supplier_id,
    CURRENT_TIMESTAMP AS load_dts,
    name,
    address,
    phone,
    acctbal,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        COALESCE(name, ''),
        COALESCE(address, ''),
        COALESCE(phone, ''),
        CAST(acctbal AS VARCHAR),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.supplier' AS rec_src
FROM tpch.tiny.supplier;

INSERT INTO memory.dds.sat_partsupp_details (
    hk_partsupp_link_id, load_dts, partsupp_availqty, partsupp_supplycost,
    partsupp_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(partkey AS VARCHAR),
        CAST(suppkey AS VARCHAR)
    )))) AS hk_partsupp_link_id,
    CURRENT_TIMESTAMP AS load_dts,
    availqty,
    supplycost,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(availqty AS VARCHAR),
        CAST(supplycost AS VARCHAR),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.partsupp' AS rec_src
FROM tpch.tiny.partsupp;

INSERT INTO memory.dds.sat_nation_details (
    hk_nation_id, load_dts, nation_name, nation_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(nationkey AS VARCHAR)))) AS hk_nation_id,
    CURRENT_TIMESTAMP AS load_dts,
    name,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        COALESCE(name, ''),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.nation' AS rec_src
FROM tpch.tiny.nation;

INSERT INTO memory.dds.sat_region_details (
    hk_region_id, load_dts, region_name, region_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CAST(regionkey AS VARCHAR)))) AS hk_region_id,
    CURRENT_TIMESTAMP AS load_dts,
    name,
    comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        COALESCE(name, ''),
        COALESCE(comment, '')
    )))) AS hash_diff,
    'tpch.tiny.region' AS rec_src
FROM tpch.tiny.region;
