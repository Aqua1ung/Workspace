#!/bin/bash

# Do NOT run as root!
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit
fi

export USE_BIN_INSTALL=true

# Download and install/update NetBird.
nb="/usr/bin/netbird"
if [[ ! -a "$nb" ]]
then
  echo "Installing NetBird ..."
  printf '\n' # Insert blank line.
  curl -fsSL https://pkgs.netbird.io/install.sh | sh
  netbird up
  cp /home/$USER/Applications/netbird-ui.desktop /home/$USER/.config/autostart
  echo "Logout or reboot needed."
else
  echo "Updating NetBird ..."
  printf '\n' # Insert blank line.
  curl -fsSL https://pkgs.netbird.io/install.sh | sh -s -- --update
fi
