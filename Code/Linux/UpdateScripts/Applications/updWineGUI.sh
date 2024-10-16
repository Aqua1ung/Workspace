#!/bin/bash

# Do not run as root/sudo.

if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

iV=$(winegui --version | sed -n 's/^.\+ //p') # Check installed version.
tag=$(curl -s -L -D - https://gitlab.melroy.org/melroy/winegui/-/tags?format=atom | grep -n -m 1 tags/v | sed -n 's/^.*tags\/v//p' | sed -n 's/<.*$//p')
if [[ "$iV" != "$tag" ]]
then
  wget -q -O /home/dad/Downloads/WineGUI.rpm https://winegui.melroy.org/downloads/WineGUI-v$tag.rpm
  sudo rpm -Uvh --nodeps /home/dad/Downloads/WineGUI.rpm
else
  echo "No WineGUI update required."
fi