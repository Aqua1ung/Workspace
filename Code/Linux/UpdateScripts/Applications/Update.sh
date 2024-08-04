#!/bin/bash

cd ~/Downloads

if [ -f /etc/kernel/cmdline.d/params.conf ]
then
  sudo rm /etc/kernel/cmdline.d/params.conf
  sudo clr-boot-manager update
  sudo cp ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/rmmod.service /etc/systemd/system
fi

sudo swupd update
sudo flatpak update
sudo flatpak repair
npm update excalidraw # Update excalidraw.
echo "Currently installed npm version is $(npm --version)"
echo "Latest npm version on server is $(curl -s -L -D - https://github.com/npm/cli/releases/latest | grep -n -m 1 "<title>" | sed -n 's/^.*e v//p' | sed -n 's/ ·.*$//p')"

printf '\n' # Skip to new line.

# Download and install/update VSCodium.
read -p "Do you want to install/update VSCodium? (Y/N) " -n 1 vsc
printf '\n' # Skip to new line.
if [ $vsc == y ] || [ $vsc == Y ]
then
  echo "Installing or updating VSCodium ..."
  location=$(curl -s -L -D - https://github.com/VSCodium/vscodium/releases/latest/ -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
  tag=$(echo "$location" | sed 's/location: https.\+tag\///')
  instRel=$(cat /usr/share/codium/resources/app/package.json | grep release | sed -n 's/  "rel.* "//p' |sed -n 's/".*$//p')
  iV=$(codium -v | sed -n 1p)
  iV+=.$instRel # Concatenate iV + instRel.
  if [[ "$iV" != "$tag" ]]
  then
    wget -O ~/Downloads/codium.rpm https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
    sudo rpm -Uvh --nodeps ~/Downloads/codium.rpm
  else
    echo "No VSCodium update required."
  fi
else
  echo "Skipping VSCodium install/update."
fi
printf '\n' # Skip to new line.

# Download and install/update PDF4QT.
read -p "Do you want to install/update PDF4QT? (Y/N) " -n 1 pdf
printf '\n' # Skip to new line.
if [ $pdf == y ] || [ $pdf == Y ]
then
  echo "Installing or updating PDF4QT ..."
  sudo chmod +x ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/updPDF4QT.sh
  ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/updPDF4QT.sh
else
  echo "Skipping PDF4QT install/update."
fi
printf '\n' # Skip to new line.

# Download and install/update WineGUI.
read -p "Do you want to install/update WineGUI? (Y/N) " -n 1 wg
printf '\n' # Skip to new line.
if [ $wg == y ] || [ $wg == Y ]
then
  echo "Installing or updating WIneGUI ..."
  iVwg=$(winegui --version | sed -n 's/^.\+ //p') # Check installed version.
  tagWg=$(curl -s -L -D - https://gitlab.melroy.org/melroy/winegui/-/tags?format=atom | grep -n -m 1 tags/v | sed -n 's/^.*tags\/v//p' | sed -n 's/<.*$//p')
  if [[ "$iVwg" != "$tagWg" ]]
  then
    wget -O ~/Downloads/WineGUI.rpm https://winegui.melroy.org/downloads/WineGUI-v$tagWg.rpm
    sudo rpm -Uvh --nodeps ~/Downloads/WineGUI.rpm
  else
    echo "No WineGUI update required."
  fi
else
  echo "Skipping WineGUI install/update."
fi
printf '\n' # Skip to new line.

# Update NetBird.
read -p "Do you want to install/update Netbird? (Y/N) " -n 1 nbd
printf '\n' # Skip to new line.
if [ $nbd == y ] || [ $nbd == Y ]
then
  sudo chmod +x ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/netbird.sh
  ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/netbird.sh
  cp -u ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/netbird-ui.desktop ~/.config/autostart
else
  echo "Skipping NetBird installation/update."
fi
printf '\n' # Insert blank line.

# Restore Remmina connections.
read -p "Do you want to update Reminna connections? (Y/N) " -n 1 rmn
printf '\n' # Skip to new line.
if [ $rmn == y ] || [ $rmn == Y ]
then
  rm -f ~/.var/app/org.remmina.Remmina/data/remmina/*
  mkdir -p ~/.var/app/org.remmina.Remmina/data/remmina
  tar -xf ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina.tar.xz -C ~/.var/app/org.remmina.Remmina/data/remmina
else
  echo "Skipping Remmina connections restore."
fi
printf '\n' # Skip to new line.

# Clear GPUCache.
sudo chmod +x ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/clearGPUCacheChrome.sh
~/Git/Workspace/Code/Linux/UpdateScripts/Applications/clearGPUCacheChrome.sh
printf '\n' # Insert blank line.

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean."
printf '\n' # Skip to new line.