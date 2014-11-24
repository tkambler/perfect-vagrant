#!/bin/bash
# Requires: supervisor, java

cd /tmp
wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.zip
apt-get install -y unzip
unzip logstash-1.4.2.zip
mv logstash-1.4.2 /opt/logstash

cat << 'EOF' > /etc/logstash.conf
input { stdin { } }
output {
  elasticsearch { host => localhost }
}
EOF

cat << 'EOF' > /etc/supervisor/conf.d/logstash.conf
[program:logstash]
command=/opt/logstash/bin/logstash -f /etc/logstash.conf
directory=/opt/logstash/bin
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/logstash/logstash.err.log
stdout_logfile=/var/log/logstash/logstash.out.log
user=logstash
EOF

mkdir /var/log/logstash

supervisorctl reread
supervisorctl update
