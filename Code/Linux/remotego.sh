#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

swupd bundle-add devpkg-libwacom

# Install hid-tools
pip3 install hid-tools

# Add RemoteGo tablet.
mkdir -p /usr/lib/udev/hwdb.d
cp /run/media/dad/InstallationKits/RemoteGo/61-evdev-local.hwdb /usr/lib/udev/hwdb.d
systemd-hwdb update
udevadm trigger /dev/input/event*