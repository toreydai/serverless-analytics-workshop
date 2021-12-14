#!/bin/bash

# 1、执行如下命令，更改主机名：
sudo hostnamectl set-hostname superset
sudo reboot

# 2、替换Ubuntu国内软件更新源：
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

sudo bash -c 'cat << EOF > /etc/apt/sources.list
deb https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
EOF'

# 3、安装Superset所需的软件依赖：
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install build-essential libssl-dev libffi-dev python3-dev python3-pip libsasl2-dev libldap2-dev -y
sudo pip3 install --upgrade pip

# 4、安装连接Athena所需的软件包：
pip install PyAthenaJDBC PyAthena

# 5、使用如下命令安装Superset：
pip install apache-superset
sudo cp /home/ubuntu/.local/bin/superset /usr/local/bin
superset db upgrade
export FLASK_APP=superset

# 6、创建管理员并设置密码：
superset fab create-admin --username admin --password secret99

# 7、初始化Superset:
superset init

# 8、启动Superset:
superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger &

# 9、配置开机自启动：
# 创建开机自启动脚本：
sudo bash -c 'cat << EOF > superset.sh
#!/bin/bash
superset run -h 0.0.0.0 -p 8088 --with-threads --reload --debugger &
EOF'

# 为脚本增加可执行权限：
sudo chmod +x superset.sh
# 将脚本复制到指定目录，以实现开机自启动：
sudo cp superset.sh /etc/profile.d
