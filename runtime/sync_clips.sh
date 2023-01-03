#!/bin/bash

for pid in $(pidof -x sync_clips.sh); do
    if [ $pid != $$ ]; then
        echo "[$(date)] : Process is already running"
        exit 1
    fi
done

umount /mnt/arlo || true
mount /dev/loop0 /mnt/arlo
rsync -avu --delete "/mnt/arlo/" "/share/arlo"