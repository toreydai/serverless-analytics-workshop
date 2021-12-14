#!/bin/bash

# RDS MySQL
# 1、创建RDS子网组:
DB_SUBNET_GROUP_ID=$(aws rds create-db-subnet-group \
  --db-subnet-group-name MySQL-Subnet-Group \
  --db-subnet-group-description "MySQL Subnet Group" \
  --subnet-ids  ${PRIVATE_SUBNET_01} ${PRIVATE_SUBNET_02} \
  --output text --query 'DBSubnetGroup.DBSubnetGroupName')

# 2、创建RDS MySQL：
aws rds create-db-instance \
    --db-instance-identifier mysql-nwcd-camp \
    --db-instance-class db.m5.large \
    --engine mysql \
    --engine-version 8.0.26 \
    --master-username admin \
    --master-user-password secret99 \
    --allocated-storage 50 \
    --availability-zone cn-northwest-1a \
    --no-multi-az \
    --vpc-security-group-ids ${MySQL_SG_ID} \
    --db-subnet-group-name ${DB_SUBNET_GROUP_ID} \
    --region cn-northwest-1

# Elasticsearch
# 1、获取ES托管密钥ID：
es_key=$(aws kms describe-key \
  --key-id alias/aws/es --query 'KeyMetadata.KeyId' \
  --output text)

# 2、获取亚马逊云科技Account id：
account_id=$(aws sts get-caller-identity \
  --query Account \
  --output text)

# 3、创建Elasticsearch:
aws opensearch create-domain \
  --domain-name es-nwcd-camp \
  --engine-version Elasticsearch_7.10 \
  --cluster-config InstanceType=r6g.large.search,InstanceCount=3,DedicatedMasterEnabled=false \
  --ebs-options EBSEnabled=true,VolumeType=gp2,VolumeSize=20 \
  --vpc-options SubnetIds=${PRIVATE_SUBNET_01},SecurityGroupIds=${ES_SG_ID} \
  --access-policies '{"Version": "2012-10-17","Statement": [{"Effect": "Allow","Principal": {"AWS": "*"},"Action": "es:*","Resource": "arn:aws-cn:es:cn-northwest-1:${account_id}:domain/es-nwcd-camp/*"}]}' \
  --advanced-security-options Enabled=true,InternalUserDatabaseEnabled=true,MasterUserOptions='{MasterUserName=admin,MasterUserPassword=Aws@2021}' \
  --encryption-at-rest-options Enabled=true,KmsKeyId=${es_key} \
  --node-to-node-encryption-options Enabled=true \
  --domain-endpoint-options EnforceHTTPS=true \
  --region cn-northwest-1

