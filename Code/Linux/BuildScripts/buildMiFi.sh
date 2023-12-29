#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

# Install swupd bundles.
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils nfs-utils waypipe devpkg-nfs-utils storage-utils nmap nodejs-basic dev-utils-gui audio-pipewire # containers-basic

cd /home/dad/Downloads
sudo -u dad mkdir /home/dad/Git

# Install remote flatpak bundles.
sudo -u dad flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo -u dad flatpak install --or-update --noninteractive -y org.gnome.Firmware com.mattjakeman.ExtensionManager # fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Check out the Git folder.
# Install and configure Git and VSCodium
git config --global user.name "Cristian Cocos"
git config --global user.email "cristi@ieee.org"

# Add update (and other) script desktop links.
cp -n /run/media/dad/InstallationKits/DesktopFiles/Update*.desktop /home/dad/.local/share/applications
cp -n /run/media/dad/InstallationKits/DesktopFiles/Flatpak/*.desktop /usr/share/applications # Broken Flatpak install (or to /usr/share/applications?).
cp -n /run/media/dad/InstallationKits/DesktopFiles/mountUSB.desktop /home/dad/.local/share/applications

# # Turn on Gnome animations.
# gsettings set org.gnome.desktop.interface enable-animations true

# # Disable automount.
# gsettings set org.gnome.desktop.media-handling automount false
# gsettings set org.gnome.desktop.media-handling automount-open false
# systemctl restart gdm.service

# # Install Excalidraw.
# npm install react react-dom @excalidraw/excalidraw

# # Install hid-tools
# pip3 install hid-tools

# # Add RemoteGo tablet.
# mkdir -p /usr/lib/udev/hwdb.d
# cp /run/media/dad/InstallationKits/RemoteGo/61-evdev-local.hwdb /usr/lib/udev/hwdb.d
# systemd-hwdb update
# udevadm trigger /dev/input/event*

# echo "Please power off, and make sure you run UpdateDadsGram.sh!"