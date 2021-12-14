import sys
from awsglue.transforms import *
from awsglue.dynamicframe import DynamicFrame
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql import functions as F
from pyspark.sql.types import StringType, TimestampType, DoubleType, LongType, IntegerType
from pyspark.context import SparkContext
from pyspark.sql import SparkSession

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
glue_spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

spark = SparkSession.builder.getOrCreate()
# Script generated for node Amazon Glue Data Catalog
file_path = 's3://nwcd-camp-bucket/output/green_tripdata/'
df = spark.read.option("multiLine", "true").option("header", "true").csv(file_path)

spec_handlers = dict()
spec_handlers["pickup_datetime"] = TimestampType()
spec_handlers["dropoff_datetime"] = TimestampType()
spec_handlers["store_and_fwd_flag"] = StringType()
spec_handlers["ehail_fee"] = StringType()
spec_handlers["passenger_count"] = IntegerType()
spec_handlers["payment_type"] = IntegerType()
spec_handlers["VendorID"] = IntegerType()
spec_handlers["RatecodeID"] = IntegerType()
spec_handlers["DOLocationID"] = IntegerType()
spec_handlers["PULocationID"] = IntegerType()

df.printSchema()
columns = df.columns
print(columns)

for item in columns:
    if item in spec_handlers:
        cast_type = spec_handlers[item]
    else:
        cast_type = DoubleType()

    df = df.withColumn(item, F.col(item).cast(cast_type))

df = df.withColumn("type", F.lit("green"))
df.printSchema()

dyn_df = DynamicFrame.fromDF(df, glueContext, "nested")
# Script generated for node S3 bucket
green_S3bucket_node3 = glueContext.write_dynamic_frame.from_options(
    frame=dyn_df,
    connection_type="s3",
    format="parquet",
    connection_options={
        "path": "s3://nwcd-camp-bucket/parquet-data/total/", 
        "partitionKeys": [],
    },
    transformation_ctx="green_S3bucket_node3"
)

job.commit()
