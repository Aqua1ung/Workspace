#!/bin/bash

# Run as root!
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi
printf '\n' # Skip to new line.

read -p "Type in your Linux username, followed by Enter: " user
printf '\n' # Skip to new line.
if [ $user != mom ] && [ $user != gabe ] && [ $user != paul ] && [ $user != dad ]
then
  echo "You have mistyped the user name. Exiting ..."
  exit 1
fi

# Purge NetBird.
read -p "Are you sure you want to uninstall NetBird? (y/n) " -n 1 nb
printf '\n' # Skip to new line.
if [ $nb == y ] || [ $nb == Y ]
then
  echo "Purging Netbird ..."
  netbird service stop
  netbird service uninstall
  rm /usr/bin/netbird*
  rm /home/$user/.config/autostart/netbird*.desktop
  echo "... done!"
else
  echo "Exiting w/o uninstalling NetBird ..."
fi