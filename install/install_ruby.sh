#!/bin/bash
source /etc/environment

cd $HYDRA_INSTALL_DIR
wget -q $RUBY_URL
tar -zxvf $RUBY_FILE
cd $RUBY_BASENAME
./configure
make
make install