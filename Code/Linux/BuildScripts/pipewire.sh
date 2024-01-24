#!/bin/bash

# Do NOT run as root! 
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi
printf '\n' # Insert blank line.

echo "Installing Pipewire ..."
systemctl --user disable pulseaudio
systemctl --user enable pipewire{-pulse,}
systemctl --user enable wireplumber
