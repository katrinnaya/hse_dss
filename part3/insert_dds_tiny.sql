-- ===== ЗАГРУЗКА ХАБОВ =====

-- Загрузка HUB_CUSTOMER
INSERT INTO dds.hub_customer (
    hk_customer_id, customer_bk, load_dts, rec_src
)
SELECT 
    MD5(CAST(c_custkey AS VARCHAR)) AS hk_customer_id,
    CAST(c_custkey AS VARCHAR) AS customer_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.customer' AS rec_src
FROM tpch.tiny.customer
WHERE NOT EXISTS (
    SELECT 1 FROM dds.hub_customer h 
    WHERE h.hk_customer_id = MD5(CAST(c_custkey AS VARCHAR))
);

-- Загрузка HUB_ORDER  
INSERT INTO dds.hub_order (
    hk_order_id, order_bk, load_dts, rec_src
)
SELECT 
    MD5(CAST(o_orderkey AS VARCHAR)) AS hk_order_id,
    CAST(o_orderkey AS VARCHAR) AS order_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.orders' AS rec_src
FROM tpch.tiny.orders
WHERE NOT EXISTS (
    SELECT 1 FROM dds.hub_order h 
    WHERE h.hk_order_id = MD5(CAST(o_orderkey AS VARCHAR))
);

-- Загрузка HUB_PART
INSERT INTO dds.hub_part (
    hk_part_id, part_bk, load_dts, rec_src
)
SELECT 
    MD5(CAST(p_partkey AS VARCHAR)) AS hk_part_id,
    CAST(p_partkey AS VARCHAR) AS part_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.part' AS rec_src
FROM tpch.tiny.part
WHERE NOT EXISTS (
    SELECT 1 FROM dds.hub_part h 
    WHERE h.hk_part_id = MD5(CAST(p_partkey AS VARCHAR))
);

-- Загрузка HUB_SUPPLIER
INSERT INTO dds.hub_supplier (
    hk_supplier_id, supplier_bk, load_dts, rec_src
)
SELECT 
    MD5(CAST(s_suppkey AS VARCHAR)) AS hk_supplier_id,
    CAST(s_suppkey AS VARCHAR) AS supplier_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.supplier' AS rec_src
FROM tpch.tiny.supplier
WHERE NOT EXISTS (
    SELECT 1 FROM dds.hub_supplier h 
    WHERE h.hk_supplier_id = MD5(CAST(s_suppkey AS VARCHAR))
);

-- Загрузка HUB_NATION
INSERT INTO dds.hub_nation (
    hk_nation_id, nation_bk, load_dts, rec_src
)
SELECT 
    MD5(CAST(n_nationkey AS VARCHAR)) AS hk_nation_id,
    CAST(n_nationkey AS VARCHAR) AS nation_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.nation' AS rec_src
FROM tpch.tiny.nation
WHERE NOT EXISTS (
    SELECT 1 FROM dds.hub_nation h 
    WHERE h.hk_nation_id = MD5(CAST(n_nationkey AS VARCHAR))
);

-- Загрузка HUB_REGION
INSERT INTO dds.hub_region (
    hk_region_id, region_bk, load_dts, rec_src
)
SELECT 
    MD5(CAST(r_regionkey AS VARCHAR)) AS hk_region_id,
    CAST(r_regionkey AS VARCHAR) AS region_bk,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.region' AS rec_src
FROM tpch.tiny.region
WHERE NOT EXISTS (
    SELECT 1 FROM dds.hub_region h 
    WHERE h.hk_region_id = MD5(CAST(r_regionkey AS VARCHAR))
);

-- ===== ЗАГРУЗКА ЛИНКОВ =====

