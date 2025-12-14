-- ===== ХАБЫ =====

-- HUB_CUSTOMER
INSERT INTO memory.dds.hub_customer (
    hk_customer_id, customer_bk, load_dts, rec_src
)
SELECT
    MD5(CAST(c_custkey AS VARCHAR)) AS hk_customer_id,
    CAST(c_custkey AS VARCHAR) AS customer_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.customer' AS rec_src
FROM tpch.tiny.customer;

-- HUB_ORDER
INSERT INTO memory.dds.hub_order (
    hk_order_id, order_bk, load_dts, rec_src
)
SELECT
    MD5(CAST(o_orderkey AS VARCHAR)) AS hk_order_id,
    CAST(o_orderkey AS VARCHAR) AS order_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.orders' AS rec_src
FROM tpch.tiny.orders;

-- HUB_PART
INSERT INTO memory.dds.hub_part (
    hk_part_id, part_bk, load_dts, rec_src
)
SELECT
    MD5(CAST(p_partkey AS VARCHAR)) AS hk_part_id,
    CAST(p_partkey AS VARCHAR) AS part_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.part' AS rec_src
FROM tpch.tiny.part;

-- HUB_SUPPLIER
INSERT INTO memory.dds.hub_supplier (
    hk_supplier_id, supplier_bk, load_dts, rec_src
)
SELECT
    MD5(CAST(s_suppkey AS VARCHAR)) AS hk_supplier_id,
    CAST(s_suppkey AS VARCHAR) AS supplier_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.supplier' AS rec_src
FROM tpch.tiny.supplier;

-- HUB_NATION
INSERT INTO memory.dds.hub_nation (
    hk_nation_id, nation_bk, load_dts, rec_src
)
SELECT
    MD5(CAST(n_nationkey AS VARCHAR)) AS hk_nation_id,
    CAST(n_nationkey AS VARCHAR) AS nation_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.nation' AS rec_src
FROM tpch.tiny.nation;

-- HUB_REGION
INSERT INTO memory.dds.hub_region (
    hk_region_id, region_bk, load_dts, rec_src
)
SELECT
    MD5(CAST(r_regionkey AS VARCHAR)) AS hk_region_id,
    CAST(r_regionkey AS VARCHAR) AS region_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.region' AS rec_src
FROM tpch.tiny.region;

-- ===== ЛИНКИ =====

-- LINK_ORDER
INSERT INTO memory.dds.link_order (
    hk_order_link_id, hk_order_id, hk_customer_id, load_dts, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(o_orderkey AS VARCHAR)),
        MD5(CAST(o_custkey AS VARCHAR))
    )) AS hk_order_link_id,
    MD5(CAST(o_orderkey AS VARCHAR)) AS hk_order_id,
    MD5(CAST(o_custkey AS VARCHAR)) AS hk_customer_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.orders' AS rec_src
FROM tpch.tiny.orders;

-- LINK_LINEITEM
INSERT INTO memory.dds.link_lineitem (
    hk_lineitem_link_id, hk_order_id, hk_part_id, hk_supplier_id, line_number, load_dts, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(l_orderkey AS VARCHAR)),
        MD5(CAST(l_partkey AS VARCHAR)),
        MD5(CAST(l_suppkey AS VARCHAR)),
        CAST(l_linenumber AS VARCHAR)
    )) AS hk_lineitem_link_id,
    MD5(CAST(l_orderkey AS VARCHAR)) AS hk_order_id,
    MD5(CAST(l_partkey AS VARCHAR)) AS hk_part_id,
    MD5(CAST(l_suppkey AS VARCHAR)) AS hk_supplier_id,
    l_linenumber AS line_number,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.lineitem' AS rec_src
FROM tpch.tiny.lineitem;

-- LINK_PARTSUPP
INSERT INTO memory.dds.link_partsupp (
    hk_partsupp_link_id, hk_part_id, hk_supplier_id, load_dts, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(ps_partkey AS VARCHAR)),
        MD5(CAST(ps_suppkey AS VARCHAR))
    )) AS hk_partsupp_link_id,
    MD5(CAST(ps_partkey AS VARCHAR)) AS hk_part_id,
    MD5(CAST(ps_suppkey AS VARCHAR)) AS hk_supplier_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.partsupp' AS rec_src
FROM tpch.tiny.partsupp;

-- LINK_CUSTOMER_NATION
INSERT INTO memory.dds.link_customer_nation (
    hk_customer_nation_link_id, hk_customer_id, hk_nation_id, load_dts, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(c_custkey AS VARCHAR)),
        MD5(CAST(c_nationkey AS VARCHAR))
    )) AS hk_customer_nation_link_id,
    MD5(CAST(c_custkey AS VARCHAR)) AS hk_customer_id,
    MD5(CAST(c_nationkey AS VARCHAR)) AS hk_nation_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.customer' AS rec_src
FROM tpch.tiny.customer;

