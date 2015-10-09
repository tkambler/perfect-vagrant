#!/bin/bash
#
# Installs Node.js and various global utilities

echo "Installing Node.js"
curl -sL https://deb.nodesource.com/setup | sudo bash -
apt-get install -y nodejs
apt-get install -y build-essential
