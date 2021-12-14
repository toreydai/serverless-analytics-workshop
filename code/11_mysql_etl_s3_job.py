import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import time

args = getResolvedOptions(sys.argv, ['tablename', 'dbuser', 'dbpassword', 'dburl', 'jdbcS3path', 's3OutputPath'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init("glue_mysql8", args)

connection_mysql8_options = {
    "url": args['dburl'],
    "dbtable": args['tablename'],
    "user": args['dbuser'],
    "password": args['dbpassword'],
    "customJdbcDriverS3Path": args['jdbcS3path']+"mysql-connector-java-8.0.26.jar",
    "customJdbcDriverClassName": "com.mysql.cj.jdbc.Driver"}
# 从MySQL中读取数据
df_catalog = glueContext.create_dynamic_frame.from_options(connection_type="mysql",connection_options=connection_mysql8_options)
# 加上filter 一般增量加载可以按照更新时间来过滤
df_filter = Filter.apply(frame = df_catalog, f = lambda x: x["trip_distance"] >=0.1)
print("--output--filter")
# 写入s3位置
writer = glueContext.write_dynamic_frame.from_options(frame = df_filter, connection_type = "s3", connection_options = {"path": args['s3OutputPath']+args['tablename']}, format = "parquet")

job.commit()