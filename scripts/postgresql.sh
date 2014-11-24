#!/bin/bash

echo "Installing PostgreSQL"

apt-get install -y postgresql postgresql-contrib libpq-dev
sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'postgres';"

cat << 'EOF' > /etc/postgresql/9.3/main/pg_hba.conf
local   all             postgres                                trust
local   all             all                                     peer
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
host    all             all             0.0.0.0/0               md5
EOF

cat << 'EOF' >> /etc/postgresql/9.3/main/postgresql.conf
listen_addresses = '*'
EOF

apt-get install -y postgresql-9.3-plv8

/etc/init.d/postgresql restart
