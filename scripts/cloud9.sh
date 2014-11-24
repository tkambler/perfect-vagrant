#!/bin/bash
#
# Installs Cloud9 Web IDE

# cd /opt
# git clone https://github.com/ajaxorg/cloud9.git
# cd cloud9
# npm install
# useradd cloudnine
# chown -R cloudnine:cloudnine cloud9

# apt-get install -y unzip
#
# cp /vagrant/files/cloud9.zip /opt
# cd /opt
# unzip cloud9.zip

cat << 'EOF' > /etc/supervisor/conf.d/cloud9.conf
[program:cloud9]
command=/opt/cloud9/bin/cloud9.sh -w / -l 0.0.0.0
directory=/opt/repos
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/cloud9/cloud9.err.log
stdout_logfile=/var/log/cloud9/cloud9.out.log
user=root
EOF

mkdir /var/log/cloud9

supervisorctl reread
supervisorctl update

supervisorctl start cloud9
