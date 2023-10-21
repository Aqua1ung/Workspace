#!/bin/bash

# Run as root/sudo.

if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

mkdir -p /etc/systemd/logind.conf.d
ln -sf /dev/null /etc/systemd/logind.conf.d/80-lidswitch.conf