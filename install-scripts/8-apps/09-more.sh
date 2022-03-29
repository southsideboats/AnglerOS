#!/bin/bash -e

apt-get clean
npm cache clean --force

apt-get -q -y install i2c-tools python3-smbus dos2unix traceroute telnet whois socat gdal-bin openvpn seahorse inxi \
  dconf-editor gedit gnome-calculator gnome-weather gnome-chess openpref \
  python3-bme680 python3-gpiozero python3-w1thermsensor  \
  sysstat jq xmlstarlet uhubctl iotop rsync timeshift at snapd \
  fontconfig nautic gnome-disk-utility catfish xfce4-screenshooter hardinfo baobab # foxtrotgps

systemctl disable openvpn

apt-get clean

systemctl disable snapd snapd.socket

#apt-get install software-properties-common

# Budgie settings
gsettings set com.solus-project.budgie-wm focus-mode true

apt-get clean
npm cache clean --force

#apt-get -q -y install arduino

pip3 install adafruit-ampy

install -v -m 0755 $FILE_FOLDER/bbn-change-password.sh "/usr/local/bin/bbn-change-password"
install -v -m 0755 $FILE_FOLDER/bbn-rename-host.sh "/usr/local/sbin/bbn-rename-host"

install -d -o 1000 -g 1000 -m 0755 "/home/user/add-ons"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/add-ons/readme.txt "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/text-to-speech-sample.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/wxtoimg-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/sdrglut-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/pactor-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/nmea-sleuth-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/qtvlm-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/predict-install.sh "/home/user/add-ons/"
#install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/nodered-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/timezone-setup.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/calibrate-touchscreen.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/change-password.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/scytalec-inmarsat-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/winlink-pat-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/openplotter-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/navionics-demo-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/widevine-lib-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/wifi-drivers-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/boatsetter-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/java-upgrade.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/lightningmaps-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/marinetraffic-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/windy-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/ads-b-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/tvheadend-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/dvb-t-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/hot-fixes-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/findacrew-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/maritime-lib-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/homeassistant-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/jellyfin-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/stdc-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/maiana-ais-install.sh "/home/user/add-ons/"
install -v -o 1000 -g 1000 -m 0755 $FILE_FOLDER/add-ons/tripwire-install.sh "/home/user/add-ons/"

/home/user/add-ons/windy-install.sh
/home/user/add-ons/lightningmaps-install.sh
/home/user/add-ons/marinetraffic-install.sh
/home/user/add-ons/boatsetter-install.sh
/home/user/add-ons/findacrew-install.sh

install -v $FILE_FOLDER/bbn-checklist.desktop "/usr/local/share/applications/"

install -d -m 0755 "/usr/local/share/colreg"
curl 'https://en.wikisource.org/api/rest_v1/page/pdf/International_Regulations_for_Preventing_Collisions_at_Sea' \
 -H 'Accept: */*;q=0.8' \
 -H 'Accept-Language: en-US,en;q=0.5' --compressed \
 -H 'DNT: 1' -H 'Connection: keep-alive' \
 -H 'Upgrade-Insecure-Requests: 1' -H 'TE: Trailers' \
 --output "/usr/local/share/colreg/colreg.pdf"
install -v $FILE_FOLDER/colreg.desktop "/usr/local/share/applications/"

install -d -m 0755 "/usr/local/share/knots"
install -v -m 0644 $FILE_FOLDER/knots/knots.html "/usr/local/share/knots/"
install -v -m 0644 $FILE_FOLDER/knots/knots.svg "/usr/local/share/knots/"
install -v -m 0644 $FILE_FOLDER/knots/License_free.txt "/usr/local/share/knots/"
install -v $FILE_FOLDER/knots.desktop "/usr/local/share/applications/"

install -d -o 1000 -g 1000 -m 0755 "/home/user/FloatPlans"

install -d '/usr/local/share/marine-life'
install -v -m 0644 $FILE_FOLDER/marine-life-id.html "/usr/local/share/marine-life/"
install -v $FILE_FOLDER/marine-life.desktop "/usr/local/share/applications/"

install -d -o 1000 -g 1000 -m 0755 "/home/user/.vessel"
install -v -o 1000 -g 1000 -m 0644 $FILE_FOLDER/vessel.data "/home/user/.vessel/"
install -v -m 0755 $FILE_FOLDER/vessel-data.sh "/usr/local/bin/vessel-data"
install -v $FILE_FOLDER/vessel-data.desktop "/usr/local/share/applications/"

if [ $LMARCH == 'arm64' ]; then
  wget https://downloads.rclone.org/rclone-current-linux-arm64.deb
  dpkg -i rclone-current-linux-arm64.deb
  rm rclone-current-linux-arm64.deb
else
  wget https://downloads.rclone.org/rclone-current-linux-arm.deb
  dpkg -i rclone-current-linux-arm.deb
  rm rclone-current-linux-arm.deb
fi


# https://github.com/raspberrypi/usbboot
CUR_DIR="$(pwd)"
mkdir -p /home/user/usbboot && cd /home/user/usbboot
git clone --depth=1 https://github.com/raspberrypi/usbboot
cd usbboot
make

rm -rf /home/user/usbboot
cd "$CUR_DIR"
