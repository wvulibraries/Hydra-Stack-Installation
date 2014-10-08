#!/bin/bash

############
# Base Setup

yum groupinstall -y "Development Tools"

yum -y install httpd httpd-devel httpd-manual httpd-tools \
mod_auth_kerb mod_auth_mysql mod_authz_ldap mod_ssl mod_wsgi \
install emacs emacs-common emacs-nox \
git wget \

##########################
## Begin Hydra Stack Setup

############
## Setup ENV

bash /vagrant/install/setup_env.sh
source /etc/environment

# Copy the installation files to the install directory
cp /vagrant/install/* $HYDRA_INSTALL_DIR

###############################
## Install the Hydra Stack RPMs

cd $HYDRA_INSTALL_DIR
bash install_rpms.sh

#####################
## Begin Ruby Install

cd $HYDRA_INSTALL_DIR
bash install_ruby.sh

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




