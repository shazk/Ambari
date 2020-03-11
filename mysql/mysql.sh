#!/bin/sh

sudo wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm

sudo rpm -Uvh mysql-community-release-el6-5.noarch.rpm

sudo yum -y install mysql mysql-server

sudo chkconfig mysqld on
sudo service mysqld start

echo "Enter db user :"
read  user

echo "Enter db password :"
read -s pwd

echo "Enter DB name to be created : "
read -s dbname

echo "Enter dump file location : "
read dmp

###Setting root password
mysqladmin -u $user password $pwd


mysql -u $user -p$pwd -e "create database ${dbname}; GRANT ALL PRIVILEGES ON ${dbname}.* TO '${user}'@'%' IDENTIFIED BY '${pwd}';flush privileges;commit;"
###Dump file

mysql -u $user -p$pwd -e "use  ${dbname}; source ${dmp}; commit;"

sudo sed -i '/\[mysqld\]/a autocommit=0' /etc/my.cnf
sudo sed -i '/\[mysqld\]/a group_concat_max_len=1111111111' /etc/my.cnf

sudo service mysqld restart
