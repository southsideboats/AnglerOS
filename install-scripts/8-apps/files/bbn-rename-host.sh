#!/bin/bash -e

# It's a crud implementation. Use with caution.

if [ "$EUID" -ne 0 ] ; then
  echo "Run as root"
  exit
fi

if [ $# -eq 0 ] ; then
    echo "Provide a new host name as the first argument"
fi

NEW_HOSTNAME=$(echo $1 | tr '[:upper:]' '[:lower:]' | sed 's/[^0-9a-z-]*//g')
OLD_HOSTNAME="${HOSTNAME:-lysmarine}"

echo "renaming from $OLD_HOSTNAME to $NEW_HOSTNAME"

sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname
sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts

sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" "/etc/NetworkManager/system-connections/lysmarine-hotspot.nmconnection"

sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" "/home/pypilot/.pypilot/signalk.conf"

echo "done."
