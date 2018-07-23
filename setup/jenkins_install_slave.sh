#!/usr/bin/env bash
# This script install Jenkins in your Ubuntu System
#
# This script must be run as root:
#   $ sudo ./jenkins_install_slave.sh master_node_public_key

# enable debug
set -x

# check root permission
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# check number of arguments
if [[ "$#" -ne 1 ]]; then
    echo "Illegal number of parameters"
    exit 1
fi

# Install packages to allow `apt` to use a repository over HTTPS
apt update
apt install apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Verify
apt-key fingerprint 0EBFCD88

# Add repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Reindexing
apt update

# Install
apt install docker-ce default-jre git openssh-server

# run as normal user instead of root, passing $1
su -l $USER -c "bash prepare_slave_environment.sh $1"
