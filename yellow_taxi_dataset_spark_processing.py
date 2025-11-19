# Установка Spark (локальный запуск)
!apt-get update
!apt-get install openjdk-8-jdk-headless -qq > /dev/null
!wget -q https://archive.apache.org/dist/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz
!tar xf spark-3.5.0-bin-hadoop3.tgz
!pip install -q findspark

import os
os.environ["JAVA_HOME"] = "/usr/lib/jvm/java-8-openjdk-amd64"
os.environ["SPARK_HOME"] = "/content/spark-3.5.0-bin-hadoop3"

import findspark
findspark.init()

print("Spark установлен и настроен")

# Создание Spark сессии
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

spark = SparkSession.builder \
    .appName("NYCTaxiAnalysis") \
    .config("spark.sql.adaptive.enabled", "true") \
    .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
    .getOrCreate()

print("Spark сессия создана")
print(f"Spark version: {spark.version}")

!mkdir -p /content/taxi_data

# Скачивание данных за первые 6 месяцев 2025 года
months = ['01', '02', '03', '04', '05', '06']
base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2025-{}.parquet"

print("Скачиваем данные за первые 6 месяцев 2025 года...")

for month in months:
    url = base_url.format(month)
    filename = f"/content/taxi_data/yellow_tripdata_2025-{month}.parquet"
    print(f"Скачиваем {filename}...")
    !wget -q -O {filename} {url}

# Загружаем все данные в один Spark DataFrame
from pyspark.sql import DataFrame

def read_and_union_parquet_files(months):
    """Читает и объединяет parquet файлы"""
    df_list = []
    for month in months:
        filename = f"/content/taxi_data/yellow_tripdata_2025-{month}.parquet"
        try:
            df_month = spark.read.parquet(filename)
            df_list.append(df_month)
            print(f"Загружен {filename}: {df_month.count():,} записей")
        except Exception as e:
            print(f"Ошибка при загрузке {filename}: {e}")
    
    # Объединяем все DataFrame
    if df_list:
        df = df_list[0]
        for i in range(1, len(df_list)):
            df = df.union(df_list[i])
        return df
    else:
        return None

# Загружаем данные
df = read_and_union_parquet_files(months)

if df:
    print(f"Общий размер данных: {df.count():,} записей")
    print("Схема данных:")
    df.printSchema()
    print("\nПример данных:")
    df.show(5)
else:
    print("Не удалось загрузить данные")

# Очитска данных

print("Статистика перед очисткой:")
print(f"Общее количество записей: {df.count():,}")

# Проверяем проблемные записи
print("\nПроблемные записи:")
print(f"trip_distance <= 0: {df.filter(col('trip_distance') <= 0).count():,}")
print(f"passenger_count <= 0: {df.filter(col('passenger_count') <= 0).count():,}")

# Проверяем диапазон дат
min_pickup = df.agg(min("tpep_pickup_datetime")).collect()[0][0]
max_pickup = df.agg(max("tpep_pickup_datetime")).collect()[0][0]
min_dropoff = df.agg(min("tpep_dropoff_datetime")).collect()[0][0]
max_dropoff = df.agg(max("tpep_dropoff_datetime")).collect()[0][0]

print(f"\nДиапазон дат посадки: {min_pickup} - {max_pickup}")
print(f"Диапазон дат высадки: {min_dropoff} - {max_dropoff}")

# Очистка данных по условиям задания
df_clean = df.filter(
    (col("tpep_pickup_datetime") >= "2025-01-01") &
    (col("tpep_pickup_datetime") <= "2025-06-30 23:59:59") &
    (col("tpep_dropoff_datetime") >= "2025-01-01") &
    (col("tpep_dropoff_datetime") <= "2025-06-30 23:59:59") &
    (col("trip_distance") > 0) &
    (col("passenger_count") > 0)
)

print(f"Данные очищены")
print(f"Размер после очистки: {df_clean.count():,} записей")
print(f"Удалено записей: {df.count() - df_clean.count():,}")

# Добавляем колонки с часом посадки и высадки, а также датой
df_with_hours = df_clean \
    .withColumn("pickup_hour", hour("tpep_pickup_datetime")) \
    .withColumn("dropoff_hour", hour("tpep_dropoff_datetime")) \
    .withColumn("pickup_date", to_date("tpep_pickup_datetime"))

