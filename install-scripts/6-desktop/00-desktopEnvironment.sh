#!/bin/bash -e

## Needed to allow the service file start X
install  -v $FILE_FOLDER/Xwrapper.config "/etc/X11/"

arch=$(dpkg --print-architecture)

if [ $LMOS == Raspbian ]; then
  apt-get -q -y install xserver-xorg-video-fbturbo
fi

if [ $LMOS == Armbian ]; then
	apt-get -q -y install xserver-xorg-legacy
fi

# Install touchscreen drivers, etc
apt-get -q -y install xserver-xorg-input-libinput xinput libinput-tools xinput-calibrator gldriver-test \
 budgie-desktop budgie-weathershow-applet budgie-rotation-lock-applet \
 gstreamer1.0-x gstreamer1.0-omx gstreamer1.0-plugins-base \
 gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-alsa \
 gstreamer1.0-libav alsa-utils libavahi-compat-libdnssd-dev git openbox \
 xbacklight lxappearance gmrun xsettingsd xserver-xorg \
 xinit libgtk2-perl cpanminus perl-base \
 dialog lxterminal network-manager-gnome system-config-printer

wget https://dl.cloudsmith.io/public/bbn-projects/bbn-budgie/deb/debian/pool/buster/main/b/bu/budgie-core_10.5-2/budgie-core_10.5-2_${arch}.deb
wget https://dl.cloudsmith.io/public/bbn-projects/bbn-budgie/deb/debian/pool/buster/main/l/li/libbudgie-plugin0_10.5-2/libbudgie-plugin0_10.5-2_${arch}.deb
wget https://dl.cloudsmith.io/public/bbn-projects/bbn-budgie/deb/debian/pool/buster/main/l/li/libbudgie-private0_10.5-2/libbudgie-private0_10.5-2_${arch}.deb

dpkg -i budgie-core_10.5-2_${arch}.deb libbudgie-plugin0_10.5-2_${arch}.deb libbudgie-private0_10.5-2_${arch}.deb

rm *budgie*.deb

install -o 1000 -g 1000 -d /home/user/.local
install -o 1000 -g 1000 -d /home/user/.local/share
install -o 1000 -g 1000 -d /home/user/.local/share/desktop-directories
install -o 1000 -g 1000 -d /home/user/.local/share/applications
install -o 1000 -g 1000 -d /home/user/.local/share/icons
install -o 1000 -g 1000 -d /home/user/.local/share/sounds

# Openbox
install -o 1000 -g 1000 -d /home/user/.config
install -o 1000 -g 1000 -d /home/user/.config/openbox
install -o 1000 -g 1000 -v $FILE_FOLDER/autostart /home/user/.config/openbox/

# Thunar file manager
install -o 1000 -g 1000 -d /home/user/.config/xfce4
install -o 1000 -g 1000 -d /home/user/.config/xfce4/xfconf
install -o 1000 -g 1000 -d /home/user/.config/xfce4/xfconf/xfce-perchannel-xml
install -o 1000 -g 1000 -v $FILE_FOLDER/thunar.xml /home/user/.config/xfce4/xfconf/xfce-perchannel-xml/

# Menus
install -o 1000 -g 1000 -d /home/user/.config/menus
install -o 1000 -g 1000 -v $FILE_FOLDER/gnome-applications.menu /home/user/.config/menus/gnome-applications.menu-orig
install -o 1000 -g 1000 -v $FILE_FOLDER/lysmarine-applications.menu /home/user/.config/menus/lysmarine-applications.menu-orig
install -o 1000 -g 1000 -v $FILE_FOLDER/lysmarine-applications.menu /home/user/.config/menus/gnome-applications.menu
install -o 1000 -g 1000 -v $FILE_FOLDER/navigation.directory /home/user/.local/share/desktop-directories/
install -o 1000 -g 1000 -v $FILE_FOLDER/openplotter.directory /home/user/.local/share/desktop-directories/

install -m 755 -v $FILE_FOLDER/bbn-commands.sh /usr/local/bin/bbn-commands

install -v $FILE_FOLDER/commands.desktop /usr/local/share/applications/

install -d /etc/budgie-desktop
install -m 644 -v $FILE_FOLDER/panel.ini /etc/budgie-desktop/


# Make some room for the rest of the build script
apt-get clean

## Install base desktop apps.
if [ $LMOS == Raspbian ]; then
	apt-get install -y -q chromium-browser midori
else
	apt-get install -y -q chromium midori
fi

# Adobe Flash Player. Copyright 1996-2015. Adobe Systems Incorporated. All Rights Reserved.
DEBIAN_FRONTEND=noniterractive apt-get -o Dpkg::Options:=="--force-confnew" -q -y install rpi-chromium-mods

apt-get install -y -q lxterminal gpsbabel file-roller lxtask thunar

#apt-get install -y -q pcmanfm mousepad

# force polkit agent to start with openbox (this is needed for nm-applet hotspot)
sed -i '/^OnlyShowIn=/ s/$/GNOME;/' /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop

install -v $FILE_FOLDER/scale-up.desktop /usr/local/share/applications/
install -v $FILE_FOLDER/scale-down.desktop /usr/local/share/applications/

install -v -m 755 $FILE_FOLDER/scale-up /usr/local/bin/
install -v -m 755 $FILE_FOLDER/scale-down /usr/local/bin/
