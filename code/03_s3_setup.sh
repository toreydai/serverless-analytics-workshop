#!/bin/bash

# 1、创建S3存储桶：
aws s3 mb s3://nwcd-camp-bucket --region cn-northwest-1

# 2、创建源数据文件夹：
aws s3api put-object --bucket nwcd-camp-bucket --key origin-data/fhv/
aws s3api put-object --bucket nwcd-camp-bucket --key origin-data/green/
aws s3api put-object --bucket nwcd-camp-bucket --key origin-data/yellow/

# 3、创建parquet数据文件夹：
aws s3api put-object --bucket nwcd-camp-bucket --key parquet-data/fhv/
aws s3api put-object --bucket nwcd-camp-bucket --key parquet-data/green/
aws s3api put-object --bucket nwcd-camp-bucket --key parquet-data/yellow/
aws s3api put-object --bucket nwcd-camp-bucket --key parquet-data/total/

# 4、创建Athena输出结果文件夹：
aws s3api put-object --bucket nwcd-camp-bucket --key athena-output/

# 5、创建JDBC存储文件夹：
aws s3api put-object --bucket nwcd-camp-bucket --key jdbc/

# 6、创建S3输出结果文件夹：
aws s3api put-object --bucket nwcd-camp-bucket --key output/