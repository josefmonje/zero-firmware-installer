#!/bin/bash
#
# Installer for zero gadget firmware
#
# Usage:
# 	chmod +x install.sh
#	./install.sh
#

KERNEL_VERSION=$(uname -r)

# Check if kernel module is there, otherwise download kernel and patch
if [ -f ~/zero-gadget-firmware/dwc2/dwc2."$KERNEL_VERSION".ko ] ;
then
  sudo cp -f ~/zero-gadget-firmware/dwc2/dwc2."$KERNEL_VERSION".ko /lib/modules/"$KERNEL_VERSION"/kernel/drivers/usb/dwc2/dwc2.ko
else
  sudo apt-get install -y bc
  sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source
  sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update
  rpi-source
  cd ~/linux/drivers/usb/dwc2
  patch -i ~/zero-gadget-firmware/dwc2/gadget.patch
  cd ~/linux
  make M=drivers/usb/dwc2 CONFIG_USB_DWC2=m
  sudo cp -f drivers/usb/dwc2/dwc2.ko /lib/modules/"$KERNEL_VERSION"/kernel/drivers/usb/dwc2/dwc2.ko
  sudo cp -f drivers/usb/dwc2/dwc2.ko ~/zero-gadget-firmware/dwc2/dwc2."$KERNEL_VERSION".ko
fi
# Install and setup files
sudo cp -f ~/zero-gadget-firmware/config.txt /boot/
sudo cp -f ~/zero-gadget-firmware/modules /etc/
sudo cp -f ~/HackPi/rc.local /etc/
sudo chmod +x /etc/rc.local
