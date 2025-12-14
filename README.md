# Итоговое задание по модулю 6

## Проектирование модели данных Data Vault для TPC-H
TPC-H benchmark состоит из 8 взаимосвязанных таблиц, представляющих систему поставок
* Customer - информация о клиентах
* Orders - информация о заказах
* LineItem - детали заказов (строки заказов)
* Part - информация о деталях/товарах
* Supplier - информация о поставщиках
* PartSupp - информация о поставках деталей
* Nation - информация о странах
* Region - информация о регионах


### Просмотр структуры схемы tiny в Trino
-- Посмотреть список таблиц в схеме tpch.tiny
SHOW TABLES FROM tpch.tiny;

### Модель Data Vault

### Описание сущностей Data Vault

## Запуск
1. Запуск Trino в Docker:

`docker run --name trino -d -p 8080:8080 trinodb/trino`

2. Подключение через DBeaver с параметрами:
* Хост: localhost
* Порт: 8080
* Пользователь: guest
* Драйвер: Trino

3. Выполнение скриптов:
* Создание схемы и таблицы (часть 2)

Проверка создания
```sql
SHOW TABLES FROM memory.dds;
```

* Загрузка данных (часть 3)

Проверка на примере хабов
```sql
SELECT COUNT(*) AS cnt FROM memory.dds.hub_customer;     
SELECT COUNT(*) AS cnt FROM memory.dds.hub_order;        
SELECT COUNT(*) AS cnt FROM memory.dds.hub_part;         
SELECT COUNT(*) AS cnt FROM memory.dds.hub_supplier;    
SELECT COUNT(*) AS cnt FROM memory.dds.hub_nation;       
SELECT COUNT(*) AS cnt FROM memory.dds.hub_region;
```
* Инкрементальная загрузка (часть 4)

 Проверка
 ```sql
 -- Сколько заказов за 1996-01-02?
SELECT COUNT(*) FROM tpch.tiny.orders WHERE orderdate = DATE '1996-01-02'; -- 2

-- Сколько добавилось в sat_order_details?
SELECT COUNT(*) FROM memory.dds.sat_order_details WHERE order_date = DATE '1996-01-02';
```
4. Проверка результатов
```sql
-- =============================================
-- ФИНАЛЬНАЯ ПРОВЕРКА: количество записей в DDS
-- =============================================

-- Проверка количества записей в хабах
SELECT 'hub_customer' AS table_name, COUNT(*) AS count FROM memory.dds.hub_customer
UNION ALL
SELECT 'hub_order', COUNT(*) FROM memory.dds.hub_order
UNION ALL
SELECT 'hub_part', COUNT(*) FROM memory.dds.hub_part
UNION ALL
SELECT 'hub_supplier', COUNT(*) FROM memory.dds.hub_supplier
UNION ALL
SELECT 'hub_nation', COUNT(*) FROM memory.dds.hub_nation
UNION ALL
SELECT 'hub_region', COUNT(*) FROM memory.dds.hub_region

UNION ALL

-- Проверка количества записей в линках
SELECT 'link_order', COUNT(*) FROM memory.dds.link_order
UNION ALL
SELECT 'link_lineitem', COUNT(*) FROM memory.dds.link_lineitem
UNION ALL
SELECT 'link_partsupp', COUNT(*) FROM memory.dds.link_partsupp

UNION ALL

-- Проверка количества записей в ключевых сателлитах
SELECT 'sat_order_details', COUNT(*) FROM memory.dds.sat_order_details
UNION ALL
SELECT 'sat_lineitem_details', COUNT(*) FROM memory.dds.sat_lineitem_details;
```
