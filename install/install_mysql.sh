#!/bin/bash

rpm -Uvh http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
yum -y install mysql-community-server mysql-community-client mysql-community-devel mysql-community-common mysql-community-libs mysql-community-release

echo "Setting Up MySQL."

systemctl enable mysqld
systemctl restart mysqld

mysql -u root < install/mysqlFedora3Setup.sql
/usr/bin/mysqladmin -u root password 'password'