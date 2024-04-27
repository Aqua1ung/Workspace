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

# read -p "This script requires that the Applications folder be up to date. Press Y if you are sure it is, N otherwise. " -n 1 apps
# if [ ! $apps == y ] && [ ! $apps == Y ]
# then
#   echo "Make sure to update the Applications folder first. Exiting."
#   exit 1
# fi

# Install update scripts.
cd /home/$user/Downloads
sudo -u $user wget https://github.com/Aqua1ung/Workspace/archive/refs/heads/master.zip
sudo -u $user unzip master.zip
sudo -u $user cp -r Workspace-master/Code/Linux/UpdateScripts/Applications /home/$user/
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
  cp /home/$user/Applications/rmmod.service /etc/systemd/system
fi

swupd update
sudo -u $user flatpak update
flatpak repair

printf '\n' # Skip to new line.

cd /home/$user/Applications

# Download and install/update Rustdesk.
read -p "Do you want to install/update Rustdesk? (Y/N) " -n 1 rdsk
printf '\n' # Skip to new line.
if [ $rdsk == y ] || [ $rdsk == Y ]
then
  echo "Installing/updating Rustdesk ..."
  version=$(curl -s -L -D - https://github.com/rustdesk/rustdesk/releases/expanded_assets/nightly | grep -n -m 1 x86_64.rpm | sed -n 's/^.*desk-//p' | sed -n 's/\.x86.*$//p') # Grab the nightly version number.
  rdOld=$(wget -N https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-$version.x86_64.rpm 2>&1 | grep -c "Omitting download") # Download Rustdesk nightly.
  if [[ $rdOld -eq 0 ]]
  then
    rpm -Uvh --force --nodeps rustdesk-*.rpm # Update Rustdesk.
    cp -u /home/$user/Applications/RustDesk/rustdesk.desktop /home/$user/.config/autostart # Should this be sudo -u $user?
  else
    echo "No update required."
  fi
else
  echo "Skipping Rustdesk install/update."
fi
printf '\n' # Insert blank line.

# Download and install/update Chrome.
read -p "Do you want to install/update Chrome? (Y/N) " -n 1 chr
printf '\n' # Skip to new line.
if [ $chr == y ] || [ $chr == Y ]
then
  sudo -u $user /home/$user/Applications/chrome.sh
else
  echo "Skipping Chrome install/update."
fi
printf '\n' # Insert blank line.
cd /home/$user/Applications

# Download and install VSCodium.
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
  iV=$(winegui --version | sed -n 's/^.\+ //p') # Check installed version.
  tag=$(curl -s -L -D - https://gitlab.melroy.org/melroy/winegui/-/tags?format=atom | grep -n -m 1 tags/v | sed -n 's/^.*tags\/v//p' | sed -n 's/<.*$//p')
  if [[ "$iV" != "$tag" ]]
  then
    sudo -u $user wget -O /home/$user/Downloads/WineGUI.rpm https://winegui.melroy.org/downloads/WineGUI-v$tag.rpm
    rpm -Uvh --nodeps /home/$user/Downloads/WineGUI.rpm
  else
    echo "No WineGUI update required."
  fi
else
  echo "Skipping WineGUI install/update."
fi
printf '\n' # Skip to new line.

# Download and install/update Ugee drivers.
# read -p "Do you want to install/update Ugee drivers? (Y/N) " -n 1 ug
# printf '\n' # Skip to new line.
# if [ $ug == y ] || [ $ug == Y ]
# then
#   outUg=$(wget -N https://www.ugee.com/download/file/id/713/pid/452/ext/rpm/ugee-pentablet.x86_64.rpm 2>&1 | grep -c "304 Not Modified")
#   nOfUg=$(rpm -qa | grep -ic ugee)
#   if [[ $outUg -eq 0 ]] # Update if newer on server.
#   then
#     # printf '\n' # Insert blank line.
#     echo "Updating Ugee drivers ..."
#     rpm -Uvh --nodeps ugee-pentablet.x86_64.rpm
#   else
#     if [[ $nOfUg -eq 0 ]] # Install if unchanged on server and not already installed.
#     then
#       # printf '\n' # Insert blank line.
#       echo "Installing Ugee drivers ..."
#       rpm -Uvh --nodeps ugee-pentablet.x86_64.rpm
#     else
#       # printf '\n' # Insert blank line.
#       echo "No Ugee driver update required."
#     fi
#   fi
# else
#   echo "Skipping Ugee driver installation."
# fi
# printf '\n' # Insert blank line.

# Update NetBird.
read -p "Do you want to install/update Netbird? (Y/N) " -n 1 nbd
printf '\n' # Skip to new line.
if [ $nbd == y ] || [ $nbd == Y ]
then
  sudo -u $user /home/$user/Applications/netbird.sh
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
  tar -xf /home/$user/Applications/remmina.tar.xz -C /home/$user/.var/app/org.remmina.Remmina/data/remmina
else
  echo "Skipping Remmina connections restore."
fi
printf '\n' # Skip to new line.

# Install Remmina Rustdesk plugin.
if [ -a /usr/bin/rustdesk ] && [ -a /usr/bin/remmina ]
then
  mkdir -p /usr/lib64/remmina/plugins
  cp -n /home/$user/Applications/remmina-plugin-rustdesk.so /usr/lib64/remmina/plugins
  mkdir -p /usr/share/icons/hicolor/16x16/emblems
  mkdir -p /usr/share/icons/hicolor/22x22/emblems
  cp -n /home/$user/Applications/16x16/emblems/remmina-rustdesk.png /usr/share/icons/hicolor/16x16/emblems
  cp -n /home/$user/Applications/22x22/emblems/remmina-rustdesk.png /usr/share/icons/hicolor/22x22/emblems
fi

# Clear GPUCache.
chmod +x /home/$user/Applications/clearGPUCacheChrome.sh
sudo -u $user /home/$user/Applications/clearGPUCacheChrome.sh
printf '\n' # Insert blank line.

# Fix PWA fonts.
sudo -u $user /home/$user/Applications/fixFontsPWA.sh

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean. Run netbird.sh to update NetBird."
printf '\n' # Skip to new line.
