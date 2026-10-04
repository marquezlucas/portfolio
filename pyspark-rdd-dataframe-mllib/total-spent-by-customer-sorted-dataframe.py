"""Gasto total por cliente con la API de DataFrames (mismo resultado que la versión RDD).

Sirve para comparar ambos enfoques: con DataFrames, Spark optimiza el plan (Catalyst)
y el código queda más cerca de SQL.
"""
from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import FloatType, IntegerType, StructField, StructType

DATA = Path(__file__).parent / "data" / "customer-orders.csv"

SCHEMA = StructType([
    StructField("customer_id", IntegerType(), True),
    StructField("item_id", IntegerType(), True),
    StructField("amount_spent", FloatType(), True),
])


def main() -> None:
    spark = SparkSession.builder.appName("CustomerOrders").master("local[*]").getOrCreate()
    try:
        df = spark.read.schema(SCHEMA).csv(str(DATA))
        total_by_customer = (
            df.groupBy("customer_id")
            .agg(F.round(F.sum("amount_spent"), 2).alias("total_spent"))  # alias sobre la columna, no sobre el DataFrame
            .orderBy("total_spent")
        )
        total_by_customer.show(total_by_customer.count(), truncate=False)
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
