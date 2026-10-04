"""Árbol de decisión (regresión) con Spark MLlib para predecir el precio por unidad de superficie.

Dataset: data/realestate.csv (Real estate valuation, Taiwán).
Flujo: lectura -> VectorAssembler -> split train/test -> DecisionTreeRegressor -> RMSE y R².
"""
from pathlib import Path

from pyspark.ml.evaluation import RegressionEvaluator
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.regression import DecisionTreeRegressor
from pyspark.sql import SparkSession

DATA = Path(__file__).parent / "data" / "realestate.csv"
FEATURES = ["HouseAge", "DistanceToMRT", "NumberConvenienceStores"]
TARGET = "PriceOfUnitArea"
SEED = 42  # semilla fija: mismo split y mismas métricas en cada ejecución


def main() -> None:
    spark = SparkSession.builder.appName("DecisionTree").master("local[*]").getOrCreate()
    try:
        df = spark.read.option("header", "true").option("inferSchema", "true").csv(str(DATA))

        assembled = VectorAssembler(inputCols=FEATURES, outputCol="features").transform(df)
        data = assembled.select("features", TARGET)

        # Se divide el DataFrame YA ensamblado (tiene la columna "features")
        train, test = data.randomSplit([0.8, 0.2], seed=SEED)

        model = DecisionTreeRegressor(featuresCol="features", labelCol=TARGET, maxDepth=5, seed=SEED).fit(train)
        predictions = model.transform(test).cache()

        evaluator = RegressionEvaluator(labelCol=TARGET, predictionCol="prediction")
        rmse = evaluator.evaluate(predictions, {evaluator.metricName: "rmse"})
        r2 = evaluator.evaluate(predictions, {evaluator.metricName: "r2"})

        predictions.select("prediction", TARGET).show(10)
        print(f"RMSE: {rmse:.2f} | R²: {r2:.3f}")
        print("Importancia de variables:", dict(zip(FEATURES, model.featureImportances.toArray().round(3), strict=False)))
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
