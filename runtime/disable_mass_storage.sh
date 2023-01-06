#!/bin/bash
modprobe -r g_mass_storage

root="/sys/kernel/config/usb_gadget/arlo"

if [ ! -d "$root" ]
then
  echo "already released"
  exit 2
fi

echo > "$root/UDC" || true
rmdir "$root"/configs/*/strings/* || true
rm -f "$root"/configs/*/mass_storage.0 || true
rmdir "$root"/functions/mass_storage.0 || true
rmdir "$root"/configs/* || true
rmdir "$root"/strings/* || true
rmdir "$root"

modprobe -r usb_f_mass_storage g_ether usb_f_ecm usb_f_rndis libcomposite || true