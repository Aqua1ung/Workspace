#!/bin/bash

# Do NOT run as root!
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit
fi

pkill netbird-ui

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
    echo "No update required. Restarting netbird-ui ..."
    setsid /usr/bin/netbird-ui >/dev/null 2>&1 < /dev/null &
    # nohup /usr/bin/netbird-ui >>/dev/null 2>>/dev/null &
    # nohup /usr/bin/netbird-ui 2>&1 &
    sleep 2
    echo "Done."
  else
    echo "Netbird has been updated. Restarting netbird-ui ..."
    setsid /usr/bin/netbird-ui >/dev/null 2>&1 < /dev/null &
    sleep 2
    echo "Done."
  fi
fi