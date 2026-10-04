"""Promedio de amigos por edad (dataset sintético de práctica)."""
from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql import functions as F

DATA = Path(__file__).parent / "data" / "fakefriends-header.csv"


def main() -> None:
    spark = SparkSession.builder.appName("FriendsByAge").master("local[*]").getOrCreate()
    try:
        friends = spark.read.option("header", "true").option("inferSchema", "true").csv(str(DATA))
        (
            friends.groupBy("age")
            .agg(F.round(F.avg("friends"), 2).alias("friends_avg"))
            .orderBy("age")
            .show(100)
        )
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
