#!/bin/bash
apt-get install samba -y

echo "[arlo]" >> /etc/samba/smb.conf
echo "browseable = yes" >> /etc/samba/smb.conf
echo "path = /share/arlo" >> /etc/samba/smb.conf
echo "read only = no" >> /etc/samba/smb.conf
echo "create mask = 777" >> /etc/samba/smb.conf

systemctl restart smbd.service