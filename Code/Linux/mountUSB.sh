#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

mkdir -p /run/media/dad/CloneZilla /run/media/dad/InstallationKits /run/media/dad/VentoyCZ /run/media/dad/VentoyIK
mount /dev/disk/by-uuid/4affd149-c8de-4987-83a7-8281e97f6eba /run/media/dad/CloneZilla
mount /dev/disk/by-uuid/604729ba-585f-44ca-9794-4c06c22195cc /run/media/dad/InstallationKits
mount /dev/disk/by-uuid/E1BD-1D00 /run/media/dad/VentoyCZ
mount /dev/disk/by-uuid/68EF-2812 /run/media/dad/VentoyIK