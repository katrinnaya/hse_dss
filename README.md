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
## Результаты 
```
 _col0 
-------
 478   
(1 row)

Query 20251126_084120_00000_fcikx, FINISHED, 1 node
Splits: 1 total, 1 done (100.00%)
0.24 [0 rows, 0B] [0 rows/s, 0B/s]
```
```
 _col0 
-------
     5 
(1 row)

Query 20251126_084308_00007_fcikx, FINISHED, 1 node
Splits: 21 total, 21 done (100.00%)
0.07 [5 rows, 176B] [76 rows/s, 2.64KiB/s]
```
```
 regionkey |    name     |                                                       comment                                 >
-----------+-------------+----------------------------------------------------------------------------------------------->
         0 | AFRICA      | lar deposits. blithely final packages cajole. regular waters are final requests. regular accou>
         1 | AMERICA     | hs use ironic, even requests. s                                                               >
         2 | ASIA        | ges. thinly even pinto beans ca                                                               >
         3 | EUROPE      | ly final courts cajole furiously final excuse                                                 >
         4 | MIDDLE EAST | uickly special accounts cajole carefully blithely close requests. carefully final asymptotes h>
(5 rows)
```
```
 _col0 
-------
    25 
(1 row)

Query 20251126_084404_00009_fcikx, FINISHED, 1 node
Splits: 21 total, 21 done (100.00%)
0.14 [25 rows, 176B] [185 rows/s, 1.27KiB/s]
```
```
 nationkey |      name      | regionkey |                                                      comment                   >
-----------+----------------+-----------+-------------------------------------------------------------------------------->
         0 | ALGERIA        |         0 |  haggle. carefully final deposits detect slyly agai                            >
         1 | ARGENTINA      |         1 | al foxes promise slyly according to the regular accounts. bold requests alon   >
         2 | BRAZIL         |         1 | y alongside of the pending deposits. carefully special packages are about the i>
         3 | CANADA         |         1 | eas hang ironic, silent packages. slyly regular packages are furiously over the>
         4 | EGYPT          |         4 | y above the carefully unusual theodolites. final dugouts are quickly across the>
         5 | ETHIOPIA       |         0 | ven packages wake quickly. regu                                                >
         6 | FRANCE         |         3 | refully final requests. regular, ironi                                         >
         7 | GERMANY        |         3 | l platelets. regular accounts x-ray: unusual, regular acco                     >
         8 | INDIA          |         2 | ss excuses cajole slyly across the packages. deposits print aroun              >
         9 | INDONESIA      |         2 |  slyly express asymptotes. regular deposits haggle slyly. carefully ironic hock>
        10 | IRAN           |         4 | efully alongside of the slyly final dependencies.                              >
        11 | IRAQ           |         4 | nic deposits boost atop the quickly final requests? quickly regula             >
        12 | JAPAN          |         2 | ously. final, express gifts cajole a                                           >
        13 | JORDAN         |         4 | ic deposits are blithely about the carefully regular pa                        >
        14 | KENYA          |         0 |  pending excuses haggle furiously deposits. pending, express pinto beans wake f>
        15 | MOROCCO        |         0 | rns. blithely bold courts among the closely regular packages use furiously bold>
        16 | MOZAMBIQUE     |         0 | s. ironic, unusual asymptotes wake blithely r                                  >
        17 | PERU           |         1 | platelets. blithely pending dependencies use fluffily across the even pinto bea>
        18 | CHINA          |         2 | c dependencies. furiously express notornis sleep slyly regular accounts. ideas >
        19 | ROMANIA        |         3 | ular asymptotes are about the furious multipliers. express dependencies nag abo>
        20 | SAUDI ARABIA   |         4 | ts. silent requests haggle. closely express packages sleep across the blithely >
        21 | VIETNAM        |         2 | hely enticingly express accounts. even, final                                  >
        22 | RUSSIA         |         3 |  requests against the platelets use never according to the quickly regular pint>
        23 | UNITED KINGDOM |         3 | eans boost carefully special requests. accounts are. carefull                  >
        24 | UNITED STATES  |         1 | y final packages. slow foxes cajole quickly. quickly silent platelets breach ir>
(25 rows)
```
```
 _col0  
--------
 150000 
(1 row)

Query 20251126_084444_00011_fcikx, FINISHED, 1 node
Splits: 21 total, 21 done (100.00%)
0.15 [150K rows, 176B] [1.03M rows/s, 1.19KiB/s]
```

