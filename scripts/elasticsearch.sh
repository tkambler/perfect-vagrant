#!/bin/bash
#
# Requires: java, supervisor

cd /tmp
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.zip
apt-get install -y unzip
unzip elasticsearch-1.3.4.zip
mv elasticsearch-1.3.4 /opt/elasticsearch

useradd elasticsearch

chown -R elasticsearch:elasticsearch /opt/elasticsearch

cat << 'EOF' > /etc/supervisor/conf.d/elasticsearch.conf
[program:elasticsearch]
command=/opt/elasticsearch/bin/elasticsearch
directory=/opt/elasticsearch/bin
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/elasticsearch/elasticsearch.err.log
stdout_logfile=/var/log/elasticsearch/elasticsearch.out.log
user=elasticsearch
EOF

mkdir /var/log/elasticsearch

supervisorctl reread
supervisorctl update
