Vagrant Hydra Stack
===================

These scripts will automate the install of the base hydra stack in a CentOS 7.0 vagrant box. Tag 1.1 uses CentOS 6.4. 

The scripts are provided by, or based on, Data Curation Experts' scripts and documentation. 

These scripts can be used separately to install a working Hydra Stack. 

A full stack should follow this path:

1. env
1. base
1. mysql
1. tomcat
1. fedora
1. solr
1. redis
1. httpd
1. ruby
1. rails 
1. passenger

Scripts can be used across multiple servers, to separate fedora/solr/rails apps. When installing on multiple servers env through tomcat are required for both fedora and solr installs. 

redis is only usd by the applications, and may not be needed in all use cases. 

Variables
=========

install_env.sh should be modified for your enviornment, though the values should work across most use cases. 

mysqlFedora3Setup.sql has passwords that should be modified.

install_mysql.sh sets the root mysql password to "password", this should be changed. 

TODO
=====

the install scripts should be more seemless. 

"install.sh fedora | solr | hydrahead" should install all the pre-reqs instead of having to run each step individually. 
