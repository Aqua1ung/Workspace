#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

read -p "Type in your Linux username, followed by Enter: " user
printf '\n' # Skip to new line.
if [ $user != mom ] && [ $user != gabe ] && [ $user != paul ]
then
  echo "You have mistyped the user name. Exiting ..."
  exit 1
fi

# Install update scripts.
cd /home/$user/Downloads
sudo -u $user wget https://github.com/Aqua1ung/Workspace/archive/refs/heads/master.zip
sudo -u $user unzip master.zip
sudo -u $user yes | cp -rf Workspace-master/Code /home/$user/Git/Workspace/
rm -rf Workspace-master/
rm master.zip

# Check to see if VLC.Plugin.makemkv is installed.
vlcP=$(flatpak list | grep -c VLC.Plugin.makemkv)
if [[ $vlcP -eq 0 ]]
then
  flatpak install org.videolan.VLC.Plugin.makemkv
else
  echo "No need to install the MakeMKV plugin for VLC."
fi
printf '\n' # Skip to new line.

if [ -f /etc/kernel/cmdline.d/params.conf ]
then
  rm /etc/kernel/cmdline.d/params.conf
  clr-boot-manager update
  cp /home/$user/Git/Workspace/Code/Linux/UpdateScripts/Applications/rmmod.service /etc/systemd/system
fi

swupd update
sudo -u $user flatpak update
flatpak repair
sudo -u $user npm update excalidraw # Update excalidraw.
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
  iV=$(sudo -u $user codium -v | sed -n 1p)
  iV+=.$instRel # Concatenate iV + instRel.
  if [[ "$iV" != "$tag" ]]
  then
    sudo -u $user wget -O /home/$user/Downloads/codium.rpm https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
    rpm -Uvh --nodeps /home/$user/Downloads/codium.rpm
  else
    echo "No VSCodium update required."
  fi
else
  echo "Skipping VSCodium install/update."
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
    sudo -u $user wget -O /home/$user/Downloads/WineGUI.rpm https://winegui.melroy.org/downloads/WineGUI-v$tagWg.rpm
    rpm -Uvh --nodeps /home/$user/Downloads/WineGUI.rpm
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
  sudo -u $user /home/$user/Git/Workspace/Code/Linux/UpdateScripts/Applications/netbird.sh
else
  echo "Skipping NetBird installation/update."
fi
printf '\n' # Insert blank line.

# Restore Remmina connections.
read -p "Do you want to update Reminna connections? (Y/N) " -n 1 rmn
printf '\n' # Skip to new line.
if [ $rmn == y ] || [ $rmn == Y ]
then
  rm -f /home/$user/.local/share/remmina/*
  sudo -u $user mkdir -p /home/$user/.var/app/org.remmina.Remmina/data/remmina
  tar -xf /home/$user/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina.tar.xz -C /home/$user/.var/app/org.remmina.Remmina/data/remmina
else
  echo "Skipping Remmina connections restore."
fi
printf '\n' # Skip to new line.

# Clear GPUCache.
chmod +x /home/$user/Git/Workspace/Code/Linux/UpdateScripts/Applications/clearGPUCacheChrome.sh
sudo -u $user /home/$user/Git/Workspace/Code/Linux/UpdateScripts/Applications/clearGPUCacheChrome.sh
printf '\n' # Insert blank line.

# Fix PWA fonts.
# sudo -u $user /home/$user/Git/Workspace/Code/Linux/UpdateScripts/Applications/fixFontsPWA.sh

# Patch Chrome permissions in FlatSeal for the installation of PWAs.
flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome
if [ ! -f /home/$user/.local/share/flatpak/overrides/com.google.Chrome ]
then
  echo "WARNING! Flatseal override did not go through! Check Flatseal Chrome permission settings. Exiting script."
  exit 1
fi

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean."
printf '\n' # Skip to new line.