-- Загрузка LINK_ORDER (связь заказа с клиентом)
INSERT INTO dds.link_order (
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
FROM tpch.tiny.orders
WHERE NOT EXISTS (
    SELECT 1 FROM dds.link_order l 
    WHERE l.hk_order_link_id = MD5(CONCAT(
        MD5(CAST(o_orderkey AS VARCHAR)),
        MD5(CAST(o_custkey AS VARCHAR))
    ))
);

-- Загрузка LINK_LINEITEM (связь строки заказа с товаром и поставщиком)
INSERT INTO dds.link_lineitem (
    hk_lineitem_link_id, hk_order_id, hk_part_id, hk_supplier_id, load_dts, rec_src, line_number
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
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.lineitem' AS rec_src,
    l_linenumber AS line_number
FROM tpch.tiny.lineitem
WHERE NOT EXISTS (
    SELECT 1 FROM dds.link_lineitem l 
    WHERE l.hk_lineitem_link_id = MD5(CONCAT(
        MD5(CAST(l_orderkey AS VARCHAR)),
        MD5(CAST(l_partkey AS VARCHAR)),
        MD5(CAST(l_suppkey AS VARCHAR)),
        CAST(l_linenumber AS VARCHAR)
    ))
);

-- Загрузка LINK_PARTSUPP (связь товара с поставщиком)
INSERT INTO dds.link_partsupp (
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
FROM tpch.tiny.partsupp
WHERE NOT EXISTS (
    SELECT 1 FROM dds.link_partsupp l 
    WHERE l.hk_partsupp_link_id = MD5(CONCAT(
        MD5(CAST(ps_partkey AS VARCHAR)),
        MD5(CAST(ps_suppkey AS VARCHAR))
    ))
);

-- Загрузка LINK_CUSTOMER_NATION (связь клиента со страной)
INSERT INTO dds.link_customer_nation (
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
FROM tpch.tiny.customer
WHERE NOT EXISTS (
    SELECT 1 FROM dds.link_customer_nation l 
    WHERE l.hk_customer_nation_link_id = MD5(CONCAT(
        MD5(CAST(c_custkey AS VARCHAR)),
        MD5(CAST(c_nationkey AS VARCHAR))
    ))
);

-- Загрузка LINK_SUPPLIER_NATION (связь поставщика со страной)
INSERT INTO dds.link_supplier_nation (
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
FROM tpch.tiny.supplier
WHERE NOT EXISTS (
    SELECT 1 FROM dds.link_supplier_nation l 
    WHERE l.hk_supplier_nation_link_id = MD5(CONCAT(
        MD5(CAST(s_suppkey AS VARCHAR)),
        MD5(CAST(s_nationkey AS VARCHAR))
    ))
);

-- Загрузка LINK_NATION_REGION (связь страны с регионом)
INSERT INTO dds.link_nation_region (
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
FROM tpch.tiny.nation
WHERE NOT EXISTS (
    SELECT 1 FROM dds.link_nation_region l 
    WHERE l.hk_nation_region_link_id = MD5(CONCAT(
        MD5(CAST(n_nationkey AS VARCHAR)),
        MD5(CAST(n_regionkey AS VARCHAR))
    ))
);

-- ===== ЗАГРУЗКА СПУТНИКОВ =====

-- Загрузка SAT_CUSTOMER_DETAILS
INSERT INTO dds.sat_customer_details (
    hk_customer_id, load_dts, rec_src, customer_name, customer_address, 
    customer_phone, customer_acctbal, customer_mktsegment, customer_comment
)
SELECT 
    MD5(CAST(c_custkey AS VARCHAR)) AS hk_customer_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.customer' AS rec_src,
    c_name AS customer_name,
    c_address AS customer_address,
    c_phone AS customer_phone,
    c_acctbal AS customer_acctbal,
    c_mktsegment AS customer_mktsegment,
    c_comment AS customer_comment
FROM tpch.tiny.customer c
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_customer_details s
    WHERE s.hk_customer_id = MD5(CAST(c_custkey AS VARCHAR))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_customer_details 
        WHERE hk_customer_id = MD5(CAST(c_custkey AS VARCHAR))
    )
    AND COALESCE(s.customer_name, '') = COALESCE(c.c_name, '')
    AND COALESCE(s.customer_address, '') = COALESCE(c.c_address, '')
    AND COALESCE(s.customer_phone, '') = COALESCE(c.c_phone, '')
    AND COALESCE(s.customer_acctbal, 0) = COALESCE(c.c_acctbal, 0)
    AND COALESCE(s.customer_mktsegment, '') = COALESCE(c.c_mktsegment, '')
    AND COALESCE(s.customer_comment, '') = COALESCE(c.c_comment, '')
);

-- Загрузка SAT_ORDER_DETAILS
INSERT INTO dds.sat_order_details (
    hk_order_id, load_dts, rec_src, order_status, order_totalprice, order_date,
    order_priority, order_clerk, order_shippriority, order_comment
)
SELECT 
    MD5(CAST(o_orderkey AS VARCHAR)) AS hk_order_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.orders' AS rec_src,
    o_orderstatus AS order_status,
    o_totalprice AS order_totalprice,
    o_orderdate AS order_date,
    o_orderpriority AS order_priority,
    o_clerk AS order_clerk,
    o_shippriority AS order_shippriority,
    o_comment AS order_comment
FROM tpch.tiny.orders o
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_order_details s
    WHERE s.hk_order_id = MD5(CAST(o_orderkey AS VARCHAR))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_order_details 
        WHERE hk_order_id = MD5(CAST(o_orderkey AS VARCHAR))
    )
    AND COALESCE(s.order_status, '') = COALESCE(o.o_orderstatus, '')
    AND COALESCE(s.order_totalprice, 0) = COALESCE(o.o_totalprice, 0)
    AND COALESCE(s.order_date, DATE '1900-01-01') = COALESCE(o.o_orderdate, DATE '1900-01-01')
    AND COALESCE(s.order_priority, '') = COALESCE(o.o_orderpriority, '')
    AND COALESCE(s.order_clerk, '') = COALESCE(o.o_clerk, '')
    AND COALESCE(s.order_shippriority, 0) = COALESCE(o.o_shippriority, 0)
    AND COALESCE(s.order_comment, '') = COALESCE(o.o_comment, '')
);

-- Загрузка SAT_LINEITEM_DETAILS
INSERT INTO dds.sat_lineitem_details (
    hk_lineitem_link_id, load_dts, rec_src, lineitem_quantity, lineitem_extendedprice,
    lineitem_discount, lineitem_tax, lineitem_returnflag, lineitem_linestatus,
    lineitem_shipdate, lineitem_commitdate, lineitem_receiptdate, lineitem_shipinstruct,
    lineitem_shipmode, lineitem_comment
)
SELECT 
    MD5(CONCAT(
        MD5(CAST(l_orderkey AS VARCHAR)),
        MD5(CAST(l_partkey AS VARCHAR)),
        MD5(CAST(l_suppkey AS VARCHAR)),
        CAST(l_linenumber AS VARCHAR)
    )) AS hk_lineitem_link_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.lineitem' AS rec_src,
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
    l_comment AS lineitem_comment
FROM tpch.tiny.lineitem l
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_lineitem_details s
    WHERE s.hk_lineitem_link_id = MD5(CONCAT(
        MD5(CAST(l_orderkey AS VARCHAR)),
        MD5(CAST(l_partkey AS VARCHAR)),
        MD5(CAST(l_suppkey AS VARCHAR)),
        CAST(l_linenumber AS VARCHAR)
    ))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_lineitem_details 
        WHERE hk_lineitem_link_id = MD5(CONCAT(
            MD5(CAST(l_orderkey AS VARCHAR)),
            MD5(CAST(l_partkey AS VARCHAR)),
            MD5(CAST(l_suppkey AS VARCHAR)),
            CAST(l_linenumber AS VARCHAR)
        ))
    )
    AND COALESCE(s.lineitem_quantity, 0) = COALESCE(l.l_quantity, 0)
    AND COALESCE(s.lineitem_extendedprice, 0) = COALESCE(l.l_extendedprice, 0)
    AND COALESCE(s.lineitem_discount, 0) = COALESCE(l.l_discount, 0)
    AND COALESCE(s.lineitem_tax, 0) = COALESCE(l.l_tax, 0)
    AND COALESCE(s.lineitem_returnflag, '') = COALESCE(l.l_returnflag, '')
    AND COALESCE(s.lineitem_linestatus, '') = COALESCE(l.l_linestatus, '')
    AND COALESCE(s.lineitem_shipdate, DATE '1900-01-01') = COALESCE(l.l_shipdate, DATE '1900-01-01')
    AND COALESCE(s.lineitem_commitdate, DATE '1900-01-01') = COALESCE(l.l_commitdate, DATE '1900-01-01')
    AND COALESCE(s.lineitem_receiptdate, DATE '1900-01-01') = COALESCE(l.l_receiptdate, DATE '1900-01-01')
    AND COALESCE(s.lineitem_shipinstruct, '') = COALESCE(l.l_shipinstruct, '')
    AND COALESCE(s.lineitem_shipmode, '') = COALESCE(l.l_shipmode, '')
    AND COALESCE(s.lineitem_comment, '') = COALESCE(l.l_comment, '')
);

