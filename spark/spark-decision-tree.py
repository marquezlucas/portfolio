from pyspark.sql import SparkSession
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.regression import DecisionTreeRegressor
from pyspark.ml.evaluation import RegressionEvaluator

from __future__ import print_function


if __name__ == "__main__":

  # Create a SparkSession
  spark = SparkSession.builder.appName("DesicionTree").getOrCreate()

# Leer el archivo CSV
# Indica que el CSV tiene encabezados
  df = spark.read.option("header", "true") \
      .option("inferSchema", "true") \
      .option("sep", ",") \
      .csv("realstate.csv")   # Ruta del archivo CSV

  # Mostrar las primeras filas para inspección
  df.show()
  df.printSchema()

  # Seleccionar las columnas necesarias
  feature_columns = ["HouseAge","DistanceToMRT","NumberConvenienceStores"]  # Columnas de características
  target_column = "PriceOfUnitArea"  # Columna objetivo (label)

  # Uso VectorAssembler para combinar las características
  assembler = VectorAssembler(inputCols=feature_columns, outputCol="features")
  assembled_df = assembler.transform(df).select("features", target_column)

  # Let's split our data into training data and testing data
  trainTest = df.randomSplit([0.5, 0.5])
  trainingDF = trainTest[0]
  testDF = trainTest[1]

  # Now create our decision tree
  dtr = DecisionTreeRegressor(featuresCol="features", labelCol=target_column)

  # Train the model using our training data
  model = dtr.fit(trainingDF)

  # Now see if we can predict values in our test data.
  # Generate predictions using our Decision Tree model for all features in our
  # test dataframe:
  fullPredictions = model.transform(testDF).cache()

  # Selecciono las predicciones y etiquetas en el DataFrame
  predictionAndLabelDF = fullPredictions.select("prediction", target_column)

  # Muestro las combinaciones de predicción y etiqueta
  predictionAndLabelDF.show()

  # Stop the session
  spark.stop()
