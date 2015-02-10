#!/bin/bash

yum -y install mysql-server mysql-community-devel

echo "Setting Up MySQL."

systemctl enable mysqld
systemctl restart mysqld

mysql -u root < install/mysqlFedora3Setup.sql
/usr/bin/mysqladmin -u root password 'password'