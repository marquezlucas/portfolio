from pyspark.sql import SparkSession
from pyspark.sql import functions as func
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, FloatType

spark = SparkSession.builder.appName("CustomerOrders").master("local[*]").getOrCreate()

schema = StructType([ \
                     StructField("customerID", IntegerType(), True), \
                     StructField("itemID", IntegerType(), True), \
                     StructField("amountSpend", FloatType(), True)])

# // Read the file as dataframe
df = spark.read.schema(schema).csv("file:///SparkCourse/customer-orders.csv")

# Select only customerID and amountSpend
customerSpend = df.select("customerID", "amountSpend")

# Aggregate to find minimum temperature for every station
totalByCustomer = customerSpend.groupBy("customerID").agg(func.round(func.sum("amountSpend"),2)).alias("totalSpend").sort("totalSpend")

results = totalByCustomer.collect();

for result in results:
    print(result)

spark.stop()