```
 custkey |        name        |                address                 | nationkey |      phone      | acctbal | mktsegme>
---------+--------------------+----------------------------------------+-----------+-----------------+---------+--------->
       1 | Customer#000000001 | IVhzIApeRb ot,c,E                      |        15 | 25-989-741-2988 |  711.56 | BUILDING>
       2 | Customer#000000002 | XSTf4,NCwDVaWNe6tEgvwfmRchLXak         |        13 | 23-768-687-3665 |  121.65 | AUTOMOBI>
       3 | Customer#000000003 | MG9kdTD2WBHm                           |         1 | 11-719-748-3364 | 7498.12 | AUTOMOBI>
       4 | Customer#000000004 | XxVSJsLAGtn                            |         4 | 14-128-190-5944 | 2866.83 | MACHINER>
       5 | Customer#000000005 | KvpyuHCplrB84WgAiGV6sYpZq7Tj           |         3 | 13-750-942-6364 |  794.47 | HOUSEHOL>
       6 | Customer#000000006 | sKZz0CsnMD7mp4Xd0YrBvx,LREYKUWAh yVn   |        20 | 30-114-968-4951 | 7638.57 | AUTOMOBI>
       7 | Customer#000000007 | TcGe5gaZNgVePxU5kRrvXBfkasDTea         |        18 | 28-190-982-9759 | 9561.95 | AUTOMOBI>
       8 | Customer#000000008 | I0B10bB0AymmC, 0PrRYBCP1yGJ8xcBPmWhl5  |        17 | 27-147-574-9335 | 6819.74 | BUILDING>
       9 | Customer#000000009 | xKiAFTjUsCuxfeleNqefumTrjS             |         8 | 18-338-906-3675 | 8324.07 | FURNITUR>
      10 | Customer#000000010 | 6LrEaV6KR6PLVcgl2ArL Q3rqzLzcT1 v2     |         5 | 15-741-346-9870 | 2753.54 | HOUSEHOL>
      11 | Customer#000000011 | PkWS 3HlXqwTuzrKg633BEi                |        23 | 33-464-151-3439 |  -272.6 | BUILDING>
      12 | Customer#000000012 | 9PWKuhzT4Zr1Q                          |        13 | 23-791-276-1263 | 3396.49 | HOUSEHOL>
      13 | Customer#000000013 | nsXQu0oVjD7PM659uC3SRSp                |         3 | 13-761-547-5974 | 3857.34 | BUILDING>
      14 | Customer#000000014 | KXkletMlL2JQEA                         |         1 | 11-845-129-3851 |  5266.3 | FURNITUR>
      15 | Customer#000000015 | YtWggXoOLdwdo7b0y,BZaGUQMLJMX1Y,EC,6Dn |        23 | 33-687-542-7601 | 2788.52 | HOUSEHOL>
      16 | Customer#000000016 | cYiaeMLZSMAOQ2 d0W,                    |        10 | 20-781-609-3107 | 4681.03 | FURNITUR>
      17 | Customer#000000017 | izrh 6jdqtp2eqdtbkswDD8SG4SzXruMfIXyR7 |         2 | 12-970-682-3487 |    6.34 | AUTOMOBI>
      18 | Customer#000000018 | 3txGO AiuFux3zT0Z9NYaFRnZt             |         6 | 16-155-215-1315 | 5494.43 | BUILDING>
      19 | Customer#000000019 | uc,3bHIx84H,wdrmLOjVsiqXCq2tr          |        18 | 28-396-526-5053 | 8914.71 | HOUSEHOL>
      20 | Customer#000000020 | JrPk8Pqplj4Ne                          |        22 | 32-957-234-8742 |  7603.4 | FURNITUR>
(20 rows)
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
## Результат
```
 returnflag | linestatus |   sum_qty   |    sum_base_price     |    sum_disc_price     |      sum_charge       |      avg>
