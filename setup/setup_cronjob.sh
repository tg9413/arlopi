#!/bin/bash
init_mass_storage="@reboot sudo sh /home/pi/arlopi/runtime/enable_mass_storage.sh > /home/pi/log/enable_mass_storage_log.txt 2>&1"
sync_clip_interval="*/1 * * * * sudo /bin/bash /home/pi/arlopi/runtime/sync_clips.sh > /home/pi/log/sync_log.txt 2>&1"
cleanup_clips_interval="0 0 * * * sudo /bin/bash /home/pi/arlopi/runtime/cleanup_clips.sh > /home/pi/log/cleanup_log.txt 2>&1"

( crontab -l | cat;  echo "$init_mass_storage" ) | crontab -
( crontab -l | cat;  echo "$sync_clip_interval" ) | crontab -
( crontab -l | cat;  echo "$cleanup_clip_interval" ) | crontab -

crontab -l
echo "Cron job updated"
