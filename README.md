# Запуск Trino
`docker run --name trino -d -p 8080:8080 trinodb/trino`
# Проверка работы в UI
`http://localhost:8080`
# Подключение через CLI 
`docker exec -it trino trino`
# Выполнение запросов
```
SELECT version();
SELECT count(*) FROM tpch.sf1.region;
SELECT * FROM tpch.sf1.region;
SELECT count(*) FROM tpch.sf1.nation;
SELECT * FROM tpch.sf1.nation;
SELECT count(*) FROM tpch.sf1.customer;
SELECT * FROM tpch.sf1.customer LIMIT 20;
```

# Pricing summary report query (Q1)
```
SELECT
    returnflag,
    linestatus,
    sum(quantity) AS sum_qty,
    sum(extendedprice) as sum_base_price,
    sum(extendedprice * (1 - discount)) AS sum_disc_price,
    sum(extendedprice * (1 - discount) * (1 + tax)) AS sum_charge,
    avg(quantity) AS avg_qty,
    avg(extendedprice) AS avg_price,
    avg(discount) AS avg_disc,
    count(*) AS count_order
FROM tpch.sf1.lineitem
WHERE shipdate <= date '1998-12-01' - INTERVAL '60' DAY
GROUP BY
    returnflag,
    linestatus
ORDER BY
    returnflag,
    linestatus;
```    
# Minimum cost supplier query (Q2)
```
SELECT
    s.acctbal,
    s.name,
    n.name,
    p.partkey,
    p.mfgr,
    s.address,
    s.phone,
    s.comment
FROM
    tpch.sf1.part p,
    tpch.sf1.supplier s,
    tpch.sf1.partsupp ps,
    tpch.sf1.nation n,
    tpch.sf1.region r
WHERE
    p.partkey = ps.partkey
    AND s.suppkey = ps.suppkey
    AND p.size = 15
    AND p.type like '%BRASS'
    AND s.nationkey = n.nationkey
    AND n.regionkey = r.regionkey
    AND r.name = 'EUROPE'
    AND ps.supplycost = (
        SELECT min(ps.supplycost)
        FROM
            tpch.sf1.partsupp ps,
            tpch.sf1.supplier s,
            tpch.sf1.nation n,
            tpch.sf1.region r
        WHERE
            p.partkey = ps.partkey
            AND s.suppkey = ps.suppkey
            AND s.nationkey = n.nationkey
            AND n.regionkey = r.regionkey
            AND r.name = 'EUROPE'
    )
ORDER BY
    s.acctbal DESC,
    n.name,
    s.name,
    p.partkey;
```
# Остановка контейнера и его удаление
`docker stop trino`

`docker rm trino`    
