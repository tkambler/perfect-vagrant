#!/bin/bash
echo "Acquire { Retries \"0\"; HTTP { Proxy \"http://10.0.3.1:3128\"; }; };" >> /etc/apt/apt.conf
exit 0
