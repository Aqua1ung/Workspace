#!/bin/bash

# Do not run as root/sudo.
if [ $(id -u) == 0 ]
then
  echo "This script should not be run as root! Exiting ..."
  exit 1
fi

# Install update scripts.
cd ~/Git/Workspace
git pull
sudo chmod +x ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/Update.sh
~/Git/Workspace/Code/Linux/UpdateScripts/Applications/Update.sh