-- Загрузка SAT_PART_DETAILS
INSERT INTO dds.sat_part_details (
    hk_part_id, load_dts, rec_src, part_name, part_mfgr, part_brand, part_type,
    part_size, part_container, part_retailprice, part_comment
)
SELECT 
    MD5(CAST(p_partkey AS VARCHAR)) AS hk_part_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.part' AS rec_src,
    p_name AS part_name,
    p_mfgr AS part_mfgr,
    p_brand AS part_brand,
    p_type AS part_type,
    p_size AS part_size,
    p_container AS part_container,
    p_retailprice AS part_retailprice,
    p_comment AS part_comment
FROM tpch.tiny.part p
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_part_details s
    WHERE s.hk_part_id = MD5(CAST(p_partkey AS VARCHAR))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_part_details 
        WHERE hk_part_id = MD5(CAST(p_partkey AS VARCHAR))
    )
    AND COALESCE(s.part_name, '') = COALESCE(p.p_name, '')
    AND COALESCE(s.part_mfgr, '') = COALESCE(p.p_mfgr, '')
    AND COALESCE(s.part_brand, '') = COALESCE(p.p_brand, '')
    AND COALESCE(s.part_type, '') = COALESCE(p.p_type, '')
    AND COALESCE(s.part_size, 0) = COALESCE(p.p_size, 0)
    AND COALESCE(s.part_container, '') = COALESCE(p.p_container, '')
    AND COALESCE(s.part_retailprice, 0) = COALESCE(p.p_retailprice, 0)
    AND COALESCE(s.part_comment, '') = COALESCE(p.p_comment, '')
);

