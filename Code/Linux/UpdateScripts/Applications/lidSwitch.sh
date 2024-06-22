#!/bin/bash

# Do not run as root/sudo.

if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

sudo mkdir -p /etc/systemd/logind.conf.d
sudo ln -sf /dev/null /etc/systemd/logind.conf.d/80-lidswitch.conf # Disables 80-lidswitch.conf.