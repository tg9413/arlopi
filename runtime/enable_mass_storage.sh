#!/bin/bash
gadget_root="/sys/kernel/config/usb_gadget"
gadget="arlo"
img_file="/arlo.img"
serial_number="SN00913415201215"
manufacturer="Sandisk"
product="pidrive"

modprobe libcomposite
mkdir -p "$gadget_root"/"$gadget"
cd "$gadget_root"/"$gadget"
echo 0x1d6b > idVendor
echo 0x0104 > idProduct
echo 0x0100 > bcdDevice
echo 0x0200 > bcdUSB
mkdir -p strings/0x409
echo "$serial_number" > strings/0x409/serialnumber
echo "$manufacturer" > strings/0x409/manufacturer
echo "$product" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: Mass Storage" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
mkdir -p functions/mass_storage.usb0
echo 0 > functions/mass_storage.usb0/lun.0/cdrom
echo 0 > functions/mass_storage.usb0/lun.0/ro
echo "$img_file" > functions/mass_storage.usb0/lun.0/file
ls /sys/class/udc > UDC