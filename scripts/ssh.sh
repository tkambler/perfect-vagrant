#!/bin/bash
echo "Configuring SSH"

cat << 'EOF' >> /root/.ssh/config
Host *
    StrictHostKeyChecking no
EOF

mkdir /home/vagrant/.ssh
chown vagrant:vagrant /home/vagrant/.ssh

cat << 'EOF' >> /home/vagrant/.ssh/config
Host *
    StrictHostKeyChecking no
EOF

chown vagrant:vagrant /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config
