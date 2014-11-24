#!/bin/bash
#
# Installs Node.js and various global utilities

echo "Installing Node.js"
curl -sL https://deb.nodesource.com/setup | sudo bash -
apt-get install -y nodejs
apt-get install -y build-essential

echo "Installing Grunt CLI"
npm install -g grunt-cli

echo "Installing Bower"
npm install -g bower

echo "Installing Browserify"
npm install -g browserify
npm install -g watchify

echo "Installing pm2"
npm install pm2 -g --unsafe-perm

echo "Installing Mocha"
npm install -g mocha

echo "Installing Knex"
npm install -g knex

echo "Installing Async"
npm install -g async

echo "Installing Bluebird"
npm install -g bluebird

echo "Installing Lo-Dash"
npm install -g lodash

echo "Installing Underscore.string"
npm install -g underscore.string

echo "Installing ShellJS"
npm install -g shelljs