-- LINK_SUPPLIER_NATION
INSERT INTO memory.dds.link_supplier_nation (
    hk_supplier_nation_link_id, hk_supplier_id, hk_nation_id, load_dts, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(s_suppkey AS VARCHAR)),
        MD5(CAST(s_nationkey AS VARCHAR))
    )) AS hk_supplier_nation_link_id,
    MD5(CAST(s_suppkey AS VARCHAR)) AS hk_supplier_id,
    MD5(CAST(s_nationkey AS VARCHAR)) AS hk_nation_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.supplier' AS rec_src
FROM tpch.tiny.supplier;

-- LINK_NATION_REGION
INSERT INTO memory.dds.link_nation_region (
    hk_nation_region_link_id, hk_nation_id, hk_region_id, load_dts, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(n_nationkey AS VARCHAR)),
        MD5(CAST(n_regionkey AS VARCHAR))
    )) AS hk_nation_region_link_id,
    MD5(CAST(n_nationkey AS VARCHAR)) AS hk_nation_id,
    MD5(CAST(n_regionkey AS VARCHAR)) AS hk_region_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.nation' AS rec_src
FROM tpch.tiny.nation;

-- ===== СПУТНИКИ =====

-- SAT_CUSTOMER_DETAILS
INSERT INTO memory.dds.sat_customer_details (
    hk_customer_id, load_dts, customer_name, customer_address, customer_phone,
    customer_acctbal, customer_mktsegment, customer_comment, hash_diff, rec_src
)
SELECT
    MD5(CAST(c_custkey AS VARCHAR)) AS hk_customer_id,
    CURRENT_TIMESTAMP AS load_dts,
    c_name AS customer_name,
    c_address AS customer_address,
    c_phone AS customer_phone,
    c_acctbal AS customer_acctbal,
    c_mktsegment AS customer_mktsegment,
    c_comment AS customer_comment,
    MD5(CONCAT(
        COALESCE(c_name, ''),
        COALESCE(c_address, ''),
        COALESCE(c_phone, ''),
        CAST(c_acctbal AS VARCHAR),
        COALESCE(c_mktsegment, ''),
        COALESCE(c_comment, '')
    )) AS hash_diff,
    'tpch.tiny.customer' AS rec_src
FROM tpch.tiny.customer;

-- SAT_ORDER_DETAILS
INSERT INTO memory.dds.sat_order_details (
    hk_order_id, load_dts, order_status, order_totalprice, order_date,
    order_priority, order_clerk, order_shippriority, order_comment, hash_diff, rec_src
)
SELECT
    MD5(CAST(o_orderkey AS VARCHAR)) AS hk_order_id,
    CURRENT_TIMESTAMP AS load_dts,
    o_orderstatus AS order_status,
    o_totalprice AS order_totalprice,
    o_orderdate AS order_date,
    o_orderpriority AS order_priority,
    o_clerk AS order_clerk,
    o_shippriority AS order_shippriority,
    o_comment AS order_comment,
    MD5(CONCAT(
        COALESCE(o_orderstatus, ''),
        CAST(o_totalprice AS VARCHAR),
        CAST(o_orderdate AS VARCHAR),
        COALESCE(o_orderpriority, ''),
        COALESCE(o_clerk, ''),
        CAST(o_shippriority AS VARCHAR),
        COALESCE(o_comment, '')
    )) AS hash_diff,
    'tpch.tiny.orders' AS rec_src
FROM tpch.tiny.orders;

-- SAT_LINEITEM_DETAILS
INSERT INTO memory.dds.sat_lineitem_details (
    hk_lineitem_link_id, load_dts, lineitem_quantity, lineitem_extendedprice,
    lineitem_discount, lineitem_tax, lineitem_returnflag, lineitem_linestatus,
    lineitem_shipdate, lineitem_commitdate, lineitem_receiptdate,
    lineitem_shipinstruct, lineitem_shipmode, lineitem_comment, hash_diff, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(l_orderkey AS VARCHAR)),
        MD5(CAST(l_partkey AS VARCHAR)),
        MD5(CAST(l_suppkey AS VARCHAR)),
        CAST(l_linenumber AS VARCHAR)
    )) AS hk_lineitem_link_id,
    CURRENT_TIMESTAMP AS load_dts,
    l_quantity AS lineitem_quantity,
    l_extendedprice AS lineitem_extendedprice,
    l_discount AS lineitem_discount,
    l_tax AS lineitem_tax,
    l_returnflag AS lineitem_returnflag,
    l_linestatus AS lineitem_linestatus,
    l_shipdate AS lineitem_shipdate,
    l_commitdate AS lineitem_commitdate,
    l_receiptdate AS lineitem_receiptdate,
    l_shipinstruct AS lineitem_shipinstruct,
    l_shipmode AS lineitem_shipmode,
    l_comment AS lineitem_comment,
    MD5(CONCAT(
        CAST(l_quantity AS VARCHAR),
        CAST(l_extendedprice AS VARCHAR),
        CAST(l_discount AS VARCHAR),
        CAST(l_tax AS VARCHAR),
        COALESCE(l_returnflag, ''),
        COALESCE(l_linestatus, ''),
        CAST(l_shipdate AS VARCHAR),
        CAST(l_commitdate AS VARCHAR),
        CAST(l_receiptdate AS VARCHAR),
        COALESCE(l_shipinstruct, ''),
        COALESCE(l_shipmode, ''),
        COALESCE(l_comment, '')
    )) AS hash_diff,
    'tpch.tiny.lineitem' AS rec_src
