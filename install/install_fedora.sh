#!/usr/bin/env bash
set -e

if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi

# set environment variables for fedora
source /etc/environment
export FEDORA_INSTALL_DIR
export HYDRA_INSTALL_DIR
echo "PATH=\$PATH:$FEDORA_HOME/server/bin:$FEDORA_HOME/client/bin" | tee -a /etc/profile.d/fedora.sh
source /etc/profile.d/fedora.sh

# check the output of "echo $PATH"
if
	[[ $(echo $PATH) == *fedora/server/bin*fedora/client/bin* ]]
then	
	echo "The path is ready to install Fedora"
else
	echo "The path is not correct, Fedora cannot be installed." >&2
	exit 1
fi

# add the ubuntu user to the tomcat group
# usermod -G tomcat -a mrbond
# check that this worked
# if
# 	[[ $(id mrbond) == *tomcat* ]]
# then
# 	echo "The local user is a member of the tomcat group"
# else
# 	echo "The local user must be a member of the tomcat group to install fedora"
# 	exit 1
# fi

# change owners on /opt - fedora expect script is run as vagrant
# chown mrbond:mrbond /opt

# get the fedora installer
# mkdir -p /opt/install && cd /opt/install
cd $HYDRA_INSTALL_DIR
wget -q -c http://sourceforge.net/projects/fedora-commons/files/fedora/3.6.2/fcrepo-installer-3.6.2.jar

# call expect script for interactive section with fedora installer
expect $HYDRA_INSTALL_DIR/install_fedora.exp

chown -R tomcat:tomcat $FEDORA_INSTALL_DIR