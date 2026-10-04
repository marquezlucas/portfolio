"""Gasto total por cliente con la API de RDDs de Spark.

Entrada: data/customer-orders.csv (customer_id, item_id, monto) sin encabezado.
Salida: gasto total por cliente, ordenado de menor a mayor.
"""
from operator import add
from pathlib import Path

from pyspark import SparkConf, SparkContext

DATA = Path(__file__).parent / "data" / "customer-orders.csv"


def parse_line(line: str) -> tuple[int, float]:
    customer_id, _item_id, amount = line.split(",")
    return int(customer_id), float(amount)


def main() -> None:
    conf = SparkConf().setMaster("local[*]").setAppName("CountUpTotalAmount")
    sc = SparkContext(conf=conf)
    try:
        totals = (
            sc.textFile(str(DATA))
            .map(parse_line)
            .reduceByKey(add)                          # (cliente, gasto_total)
            .map(lambda kv: (kv[1], kv[0]))            # (gasto_total, cliente) para ordenar por monto
            .sortByKey()
        )
        for amount, customer_id in totals.collect():
            print(f"{customer_id}\t{amount:,.2f}")
    finally:
        sc.stop()


if __name__ == "__main__":
    main()
