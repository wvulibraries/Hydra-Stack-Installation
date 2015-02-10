#!/bin/bash

# A full install should follow this path:
# env
# base
# mysql
# tomcat
# fedora
# solr
# redis
# httpd
# ruby
# rails 
# passenger

# Check to make sure we are the root user
if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi

if [ -z "$1" ] ; then
    echo "Must provide an install argument."
    exit 1
fi

# make sure the install scripts are executable
chmod u+x install/*

# make sure the yum caches are clear
# Else we may see errors from bad mirror locations
yum clean all -y

# Assign the lowercase value of the first command line argument
TYPE=`echo | awk -v str=$1 '{print tolower(str)}'`

# ## Installation Functions

install() {

	SCRIPT="install/install_$2.sh"

	#check if the file exists
	if [ ! -f $SCRIPT ]; then
    	echo "Install script not found!"
    	exit 1
	fi
	
	echo $1
	$SCRIPT
}

# ## determine install type

# If we are installing the environment, do it
# Otherwise we source it. 
if [ $TYPE == "env" ] 
then
	install "Installing environment." "env"
else
	source /etc/environment
	install "Installing $TYPE" "$TYPE"
fi

echo "Done. ($TYPE)"