print("Колонки с часами добавлены")
print("Проверяем добавленные колонки:")
df_with_hours.select("tpep_pickup_datetime", "pickup_hour", "tpep_dropoff_datetime", "dropoff_hour", "pickup_date").show(5)

# Выбираем только нужные колонки согласно заданию
df_final = df_with_hours.select(
    col("tpep_pickup_datetime").alias("pickup_datetime"),
    col("tpep_dropoff_datetime").alias("dropoff_datetime"),
    col("passenger_count"),
    col("trip_distance"),
    col("PULocationID"),
    col("DOLocationID"),
    col("total_amount"),
    col("pickup_hour"),
    col("dropoff_hour"),
    col("pickup_date")
)

print("Нужные колонки выбраны")
print("Схема финального DataFrame:")
df_final.printSchema()
print(f"Размер данных: {df_final.count():,} записей")
df_final.show(5)

# Скачиваем данные о зонах такси
zones_url = "https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv"
zones_filename = "/content/taxi_data/taxi_zones.csv"

print("Скачиваем данные о зонах...")
!wget -q -O {zones_filename} {zones_url}

# Загружаем данные о зонах в Spark
zones_df = spark.read \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .csv(zones_filename)

print(f"Данные о зонах загружены: {zones_df.count()} зон")
print("Схема данных о зонах:")
zones_df.printSchema()
zones_df.show(5)

# Соединяем данные о поездках с названиями зон посадки
df_with_pu_zones = df_final.join(
    zones_df.select(
        col("LocationID").alias("PULocationID_join"),
        col("Zone").alias("PUZone")
    ),
    df_final.PULocationID == col("PULocationID_join"),
    "left"
).drop("PULocationID_join")

# Соединяем с названиями зон высадки
df_with_all_zones = df_with_pu_zones.join(
    zones_df.select(
        col("LocationID").alias("DOLocationID_join"),
        col("Zone").alias("DOZone")
    ),
    df_with_pu_zones.DOLocationID == col("DOLocationID_join"),
    "left"
).drop("DOLocationID_join")

print("Данные соединены с зонами")
print(f"Размер данных после соединения: {df_with_all_zones.count():,} записей")
print("Колонки после соединения:")
df_with_all_zones.printSchema()
df_with_all_zones.select("PULocationID", "PUZone", "DOLocationID", "DOZone").show(10)

# Агрегация
# Сначала создаем агрегацию по дням и часам
daily_hourly_agg = df_with_all_zones.groupBy("PUZone", "pickup_date", "pickup_hour") \
    .agg(count("*").alias("daily_trip_count"))

print("Ежедневная часовая агрегация создана")
print(f"Размер агрегированных данных: {daily_hourly_agg.count():,} записей")
daily_hourly_agg.show(10)

# pivot-таблица
# Вычисляем среднее количество поездок для каждой зоны в каждый час
average_hourly_agg = daily_hourly_agg.groupBy("PUZone", "pickup_hour") \
    .agg(avg("daily_trip_count").alias("avg_trip_count"))

print("Средняя часовая агрегация создана")
print(f"Размер данных: {average_hourly_agg.count():,} записей")
average_hourly_agg.show(10)

# Создаем pivot таблицу
pivot_df = average_hourly_agg.groupBy("PUZone") \
    .pivot("pickup_hour", [str(i) for i in range(24)]) \
    .agg(first("avg_trip_count")) \
    .fillna(0)

# Переименовываем колонки для единообразия
hour_columns = [f"hour_{i}" for i in range(24)]
for i in range(24):
    pivot_df = pivot_df.withColumnRenamed(str(i), f"hour_{i}")

print("Pivot таблица создана")
print(f"Размер pivot таблицы: {pivot_df.count()} строк, {len(pivot_df.columns)} колонок")
print(f"Колонки: {pivot_df.columns}")

# Показываем результат
pivot_df.show(10)

# Сохраняем итоговый набор данных в формате parquet
output_path = "/content/taxi_data/final_hourly_zone_aggregation_spark"

# Сохраняем в режиме перезаписи
pivot_df.write \
    .mode("overwrite") \
    .option("compression", "snappy") \
    .parquet(output_path)

print(f"Результат сохранен в: {output_path}")

spark.stop() 

# Проверяем сохраненные данные
saved_df = spark.read.parquet(output_path)
print(f"Проверка: загружено {saved_df.count()} строк, {len(saved_df.columns)} колонок")
print("Колонки сохраненного файла:")
print(saved_df.columns)
