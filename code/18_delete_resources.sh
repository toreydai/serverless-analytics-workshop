#!bin/bash

# 1、	删除Superset EC2实例
superset_id=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Superset" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output=text)

aws ec2 terminate-instances --instance-ids ${superset_id}

# 2、	删除跳板机EC2实例
bastin_id=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=BastinHost" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output=text)

aws ec2 terminate-instances --instance-ids ${bastin_id}

# 3、	删除MySQL实例
aws rds delete-db-instance \
    --db-instance-identifier mysql-nwcd-camp

# 4、	删除Elasticsearch实例
aws opensearch delete-domain --domain-name es-nwcd-camp

# 5、	清空并删除S3存储桶
aws s3 rm s3://nwcd-camp-bucket --recursive
aws s3 rb s3://nwcd-camp-bucket --force

# 6、	删除IAM角色
# a)	删除Role_for_Superset
aws iam detach-role-policy \
  --role-name Role_for_Superset \
  --policy-arn arn:aws-cn:iam::aws:policy/AmazonS3FullAccess
aws iam detach-role-policy \
  --role-name Role_for_Superset \
  --policy-arn arn:aws-cn:iam::aws:policy/AWSGlueConsoleFullAccess
aws iam detach-role-policy \
  --role-name Role_for_Superset \
  --policy-arn arn:aws-cn:iam::aws:policy/AmazonAthenaFullAccess
aws iam delete-role --role-name Role_for_Superset

# b)	删除Role_for_Glue
aws iam detach-role-policy \
  --role-name Role_for_Glue \
  --policy-arn arn:aws-cn:iam::aws:policy/AmazonS3FullAccess
aws iam detach-role-policy \
  --role-name Role_for_Glue \
  --policy-arn arn:aws-cn:iam::aws:policy/AWSGlueConsoleFullAccess
aws iam detach-role-policy \
  --role-name Role_for_Glue \
  --policy-arn arn:aws-cn:iam::aws:policy/AmazonAthenaFullAccess
aws iam delete-role --role-name Role_for_Glue

# c)	删除Role_for_Bastin
aws iam detach-role-policy \
  --role-name Role_for_Bastin \
  --policy-arn arn:aws-cn:iam::aws:policy/AdministratorAccess
aws iam delete-role --role-name Role_for_Bastin

# 7、	删除VPC终端节点及VPC
# a)	删除VPC终端节点
aws ec2 delete-vpc-endpoints --vpc-endpoint-ids ${VPC_EP_ID}
# b)	删除VPC
aws ec2 delete-vpc --vpc-id ${VPC_ID}

