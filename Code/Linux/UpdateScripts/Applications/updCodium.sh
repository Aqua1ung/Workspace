#!/bin/bash

# Run as root/sudo.

if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

location=$(curl -s -L -D - https://github.com/VSCodium/vscodium/releases/latest/ -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
tag=$(echo "$location" | sed 's/location: https.\+tag\///')
instVer=$(codium -s | sed -n 1p | sed -n 's/^.\+VSCodium //p' | sed -n 's/ (.\+$//p' | sed -n 's/ /\./p') # Check installed version.
if [ "$instVer" != "$tag" ]
then
  sudo -u dad wget -O /home/dad/Downloads/codium.rpm https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
  rpm -Uvh --nodeps /home/dad/Downloads/codium.rpm
else
  echo "No VSCodium update required."
fi