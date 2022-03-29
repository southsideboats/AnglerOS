#!/bin/bash -e
apt-get install -y -q plymouth plymouth-label libblockdev-mdraid2

## This override the default tty1 behaviour to make it more discrete during the boot process
install -v -d "/etc/systemd/system/getty@tty1.service.d"
install -v -m0644 $FILE_FOLDER/skip-prompt.conf "/etc/systemd/system/getty@tty1.service.d/"

## Debian
if [ -f /etc/default/grub ] ; then
  install -m0644 -v $FILE_FOLDER/grub "/etc/default/grub"
  install -m0644 -v $FILE_FOLDER/background.png "/boot/grub/background.png"
  echo FRAMEBUFFER=y >> /etc/initramfs-tools/conf.d/splash
  update-initramfs -u
  update-grub
fi

## Theming of the boot process
install -v $FILE_FOLDER/ascii_logo.txt "/etc/motd"
cp -r $FILE_FOLDER/dreams "/usr/share/plymouth/themes/"
plymouth-set-default-theme dreams

