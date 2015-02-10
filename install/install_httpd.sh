#!/bin/bash

#install the httpd RPMs
yum -y install httpd httpd-devel httpd-manual httpd-tools \
mod_auth_kerb mod_auth_mysql mod_authz_ldap mod_ssl mod_wsgi

# Setup apache virtual hosts directory
mkdir -p /etc/httpd/virtualHosts/
echo "NameVirtualHost *:80" | tee -a /etc/httpd/conf/httpd.conf
echo "IncludeOptional virtualHosts/*.conf" | tee -a /etc/httpd/conf/httpd.conf

systemctl enable httpd