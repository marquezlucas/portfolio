from pyspark import SparkConf, SparkContext

conf = SparkConf().setMaster("local").setAppName("CountUpTotalAmount")
sc = SparkContext(conf = conf)

def parseLine(line):
    fields = line.split(',')
    customerID = fields[0]
    dollarAmount = fields[2]
    return (int(customerID), float(dollarAmount))

lines = sc.textFile("file:///SparkCourse/customer-orders.csv")

rdd = lines.map(parseLine)
totalsByCustomerID = rdd.mapValues(lambda x: (x, 1)).reduceByKey(lambda x, y: x + y)
totalsByDollarAmountSorted = totalsByCustomerID.mapValues(lambda x: (x[1], x[0])).sortByKey()
results = totalsByDollarAmountSorted.collect()

for result in results:
    print(result[0] + "\t{:.2f}F".format(result[1]))



