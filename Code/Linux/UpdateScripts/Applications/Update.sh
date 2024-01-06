#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

read -p "Type in your Linux username, followed by Enter: " user
printf '\n' # Skip to new line.
if [ $user != mom ] && [ $user != gabe ] && [ $user != paul ]
then
  echo "You have mistyped the user name. Exiting ..."
  exit
fi

# Check to see if VLC.Plugin.makemkv is installed.
vlcP=$(flatpak list | grep -c VLC.Plugin.makemkv)
if [[ $vlcP -eq 0 ]]
then
  flatpak install org.videolan.VLC.Plugin.makemkv
else
  echo "No need to install the MakeMKV plugin for VLC."
fi
printf '\n' # Skip to new line.

swupd update
sudo -u $user flatpak update
flatpak repair

printf '\n' # Skip to new line.

cd /home/$user/Applications

# Required by AURGA viewer.
# read -p "Do you use AURGA? (Y/N) " -n 1 aurga
# printf '\n' # Skip to new line.
# if [ $aurga == y ] || [ $aurga == Y ]
# then
#   av="/etc/udev/rules.d/99-input-permissions.rules"
#   if [[ ! -a "$av" ]]
#   then
#     cp AURGA/LinuxBinaries/99-input-permissions.rules /etc/udev/rules.d/
#     udevadm control --reload-rules && udevadm trigger
#   else
#     echo "No AURGA tweak needed."
#   fi
# else
#   echo "Skipping AURGA tweak install."
# fi
# printf '\n'

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
  # echo $location
  tag=$(echo "$location" | sed 's/location: https.\+tag\///')
  wget -N https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
  rpm -Uvh --nodeps codium*.rpm
else
  echo "Skipping VSCodium install/update."
fi
printf '\n' # Skip to new line.

# Download and install/update Ugee drivers.
read -p "Do you want to install/update Ugee drivers? (Y/N) " -n 1 ug
printf '\n' # Skip to new line.
if [ $ug == y ] || [ $ug == Y ]
then
  outUg=$(wget -N https://www.ugee.com/download/file/id/713/pid/452/ext/rpm/ugee-pentablet.x86_64.rpm 2>&1 | grep -c "304 Not Modified")
  nOfUg=$(rpm -qa | grep -ic ugee)
  if [[ $outUg -eq 0 ]] # Update if newer on server.
  then
    # printf '\n' # Insert blank line.
    echo "Updating Ugee drivers ..."
    rpm -Uvh --nodeps ugee-pentablet.x86_64.rpm
  else
    if [[ $nOfUg -eq 0 ]] # Install if unchanged on server and not already installed.
    then
      # printf '\n' # Insert blank line.
      echo "Installing Ugee drivers ..."
      rpm -Uvh --nodeps ugee-pentablet.x86_64.rpm
    else
      # printf '\n' # Insert blank line.
      echo "No Ugee driver update required."
    fi
  fi
else
  echo "Skipping Ugee driver installation."
fi
printf '\n' # Insert blank line.

# Update NetBird.
read -p "Do you want to install/update Netbird? (Y/N) " -n 1 nbd
printf '\n' # Skip to new line.
if [ $nbd == y ] || [ $nbd == Y ]
then
  sudo -u $user /home/$user/Applications/netbird.sh
else
  echo "Skipping NetBird installation/update."
fi

# Restore Remmina connections.
read -p "Do you want to update Reminna connections? (Y/N) " -n 1 rmn
printf '\n' # Skip to new line.
if [ $rmn == y ] || [ $rmn == Y ]
then
  rm -f /home/$user/.local/share/remmina/*
  sudo -u $user mkdir -p /home/$user/.local/share/remmina/
  tar -xf /home/$user/Applications/remmina.tar.xz -C /home/$user/.local/share/remmina/
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
echo "Clearing GPUCache ..."
printf '\n' # Insert blank line.
find /home/"$user"/.config -type d -name GPUCache | while read path
do
rm "$path"/*
done
printf '\n' # Insert blank line.
echo "Done. In case you notice 'cannot remove' error messages, that means that the cache was already empty."
printf '\n' # Insert blank line.

# Fix PWA fonts.
sudo -u $user /home/$user/Applications/fixFontsPWA.sh

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean. Run netbird.sh to update NetBird."
printf '\n' # Skip to new line.