------------+------------+-------------+-----------------------+-----------------------+-----------------------+--------->
 A          | F          | 3.7734107E7 |  5.658655440072895E10 |  5.375825713486947E10 | 5.5909065222827614E10 | 25.52200>
 N          | F          |    991417.0 |   1.487504710380001E9 |  1.4130821680540988E9 |  1.4696492231943758E9 | 25.51647>
 N          | O          | 7.5669043E7 | 1.1348791644467107E11 | 1.0781484730912013E11 | 1.1213122830926822E11 | 25.50207>
 R          | F          | 3.7719753E7 |  5.656804138090029E10 |  5.374129268460422E10 | 5.5889619119832016E10 |  25.5057>
(4 rows)
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
## Результат
```
 acctbal |        name        |      name      | partkey |      mfgr      |                 address                  |   >
---------+--------------------+----------------+---------+----------------+------------------------------------------+--->
 9938.53 | Supplier#000005359 | UNITED KINGDOM |  185358 | Manufacturer#4 | QKuHYh,vZGiwu2FWEJoLDx04                 | 33>
 9937.84 | Supplier#000005969 | ROMANIA        |  108438 | Manufacturer#1 | ANDENSOSmk,miq23Xfb5RWt6dvUcvt6Qa        | 29>
 9936.22 | Supplier#000005250 | UNITED KINGDOM |     249 | Manufacturer#4 | B3rqp0xbSEim4Mpy2RH J                    | 33>
 9923.77 | Supplier#000002324 | GERMANY        |   29821 | Manufacturer#4 | y3OD9UywSTOk                             | 17>
 9871.22 | Supplier#000006373 | GERMANY        |   43868 | Manufacturer#5 | J8fcXWsTqM                               | 17>
 9870.78 | Supplier#000001286 | GERMANY        |   81285 | Manufacturer#2 | YKA,E2fjiVd7eUrzp2Ef8j1QxGo2DFnosaTEH    | 17>
 9870.78 | Supplier#000001286 | GERMANY        |  181285 | Manufacturer#4 | YKA,E2fjiVd7eUrzp2Ef8j1QxGo2DFnosaTEH    | 17>
 9852.52 | Supplier#000008973 | RUSSIA         |   18972 | Manufacturer#2 | t5L67YdBYYH6o,Vz24jpDyQ9                 | 32>
 9847.83 | Supplier#000008097 | RUSSIA         |  130557 | Manufacturer#2 | xMe97bpE69NzdwLoX                        | 32>
 9847.57 | Supplier#000006345 | FRANCE         |   86344 | Manufacturer#1 | VSt3rzk3qG698u6ld8HhOByvrTcSTSvQlDQDag   | 16>
 9847.57 | Supplier#000006345 | FRANCE         |  173827 | Manufacturer#2 | VSt3rzk3qG698u6ld8HhOByvrTcSTSvQlDQDag   | 16>
 9836.93 | Supplier#000007342 | RUSSIA         |    4841 | Manufacturer#4 | JOlK7C1,7xrEZSSOw                        | 32>
  9817.1 | Supplier#000002352 | RUSSIA         |  124815 | Manufacturer#2 | 4LfoHUZjgjEbAKw TgdKcgOc4D4uCYw          | 32>
  9817.1 | Supplier#000002352 | RUSSIA         |  152351 | Manufacturer#3 | 4LfoHUZjgjEbAKw TgdKcgOc4D4uCYw          | 32>
 9739.86 | Supplier#000003384 | FRANCE         |  138357 | Manufacturer#2 | o,Z3v4POifevE k9U1b 6J1ucX,I             | 16>
 9721.95 | Supplier#000008757 | UNITED KINGDOM |  156241 | Manufacturer#3 | Atg6GnM4dT2                              | 33>
 9681.33 | Supplier#000008406 | RUSSIA         |   78405 | Manufacturer#1 | ,qUuXcftUl                               | 32>
 9643.55 | Supplier#000005148 | ROMANIA        |  107617 | Manufacturer#1 | kT4ciVFslx9z4s79p Js825                  | 29>
 9624.82 | Supplier#000001816 | FRANCE         |   34306 | Manufacturer#3 | e7vab91vLJPWxxZnewmnDBpDmxYHrb           | 16>
 9624.78 | Supplier#000009658 | ROMANIA        |  189657 | Manufacturer#1 | oE9uBgEfSS4opIcepXyAYM,x                 | 29>
 9612.94 | Supplier#000003228 | ROMANIA        |  120715 | Manufacturer#2 | KDdpNKN3cWu7ZSrbdqp7AfSLxx,qWB           | 29>
 9612.94 | Supplier#000003228 | ROMANIA        |  198189 | Manufacturer#4 | KDdpNKN3cWu7ZSrbdqp7AfSLxx,qWB           | 29>
 9571.83 | Supplier#000004305 | ROMANIA        |  179270 | Manufacturer#2 | qNHZ7WmCzygwMPRDO9Ps                     | 29>
  9558.1 | Supplier#000003532 | UNITED KINGDOM |   88515 | Manufacturer#4 | EOeuiiOn21OVpTlGguufFDFsbN1p0lhpxHp      | 33>
 9492.79 | Supplier#000005975 | GERMANY        |   25974 | Manufacturer#5 | S6mIiCTx82z7lV                           | 17>
 9461.05 | Supplier#000002536 | UNITED KINGDOM |   20033 | Manufacturer#1 | 8mmGbyzaU 7ZS2wJumTibypncu9pNkDc4FYA     | 33>
 9453.01 | Supplier#000000802 | ROMANIA        |  175767 | Manufacturer#1 | ,6HYXb4uaHITmtMBj4Ak57Pd                 | 29>
 9408.65 | Supplier#000007772 | UNITED KINGDOM |  117771 | Manufacturer#4 | AiC5YAH,gdu0i7                           | 33>
 9359.61 | Supplier#000004856 | ROMANIA        |   62349 | Manufacturer#5 | HYogcF3Jb yh1                            | 29>
 9357.45 | Supplier#000006188 | UNITED KINGDOM |  138648 | Manufacturer#1 | g801,ssP8wpTk4Hm                         | 33>
 9352.04 | Supplier#000003439 | GERMANY        |  170921 | Manufacturer#4 | qYPDgoiBGhCYxjgC                         | 17>
 9312.97 | Supplier#000007807 | RUSSIA         |   90279 | Manufacturer#5 | oGYMPCk9XHGB2PBfKRnHA                    | 32>
 9312.97 | Supplier#000007807 | RUSSIA         |  100276 | Manufacturer#5 | oGYMPCk9XHGB2PBfKRnHA                    | 32>
 9280.27 | Supplier#000007194 | ROMANIA        |   47193 | Manufacturer#3 | zhRUQkBSrFYxIAXTfInj vyGRQjeK            | 29>
  9274.8 | Supplier#000008854 | RUSSIA         |   76346 | Manufacturer#3 | 1xhLoOUM7I3mZ1mKnerw OSqdbb4QbGa         | 32>
 9249.35 | Supplier#000003973 | FRANCE         |   26466 | Manufacturer#1 | d18GiDsL6Wm2IsGXM,RZf1jCsgZAOjNYVThTRP4  | 16>
 9249.35 | Supplier#000003973 | FRANCE         |   33972 | Manufacturer#1 | d18GiDsL6Wm2IsGXM,RZf1jCsgZAOjNYVThTRP4  | 16>
  9208.7 | Supplier#000007769 | ROMANIA        |   40256 | Manufacturer#5 | rsimdze 5o9P Ht7xS                       | 29>
 9201.47 | Supplier#000009690 | UNITED KINGDOM |   67183 | Manufacturer#5 | CB BnUTlmi5zdeEl7R7                      | 33>
  9192.1 | Supplier#000000115 | UNITED KINGDOM |   85098 | Manufacturer#3 | nJ 2t0f7Ve,wL1,6WzGBJLNBUCKlsV           | 33>
 9189.98 | Supplier#000001226 | GERMANY        |   21225 | Manufacturer#4 | qsLCqSvLyZfuXIpjz                        | 17>
 9128.97 | Supplier#000004311 | RUSSIA         |  146768 | Manufacturer#5 | I8IjnXd7NSJRs594RxsRR0                   | 32>
 9104.83 | Supplier#000008520 | GERMANY        |  150974 | Manufacturer#4 | RqRVDgD0ER J9 b41vR2,3                   | 17>
  9101.0 | Supplier#000005791 | ROMANIA        |  128254 | Manufacturer#5 | zub2zCV,jhHPPQqi,P2INAjE1zI n66cOEoXFG   | 29>
 9094.57 | Supplier#000004582 | RUSSIA         |   39575 | Manufacturer#1 | WB0XkCSG3r,mnQ n,h9VIxjjr9ARHFvKgMDf     | 32>
 8996.87 | Supplier#000004702 | FRANCE         |  102191 | Manufacturer#5 | 8XVcQK23akp                              | 16>
 8996.14 | Supplier#000009814 | ROMANIA        |  139813 | Manufacturer#2 | af0O5pg83lPU4IDVmEylXZVqYZQzSDlYLAmR     | 29>
 8968.42 | Supplier#000010000 | ROMANIA        |  119999 | Manufacturer#5 | aTGLEusCiL4F PDBdv665XBJhPyCOB0i         | 29>
 8936.82 | Supplier#000007043 | UNITED KINGDOM |  109512 | Manufacturer#1 | FVajceZInZdbJE6Z9XsRUxrUEpiwHDrOXi,1Rz   | 33>
 8929.42 | Supplier#000008770 | FRANCE         |  173735 | Manufacturer#4 | R7cG26TtXrHAP9 HckhfRi                   | 16>
 8920.59 | Supplier#000003967 | ROMANIA        |   26460 | Manufacturer#1 | eHoAXe62SY9                              | 29>
 8920.59 | Supplier#000003967 | ROMANIA        |  173966 | Manufacturer#2 | eHoAXe62SY9                              | 29>
 8913.96 | Supplier#000004603 | UNITED KINGDOM |  137063 | Manufacturer#2 | OUzlvMUr7n,utLxmPNeYKSf3T24OXskxB5       | 33>
 8877.82 | Supplier#000007967 | FRANCE         |  167966 | Manufacturer#5 | A3pi1BARM4nx6R,qrwFoRPU                  | 16>
 8862.24 | Supplier#000003323 | ROMANIA        |   73322 | Manufacturer#3 | W9 lYcsC9FwBqk3ItL                       | 29>
 8841.59 | Supplier#000005750 | ROMANIA        |  100729 | Manufacturer#5 | Erx3lAgu0g62iaHF9x50uMH4EgeN9hEG         | 29>
 8781.71 | Supplier#000003121 | ROMANIA        |   13120 | Manufacturer#5 | wNqTogx238ZYCamFb,50v,bj 4IbNFW9Bvw1xP   | 29>
 8754.24 | Supplier#000009407 | UNITED KINGDOM |  179406 | Manufacturer#4 | CHRCbkaWcf5B                             | 33>
 8691.06 | Supplier#000004429 | UNITED KINGDOM |  126892 | Manufacturer#2 | k,BQms5UhoAF1B2Asi,fLib                  | 33>
 8655.99 | Supplier#000006330 | RUSSIA         |  193810 | Manufacturer#2 | UozlaENr0ytKe2w6CeIEWFWn iO3S8Rae7Ou     | 32>
 8638.36 | Supplier#000002920 | RUSSIA         |   75398 | Manufacturer#1 | Je2a8bszf3L                              | 32>
(query aborted by user)

Query 20251126_084600_00014_fcikx, FINISHED, 1 node
Splits: 315 total, 315 done (100.00%)
1.78 [1.78M rows, 4.1MiB] [1000K rows/s, 2.3MiB/s]
```
# Остановка контейнера и его удаление
`docker stop trino`

`docker rm trino`    
