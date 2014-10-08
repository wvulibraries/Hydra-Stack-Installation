#!/bin/bash
source /etc/environment

# Install RPMs specific to the hydra stack. 

# EPEL Repo
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# MySQL Repo
rpm -ivh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm

yum -y install mysql-server mysql-community-devel \
sqlite-devel expect \
screen curl-devel openssl-devel readline-devel ruby-devel  tcl ImageMagick-devel nasm \
libxml2-devel libxslt-devel libyaml-devel \
java-1.7.0-openjdk-devel tomcat tomcat-admin-webapps tomcat-webapps \

###############
## Tomcat Setup

# Add the current user (root in vagrant) to the tomcat group
usermod -G tomcat -a $USER

# Start tomcat
/etc/init.d/tomcat restart

#ensure that tomcat starts at boot
chkconfig tomcat on

################
## Setup MySQL

# Start Mysql
/etc/init.d/mysqld restart

# ensure that mysql starts at boot
chkconfig mysqld on

cd $HYDRA_INSTALL_DIR
mysql -u root < mysqlFedora3Setup.sql

/usr/bin/mysqladmin -u root password 'password'