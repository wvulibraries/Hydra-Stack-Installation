CREATE DATABASE fedora3;  
GRANT ALL ON fedora3.* TO fedoraDBAdmin@localhost IDENTIFIED BY 'fedoraAdmin';  
GRANT ALL ON fedora3.* TO fedoraDBAdmin@'%' IDENTIFIED BY 'fedoraAdmin';