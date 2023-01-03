#!/bin/bash
usb_gadget="/sys/kernel/config/usb_gadget"
gadget="arlo"
gadget_root="$usb_gadget/$gadget"
img_file="/arlo.img"
manufacturer="Sandisk"
product="pidrive"
max_power=100 #500 for pi4, 200 for piz2
lang=0x409
cfg=c

modprobe libcomposite

mkdir -p "$gadget_root/configs/$cfg.1"

echo 0x1d6b > "$gadget_root/idVendor"  # Linux Foundation
echo 0x0104 > "$gadget_root/idProduct" # Composite Gadget
echo 0x0100 > "$gadget_root/bcdDevice" # v1.0.0
echo 0x0200 > "$gadget_root/bcdUSB"    # USB 2.0

mkdir -p "$gadget_root/strings/$lang"
mkdir -p "$gadget_root/configs/$cfg.1/strings/$lang"

echo "arlo-Pi-$(grep Serial /proc/cpuinfo | awk '{print $3}')" > "$gadget_root/strings/$lang/serialnumber"
echo "$manufacturer" > "$gadget_root/strings/$lang/manufacturer"
echo "$product" > "$gadget_root/strings/$lang/product"
echo "Arlo-Pi Config" > "$gadget_root/configs/$cfg.1/strings/$lang/configuration"
echo "$max_power" > "$gadget_root/configs/$cfg.1/MaxPower"

mkdir -p "$gadget_root/functions/mass_storage.0"

echo "$img_file" > "$gadget_root/functions/mass_storage.0/lun.0/file"
echo "Arlo Pi $(du -h $img_file | awk '{print $1}')" > "$gadget_root/functions/mass_storage.0/lun.0/inquiry_string"

ln -sf "$gadget_root/functions/mass_storage.0" "$gadget_root/configs/$cfg.1"
ls /sys/class/udc > "$gadget_root/UDC"