#!/bin/bash

# 1、创建跳板机和Superset主机所需的密钥对
aws ec2 create-key-pair \
  --key-name kp_camp \
  --output text \
  --query 'KeyMaterial' \
  > kp_camp.pem

# 2、修改密钥对文件权限为400
chmod 400 kp_camp.pem

# 3、获取最新的EC2 Ubuntu AMI
IMAGE_ID=$(aws ec2 describe-images \
  --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-** \
  --query 'Images[*].[ImageId,CreationDate]' --output text \
  | sort -k2 -r \
  | head -n1)

# 4、创建跳板机EC2实例
instance_id=$(aws ec2 run-instances \
  --associate-public-ip-address \
  --image-id ${IMAGE_ID} \
  --instance-type t2.micro \
  --count 1 \
  --subnet-id ${PUBLIC_SUBNET_01} \
  --key-name kp_camp \
  --security-group-ids ${Bastin_SG_ID} \
  --block-device-mappings='{"DeviceName": "/dev/sda1", "Ebs": { "VolumeSize": 50, "VolumeType": "gp3" }, "NoDevice": "" }' \
  --output text --query 'Instances[].InstanceId')

# 5、为跳板机打标签
aws ec2 create-tags \
  --resources ${instance_id} \
  --tags "Key=Name,Value=BastinHost"

# 6、为跳板机EC2实例绑定IAM实例配置文件
aws iam create-instance-profile \
  --instance-profile-name Bastin-Instance-Profile

aws iam add-role-to-instance-profile \
  --instance-profile-name Bastin-Instance-Profile \
  --role-name Role_for_Bastin

aws ec2 associate-iam-instance-profile \
  --instance-id ${instance_id} \
  --iam-instance-profile Name=Bastin-Instance-Profile \
  --region cn-northwest-1
