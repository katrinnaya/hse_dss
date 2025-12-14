-- ========================================================
-- Усложнение: Инкрементальная загрузка данных за конкретный день
-- Дата передаётся как параметр 
-- Загрузка за 1996-01-02 (2 заказа)
-- ========================================================

-- 1. Загрузка SAT_ORDER_DETAILS за указанный день
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
FROM tpch.tiny.orders
WHERE orderdate = DATE '1996-01-02';  -- <<< Это и есть "параметр даты"

-- 2. Загрузка SAT_LINEITEM_DETAILS за тот же день
-- (только строки заказов, созданных в указанный день)
INSERT INTO memory.dds.sat_lineitem_details (
    hk_lineitem_link_id, load_dts, lineitem_quantity, lineitem_extendedprice,
    lineitem_discount, lineitem_tax, lineitem_returnflag, lineitem_linestatus,
    lineitem_shipdate, lineitem_commitdate, lineitem_receiptdate,
    lineitem_shipinstruct, lineitem_shipmode, lineitem_comment, hash_diff, rec_src
)
SELECT
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(l.orderkey AS VARCHAR),
        CAST(l.partkey AS VARCHAR),
        CAST(l.suppkey AS VARCHAR),
        CAST(l.linenumber AS VARCHAR)
    )))) AS hk_lineitem_link_id,
    CURRENT_TIMESTAMP AS load_dts,
    l.quantity,
    l.extendedprice,
    l.discount,
    l.tax,
    l.returnflag,
    l.linestatus,
    l.shipdate,
    l.commitdate,
    l.receiptdate,
    l.shipinstruct,
    l.shipmode,
    l.comment,
    TO_HEX(MD5(TO_UTF8(CONCAT(
        CAST(l.quantity AS VARCHAR),
        CAST(l.extendedprice AS VARCHAR),
        CAST(l.discount AS VARCHAR),
        CAST(l.tax AS VARCHAR),
        COALESCE(l.returnflag, ''),
        COALESCE(l.linestatus, ''),
        CAST(l.shipdate AS VARCHAR),
        CAST(l.commitdate AS VARCHAR),
        CAST(l.receiptdate AS VARCHAR),
        COALESCE(l.shipinstruct, ''),
        COALESCE(l.shipmode, ''),
        COALESCE(l.comment, '')
    )))) AS hash_diff,
    'tpch.tiny.lineitem' AS rec_src
FROM tpch.tiny.lineitem l
JOIN tpch.tiny.orders o ON l.orderkey = o.orderkey
WHERE o.orderdate = DATE '1996-01-02';  -- <<< та же дата
