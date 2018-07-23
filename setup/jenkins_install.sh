#!/usr/bin/env bash
# This script install Jenkins in your Ubuntu System
#
# This script must be run as root:
#   $ sudo ./jenkins_install.sh

# enable debug
set -x

# check root permission
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# Install Jenkins
# Add Jenkins to trusted keys and source list
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

# Install via package manager
apt update
apt install jenkins

# print password to access
echo 'Open yourhost:8080 and use following secret key for configuring jenkins: '
cat /var/lib/jenkins/secrets/initialAdminPassword
