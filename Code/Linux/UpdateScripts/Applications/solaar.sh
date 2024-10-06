#!/bin/bash

# Do NOT run as root/sudo.
if [ "$(id -u)" == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

# Add Solaar rules and other stuff.
mkdir -p ~/.config/solaar
cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/*.yaml ~/.config/solaar

# Autostart Solaar; this can also be done from Tweaks.
cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/solaar.desktop ~/.config/autostart