#!/bin/bash

# 1、创建VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --output text --query 'Vpc.VpcId')
aws ec2 create-tags --resources ${VPC_ID} --tags Key=Name,Value=VPC-NWCD-Camp
aws ec2 modify-vpc-attribute --vpc-id ${VPC_ID} --enable-dns-support '{"Value": true}'
aws ec2 modify-vpc-attribute --vpc-id ${VPC_ID} --enable-dns-hostnames '{"Value": true}'

# 2、创建公有子网
PUBLIC_SUBNET_01=$(aws ec2 create-subnet \
  --vpc-id ${VPC_ID} \
  --cidr-block 10.0.1.0/24 \
  --availability-zone cn-northwest-1a \
  --output text --query 'Subnet.SubnetId')
aws ec2 create-tags --resources ${PUBLIC_SUBNET_01} --tags Key=Name,Value=Public-Subnet01

PUBLIC_SUBNET_02=$(aws ec2 create-subnet \
  --vpc-id ${VPC_ID} \
  --cidr-block 10.0.3.0/24 \
  --availability-zone cn-northwest-1b \
  --output text --query 'Subnet.SubnetId')
aws ec2 create-tags --resources ${PUBLIC_SUBNET_02} --tags Key=Name,Value=Public-Subnet02

# 3、创建私有子网
PRIVATE_SUBNET_01=$(aws ec2 create-subnet \
  --vpc-id ${VPC_ID} \
  --cidr-block 10.0.2.0/24 \
  --availability-zone cn-northwest-1a \
  --output text --query 'Subnet.SubnetId')
aws ec2 create-tags --resources ${PRIVATE_SUBNET_01} --tags Key=Name,Value=Private-Subnet01

PRIVATE_SUBNET_02=$(aws ec2 create-subnet \
  --vpc-id ${VPC_ID} \
  --cidr-block 10.0.4.0/24 \
  --availability-zone cn-northwest-1b \
  --output text --query 'Subnet.SubnetId')
aws ec2 create-tags --resources ${PRIVATE_SUBNET_02} --tags Key=Name,Value=Private-Subnet02

# 4、创建互联网网关
IGW_ID=$(aws ec2 create-internet-gateway --output text --query 'InternetGateway.InternetGatewayId')
aws ec2 create-tags --resources ${IGW_ID} --tags Key=Name,Value=IGW-Camp
aws ec2 attach-internet-gateway --internet-gateway-id ${IGW_ID} --vpc-id ${VPC_ID}

# 5、创建公有路由表
PUBLIC_RTB_ID=$(aws ec2 create-route-table --vpc-id ${VPC_ID} --output text --query 'RouteTable.RouteTableId')
aws ec2 create-tags --resources ${PUBLIC_RTB_ID} --tags Key=Name,Value=Public_RTB
aws ec2 associate-route-table --route-table-id ${PUBLIC_RTB_ID} --subnet-id ${PUBLIC_SUBNET_01}
aws ec2 associate-route-table --route-table-id ${PUBLIC_RTB_ID} --subnet-id ${PUBLIC_SUBNET_02}
aws ec2 create-route --route-table-id ${PUBLIC_RTB_ID} --destination-cidr-block 0.0.0.0/0 --gateway-id ${IGW_ID}

# 6、创建私有路由表
aws ec2 create-route --route-table-id ${PUBLIC_RTB_ID} --destination-cidr-block 0.0.0.0/0 --gateway-id ${IGW_ID}
PRIVATE_RTB_ID=$(aws ec2 create-route-table --vpc-id ${VPC_ID} --output text --query 'RouteTable.RouteTableId')
aws ec2 create-tags --resources ${PRIVATE_RTB_ID} --tags Key=Name,Value=Private_RTB
aws ec2 associate-route-table --route-table-id ${PRIVATE_RTB_ID} --subnet-id ${PRIVATE_SUBNET_01}
aws ec2 associate-route-table --route-table-id ${PRIVATE_RTB_ID} --subnet-id ${PRIVATE_SUBNET_02}

# 7、创建MySQL安全组
MySQL_SG_ID=$(aws ec2 create-security-group \
  --group-name MySQL-SG \
  --description "MySQL security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')
aws ec2 create-tags --resources ${MySQL_SG_ID} --tags Key=Name,Value=MySQL-SG
aws ec2 authorize-security-group-ingress --group-id ${MySQL_SG_ID} --protocol tcp --port 3306 --cidr 10.0.0.0/16
aws ec2 authorize-security-group-ingress --group-id ${MySQL_SG_ID} --protocol all --source-group ${MySQL_SG_ID}

# 8、创建Elasticsearch安全组
ES_SG_ID=$(aws ec2 create-security-group \
  --group-name ES-SG \
  --description "ES security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')
aws ec2 create-tags --resources ${ES_SG_ID} --tags Key=Name,Value=ES-SG
aws ec2 authorize-security-group-ingress --group-id ${ES_SG_ID} --protocol tcp --port 443 --cidr 10.0.0.0/16

# 9、创建跳板机安全组
Bastin_SG_ID=$(aws ec2 create-security-group \
  --group-name Bastin-SG \
  --description "Bastin security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')
aws ec2 create-tags --resources ${Bastin_SG_ID} --tags Key=Name,Value=Bastin-SG
aws ec2 authorize-security-group-ingress --group-id ${Bastin_SG_ID} --protocol tcp --port 22 --cidr 0.0.0.0/0

# 10、创建Superset安全组
Superset_SG_ID=$(aws ec2 create-security-group \
  --group-name Superset-SG \
  --description "Superset security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')
aws ec2 create-tags --resources ${Superset_SG_ID} --tags Key=Name,Value=Superset-SG
aws ec2 authorize-security-group-ingress --group-id ${Superset_SG_ID} --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id ${Superset_SG_ID} --protocol tcp --port 8088 --cidr 0.0.0.0/0

# 11、创建Glue安全组
GLUE_SG_ID=$(aws ec2 create-security-group \
  --group-name Glue-SG \
  --description "Glue security group" \
  --vpc-id ${VPC_ID} \
  --output text --query 'GroupId')
aws ec2 create-tags --resources ${GLUE_SG_ID} --tags Key=Name,Value=Glue-SG
aws ec2 authorize-security-group-ingress --group-id ${GLUE_SG_ID} --protocol all --cidr 10.0.0.0/16
aws ec2 authorize-security-group-ingress --group-id ${GLUE_SG_ID} --protocol all --source-group ${GLUE_SG_ID}

# 12、创建S3终端节点
VPC_EP_ID=$(aws ec2 create-vpc-endpoint \
  --vpc-endpoint-type Gateway \
  --vpc-id ${VPC_ID} \
  --service-name com.amazonaws.cn-northwest-1.s3 \
  --route-table-ids ${PRIVATE_RTB_ID} \
  --query 'VpcEndpoint.VpcId' \
  --output text)
