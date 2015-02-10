#!/usr/bin/env bash
set -e

if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi

gem install passenger
expect /opt/hydraStack/install/install_passenger.exp

cat /etc/httpd/conf.d/passenger.conf <<EOF
   LoadModule passenger_module /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so
   <IfModule mod_passenger.c>
     PassengerRoot /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53
     PassengerDefaultRuby /usr/local/bin/ruby
   </IfModule>
EOF

cat /etc/httpd/virtualHosts/website.passenger.conf <<EOF

   <VirtualHost *:80>
      ServerName localhost
      # !!! Be sure to point DocumentRoot to 'public'!
      DocumentRoot /somewhere/public
      <Directory /somewhere/public>
         # This relaxes Apache security settings.
         AllowOverride all
         # MultiViews must be turned off.
         Options -MultiViews
         # Uncomment this if you're on Apache >= 2.4:
         #Require all granted
      </Directory>
   </VirtualHost>

EOF