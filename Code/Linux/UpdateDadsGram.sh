#!/bin/bash

# Do not run as root/sudo.
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root (sudo -E)! Exiting ..."
  exit 1
fi

cd ~/Git/Workspace
noUDG=$(git pull | grep -c UpdateDadsGram.sh)
if [[ ! $noUDG -eq 0 ]]
then
  echo "Please re-run the UpdateDadsGram script, as it has changed on the disk."
  exit 1
fi

if [ -f /etc/kernel/cmdline.d/params.conf ]
then
  sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/ucsiAcpi.sh
  sudo /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/ucsiAcpi.sh
fi

sudo swupd update
sudo flatpak update
sudo flatpak repair
npm update excalidraw # Update excalidraw.
echo "Currently installed npm version is $(npm --version)"
echo "Latest npm version on server is $(curl -s -L -D - https://github.com/npm/cli/releases/latest | grep -n -m 1 "<title>" | sed -n 's/^.*e v//p' | sed -n 's/ ·.*$//p')"

printf '\n' # Skip to new line.

cd ~/Downloads

# Download and install/update Rustdesk.
read -p "Do you want to install/update Rustdesk? (Y/N) " -n 1 rdsk
printf '\n' # Skip to new line.
if [ $rdsk == y ] || [ $rdsk == Y ]
then
  echo "Installing/updating Rustdesk ..."
  version=$(curl -s -L -D - https://github.com/rustdesk/rustdesk/releases/expanded_assets/nightly | grep -n -m 1 x86_64.flatpak | sed -n 's/^.*desk-//p' | sed -n 's/-x86.*$//p') # Grab the nightly version number.
  wget -N -q https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-$version-x86_64.flatpak # Download Rustdesk nightly.
  sudo flatpak install --or-update --bundle rustdesk-$version-x86_64.flatpak
  # cp -u ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/RustDesk/com.rustdesk.RustDesk.desktop ~/.config/autostart
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
      sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/chrome.sh
      ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/chrome.sh
    else # Install the Flatpak flavor.
      sudo flatpak install --or-update --noninteractive -y com.google.Chrome
      sudo chmod +x /home/dad/Git/Workspace/Code/Linux/patchFlatseal.sh
      ~/Git/Workspace/Code/Linux/patchFlatseal.sh
      echo "You will need to log out and log back in to enable PWA shortcuts."
      if [ ! -f ~/.local/share/flatpak/overrides/com.google.Chrome ]
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
  sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCodium.sh
  ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCodium.sh
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
  sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updPDF4QT.sh
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
  sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updWineGUI.sh
  ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/updWineGUI.sh
else
  echo "Skipping WineGUI install/update."
fi
printf '\n' # Skip to new line.

# Restore Remmina connections.
read -p "Do you want to update Reminna connections? (Y/N) " -n 1 rmn
printf '\n' # Skip to new line.
if [ $rmn == y ] || [ $rmn == Y ]
then
  rm -f ~/.local/share/remmina/*
  mkdir -p ~/.local/share/remmina/
  tar -xf ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina.tar.xz -C ~/.local/share/remmina/
else
  echo "Skipping Remmina connections restore."
fi
printf '\n' # Skip to new line.

# Install Remmina Rustdesk plugin.
if [ -d /var/lib/flatpak/app/com.rustdesk.RustDesk ] && [ -a /usr/bin/remmina ]
then
  sudo mkdir -p /usr/lib64/remmina/plugins
  sudo cp -n /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina-plugin-rustdesk.so /usr/lib64/remmina/plugins
  sudo mkdir -p /usr/share/icons/hicolor/16x16/emblems
  sudo mkdir -p /usr/share/icons/hicolor/22x22/emblems
  sudo cp -n /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/16x16/emblems/remmina-rustdesk.png /usr/share/icons/hicolor/16x16/emblems
  sudo cp -n /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/22x22/emblems/remmina-rustdesk.png /usr/share/icons/hicolor/22x22/emblems
fi
printf '\n' # Skip to new line.

# Update NetBird.
read -p "Do you want to install/update Netbird? (Y/N) " -n 1 nbd
printf '\n' # Skip to new line.
if [ $nbd == y ] || [ $nbd == Y ]
then
  sudo chmod +x /home/dad/Git/Workspace/Code/Linux/BuildScripts/netbird_dad.sh
  ~/Git/Workspace/Code/Linux/BuildScripts/netbird_dad.sh
  cp -u ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/netbird-ui.desktop ~/.config/autostart
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
  tag=$(curl -s -L -D - https://github.com/aurgatech/apps/releases/latest/ | grep -n -m 1 'href="/aurgatech/apps/releases/tag/' | sed -n 's/^.*tag\///p' | sed -n 's/" data-v.*$//p')
  aurgaV=$(curl -s -L -D - https://aurga.com/pages/download | grep -n -m 1 "Installer (64bit)" | sed -n 's/^.*_x64_v//p' | sed -n 's/\.exe.*$//p')
  if [ -f ~/.local/share/winegui/prefixes/Win11NoDirectX/drive_c/"Program Files"/"AURGA Viewer"/version ] && [ "$aurgaV" == "$(cat ~/.local/share/winegui/prefixes/Win11NoDirectX/drive_c/"Program Files"/"AURGA Viewer"/version)" ]
  then
    echo "No AURGA update available."
  else
    echo "Updating/installing AURGA ..."
    wget -P ~/Downloads/ https://github.com/aurgatech/apps/releases/download/$tag/AURGAViewer_Win_x64_v$aurgaV.exe
    wine64 ~/Downloads/AURGAViewer_Win_x64_v$aurgaV.exe
    echo "Done."
    echo "$aurgaV" > ~/.local/share/winegui/prefixes/Win11NoDirectX/drive_c/"Program Files"/"AURGA Viewer"/version
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
  sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCdrdao.sh
  ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/updCdrdao.sh
else
  echo "Skipping cdrdao install/update."
fi
printf '\n' # Skip to new line.

echo "Clearing GPUCache ..."
for i in $(find ~/.config ~/.var -type d -name "GPUCache" 2>/dev/null); do rm -rf ${i}; done
printf '\n' # Insert blank line.

# Fix PWA fonts.
chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/fixFontsPWA.sh
~/Git/Workspace/Code/Linux/UpdateScripts/Applications/fixFontsPWA.sh

echo "You may need to do a reboot, followed by swupd clean, swupd repair, another reboot, and swupd clean. Run netbird_dad.sh to update NetBird."
printf '\n' # Skip to new line.