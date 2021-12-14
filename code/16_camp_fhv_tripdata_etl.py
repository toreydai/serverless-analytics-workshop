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
    table_name="crawler_fhv",
    transformation_ctx="DataCatalogtable_node1",
)
## Add a column 'type' with all the values are 'fhv'

def AddType(rec):
    rec["type"] = "fhv" # add "fhv" to dictionary rec when then function runs
    return rec

mapped_DataCatalogtable_node1 = Map.apply(frame = DataCatalogtable_node1, f = AddType)

# Script generated for node ApplyMapping
ApplyMapping_node2 = ApplyMapping.apply(
    frame=mapped_DataCatalogtable_node1,
    mappings=[
        ("dispatching_base_num", "string", "dispatching_base_num", "string"),
        ("pickup_datetime", "string", "pickup_datetime", "timestamp"),
        ("dropoff_datetime", "string", "dropoff_datetime", "timestamp"),
        ("pulocationid", "long", "pulocationid", "long"),
        ("dolocationid", "long", "dolocationid", "long"),
        ("sr_flag", "string", "sr_flag", "string"),
        ("affiliated_base_number", "string", "affiliated_base_number", "string"),
        ("type", "string", "type", "string")
    ],
    transformation_ctx="ApplyMapping_node2",
)

# Script generated for node fhv_S3_bucket
fhv_S3_bucket_node3 = glueContext.write_dynamic_frame.from_options(
    frame=ApplyMapping_node2,
    connection_type="s3",
    format="glueparquet",
    connection_options={
        "path": "s3://nwcd-camp-bucket/parquet-data/total/",
        "partitionKeys": [],
    },
    format_options={"compression": "snappy"},
    transformation_ctx="fhv_S3_bucket_node3",
)

job.commit()
