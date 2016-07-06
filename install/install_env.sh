#!/bin/bash

# install_env is for use on the CentOS 7 server installs.
# setup_env is for use in the vagrant installation
#
# Eventually these should be merged into a single script.

# Variables
HYDRA_STACK_DIR="/opt/hydraStack"
HYDRA_INSTALL_DIR="$HYDRA_STACK_DIR/install"

# For the fedora install script to work, this must end with "/fedora"
FEDORA_INSTALL_DIR="$HYDRA_STACK_DIR/fedora"
SOLR_INSTALL_DIR="$HYDRA_STACK_DIR/solr"

RUBY_BASENAME="ruby-2.2.5"
RUBY_FILE="$RUBY_BASENAME.tar.gz"
RUBY_URL="http://cache.ruby-lang.org/pub/ruby/2.2/$RUBY_FILE"

# Env setup
echo "HYDRA_NAME=demo" | tee -a /etc/environment
echo "RAILS_ENV=production" | tee -a /etc/environment

echo "HYDRA_STACK_DIR=$HYDRA_STACK_DIR" | tee -a /etc/environment
echo "HYDRA_INSTALL_DIR=$HYDRA_INSTALL_DIR" | tee -a /etc/environment
echo "FEDORA_INSTALL_DIR=$FEDORA_INSTALL_DIR" | tee -a /etc/environment
echo "FEDORA_HOME=$FEDORA_INSTALL_DIR" | tee -a /etc/environment
echo "SOLR_INSTALL_DIR=$SOLR_INSTALL_DIR" | tee -a /etc/environment
echo "RUBY_BASENAME=$RUBY_BASENAME" | tee -a /etc/environment
echo "RUBY_FILE=$RUBY_FILE" | tee -a /etc/environment
echo "RUBY_URL=$RUBY_URL" | tee -a /etc/environment


# ensure that we have the 2 global bins in the path
echo "PATH=/usr/local/bin:/usr/bin" | tee -a /etc/environment

# Export the ENV Variables
export HYDRA_STACK_DIR HYDRA_INSTALL_DIR FEDORA_INSTALL_DIR SOLR_INSTALL_DIR
export RUBY_FILE RUBY_URL RUBY_BASENAME
