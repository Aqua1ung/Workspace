#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

# force=$(swupd check-update | grep -c "There are no updates available")
force=6 # Apparently forcing Chrome re-install doesn't fix hardware acceleration.
swupd update
flatpak update

printf '\n' # Skip to new line.

# Install dependencies.
# swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils # containers-basic

cd /run/media/dad/InstallationKits

# Required by AURGA viewer.
read -p "Do you use AURGA? (Y/N) " -n 1 aurga
printf '\n' # Skip to new line.
if [ $aurga == y ] || [ $aurga == Y ]
then
  av="/etc/udev/rules.d/99-input-permissions.rules"
  if [[ ! -a "$av" ]]
  then
    cp /run/media/dad/InstallationKits/AURGA/LinuxBinaries/99-input-permissions.rules /etc/udev/rules.d/
    udevadm control --reload-rules && udevadm trigger
  fi
else
  echo "Skipping AURGA tweak install."
fi
printf '\n'

# Download and install/update Rustdesk.
read -p "Do you want to install/update Rustdesk? (Y/N) " -n 1 rdsk
printf '\n' # Skip to new line.
if [ $rdsk == y ] || [ $rdsk == Y ]
then
  outRD=$(wget -N https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-1.2.2-0-x86_64.pkg.tar.zst 2>&1 | grep -c "304 Not Modified")
  rd="/usr/lib/rustdesk"
  if [[ $outRD -eq 0 ]] # Update if newer on server.
  then
    echo "Updating Rustdesk ..."
    tar -xf /run/media/dad/InstallationKits/rustdesk-1.2.2-0-x86_64.pkg.tar.zst -C /
    cp /usr/share/rustdesk/files/rustdesk.service /etc/systemd/system
    cp /usr/share/rustdesk/files/rustdesk.desktop /usr/share/applications
    cp /run/media/dad/InstallationKits/RustDesk/rustdesk.desktop /home/dad/.config/autostart/
    cp /usr/share/rustdesk/files/rustdesk-link.desktop /usr/share/applications
    systemctl daemon-reload
    systemctl enable rustdesk
    systemctl start rustdesk
    update-desktop-database
  else
    if [[ ! -a "$rd" ]] # Install if unchanged on server and not already installed.
    then
      # printf '\n' # Insert blank line.
      echo "Installing Rustdesk ..."
      tar -xf /run/media/dad/InstallationKits/rustdesk-1.2.2-0-x86_64.pkg.tar.zst -C /
      cp /usr/share/rustdesk/files/rustdesk.service /etc/systemd/system
      cp /usr/share/rustdesk/files/rustdesk.desktop /usr/share/applications
      cp /run/media/dad/InstallationKits/RustDesk/rustdesk.desktop /home/dad/.config/autostart/
      cp /usr/share/rustdesk/files/rustdesk-link.desktop /usr/share/applications
      systemctl daemon-reload
      systemctl enable rustdesk
      systemctl start rustdesk
      update-desktop-database
    else
      # printf '\n' # Insert blank line.
      echo "No Rustdesk update required."
    fi
  fi
else
  echo "Skipping Rustdesk install/update."
fi
printf '\n' # Insert blank line.

# Download and install/update Chrome.
read -p "Do you want to install/update Chrome? (Y/N) " -n 1 chr
printf '\n' # Skip to new line.
if [ $chr == y ] || [ $chr == Y ] || [ $force -eq 0 ]
then
  wget -N https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm # Download Chrome.
  if [ $force -eq 0 ] # Force Chrome re-install.
  then
    printf '\n' # Insert blank line.
    echo "Forcing Chrome (re)install ..."
    rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub
    rpm -ivh --force --nodeps google-chrome*.rpm
    sed -i 's\/usr/bin/google-chrome-stable\env FONTCONFIG_PATH=/usr/share/defaults/fonts /usr/bin/google-chrome-stable\g' /usr/share/applications/google-chrome.desktop
  else
    # printf '\n' # Insert blank line.
    echo "Update Chrome ..."
    rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub
    rpm -Uvh --nodeps google-chrome*.rpm
    sed -i 's\/usr/bin/google-chrome-stable\env FONTCONFIG_PATH=/usr/share/defaults/fonts /usr/bin/google-chrome-stable\g' /usr/share/applications/google-chrome.desktop
  fi
else
  echo "Skipping Chrome install/update."
fi
printf '\n' # Insert blank line.

# Download and install VSCodium.
echo "Installing or updating VSCodium ..."
location=$(curl -s -L -D - https://github.com/VSCodium/vscodium/releases/latest/ -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
# echo $location
tag=$(echo "$location" | sed 's/location: https.\+tag\///')
wget -N https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
rpm -Uvh --nodeps codium*.rpm
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

# Restore Remmina connections.
read -p "Do you want to update Reminna connections? (Y/N) " -n 1 rmn
printf '\n' # Skip to new line.
if [ $rmn == y ] || [ $rmn == Y ]
then
  rm -f /home/dad/.local/share/remmina/*
  sudo -u dad mkdir -p /home/dad/.local/share/remmina/
  tar -xf /run/media/dad/InstallationKits/remmina.tar.xz -C /home/dad/.local/share/remmina/
else
  echo "Skipping Remmina connections restore."
fi
printf '\n' # Skip to new line.

echo "Clearing GPUCache ..."
printf '\n' # Insert blank line.
find /home/"$user"/.config -type d -name GPUCache | while read path
do
rm "$path"/*
done
printf '\n' # Insert blank line.
echo "Done. In case you notice 'cannot remove' error messages, that means that the cache was already empty."

printf '\n' # Insert blank line.

# Install/update NetBird.

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean."
printf '\n' # Skip to new line.