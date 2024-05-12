#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

flatpak install fr.romainvigier.MetadataCleaner