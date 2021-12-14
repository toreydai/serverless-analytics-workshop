#!/bin/bash

# 1、创建跳板机所需的IAM权限
cat <<EoF > ./ec2-trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EoF

aws iam create-role --role-name Role_for_Bastin --assume-role-policy-document file://ec2-trust-policy.json

aws iam attach-role-policy --policy-arn arn:aws-cn:iam::aws:policy/AdministratorAccess \
    --role-name Role_for_Bastin

# 2、创建Superset所需的IAM权限
aws iam create-role --role-name Role_for_Superset --assume-role-policy-document file://ec2-trust-policy.json

aws iam attach-role-policy --policy-arn arn:aws-cn:iam::aws:policy/AmazonS3FullAccess \
    --role-name Role_for_Superset
aws iam attach-role-policy --policy-arn arn:aws-cn:iam::aws:policy/AWSGlueConsoleFullAccess \
--role-name Role_for_Superset
aws iam attach-role-policy --policy-arn arn:aws-cn:iam::aws:policy/AmazonAthenaFullAccess \
--role-name Role_for_Superset

# 3、创建Glue所需的IAM权限
cat <<EoF > ./glue-trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "glue.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EoF

aws iam create-role --role-name Role_for_Glue --assume-role-policy-document file://glue-trust-policy.json

aws iam attach-role-policy --policy-arn arn:aws-cn:iam::aws:policy/AmazonS3FullAccess \
--role-name Role_for_Glue

aws iam attach-role-policy --policy-arn arn:aws-cn:iam::aws:policy/AWSGlueServiceRole \
--role-name Role_for_Glue

aws iam attach-role-policy --policy-arn arn:aws-cn:iam::aws:policy/AmazonAthenaFullAccess \
    --role-name Role_for_Glue
