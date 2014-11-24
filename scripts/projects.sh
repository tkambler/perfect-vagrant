#!/bin/bash

# Front-End

cd /home/vagrant/projects
git clone git@github.com:tkambler/vagrant-example-project.git example-project
cd example-project
npm install
bower install --allow-root --config.interactive=false
chown -R vagrant:vagrant /home/vagrant/projects/example-project

mkdir /var/log/example-project
cat << 'EOF' > /etc/supervisor/conf.d/example-project.conf
[program:example-project]
command=grunt
directory=/home/vagrant/projects/example-project
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/example-project/example-project.err.log
stdout_logfile=/var/log/example-project/example-project.out.log
user=vagrant
EOF
supervisorctl reread
supervisorctl update

cat << 'EOF' > /etc/supervisor/conf.d/example-project-watch.conf
[program:example-project-watch]
command=watchify public/app/index.js -o build/app.js
directory=/home/vagrant/projects/example-project
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/example-project/example-project-watch.err.log
stdout_logfile=/var/log/example-project/example-project-watch.out.log
user=vagrant
EOF

supervisorctl reread
supervisorctl update

# API

cd /home/vagrant/projects
git clone git@github.com:tkambler/vagrant-example-api.git api
cd api
npm install
chown -R vagrant:vagrant /home/vagrant/projects/api

sudo -H -u vagrant bash -c 'pm2 start /home/vagrant/projects/api/pm2/development.json'
