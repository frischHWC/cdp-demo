from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.types import IntegerType


def main():
    
    SparkConf().setMaster("yarn")
    
    spark = SparkSession \
        .builder \
        .appName("first_app") \
        .getOrCreate()

    rdd = spark.sparkContext.parallelize(range(1, 10000), 10)
    df = spark.createDataFrame(rdd, IntegerType())

    df.count()

    spark.stop()

    
if __name__ == "__main__":

    main()
