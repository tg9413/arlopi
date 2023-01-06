#!/bin/bash
mkdir -p /home/pi/log
echo "Enabling DWC2"
sudo sh /home/pi/arlopi/setup/enable_dwc2_module.sh
echo "Creating Storage"
sudo sh /home/pi/arlopi/setup/create_storages.sh
echo "Settup up Samba"
sudo sh /home/pi/arlopi/setup/setup_samba.sh
echo "Setting up Cronjob"
sh /home/pi/arlopi/setup/setup_cronjob.sh
echo "Restarting system"
sudo reboot now