#!/bin/bash

# Run as root/sudo.

if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

location=$(curl -s -L -D - https://github.com/VSCodium/vscodium/releases/latest/ -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
tag=$(echo "$location" | sed 's/location: https.\+tag\///')
instRel=$(cat /usr/share/codium/resources/app/package.json | grep release | sed -n 's/  "rel.* "//p' |sed -n 's/".*$//p')
iV=$(sudo -u dad codium -v | sed -n 1p)
iV+=.$instRel # Concatenate iV + instRel.
# echo "iV  is: $iV"
# echo "tag is: $tag"
if [[ "$iV" != "$tag" ]]
then
  sudo -u dad wget -O /home/dad/Downloads/codium.rpm https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
  rpm -Uvh --nodeps /home/dad/Downloads/codium.rpm
else
  echo "No VSCodium update required."
fi