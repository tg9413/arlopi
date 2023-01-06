#!/bin/bash -eu
ARLO_IMG_FILE=/arlo.bin
ARLO_IMG_SIZE=31457280
USE_EXFAT=1

function log_progress () {
  if declare -F setup_progress > /dev/null
  then
    setup_progress "create-backingfiles: $1"
    return
  fi
  echo "create-backingfiles: $1"
}



function first_partition_offset () {
  local filename="$1"
  local size_in_bytes
  local size_in_sectors
  local sector_size
  local partition_start_sector

  size_in_bytes=$(sfdisk -l -o Size -q --bytes "$1" | tail -1)
  size_in_sectors=$(sfdisk -l -o Sectors -q "$1" | tail -1)
  sector_size=$(( size_in_bytes / size_in_sectors ))
  partition_start_sector=$(sfdisk -l -o Start -q "$1" | tail -1)

  echo $(( partition_start_sector * sector_size ))
}


function add_drive () {
  local name="$1"
  local label="$2"
  local size="$3"
  local filename="$4"
  local useexfat="$5"

  log_progress "Allocating ${size}K for $filename..."
  fallocate -l "$size"K "$filename"
  if [ "$useexfat" = true  ]
  then
    echo "type=7" | sfdisk "$filename" > /dev/null
  else
    echo "type=c" | sfdisk "$filename" > /dev/null
  fi

  local partition_offset
  partition_offset=$(first_partition_offset "$filename")

  loopdev=$(losetup -o "$partition_offset" -f --show "$filename")
  log_progress "Creating filesystem with label '$label'"
  if [ "$useexfat" = true  ]
  then
    mkfs.exfat "$loopdev" -L "$label"
  else
    mkfs.vfat "$loopdev" -F 32 -n "$label"
  fi
  losetup -d "$loopdev"

  local mountpoint=/mnt/"$name"

  if [ ! -e "$mountpoint" ]
  then
    mkdir "$mountpoint"
  fi
}


function check_for_exfat_support () {
  # First check for built-in ExFAT support
  # If that fails, check for an ExFAT module
  # in this last case exfat doesn't appear
  # in /proc/filesystems if the module is not loaded.
  if grep -q exfat /proc/filesystems &> /dev/null
  then
    return 0;
  elif modprobe -n exfat &> /dev/null
  then
    return 0;
  else 
    return 1;  
  fi
}

add_drive "arlo" "ARLO" "$ARLO_IMG_SIZE" "$ARLO_IMG_FILE" "$USE_EXFAT"

# fallocate -l "$size"K "$img_file"
# echo "type=c" | sfdisk "$img_file" > /dev/null
# mkfs.vfat "$img_file" -F 32 -n ARLO
# mkdir -p /mnt/arlo   #mounting folder for image
# mkdir -p /share/arlo #Samba share folder to be rync with mounting folder