#!/bin/bash
source /etc/environment

# Install RPMs specific to the hydra stack. 

# EPEL Repo
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# MySQL Repo
rpm -ivh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm

yum -y install mysql-server
yum -y install sqlite-devel expect
yum -y install screen curl-devel openssl-devel readline-devel ruby-devel  tcl ImageMagick-devel nasm
yum -y install libxml2-devel libxslt-devel libyaml-devel
yum -y install java-1.7.0-openjdk-devel tomcat tomcat-admin-webapps tomcat-webapps

# Add the current user (root in vagrant) to the tomcat group
usermod -G tomcat -a $USER

################
## Setup MySQL

/etc/init.d/mysqld restart

cd $HYDRA_INSTALL_DIR
mysql -u root < mysqlFedoraSetup.sql

/usr/bin/mysqladmin -u root password 'password'