#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

# Install swupd bundles.
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils nfs-utils waypipe devpkg-nfs-utils storage-utils nmap nodejs-basic dev-utils-gui audio-pipewire Solaar-gui hardinfo postfix input-remapper containers-basic

cd /home/dad/Downloads
sudo -u dad mkdir /home/dad/Git /home/dad/.haos

# Start Docker service.
systemctl enable docker.service --now

# Install remoteflatpak bundles.
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --or-update --noninteractive -y org.gnome.Firmware com.mattjakeman.ExtensionManager # fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Check out the Git folder; configure Git first.
git config --global user.name "Cristian Cocos"
git config --global user.email "cristi@ieee.org"
sudo -u dad git clone https://github.com/Aqua1ung/Workspace.git /home/dad/Git/Workspace

# Add update (and other) script desktop links.
sudo -u dad cp -n /home/dad/Git/Workspace/Code/Linux/DesktopFiles/Dad/UpdateMiFiCmd.desktop /home/dad/.local/share/applications
# cp -n /run/media/dad/InstallationKits/DesktopFiles/Flatpak/*.desktop /usr/share/applications # In case of broken Flatpak install (or to /usr/share/applications?).

# Add permissions for Solaar to start as root.
mkdir -p /etc/udev/rules.d/
cp /home/dad/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Add Solaar rules and other stuff.
sudo -u dad mkdir /home/dad/.config/solaar
sudo -u dad cp /home/dad/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/*.yaml /home/dad/.config/solaar
sudo -u dad cp /home/dad/Git/Workspace/Code/Linux/BuildScripts/Solaar/solaar.desktop /home/dad/.config/autostart

# Install PowerShell.
chmod +x /home/dad/Git/Workspace/Code/Linux/installPowerShell.sh
/home/dad/Git/Workspace/Code/Linux/installPowerShell.sh

# Install HAOS Docker container.
sudo docker run -d --name homeassistant --device=/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20231216151619-if00 --privileged --restart=unless-stopped -e TZ=America/New_York -v /home/dad/.haos:/config -v /run/dbus:/run/dbus:ro --network=host ghcr.io/home-assistant/home-assistant:stable

# Trigger MiFi reboot every day at 4:00AM.
cp /home/dad/Git/Workspace/Code/Linux/SystemdUnits/mifi.* /etc/systemd/system/
systemctl enable mifi.timer --now