-- Загрузка SAT_SUPPLIER_DETAILS
INSERT INTO dds.sat_supplier_details (
    hk_supplier_id, load_dts, rec_src, supplier_name, supplier_address,
    supplier_phone, supplier_acctbal, supplier_comment
)
SELECT 
    MD5(CAST(s_suppkey AS VARCHAR)) AS hk_supplier_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.supplier' AS rec_src,
    s_name AS supplier_name,
    s_address AS supplier_address,
    s_phone AS supplier_phone,
    s_acctbal AS supplier_acctbal,
    s_comment AS supplier_comment
FROM tpch.tiny.supplier s
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_supplier_details st
    WHERE st.hk_supplier_id = MD5(CAST(s_suppkey AS VARCHAR))
    AND st.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_supplier_details 
        WHERE hk_supplier_id = MD5(CAST(s_suppkey AS VARCHAR))
    )
    AND COALESCE(st.supplier_name, '') = COALESCE(s.s_name, '')
    AND COALESCE(st.supplier_address, '') = COALESCE(s.s_address, '')
    AND COALESCE(st.supplier_phone, '') = COALESCE(s.s_phone, '')
    AND COALESCE(st.supplier_acctbal, 0) = COALESCE(s.s_acctbal, 0)
    AND COALESCE(st.supplier_comment, '') = COALESCE(s.s_comment, '')
);

-- Загрузка SAT_PARTSUPP_DETAILS
INSERT INTO dds.sat_partsupp_details (
    hk_partsupp_link_id, load_dts, rec_src, partsupp_availqty, partsupp_supplycost, partsupp_comment
)
SELECT 
    MD5(CONCAT(
        MD5(CAST(ps_partkey AS VARCHAR)),
        MD5(CAST(ps_suppkey AS VARCHAR))
    )) AS hk_partsupp_link_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.partsupp' AS rec_src,
    ps_availqty AS partsupp_availqty,
    ps_supplycost AS partsupp_supplycost,
    ps_comment AS partsupp_comment
FROM tpch.tiny.partsupp ps
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_partsupp_details s
    WHERE s.hk_partsupp_link_id = MD5(CONCAT(
        MD5(CAST(ps_partkey AS VARCHAR)),
        MD5(CAST(ps_suppkey AS VARCHAR))
    ))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_partsupp_details 
        WHERE hk_partsupp_link_id = MD5(CONCAT(
            MD5(CAST(ps_partkey AS VARCHAR)),
            MD5(CAST(ps_suppkey AS VARCHAR))
        ))
    )
    AND COALESCE(s.partsupp_availqty, 0) = COALESCE(ps.ps_availqty, 0)
    AND COALESCE(s.partsupp_supplycost, 0) = COALESCE(ps.ps_supplycost, 0)
    AND COALESCE(s.partsupp_comment, '') = COALESCE(ps.ps_comment, '')
);

-- Загрузка SAT_NATION_DETAILS
INSERT INTO dds.sat_nation_details (
    hk_nation_id, load_dts, rec_src, nation_name, nation_comment
)
SELECT 
    MD5(CAST(n_nationkey AS VARCHAR)) AS hk_nation_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.nation' AS rec_src,
    n_name AS nation_name,
    n_comment AS nation_comment
FROM tpch.tiny.nation n
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_nation_details s
    WHERE s.hk_nation_id = MD5(CAST(n_nationkey AS VARCHAR))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_nation_details 
        WHERE hk_nation_id = MD5(CAST(n_nationkey AS VARCHAR))
    )
    AND COALESCE(s.nation_name, '') = COALESCE(n.n_name, '')
    AND COALESCE(s.nation_comment, '') = COALESCE(n.n_comment, '')
);

-- Загрузка SAT_REGION_DETAILS
INSERT INTO dds.sat_region_details (
    hk_region_id, load_dts, rec_src, region_name, region_comment
)
SELECT 
    MD5(CAST(r_regionkey AS VARCHAR)) AS hk_region_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.region' AS rec_src,
    r_name AS region_name,
    r_comment AS region_comment
FROM tpch.tiny.region r
WHERE NOT EXISTS (
    SELECT 1 FROM dds.sat_region_details s
    WHERE s.hk_region_id = MD5(CAST(r_regionkey AS VARCHAR))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_region_details 
        WHERE hk_region_id = MD5(CAST(r_regionkey AS VARCHAR))
    )
    AND COALESCE(s.region_name, '') = COALESCE(r.r_name, '')
    AND COALESCE(s.region_comment, '') = COALESCE(r.r_comment, '')
);
