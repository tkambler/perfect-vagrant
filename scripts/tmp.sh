#!/bin/bash

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
