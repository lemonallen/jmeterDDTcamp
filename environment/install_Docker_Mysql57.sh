#!/bin/sh

nowdir=$PWD

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.rpo.bakup

yum install -y wget

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo


yum makecache

# 安装docker依赖
yum install -y yum-utils device-mapper-persistent-data lvm2

if [ -x "$(command -v docker)" ];
then
	echo "docker 已经安装！"
else
	curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
fi

# 启动docker
systemctl enable docker
systemctl restart docker
sleep 3

echo "docker安装完成"

cd $nowdir

mkdir mysqldata

# 用docker安装mysql5.7
docker run -itd --restart always --name centos7_mysql57 -p 3337:3306 -e MYSQL_ROOT_PASSWORD=123456 -v $PWD/mysqldata:/var/lib/mysql daocloud.io/mysql:5.7

echo "docker安装mysql完成"
echo "Mysql版本为: 5.7"
echo "Mysql的端口为：3337"
echo "Mysql的root密码为: 123456"

systemctl stop firewalld
systemctl disable firewalld

