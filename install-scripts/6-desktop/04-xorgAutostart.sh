#!/bin/bash -e

install -v -m644 $FILE_FOLDER/startx.service "/etc/systemd/system/startx.service"

systemctl disable startx.service
#systemctl set-default graphical.target
