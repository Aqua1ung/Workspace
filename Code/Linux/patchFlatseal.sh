#!/bin/bash

# Do NOT run as root!
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

# Patch Chrome permissions in FlatSeal for the installation of PWAs.
flatpak override --user --filesystem=~/.local/share/applications:create --filesystem=~/.local/share/icons:create com.google.Chrome
echo "You will need to log out and log back in to enable PWA shortcuts."