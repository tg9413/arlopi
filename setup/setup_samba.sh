#!/bin/bash
apt-get install samba winbind -y

cat <<- EOF > /etc/samba/smb.conf
	[global]
	   deadtime = 2
	   workgroup = WORKGROUP
	   dns proxy = no
	   log file = /var/log/samba.log.%m
	   max log size = 1000
	   syslog = 0
	   panic action = /usr/share/samba/panic-action %d
	   server role = standalone server
	   passdb backend = tdbsam
	   obey pam restrictions = yes
	   unix password sync = yes
	   passwd program = /usr/bin/passwd %u
	   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
	   pam password change = yes
	   map to guest = bad user
	   min protocol = SMB2
	   usershare allow guests = yes
           unix extensions = no
           wide links = yes
	[Arlo]
	   read only = no
	   locking = no
       browseable = yes
	   path = /share/arlo
	   create mask = 777
	   admin users = pi
	EOF

systemctl restart smbd.service