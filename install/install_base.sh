#!/bin/bash

############
# Base Setup

yum groupinstall -y "Development Tools"

yum -y install emacs emacs-common emacs-nox git wget \
sqlite-devel expect \
screen curl-devel openssl-devel readline-devel ruby-devel  tcl \
ImageMagick-devel nasm libxml2-devel libxslt-devel libyaml-devel