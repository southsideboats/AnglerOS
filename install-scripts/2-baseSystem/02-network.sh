#!/bin/bash -e

# Network manager
apt-get install -y -q network-manager make avahi-daemon createap bridge-utils wakeonlan


# Resolve lysmarine.local
install -v $FILE_FOLDER/hostname "/etc/"
cat $FILE_FOLDER/hosts >> /etc/hosts
sed -i '/debian/d' /etc/hosts

# Access Point management
install -m0600 -v $FILE_FOLDER/lysmarine-hotspot.nmconnection "/etc/NetworkManager/system-connections/"
systemctl disable dnsmasq


##  NetworkManager provide its own wpa_supplicant, stop the others to avoid conflicts.
if service --status-all | grep -Fq 'dhcpcd'; then
	systemctl disable dhcpcd.service
fi
systemctl disable wpa_supplicant.service
systemctl disable hostapd.service


## Disable some useless networking services
systemctl disable NetworkManager-wait-online.service # if we do not boot remote user over the network this is not needed
systemctl disable ModemManager.service # for 2G/3G/4G
systemctl disable pppd-dns.service # For dial-up Internet LOL

install -v -m 0644 $FILE_FOLDER/wifi_powersave@.service "/etc/systemd/system/"
systemctl disable wifi_powersave@on.service
systemctl mask wifi_powersave@on.service
systemctl enable wifi_powersave@off.service

# See: http://downloads.fars-robotics.net/
#curl -1sLf http://downloads.fars-robotics.net/wifi-drivers/install-wifi > /usr/local/sbin/install-wifi
curl -1sLf https://raw.githubusercontent.com/bareboat-necessities/my-bareboat/master/install-wifi/install-wifi > /usr/local/sbin/install-wifi
chmod +x /usr/local/sbin/install-wifi
