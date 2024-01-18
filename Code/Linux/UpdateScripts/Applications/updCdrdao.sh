#!/bin/bash

# Run as root/sudo.

if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

$iV=$(cdrdao 2>&1 | grep version | sed -n 's/^.\+on //p' | sed -n 's/ -.*$//p') # Check installed version.
location=$(curl -s -L -D - https://github.com/cdrdao/cdrdao/releases/latest -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
tag=$(echo "$location" | sed 's/location: https.\+tag\///')
ver=$(echo "$tag" | sed -n 's/rel_//p' | sed -n 's/_/./gp')
if [[ "$iV" != "$ver" ]]
then
  sudo -u dad wget -O /home/dad/Downloads/cdrdao.tar.bz2 https://github.com/cdrdao/cdrdao/releases/download/$tag/cdrdao-$ver.tar.bz2
  sudo -u dad mkdir /home/dad/Downloads/cdrdao
  sudo -u dad tar -xf /home/dad/Downloads/cdrdao.tar.bz2 -C /home/dad/Downloads/cdrdao --strip 1
  cd /home/dad/Downloads/cdrdao
  sudo -u dad configure && make
  make install
  sudo -u dad make clean
  cd -
else
  echo "No cdrdao update required."
fi