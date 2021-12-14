#!/bin/bash

# 1、更改主机名：
sudo hostnamectl set-hostname bastin

# 2、安装Amazon CLI v2:
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install unzip -y

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

# 3、安装MySQL Client:
sudo apt install mysql-client-core-8.0 -y