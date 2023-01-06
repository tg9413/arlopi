#!/bin/bash
init_mass_storage="@reboot sudo sh /home/pi/arlopi/runtime/enable_mass_storage.sh > /home/pi/log/enable_mass_storage_log.txt 2>&1"
init_image_dev="@reboot sudo losetup --show -fP /arlo.bin > /home/pi/log/arlo_bin_mount.txt 2>&1"
sync_clip_interval="*/1 * * * * sudo sh /home/pi/arlopi/runtime/sync_clips.sh > /home/pi/log/sync_log.txt 2>&1"

( crontab -l | cat;  echo "$init_mass_storage" ) | crontab -
( crontab -l | cat;  echo "$init_image_dev" ) | crontab -
( crontab -l | cat;  echo "$sync_clip_interval" ) | crontab -

crontab -l
echo "Cron job updated"
