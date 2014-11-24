#!/bin/bash

gem install mailcatcher

cat << 'EOF' > /etc/supervisor/conf.d/mailcatcher.conf
[program:mailcatcher]
command=mailcatcher --http-ip 0.0.0.0 --foreground
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/mailcatcher/mailcatcher.err.log
stdout_logfile=/var/log/mailcatcher/mailcatcher.out.log
user=root
EOF

mkdir /var/log/mailcatcher
supervisorctl reread
supervisorctl update
