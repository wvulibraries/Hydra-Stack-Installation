#!/bin/bash

yum -y install java-1.7.0-openjdk-devel tomcat tomcat-admin-webapps tomcat-webapps

###############
## Tomcat Setup

# Add the current user (root in vagrant) to the tomcat group
# we are speificaly using both of these, if you SU to root, without a -, $USER
# is still the original logged in user
/usr/sbin/usermod -G tomcat -a $USER
/usr/sbin/usermod -G tomcat -a root

# Start tomcat
systemctl restart tomcat

#ensure that tomcat starts at boot
systemctl enable tomcat

# Setup a rule to allow connections on port 8080
# @TODO port should be configurable in the env 
echo "Be sure to open port 8080 on the server"
echo "/usr/sbin/iptables -A INPUT -p tcp -m tcp -m state --dport 8080 --state NEW -j ACCEPT"