#!/bin/bash

# Do NOT run as root! 
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit
fi

# mkdir -p /run/media/dad/CloneZilla /run/media/dad/InstallationKits /run/media/dad/VentoyCZ /run/media/dad/VentoyIK
udisksctl mount -b /dev/disk/by-uuid/694290e7-0460-459b-a59c-6ce976a12b7e # /run/media/dad/CloneZilla
udisksctl mount -b /dev/disk/by-uuid/8c53f34a-75dd-44de-bd1b-2aa7b0ce5a49 # /run/media/dad/InstallationKits
udisksctl mount -b /dev/disk/by-uuid/C512-23DF # /run/media/dad/Ventoy
udisksctl mount -b /dev/disk/by-uuid/3a246465-e7de-4894-981a-9da617ad0ff2 # /run/media/dad/Sandbox