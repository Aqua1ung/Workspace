#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

rm /etc/kernel/cmdline.d/params.conf
clr-boot-manager update
cp /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/rmmod.service /etc/systemd/system