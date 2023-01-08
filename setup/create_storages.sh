#!/bin/bash -eu
ARLO_IMG_FILE=/arlo.bin
ARLO_IMG_SIZE=31457280

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

  fallocate -l "$size"K "$filename"
  echo "type=c" | sfdisk "$filename" > /dev/null
  
  local partition_offset
  partition_offset=$(first_partition_offset "$filename")

  loopdev=$(losetup -o "$partition_offset" -f --show "$filename")

  mkfs.vfat "$loopdev" -F 32 -n "$label"

  losetup -d "$loopdev"

  local mountpoint=/mnt/"$name"

  if [ ! -e "$mountpoint" ]
  then
    mkdir "$mountpoint"
  fi
}


add_drive "arlo" "ARLO" "$ARLO_IMG_SIZE" "$ARLO_IMG_FILE" 
