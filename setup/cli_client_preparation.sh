#!/usr/bin/env bash
# download jenkins-cli.jar jenkins_url and print help for test
#
# This script must be run as root:
##   $ sudo ./cli_client_preparation.sh jenkins_url

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

# check if java installed
command -v java >/dev/null 2>&1 || { echo >&2 "jre not installed. Installing jre for executing client binary, please input your password"; apt-get update; apt-get -yq install default-jre-headless; }

# check if curl installed
command -v curl >/dev/null 2>&1 || { echo >&2 "curl not installed. Installing curl for downloading client binary, please input your password"; apt-get update; apt-get -yq install curl; }

# download to user's home
su -l $USER -c "curl \"$1/jnlpJars/jenkins-cli.jar\" -o $HOME/jenkins-cli.jar"

# test
su -l $USER -c "java -jar \$HOME/jenkins-cli.jar -s $1 -auth cinnamon:cinnamon help"
