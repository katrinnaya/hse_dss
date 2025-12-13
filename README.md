# Итоговое задание по модулю 6

## Часть 1. Проектирование модели данных Data Vault для TPC-H
TPC-H benchmark состоит из 8 взаимосвязанных таблиц, представляющих систему поставок
* Customer - информация о клиентах
* Orders - информация о заказах
* LineItem - детали заказов (строки заказов)
* Part - информация о деталях/товарах
* Supplier - информация о поставщиках
* PartSupp - информация о поставках деталей
* Nation - информация о странах
* Region - информация о регионах

## Модель Data Vault

## Описание сущностей Data Vault

## Просмотр структуры схемы tiny в Trino
-- Посмотреть список таблиц в схеме tpch.tiny
SHOW TABLES FROM tpch.tiny;

-- Посмотреть структуру таблицы customer
DESCRIBE tpch.tiny.customer;

-- Посмотреть структуру таблицы orders
DESCRIBE tpch.tiny.orders;

-- Посмотреть структуру таблицы lineitem
DESCRIBE tpch.tiny.lineitem;
