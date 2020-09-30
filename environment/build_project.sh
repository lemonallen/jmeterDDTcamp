#!/bin/sh

tomcat_ver='apache-tomcat-8.5.57.tar.gz'
tomcat='apache-tomcat-8.5.57'

yum install -y wget

yum list installed |grep -e java -e jdk
if [ $? -eq 0 ]
then
	echo "已经安装jdk"
else
	yum install -y java-1.8.0-openjdk*
fi

wget https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.57/bin/$tomcat_ver

tar -xzvf $tomcat_ver

cp $PWD/erp.war $PWD/$tomcat/webapps
echo "请勿操作，脚本还在运行..."
sleep 3

sh $PWD/$tomcat/bin/startup.sh
echo "请勿操作，脚本还在运行..."
sleep 15


sed -i 's/3306/3337/g' $PWD/$tomcat/webapps/erp/WEB-INF/classes/application.yml
sed -i 's/5057355smyqcHJY/123456/g' $PWD/$tomcat/webapps/erp/WEB-INF/classes/application.yml

echo "配置文件已经修改"

echo "停止tomcat"
sh $PWD/$tomcat/bin/shutdown.sh
echo "请勿操作，脚本还在运行..."
sleep 5

echo "重启tomcat服务"
sh $PWD/$tomcat/bin/startup.sh
echo "tomcat已重启！"

systemctl stop firewalld.service
systemctl disable firewalld.service

