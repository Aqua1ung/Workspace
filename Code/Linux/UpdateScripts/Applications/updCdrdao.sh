#!/bin/bash

# Do not run as root/sudo.

if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

iV=$(cdrdao 2>&1 | grep version | sed -n 's/^.\+on //p' | sed -n 's/ -.*$//p') # Check installed version.
location=$(curl -s -L -D - https://github.com/cdrdao/cdrdao/releases/latest -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
tag=$(echo "$location" | sed 's/location: https.\+tag\///')
ver=$(echo "$tag" | sed -n 's/rel_//p' | sed -n 's/_/./gp')
if [[ "$iV" != "$ver" ]]
then
  wget -O /home/dad/Downloads/cdrdao.tar.bz2 https://github.com/cdrdao/cdrdao/releases/download/$tag/cdrdao-$ver.tar.bz2
  mkdir /home/dad/Downloads/cdrdao
  tar -xf /home/dad/Downloads/cdrdao.tar.bz2 -C /home/dad/Downloads/cdrdao --strip 1
  cd /home/dad/Downloads/cdrdao
  ./configure && make
  sudo make install
  make clean
  cd -
else
  echo "No cdrdao update required."
fi