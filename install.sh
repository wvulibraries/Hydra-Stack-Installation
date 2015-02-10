#!/bin/bash

# A full install should follow this path:
# env
# base
# mysql
# tomcat
# redis
# fedora
# solr
# httpd
# ruby
# passenger

# Check to make sure we are the root user
if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
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
install_env(){
	echo "Installing environment."
	install/install_env.sh
}

install_base() {
	echo "Installing Base."
	install/install_base.sh
}

install_fedora() {
	echo "Installing Fedora."
	install/install_fedora.sh
}

install_solr() {
	echo "Installing Solr."
	install/install_solr.sh
}

install_ruby() {
	echo "Installing Ruby."
	install/install_ruby.sh
}

install_mysql() {
	echo "Installing MySQL."
	install/install_mysql.sh

}

install_tomcat() {

	echo "Installing Tomcat"
	install/install_tomcat.sh
}

install_redis() {

	echo "Installing Redis"
	install/install_redis.sh

}

install_passenger() {

	echo "Installing Passanger"
	install/install_passenger.sh

}

install_httpd() {
	echo "Installing Apache."
	install/install_httpd.sh
}

# ## determine install type

# If we are installing the environment, do it
# Otherwise we source it. 
if [ $TYPE == "env" ] 
then
	install_env
else
	source /etc/environment
fi



if [ $TYPE == 'base' ]
then

	install_base

elif [ $TYPE == 'fedora' ]
then
	install_fedora

elif [ $TYPE == 'solr' ]
then
	install_solr
elif [ $TYPE == 'ruby' ]
then
	install_ruby
elif [ $TYPE == 'mysql' ]
then
	install_mysql
elif [ $TYPE == 'tomcat' ]
then
	install_tomcat
elif [ $TYPE == 'redis' ]
then
	install_redis
elif [ $TYPE == 'passenger' ]
then
	install_passenger
elif [ $TYPE == 'httpd' ]
then
	install_httpd
fi

echo "Done. ($TYPE)"

