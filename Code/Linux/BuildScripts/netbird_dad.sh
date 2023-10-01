#!/bin/bash

# Do NOT run as root!
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit
fi

pkill netbird-ui

# read -p "Type your Linux username followed by Enter: " user
# printf '\n' # Insert blank line.
export USE_BIN_INSTALL=true

# Download and install/update NetBird.
nb="/usr/bin/netbird"
if [[ ! -a "$nb" ]]
then
  echo "Installing NetBird ..."
  printf '\n' # Insert blank line.
  curl -fsSL https://pkgs.netbird.io/install.sh | sh
  netbird up
  cp /run/media/dad/InstallationKits/netbird-ui.desktop /home/dad/.config/autostart
  echo "Logout or reboot needed."
else
  echo "Updating NetBird ..."
  printf '\n' # Insert blank line.
  noupd=$(curl -fsSL https://pkgs.netbird.io/install.sh | sh -s -- --update | grep -c "is up-to-date")
  if [[ ! $noupd -eq 0 ]]
  then
    netbird-ui
  fi
fi
