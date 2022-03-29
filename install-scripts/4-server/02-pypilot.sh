#!/bin/bash -e

## this stage depends on stage 18-users for the pypilot user creation
## adduser --home /home/pypilot --gecos --system --disabled-password --disabled-login pypilot

# Op way
apt-get install -y -q --no-install-recommends git python3 python3-pip python3-dev python3-setuptools libpython3-dev \
  python3-wheel python3-numpy python3-scipy swig python3-ujson \
  python3-serial python3-pyudev python3-pil python3-flask python3-engineio \
  python3-opengl  python3-wxgtk4.0 \
  libffi-dev python3-gevent python3-zeroconf watchdog lirc gpio-utils lm-sensors ir-keytable

systemctl disable watchdog
systemctl disable lircd

usermod -a -G lirc user
usermod -a -G lirc pypilot
usermod -a -G lirc signalk

install -v -m 0644 $FILE_FOLDER/60-watchdog.rules "/etc/udev/rules.d/60-watchdog.rules"

if [ $LMARCH == 'arm64' ]; then
  pip3 install pywavefront pyglet gps gevent-websocket importlib_metadata "python-socketio<5" "flask-socketio<5"
else
  apt-get install -y -q python3-flask-socketio
  pip3 install pywavefront pyglet gps gevent-websocket importlib_metadata "python-socketio<5"
fi


pushd ./stageCache
  # Install RTIMULib2 as it's a dependency of pypilot
  if [[ ! -d ./RTIMULib2 ]]; then
    git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
  fi
  echo "Build and install RTIMULib2"

  pushd ./RTIMULib2/Linux/python
    python3 setup.py install
    python3 setup.py clean --all
  popd

#  apt-get install -yq python3-rtimulib2-pypilot

  echo "Get pypilot"
  if [[ ! -d ./pypilot ]]; then
    git clone https://github.com/pypilot/pypilot.git
    cd pypilot
    git checkout a820bcda00f12c37cba8294b1f8ea0206a84b429 # Jan 10, 2022
    cd ..
    git clone --depth=1 https://github.com/pypilot/pypilot_data.git
    cp -rv ./pypilot_data/* ./pypilot
    rm -rf ./pypilot_data
    pushd ./pypilot
      sed -i 's/from importlib.metadata/from importlib_metadata/' dependencies.py || true
      python3 setup.py build
    popd
  fi
  ## Build and install pypilot
  pushd ./pypilot
    python3 setup.py install
    python3 setup.py clean --all
  popd
popd

## Install the service files
install -v -m 0644 $FILE_FOLDER/pypilot@.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_boatimu.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_web.service "/etc/systemd/system/"
install -v -m 0644 $FILE_FOLDER/pypilot_hat.service "/etc/systemd/system/"

sed -i 's/_http._tcp.local./_signalk-http._tcp.local./' "$(find /usr/local/lib -name signalk.py)" || true
sed -i 's/ttyAMA0/serial1/' "$(find /usr/local/lib -name serialprobe.py)" || true
sed -i "s/'ttyAMA'//" "$(find /usr/local/lib -name serialprobe.py)" || true

cp $FILE_FOLDER/wind.py "$(find /usr/local/lib -name wind.py)" || true

systemctl disable pypilot_boatimu.service
systemctl enable pypilot_hat.service
systemctl enable pypilot@pypilot.service                               # listens on tcp 20220 and 23322
systemctl enable pypilot_web.service                                   # listens on tcp 8080

## Install the user config files
install -v -o pypilot -g pypilot -m 0755 -d /home/pypilot/.pypilot
install -v -o pypilot -g pypilot -m 0755 -d /home/tc/.pypilot
install -v -o user -g user -m 0755 -d /home/user/.pypilot
install -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/signalk.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/webapp.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/pypilot_client.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/hat.conf "/home/pypilot/.pypilot/"
install -v -o pypilot -g pypilot -m 0644 $FILE_FOLDER/blacklist_serial_ports "/home/pypilot/.pypilot/"
install -v -o user -g user -m 0644 $FILE_FOLDER/pypilot_client.conf "/home/user/.pypilot/"

install -v -m 0644 $FILE_FOLDER/lircd.conf "/etc/lirc/lircd.conf.d/lircd-pypilot.conf"

## Install The .desktop files
install -d /usr/local/share/applications
install -v $FILE_FOLDER/pypilot_calibration.desktop "/usr/local/share/applications/"
install -v $FILE_FOLDER/pypilot_control.desktop "/usr/local/share/applications/"

install -m 755 $FILE_FOLDER/pypilot-restart "/usr/local/sbin/pypilot-restart"

## Give permission to sudo chrt without a password for the user pypilot.
{
  echo ""
  echo 'pypilot ALL=(ALL) NOPASSWD: /usr/bin/chrt'
  echo 'user ALL=(ALL) NOPASSWD: /usr/local/sbin/pypilot-restart'
} >>/etc/sudoers

## Reduce excessive logging
sed '1 i :msg, contains, "autopilot failed to read imu at time" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "No IMU detected" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "No IMU Detected" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "Failed to open I2C bus" ~' -i /etc/rsyslog.conf
sed '1 i :msg, contains, "Using fusion algorithm Kalman" ~' -i /etc/rsyslog.conf
