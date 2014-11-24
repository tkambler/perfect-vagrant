#!/bin/bash
# Description: Web-based front-end to Elasticsearch
# Requires: node

cd /tmp
wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.zip
apt-get install -y unzip
unzip kibana-3.1.1.zip
mkdir -p /opt/kibana/public
mv kibana-3.1.1 /opt/kibana/public

cat << 'EOF' > /opt/kibana/server.js
var express = require('express');
var app = express();
app.use('/', express.static(__dirname + '/public'));
app.listen(7000);
EOF

cat << 'EOF' > /opt/kibana/package.json
{
    "name": "kibana-frontend",
    "version": "0.0.0"
}
EOF

cd /opt/kibana
npm install express --save

useradd kibana
chown -R kibana:kibana /opt/kibana

cat << 'EOF' > /etc/supervisor/conf.d/kibana.conf
[program:kibana]
command=/usr/bin/node /opt/kibana/server.js
directory=/opt/kibana
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/kibana/kibana.err.log
stdout_logfile=/var/log/kibana/kibana.out.log
user=kibana
EOF

mkdir /var/log/kibana

supervisorctl reread
supervisorctl update
