#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

if [ ! -d /var/lib/flatpak/app/com.google.Chrome ]
then
  read -p "Do you want to install or update Chrome? (Y/N) " -n 1 chr
  printf '\n' # Skip to new line.
  if [ $chr == y ] || [ $chr == Y ]
  then
    read -p "What flavor? (Type 1 for native, anything else for Flatpak.) " -n 1 fon
    printf '\n' # Insert blank line.
    if [ $fon -eq 1 ]
    then # Install or update the native flavor.
      chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/chrome.sh
      sudo -u dad /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/chrome.sh
    else # Install the Flatpak flavor.
      sudo -u dad flatpak install --or-update --noninteractive -y --system com.google.Chrome
      chmod +x /home/dad/Git/Workspace/Code/Linux/patchFlatseal.sh
      sudo -u dad /home/dad/Git/Workspace/Code/Linux/patchFlatseal.sh
      if [ ! -f /home/dad/.local/share/flatpak/overrides/com.google.Chrome ]
      then
        echo "WARNING! Flatseal override did not go through! Check Flatseal Chrome permission settings. Exiting script."
        exit 1
      fi
    fi
  else
    echo "Skipping Chrome install/update."
  fi
else
  echo "Chrome Flatpak is already installed."
fi
printf '\n' # Insert blank line.