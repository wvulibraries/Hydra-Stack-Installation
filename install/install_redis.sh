#!/usr/bin/env bash
set -e

if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi

echo "Install the Redis server from source"

## download, make, install

wget -q http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make

cp src/redis-server /usr/local/bin/
cp src/redis-cli /usr/local/bin/

# create the necessary directories
mkdir -p /etc/redis /var/redis /var/redis/6379

# add LSB info to the the init script
echo "### BEGIN INIT INFO
# Provides:          redis_6379
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start redis on port 6379 at boot time
# Description:       Enable service provided by  daemon.
### END INIT INFO" > /etc/init.d/redis_6379
cat utils/redis_init_script >> /etc/init.d/redis_6379

# make redis script executable
chmod a+x /etc/init.d/redis_6379

# add to init
/usr/sbin/chkconfig redis_6379 on

# create the config file
cp redis.conf /etc/redis/6379.conf

# daemonize, set the pidfile, configure logging, and set the home dir
sed 's/^\(daemonize\ \)no.*$/\1yes/' -i /etc/redis/6379.conf
sed 's#^\(pidfile\ /var/run/\).*$#\1redis_6379.pid#' -i /etc/redis/6379.conf
sed 's/^\(loglevel\ \)verbose.*$/\1notice/' -i /etc/redis/6379.conf
sed 's#^\(dir\ \).*$#\1/var/redis/6379#' -i /etc/redis/6379.conf

/usr/sbin/chkconfig redis_6379 on
/etc/init.d/redis_6379 start