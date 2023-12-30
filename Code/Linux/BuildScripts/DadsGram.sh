#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

# Removes kernel module int3403_thermal, to stop the spamming of the log.
cp /run/media/dad/InstallationKits/rmmod.* /etc/systemd/system
systemctl enable rmmod.timer

mkdir /etc/kernel
mkdir /etc/kernel/cmdline.d
sudo -u dad mkdir /home/dad/.config/autostart/
sudo -u dad  mkdir /home/dad/.var
# mkdir /etc/udev/hwdb.d/

# Masks the gpe6E flag on boot.
cp /run/media/dad/InstallationKits/params.conf /etc/kernel/cmdline.d
clr-boot-manager update

# Install swupd bundles.
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina nmap nodejs-basic dev-utils-gui audio-pipewire devpkg-libwacom # containers-basic

cd /home/dad/Downloads
sudo -u dad mkdir /home/dad/Git

# Install remote flatpak bundles.
sudo -u dad flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo -u dad flatpak install --or-update --noninteractive -y com.github.tchx84.Flatseal org.gnome.Firmware com.mattjakeman.ExtensionManager org.videolan.VLC com.makemkv.MakeMKV org.videolan.VLC.Plugin.makemkv org.rncbc.qpwgraph net.scribus.Scribus net.codeindustry.MasterPDFEditor # fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Add permissions for Solaar to start as root.
mkdir /etc/udev/rules.d/
cp /run/media/dad/InstallationKits/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Add Solaar rules and other stuff.
sudo -u dad mkdir /home/dad/.config/solaar
cp /run/media/dad/InstallationKits/Solaar/DadsGram/*.yaml /home/dad/.config/solaar
cp /run/media/dad/InstallationKits/Solaar/solaar.desktop /home/dad/.config/autostart

# Check out the Git folder; configure Git first.
git config --global user.name "Cristian Cocos"
git config --global user.email "cristi@ieee.org"
sudo -u dad git clone https://github.com/Aqua1ung/Workspace.git /home/dad/Git

# Add update (and other) script desktop links.
cp -n /run/media/dad/InstallationKits/DesktopFiles/Update*.desktop /home/dad/.local/share/applications
cp -n /run/media/dad/InstallationKits/DesktopFiles/Flatpak/*.desktop /usr/share/applications # Broken Flatpak install (or to /usr/share/applications?).
cp -n /run/media/dad/InstallationKits/DesktopFiles/mountUSB.desktop /home/dad/.local/share/applications

# Turn on Gnome animations.
gsettings set org.gnome.desktop.interface enable-animations true

# Disable automount.
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false
systemctl restart gdm.service

# Install Excalidraw.
npm install react react-dom @excalidraw/excalidraw

# Install hid-tools
pip3 install hid-tools

# Add RemoteGo tablet.
mkdir -p /usr/lib/udev/hwdb.d
cp /run/media/dad/InstallationKits/RemoteGo/61-evdev-local.hwdb /usr/lib/udev/hwdb.d
systemd-hwdb update
udevadm trigger /dev/input/event*

# echo "Please power off, and make sure you run UpdateDadsGram.sh!"