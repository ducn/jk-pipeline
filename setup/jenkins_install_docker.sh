#!/usr/bin/env bash
# This script install Jenkins in your Ubuntu System
#
# This script must be run as root:
#   $ sudo ./jenkins_install_docker.sh jenkins_image.tar.gz

# Enable debug
set -x

# Check root permission
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
apt install docker-ce

# Import jenkins_image
docker pull bachngocson/jenkins

# Create separate docker volume
docker volume create jenkins_home

# Run the jenkins container
docker run -idt --name=jenkins_docker_container -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -u root bachngocson/jenkins

# print password to access
echo 'Open yourhost:8080 and use following secret key for configuring jenkins: '
docker container exec -it jenkins_docker_container cat /var/jenkins_home/secrets/initialAdminPassword
