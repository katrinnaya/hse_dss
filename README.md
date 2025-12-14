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
4. Проверка результатов
```sql
-- Проверка количества записей в хабах
SELECT 'hub_customer' AS table_name, COUNT(*) AS count FROM dds.hub_customer
UNION ALL
SELECT 'hub_order', COUNT(*) FROM dds.hub_order
UNION ALL
SELECT 'hub_part', COUNT(*) FROM dds.hub_part
UNION ALL
SELECT 'hub_supplier', COUNT(*) FROM dds.hub_supplier
UNION ALL
SELECT 'hub_nation', COUNT(*) FROM dds.hub_nation
UNION ALL
SELECT 'hub_region', COUNT(*) FROM dds.hub_region;

-- Проверка связей
SELECT COUNT(*) AS link_count FROM dds.link_order;
SELECT COUNT(*) AS link_count FROM dds.link_lineitem;
SELECT COUNT(*) AS link_count FROM dds.link_partsupp;
```
