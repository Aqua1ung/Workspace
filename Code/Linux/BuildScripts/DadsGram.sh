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
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina # containers-basic

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
sudo -u dad cp /run/media/dad/InstallationKits/Solaar/DadsGram/*.yaml /home/dad/.config/solaar
sudo -u dad cp /run/media/dad/InstallationKits/Solaar/solaar.desktop /home/dad/.config/autostart

# Configure Git email and username.
git config --global user.name "Cristian Cocos"
git config --global user.email "cristi@ieee.org"

# Add update script desktop links.
sudo -u dad cp /run/media/dad/InstallationKits/Update*.desktop /home/dad/.local/share/applications

# Add Rustdeak plugin to Remmina.
# location=$(curl -s -L -D - https://github.com/VSCodium/vscodium/releases/latest/ -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
# # echo $location
# tag=$(echo "$location" | sed 's/location: https.\+tag\///')
# wget -N https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
# rpm -Uvh --nodeps codium*.rpm
# printf '\n' # Skip to new line.

# mkdir -p /usr/share/icons/hicolor/22x22/emblems
# mkdir -p /usr/share/icons/hicolor/16x16/emblems
# cp /home/dad/Downloads/usr/share/icons/hicolor/16x16/emblems/* /usr/share/icons/hicolor/16x16/emblems
# cp /home/dad/Downloads/usr/share/icons/hicolor/22x22//emblems/* /usr/share/icons/hicolor/22x22/emblems
# tar --use-compress-program=unzstd -xvf remmina*.tar.zst
# cp /home/dad/Downloads/usr/lib/remmina/plugins/*.so /usr/lib64/remmina/plugins/
# rm -rf usr

echo "Please power off, and make sure you run UpdateDadsGram.sh and netbird_dad.sh!"