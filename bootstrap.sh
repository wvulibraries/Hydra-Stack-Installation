#!/bin/bash

#######################
## Begin General Script

# Variables
HYDRA_STACK_DIR="/opt/hydraStack"
HYDRA_INSTALL_DIR="$HYDRA_STACK_DIR/install"
FEDORA_INSTALL_DIR="$HYDRA_STACK_DIR/fedora"
SOLR_INSTALL_DIR="$HYDRA_STACK_DIR/solr"

RUBY_BASENAME="ruby-2.1.3"
RUBY_FILE="$RUBY_BASENAME.tar.gz"
RUBY_URL="http://cache.ruby-lang.org/pub/ruby/2.1/$RUBY_FILE"

# Env setup

echo "HYDRA_NAME=demo" | tee -a /etc/environment
echo "RAILS_ENV=production" | tee -a /etc/environment

echo "HYDRA_STACK_DIR=$HYDRA_STACK_DIR" | tee -a /etc/environment
echo "HYDRA_INSTALL_DIR=$HYDRA_INSTALL_DIR" | tee -a /etc/environment
echo "FEDORA_INSTALL_DIR=$FEDORA_INSTALL_DIR" | tee -a /etc/environment
echo "SOLR_INSTALL_DIR=$SOLR_INSTALL_DIR" | tee -a /etc/environment

source /etc/environment

mkdir -p $HYDRA_INSTALL_DIR

# Copy the installation files to the install directory
cp /vagrant/install/* $HYDRA_INSTALL_DIR

# Base Yum Installs

# EPEL Repo
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# MySQL Repo
rpm -ivh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm

yum group install -y "Development Tools"

yum -y install httpd httpd-devel httpd-manual httpd-tools
yum -y install mysql-server
yum -y install mod_auth_kerb mod_auth_mysql mod_authz_ldap mod_ssl mod_wsgi 
yum -y install emacs emacs-common emacs-nox
yum -y install git wget sqlite-devel expect
yum -y install screen curl-devel openssl-devel readline-devel ruby-devel  tcl ImageMagick-devel nasm
yum -y install libxml2-devel libxslt-devel libyaml-devel
yum -y install java-1.7.0-openjdk-devel tomcat tomcat-admin-webapps tomcat-webapps

# Fix Mysql
touch /var/lib/mysql/mysql.sock
chown mysql:mysql /var/lib/mysql/mysql.sock

# Add the current user (root in vagrant) to the tomcat group
usermod -G tomcat -a $USER

#####################
## Begin Ruby Install

cd $HYDRA_INSTALL_DIR
wget -q $RUBY_URL
tar -zxvf $RUBY_FILE
cd $RUBY_BASENAME
./configure
make
make install

cd $HYDRA_STACK_DIR

################
## Upgrade MySQL
# @TODO Secure root user

/etc/init.d/mysqld restart

cd $HYDRA_INSTALL_DIR
mysql -u root < mysqlFedoraSetup.sql

################
# Fedora Install

# Make sure mysql is running
/etc/init.d/mysqld restart

cd $HYDRA_INSTALL_DIR
bash install_fedora.sh

##############
# Install Solr

cd $HYDRA_INSTALL_DIR
bash install_solr.sh

###############
# Install Redis

cd $HYDRA_INSTALL_DIR
bash install_redis.sh

##################################
## Make sure servers are started up

/etc/init.d/httpd start
chkconfig httpd on

/etc/init.d/tomcat start
chkconfig tomcat on

chkconfig mysqld on
