from pyspark.sql import SparkSession
from pyspark.sql import functions as func

spark = SparkSession.builder.appName("FriendsByAge").getOrCreate()

friends = spark.read.option("header", "true").option("inferSchema", "true").csv("file:///SparkCourse/fakefriends-header.csv")
#tomo solo las columnas de edad "age" y de amigos "friends"
friendsAndAge = friends.select("age", "friends")

#las agrupo por "age", genero un promedio por "friends" y lo ordeno por "age"
friendsByAge = friendsAndAge.groupBy("age").avg("friends").sort("age").show()

#redondeo con dos decimales 
friendsByAge.groupBy("age").agg(func.round(func.avg("friends"), 2).alias("friends_avg")).sort("age").show()

spark.stop()