FROM tpch.tiny.lineitem;

-- SAT_PART_DETAILS
INSERT INTO memory.dds.sat_part_details (
    hk_part_id, load_dts, part_name, part_mfgr, part_brand, part_type,
    part_size, part_container, part_retailprice, part_comment, hash_diff, rec_src
)
SELECT
    MD5(CAST(p_partkey AS VARCHAR)) AS hk_part_id,
    CURRENT_TIMESTAMP AS load_dts,
    p_name AS part_name,
    p_mfgr AS part_mfgr,
    p_brand AS part_brand,
    p_type AS part_type,
    p_size AS part_size,
    p_container AS part_container,
    p_retailprice AS part_retailprice,
    p_comment AS part_comment,
    MD5(CONCAT(
        COALESCE(p_name, ''),
        COALESCE(p_mfgr, ''),
        COALESCE(p_brand, ''),
        COALESCE(p_type, ''),
        CAST(p_size AS VARCHAR),
        COALESCE(p_container, ''),
        CAST(p_retailprice AS VARCHAR),
        COALESCE(p_comment, '')
    )) AS hash_diff,
    'tpch.tiny.part' AS rec_src
FROM tpch.tiny.part;

-- SAT_SUPPLIER_DETAILS
INSERT INTO memory.dds.sat_supplier_details (
    hk_supplier_id, load_dts, supplier_name, supplier_address, supplier_phone,
    supplier_acctbal, supplier_comment, hash_diff, rec_src
)
SELECT
    MD5(CAST(s_suppkey AS VARCHAR)) AS hk_supplier_id,
    CURRENT_TIMESTAMP AS load_dts,
    s_name AS supplier_name,
    s_address AS supplier_address,
    s_phone AS supplier_phone,
    s_acctbal AS supplier_acctbal,
    s_comment AS supplier_comment,
    MD5(CONCAT(
        COALESCE(s_name, ''),
        COALESCE(s_address, ''),
        COALESCE(s_phone, ''),
        CAST(s_acctbal AS VARCHAR),
        COALESCE(s_comment, '')
    )) AS hash_diff,
    'tpch.tiny.supplier' AS rec_src
FROM tpch.tiny.supplier;

-- SAT_PARTSUPP_DETAILS
INSERT INTO memory.dds.sat_partsupp_details (
    hk_partsupp_link_id, load_dts, partsupp_availqty, partsupp_supplycost,
    partsupp_comment, hash_diff, rec_src
)
SELECT
    MD5(CONCAT(
        MD5(CAST(ps_partkey AS VARCHAR)),
        MD5(CAST(ps_suppkey AS VARCHAR))
    )) AS hk_partsupp_link_id,
    CURRENT_TIMESTAMP AS load_dts,
    ps_availqty AS partsupp_availqty,
    ps_supplycost AS partsupp_supplycost,
    ps_comment AS partsupp_comment,
    MD5(CONCAT(
        CAST(ps_availqty AS VARCHAR),
        CAST(ps_supplycost AS VARCHAR),
        COALESCE(ps_comment, '')
    )) AS hash_diff,
    'tpch.tiny.partsupp' AS rec_src
FROM tpch.tiny.partsupp;

-- SAT_NATION_DETAILS
INSERT INTO memory.dds.sat_nation_details (
    hk_nation_id, load_dts, nation_name, nation_comment, hash_diff, rec_src
)
SELECT
    MD5(CAST(n_nationkey AS VARCHAR)) AS hk_nation_id,
    CURRENT_TIMESTAMP AS load_dts,
    n_name AS nation_name,
    n_comment AS nation_comment,
    MD5(CONCAT(
        COALESCE(n_name, ''),
        COALESCE(n_comment, '')
    )) AS hash_diff,
    'tpch.tiny.nation' AS rec_src
FROM tpch.tiny.nation;

-- SAT_REGION_DETAILS
INSERT INTO memory.dds.sat_region_details (
    hk_region_id, load_dts, region_name, region_comment, hash_diff, rec_src
)
SELECT
    MD5(CAST(r_regionkey AS VARCHAR)) AS hk_region_id,
    CURRENT_TIMESTAMP AS load_dts,
    r_name AS region_name,
    r_comment AS region_comment,
    MD5(CONCAT(
        COALESCE(r_name, ''),
        COALESCE(r_comment, '')
    )) AS hash_diff,
    'tpch.tiny.region' AS rec_src
FROM tpch.tiny.region;
