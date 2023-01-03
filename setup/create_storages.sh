#!/bin/bash
img_file=/arlo.img
size=4G

fallocate -l "$size" "$img_file"
echo "type=c" | sfdisk "$img_file" > /dev/null
mkfs.vfat "$img_file" -F 32 -n ARLO
mkdir -p /mnt/arlo   #mounting folder for image
mkdir -p /share/arlo #Samba share folder to be rync with mounting folder