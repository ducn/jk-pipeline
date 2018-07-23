#!/usr/bin/env bash

# generate ssh key pair for server to access
ssh-keygen

echo 'Use following public key to setup GitHub account for pulling source code automatically'
cat $HOME/.ssh/id_rsa.pub

echo $1 >> $HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

mkdir $HOME/jenkins