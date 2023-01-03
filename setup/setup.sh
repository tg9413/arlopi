#!/bin/bash
mkdir -p /home/pi/log
echo "Creating Storage"
sudo sh /home/pi/arlopi/setup/create_storages.sh
echo "Settup up Samba"
sudo sh /home/pi/arlopi/setup/setup_samba.sh
echo "Setting up Cronjob"
sh /home/pi/arlopi/setup/setup_cronjob.sh
echo "Enabling DWC2, system will reboot after this"
sudo sh /home/pi/arlopi/setup/enable_dwc2_module.sh