#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root (sudo -E)! Exiting ..."
  exit
fi

cd /home/dad/Git/Workspace
sudo -u dad git pull
# sudo -u dad /home/dad/Git/Workspace/Code/Linux/mountUSB.sh

swupd update
sudo -u dad flatpak update
flatpak repair

printf '\n' # Skip to new line.

cd /home/dad/Downloads

# Download and install/update PowerShell.
read -p "Do you want to install/update PowerShell? (Y/N) " -n 1 psh
printf '\n' # Skip to new line.
if [ $psh == y ] || [ $psh == Y ]
then
  echo "Installing or updating PowerShell ..."
  /home/dad/Git/Workspace/Code/Linux/installPowerShell.sh
else
  echo "Skipping PowerShell install/update."
fi
printf '\n' # Skip to new line.

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
    cp -u /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/RustDesk/rustdesk.desktop /home/dad/.config/autostart
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
  sudo -u dad /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/chrome.sh
else
  echo "Skipping Chrome install/update."
fi
printf '\n' # Insert blank line.

# Update NetBird.
read -p "Do you want to install/update Netbird? (Y/N) " -n 1 nbd
printf '\n' # Skip to new line.
if [ $nbd == y ] || [ $nbd == Y ]
then
  sudo -u dad /home/dad/Git/Workspace/Code/Linux/BuildScripts/netbird_dad.sh
else
  echo "Skipping NetBird installation/update."
fi
printf '\n' # Skip to new line.

echo "Clearing GPUCache ..."
printf '\n' # Insert blank line.
find /home/dad/.config -type d -name GPUCache | while read path
do
rm "$path"/*
done
printf '\n' # Insert blank line.
echo "Done. In case you notice 'cannot remove' error messages, that means that the cache was already empty."
printf '\n' # Insert blank line.

# Fix PWA fonts.
sudo -u dad /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/fixFontsPWA.sh

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean. Run netbird_dad.sh to update NetBird."
printf '\n' # Skip to new line.