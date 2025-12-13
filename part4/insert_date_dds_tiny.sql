-- Загрузка SAT_ORDER_DETAILS за конкретный день
-- Параметр: load_date (DATE)
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
WHERE o_orderdate = DATE '2025-12-13' -- Параметр load_date
AND NOT EXISTS (
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

-- Загрузка SAT_LINEITEM_DETAILS за конкретный день
-- Параметр: load_date (DATE)
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
JOIN tpch.tiny.orders o ON l.l_orderkey = o.o_orderkey
WHERE o.o_orderdate = DATE '2025-12-13' -- Параметр load_date
AND NOT EXISTS (
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

-- Загрузка SAT_CUSTOMER_DETAILS за конкретный день
-- Параметр: load_date (DATE)
-- Для клиентов мы загружаем всех, у которых есть заказы за указанную дату
INSERT INTO dds.sat_customer_details (
    hk_customer_id, load_dts, rec_src, customer_name, customer_address, 
    customer_phone, customer_acctbal, customer_mktsegment, customer_comment
)
SELECT 
    MD5(CAST(c.c_custkey AS VARCHAR)) AS hk_customer_id,
    CURRENT_TIMESTAMP AS load_dts,
    'tpch.tiny.customer' AS rec_src,
    c.c_name AS customer_name,
    c.c_address AS customer_address,
    c.c_phone AS customer_phone,
    c.c_acctbal AS customer_acctbal,
    c.c_mktsegment AS customer_mktsegment,
    c.c_comment AS customer_comment
FROM tpch.tiny.customer c
JOIN tpch.tiny.orders o ON c.c_custkey = o.o_custkey
WHERE o.o_orderdate = DATE '2025-12-13' -- Параметр load_date
AND NOT EXISTS (
    SELECT 1 FROM dds.sat_customer_details s
    WHERE s.hk_customer_id = MD5(CAST(c.c_custkey AS VARCHAR))
    AND s.load_dts = (
        SELECT MAX(load_dts) FROM dds.sat_customer_details 
        WHERE hk_customer_id = MD5(CAST(c.c_custkey AS VARCHAR))
    )
    AND COALESCE(s.customer_name, '') = COALESCE(c.c_name, '')
    AND COALESCE(s.customer_address, '') = COALESCE(c.c_address, '')
    AND COALESCE(s.customer_phone, '') = COALESCE(c.c_phone, '')
    AND COALESCE(s.customer_acctbal, 0) = COALESCE(c.c_acctbal, 0)
    AND COALESCE(s.customer_mktsegment, '') = COALESCE(c.c_mktsegment, '')
    AND COALESCE(s.customer_comment, '') = COALESCE(c.c_comment, '')
);
