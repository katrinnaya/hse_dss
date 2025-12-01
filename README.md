# Streaming
* Работа с потоками данных в реальном времени с использованием **Apache Kafka** и **ksqlDB**.  
* Выполнение объединения двух потоков (`PurchaseStream`, `PaymentStream`) с временным окном `WITHIN 7 DAYS`.

## Этапы выполнения
### Создание `docker-compose.yml`
Использован исправленный файл с отключённой отправкой метрик:
```yaml
KSQL_CONFLUENT_SUPPORT_METRICS_ENABLE: "false"
```
### Запуск контейнеров в фоновом режиме
`docker-compose up -d`

### Подключение к ksqlDB CLI
`docker exec -it ksqldb-cli ksql http://ksqldb-server:8088`

### Настройка чтения с начала топиков
`SET 'auto.offset.reset' = 'earliest';`

### Создание потоков
```
-- Создание потоков
CREATE STREAM PurchaseStream (id INT KEY, product VARCHAR, left_ts VARCHAR)
  WITH (
    KAFKA_TOPIC='PurchaseTopic',
    VALUE_FORMAT='JSON',
    TIMESTAMP='left_ts',
    TIMESTAMP_FORMAT='yyyy-MM-dd''T''HH:mm:ssX',
    PARTITIONS=3
  );

CREATE STREAM PaymentStream (ID INT KEY, purchaseId INT, status VARCHAR, right_ts VARCHAR)
  WITH (
    KAFKA_TOPIC='PaymentTopic',
    VALUE_FORMAT='JSON',
    TIMESTAMP='right_ts',
    TIMESTAMP_FORMAT='yyyy-MM-dd''T''HH:mm:ssX',
    PARTITIONS=3
  );

-- Объединение потоков с временным окном 7 дней
CREATE STREAM PaymentPurchaseStream
  WITH (KAFKA_TOPIC = 'PaymentPurchaseTopic', VALUE_FORMAT='JSON') AS
  SELECT l.id AS purchaseId, l.product, r.status
  FROM PurchaseStream l
  INNER JOIN PaymentStream r
    WITHIN 7 DAYS
    ON l.id = r.purchaseId
  EMIT CHANGES;
```
### Вставка тестовых данных
```
INSERT INTO PurchaseStream (id, product, left_ts) VALUES (1, 'kettle', '2022-01-29T06:01:18Z');
INSERT INTO PurchaseStream (id, product, left_ts) VALUES (2, 'grill', '2022-01-29T17:02:20Z');
INSERT INTO PurchaseStream (id, product, left_ts) VALUES (3, 'toaster', '2022-01-29T13:44:10Z');
INSERT INTO PurchaseStream (id, product, left_ts) VALUES (4, 'hair dryer', '2022-01-29T11:58:25Z');

INSERT INTO PaymentStream (id, purchaseId, status, right_ts) VALUES (101, 1, 'OK', '2022-01-29T06:11:18Z');
INSERT INTO PaymentStream (id, purchaseId, status, right_ts) VALUES (103, 3, 'OK', '2022-01-29T13:54:10Z');
INSERT INTO PaymentStream (id, purchaseId, status, right_ts) VALUES (104, 4, 'OK', '2022-01-29T12:08:25Z');
```
### Просмотр результата объединения
`SELECT * FROM PaymentPurchaseStream EMIT CHANGES LIMIT 3;`
```
+--------------------+--------------------+--------------------+
|PURCHASEID          |PRODUCT             |STATUS              |
+--------------------+--------------------+--------------------+
|1                   |kettle              |OK                  |
|3                   |toaster             |OK                  |
|4                   |hair dryer          |OK                  |
+--------------------+--------------------+--------------------+
```
### Остановка контейнера и очистка
`docker-compose down -v`

### Примечания
* Отсутствует запись с `purchaseId = 2`, т.к. в потоке `PaymentStream` отсутствует соответствующая запись платежа. При использовании `INNER JOIN` в результат попадают только пары событий, присутствующие в обоих потоках.
* Команда `SET 'auto.offset.reset' = 'earliest'` необходима для чтения исторических данных, т.к. временные метки событий относятся к 2022 году, а система запущена в 2025 году.
