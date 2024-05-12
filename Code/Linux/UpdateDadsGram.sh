#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root (sudo -E)! Exiting ..."
  exit 1
fi

cd /home/dad/Git/Workspace
noUDG=$(sudo -u dad git pull | grep -c UpdateDadsGram.sh)
if [[ ! $noUDG -eq 0 ]]
then
  echo "Please re-run the UpdateDadsGram script, as it has changed on the disk."
  exit 1
fi

if [ -f /etc/kernel/cmdline.d/params.conf ]
then
  chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/ucsiAcpi.sh
  /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/ucsiAcpi.sh
fi

# Check to see if VLC.Plugin.makemkv is installed.
vlcP=$(flatpak list | grep -c VLC.Plugin.makemkv)
if [[ $vlcP -eq 0 ]]
then
  sudo -u dad flatpak install org.videolan.VLC.Plugin.makemkv
else
  echo "No need to install the MakeMKV plugin for VLC."
fi
printf '\n' # Skip to new line.

swupd update
sudo -u dad flatpak update
flatpak repair
sudo -u dad npm update excalidraw # Update excalidraw.
echo "Currently installed npm version is $(npm --version)"
echo "Latest npm version on server is $(curl -s -L -D - https://github.com/npm/cli/releases/latest | grep -n -m 1 "<title>" | sed -n 's/^.*e v//p' | sed -n 's/ ·.*$//p')"

printf '\n' # Skip to new line.

cd /home/dad/Downloads

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
if [ ! -d /var/lib/flatpak/app/com.google.Chrome ]
then
  read -p "Do you want to install or update Chrome? (Y/N) " -n 1 chr
  printf '\n' # Skip to new line.
  if [ $chr == y ] || [ $chr == Y ]
  then
    read -p "What flavor? (Type 1 for native, anything else for Flatpak.) " -n 1 fon
    printf '\n' # Insert blank line.
    if [[ $fon -eq 1 ]]
    then # Install or update the native flavor.
      chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/chrome.sh
      sudo -u dad /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/chrome.sh
    else # Install the Flatpak flavor.
      sudo -u dad flatpak install --or-update --noninteractive -y --system com.google.Chrome
      sudo -u dad flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome
      echo "You will need to log out and log back in to enable PWA shortcuts."
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

# Download and install/update VSCodium.
read -p "Do you want to install/update VSCodium? (Y/N) " -n 1 vsc
printf '\n' # Skip to new line.
if [ $vsc == y ] || [ $vsc == Y ]
then
  echo "Installing or updating VSCodium ..."
  chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCodium.sh
  /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCodium.sh
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
  chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updWineGUI.sh
  /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updWineGUI.sh
else
  echo "Skipping WineGUI install/update."
fi
printf '\n' # Skip to new line.

# Restore Remmina connections.
read -p "Do you want to update Reminna connections? (Y/N) " -n 1 rmn
printf '\n' # Skip to new line.
if [ $rmn == y ] || [ $rmn == Y ]
then
  rm -f /home/dad/.local/share/remmina/*
  sudo -u dad mkdir -p /home/dad/.local/share/remmina/
  tar -xf /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina.tar.xz -C /home/dad/.local/share/remmina/
else
  echo "Skipping Remmina connections restore."
fi
printf '\n' # Skip to new line.

# Install Remmina Rustdesk plugin.
if [ -a /usr/bin/rustdesk ] && [ -a /usr/bin/remmina ]
then
  mkdir -p /usr/lib64/remmina/plugins
  cp -n /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina-plugin-rustdesk.so /usr/lib64/remmina/plugins
  mkdir -p /usr/share/icons/hicolor/16x16/emblems
  mkdir -p /usr/share/icons/hicolor/22x22/emblems
  cp -n /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/16x16/emblems/remmina-rustdesk.png /usr/share/icons/hicolor/16x16/emblems
  cp -n /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/22x22/emblems/remmina-rustdesk.png /usr/share/icons/hicolor/22x22/emblems
fi
printf '\n' # Skip to new line.

# Update NetBird.
read -p "Do you want to install/update Netbird? (Y/N) " -n 1 nbd
printf '\n' # Skip to new line.
if [ $nbd == y ] || [ $nbd == Y ]
then
  chmod +x /home/dad/Git/Workspace/Code/Linux/BuildScripts/netbird_dad.sh
  sudo -u dad /home/dad/Git/Workspace/Code/Linux/BuildScripts/netbird_dad.sh
else
  echo "Skipping NetBird installation/update."
fi
printf '\n' # Skip to new line.

# Update AURGA.
read -p "Do you want to install/update AURGA? (Y/N) " -n 1 aurga
printf '\n' # Skip to new line.
if [ $aurga == y ] || [ $aurga == Y ]
then
  # echo "Installing or updating AURGA ..."
  aurgaV=$(curl -s -L -D - https://www.aurga.com/pages/download | grep -n -m 1 "Windows 8+" | sed -n 's/^.*x64_v//p' | sed -n 's/\.exe.*$//p')
  if [ -f /home/dad/.wine/drive_c/"Program Files"/"AURGA Viewer"/version ] && [ "$aurgaV" == "$(cat /home/dad/.wine/drive_c/"Program Files"/"AURGA Viewer"/version)" ]
  then
    echo "No AURGA update available."
  else
    echo "Updating/installing AURGA ..."
    sudo -u dad wget -P /home/dad/Downloads/ https://cdn.shopify.com/s/files/1/0627/4659/1401/files/AURGAViewer_Installer_x64_v$aurgaV.exe
    sudo -u dad wine64 /home/dad/Downloads/AURGAViewer_Installer_x64_v$aurgaV.exe
    echo "Done."
    sudo -u dad echo "$aurgaV" > /home/dad/.wine/drive_c/"Program Files"/"AURGA Viewer"/version
  fi
else
    echo "Skipping AURGA installation/update."
fi
printf '\n' # Skip to new line.

# Download and install/update cdrdao.
read -p "Do you want to install/update cdrdao? (Y/N) " -n 1 cdrd
printf '\n' # Skip to new line.
if [ $cdrd == y ] || [ $cdrd == Y ]
then
  echo "Installing or updating cdrdao ..."
  chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCdrdao.sh
  /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCdrdao.sh
else
  echo "Skipping cdrdao install/update."
fi
printf '\n' # Skip to new line.

echo "Clearing GPUCache ..."
for i in $(find ~/.config ~/.var -type d -name "GPUCache" 2>/dev/null); do rm -rf ${i}; done
printf '\n' # Insert blank line.

# Fix PWA fonts.
chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/fixFontsPWA.sh
sudo -u dad /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/fixFontsPWA.sh

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean. Run netbird_dad.sh to update NetBird."
printf '\n' # Skip to new line.
