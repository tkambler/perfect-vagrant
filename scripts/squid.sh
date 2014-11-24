#!/bin/bash
docker pull pmoust/squid-deb-proxy
if [ ! -d "/proxy_cache" ] then
    mkdir /proxy_cache
fi
docker run -d --name proxy -v /proxy_cache:/cachedir -p 3128:8000 pmoust/squid-deb-proxy
exit 0
