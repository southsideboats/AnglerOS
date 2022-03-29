#!/bin/bash -e
apt-get -y -q install sudo policykit-1

## Force keyboard layout to be EN US by default.
sed -i "s/XKBLAYOUT=.*/XKBLAYOUT=\"us\"/g" /etc/default/keyboard

## Set root password.
echo 'root:changeme' | chpasswd

## Remove default user (if any).
oldUser=$(cat /etc/passwd | grep 1000:1000 | cut -f1 -d:) 
if [[ ! -z $oldUser ]]; then 
	echo "Removing user "$oldUser
	userdel -r -f $oldUser
else
	echo "No default user found !"
fi

## Add default user.
adduser --uid 1000 --home /home/user --quiet --disabled-password -gecos "lysmarine" user
echo 'user:changeme' | chpasswd
echo "user ALL=(ALL:ALL) ALL" >> /etc/sudoers
usermod -a -G netdev user
usermod -a -G adm user
usermod -a -G tty user
usermod -a -G i2c user
usermod -a -G spi user
usermod -a -G gpio user
usermod -a -G sudo user
usermod -a -G video user
usermod -a -G input user     # for evdev-rce
usermod -a -G audio user
usermod -a -G dialout user
usermod -a -G lp user
#usermod -a -G scanner user
usermod -a -G cdrom user
usermod -a -G plugdev user
usermod -a -G fax user
usermod -a -G voice user
usermod -a -G bluetooth user
usermod -a -G games user
usermod -a -G users user

## Create signalk user to run the server.
if [ ! -d /home/signalk ]; then
	echo "Creating signalk user"
	adduser --home /home/signalk --gecos --system --disabled-password --disabled-login signalk
fi

usermod -a -G tty signalk
usermod -a -G i2c signalk
usermod -a -G spi signalk
usermod -a -G gpio signalk
usermod -a -G dialout signalk
usermod -a -G plugdev signalk

## Create pypilot user to run the services.
if [ ! -d /home/pypilot ]; then
	echo "Creating pypilot user"
	adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot
fi

usermod -a -G tty pypilot
usermod -a -G i2c pypilot
usermod -a -G spi pypilot
usermod -a -G gpio pypilot
usermod -a -G dialout pypilot
usermod -a -G plugdev pypilot

## Create the charts group and add users that have to write to that folder.
if ! grep -q charts /etc/group; then
	groupadd charts
	usermod -a -G charts signalk
	usermod -a -G charts user
	usermod -a -G charts root
fi

## Create the special charts folder.
install -v -d -m 6775 -o signalk -g charts /srv/charts

## Link the chart folder to home for convenience.
if [ ! -f /home/user/charts ] ; then
	su user -c "ln -s /srv/charts /home/user/charts"
fi

groupadd -r lirc
useradd -r -g lirc -d /var/lib/lirc -s /usr/bin/nologin -c "LIRC daemon user" lirc
usermod -a -G input lirc

## Manage the permissions and privileges.
if [[ -d /etc/polkit-1 ]]; then
	echo "polkit found, adding rules"
	install -d "/etc/polkit-1/localauthority/50-local.d"
	install -v $FILE_FOLDER/mount.pkla  "/etc/polkit-1/localauthority/50-local.d/"
	install -v $FILE_FOLDER/all_all_users_to_shutdown_reboot.pkla "/etc/polkit-1/localauthority/50-local.d/"
	install -d "/etc/polkit-1/localauthority/10-vendor.d"
	install -v $FILE_FOLDER/org.freedesktop.NetworkManager.pkla  "/etc/polkit-1/localauthority/10-vendor.d/"
fi



echo 'PATH="/sbin:/usr/sbin:$PATH"' >> /home/user/.profile # Give user capability to halt and reboot.

if [ -f /root/.not_logged_in_yet ]; then # Disable first login script.
	rm /root/.not_logged_in_yet
fi

## Prevent the creation of useless home folders on first boot.
if [ -f /etc/xdg/user-dirs.defaults ]; then
  sed -i 's/^TEMPLATES=/#&/'   /etc/xdg/user-dirs.defaults
  sed -i 's/^PUBLICSHARE=/#&/' /etc/xdg/user-dirs.defaults
#  sed -i 's/^DESKTOP=/#&/'     /etc/xdg/user-dirs.defaults
#  sed -i 's/^MUSIC=/#&/'       /etc/xdg/user-dirs.defaults
#  sed -i 's/^PICTURES=/#&/'    /etc/xdg/user-dirs.defaults
#  sed -i 's/^VIDEOS=/#&/'      /etc/xdg/user-dirs.defaults
fi

ln -s /root /home/root # for openplotter
