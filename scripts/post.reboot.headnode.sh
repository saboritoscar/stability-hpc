#!/bin/bash

# actions necessary post first headnode reboot
# run as root

# clear sssd cache (will also run in cron every hour)
systemctl stop sssd; rm -rf /var/lib/sss/{db,mc}/*; systemctl start sssd

# establish disk quota
xfs_quota -x -c 'limit -u bsoft=30000m bhard=40000m -d' /

# run this on production, comment on sandbox
#sed -E -i 's|^#?(PasswordAuthentication)\s.*|\1 no|' /etc/ssh/sshd_config
systemctl restart sshd

# index /home and /fsx
duc index /home
#duc index /fsx

