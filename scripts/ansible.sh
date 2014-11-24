#!/bin/bash

echo "Installing software-properties-common"
apt-get install -y software-properties-common

echo "Adding PPA: ppa:ansible/ansible"
apt-add-repository -y ppa:ansible/ansible

echo "Updating Apt"
apt-get update

echo "Installing Ansible"
apt-get install -y ansible

echo "Ansible install complete"

exit 0
