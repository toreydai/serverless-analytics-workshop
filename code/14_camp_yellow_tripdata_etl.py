import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node Data Catalog table
DataCatalogtable_node1 = glueContext.create_dynamic_frame.from_catalog(
    database="db_nwcd_camp",
    table_name="crawler_yellow_tripdata",
    transformation_ctx="DataCatalogtable_node1",
)

## Add a column 'type' with all the values are 'yellow'

def AddType(rec):
    rec["type"] = "yellow" # add "yellow" to dictionary rec when then function runs
    return rec

mapped_DataCatalogtable_node1 = Map.apply(frame = DataCatalogtable_node1, f = AddType)

# Script generated for node ApplyMapping
ApplyMapping_node2 = ApplyMapping.apply(
    frame=mapped_DataCatalogtable_node1,
    mappings=[
        ("extra", "double", "extra", "double"),
        ("tpep_dropoff_datetime", "string", "dropoff_datetime", "timestamp"),
        ("trip_distance", "double", "trip_distance", "double"),
        ("mta_tax", "double", "mta_tax", "double"),
        ("improvement_surcharge", "double", "improvement_surcharge", "double"),
        ("dolocationid", "int", "dolocationid", "int"),
        ("congestion_surcharge", "double", "congestion_surcharge", "double"),
        ("total_amount", "double", "total_amount", "double"),
        ("payment_type", "int", "payment_type", "int"),
        ("fare_amount", "double", "fare_amount", "double"),
        ("ratecodeid", "int", "ratecodeid", "int"),
        ("tpep_pickup_datetime", "string", "pickup_datetime", "timestamp"),
        ("vendorid", "int", "vendorid", "int"),
        ("pulocationid", "int", "pulocationid", "int"),
        ("tip_amount", "double", "tip_amount", "double"),
        ("tolls_amount", "double", "tolls_amount", "double"),
        ("store_and_fwd_flag", "string", "store_and_fwd_flag", "string"),
        ("passenger_count", "int", "passenger_count", "int"),
        ("type", "string", "type", "string")
    ],
    transformation_ctx="ApplyMapping_node2",
)

# Script generated for node yellow_S3_bucket
yellow_S3_bucket_node3 = glueContext.write_dynamic_frame.from_options(
    frame=ApplyMapping_node2,
    connection_type="s3",
    format="glueparquet",
    connection_options={
        "path": "s3://nwcd-camp-bucket/parquet-data/total/",
        "partitionKeys": [],
    },
    format_options={"compression": "snappy"},
    transformation_ctx="yellow_S3_bucket_node3",
)

job.commit()