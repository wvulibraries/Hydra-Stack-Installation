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
echo "FEDORA_HOME=$FEDORA_INSTALL_DIR" | tee -a /etc/environment
echo "SOLR_INSTALL_DIR=$SOLR_INSTALL_DIR" | tee -a /etc/environment

source /etc/environment

mkdir -p $HYDRA_INSTALL_DIR

# Copy the installation files to the install directory
cp /vagrant/install/* $HYDRA_INSTALL_DIR

# Base Yum Installs

yum groupinstall -y "Development Tools"

yum -y install httpd httpd-devel httpd-manual httpd-tools
yum -y install mod_auth_kerb mod_auth_mysql mod_authz_ldap mod_ssl mod_wsgi 
yum -y install emacs emacs-common emacs-nox


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

/etc/init.d/mysqld restart

cd $HYDRA_INSTALL_DIR
mysql -u root < mysqlFedoraSetup.sql

/usr/bin/mysqladmin -u root password 'password'

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

/etc/init.d/httpd restart
chkconfig httpd on

/etc/init.d/tomcat restart
chkconfig tomcat on

chkconfig mysqld on
