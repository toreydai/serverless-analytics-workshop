#!/bin/bash

# 1、创建Superset EC2实例
superset_instance_id=$(aws ec2 run-instances \
  --associate-public-ip-address \
  --image-id ${IMAGE_ID} \
  --instance-type c5.large \
  --count 1 \
  --subnet-id ${PUBLIC_SUBNET_01} \
  --key-name kp_camp \
  --security-group-ids ${Superset_SG_ID} \
  --block-device-mappings='{"DeviceName": "/dev/sda1", "Ebs": { "VolumeSize": 50, "VolumeType": "gp3" }, "NoDevice": "" }' \
  --output text --query 'Instances[].InstanceId')

# 2、为Superset实例打标签：
aws ec2 create-tags --resources ${superset_instance_id} --tags "Key=Name,Value=Superset"

# 3、为Superset实例绑定IAM实例配置文件：
aws iam create-instance-profile \
  --instance-profile-name Superset-Instance-Profile

aws iam add-role-to-instance-profile \
  --instance-profile-name Superset-Instance-Profile \
  --role-name Role_for_Superset

aws ec2 associate-iam-instance-profile \
  --instance-id ${superset_instance_id} \
  --iam-instance-profile Name=Superset-Instance-Profile \
  --region cn-northwest-1