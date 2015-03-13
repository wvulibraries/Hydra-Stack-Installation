#!/bin/bash

cd /vagrant
bash /vagrant/install.sh env

source /etc/environment

# Copy the installation files to the install directory
mkdir -p $HYDRA_INSTALL_DIR
cp /vagrant/install/* $HYDRA_INSTALL_DIR
cp /vagrant/install.sh $HYDRA_STACK_DIR

cd $HYDRA_STACK_DIR

bash install.sh base
bash install.sh mysql
bash install.sh tomcat
bash install.sh fedora
bash install.sh solr
bash install.sh redis
bash install.sh httpd
bash install.sh ruby
bash install.sh rails
bash install.sh passenger



