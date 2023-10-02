#!/bin/bash

# Run as root/sudo.

if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

printf '\n' # Skip to new line.

read -p "Type in your Linux username, followed by Enter: " user
printf '\n' # Skip to new line.
if [ $user != mom ] && [ $user != gabe ] && [ $user != paul ]
then
  echo "You have mistyped the user name. Exiting ..."
  exit
fi

if [ $user == gabe ]
then
  # Removes kernel module int3403_thermal, to stop the spamming of the log.
  cp /run/media/gabe/InstallationKits/rmmod.* /etc/systemd/system
  systemctl enable rmmod.timer
  mkdir /etc/kernel
  mkdir /etc/kernel/cmdline.d
  sudo -u gabe mkdir /home/gabe/.config/autostart/
  sudo -u gabe  mkdir /home/gabe/.var
  # Masks the gpe6E flag on boot.
  cp /run/media/gabe/InstallationKits/params.conf /etc/kernel/cmdline.d
  clr-boot-manager update
fi

# Install swupd bundles.
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina # containers-basic

cd /home/$user/Downloads

# Install remote flatpak bundles.
sudo -u dad flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo -u dad flatpak install --or-update --noninteractive -y com.github.tchx84.Flatseal org.gnome.Firmware com.mattjakeman.ExtensionManager org.videolan.VLC com.makemkv.MakeMKV org.videolan.VLC.Plugin.makemkv org.rncbc.qpwgraph net.scribus.Scribus # net.codeindustry.MasterPDFEditor fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Add permissions for Solaar to start as root.
mkdir /etc/udev/rules.d/
cp /run/media/$user/InstallationKits/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Add Solaar rules and other stuff.
sudo -u $user mkdir /home/$user/.config/solaar
sudo -u $user cp /run/media/$user/InstallationKits/Solaar/DadsGram/*.yaml /home/$user/.config/solaar
sudo -u $user cp /run/media/$user/InstallationKits/Solaar/solaar.desktop /home/$user/.config/autostart

# Install update scripts.
wget https://github.com/Aqua1ung/Workspace/archive/refs/heads/master.zip
unzip master.zip
cp -r Workspace-master/Code/Linux/UpdateScripts/Applications /home/$user/
rm -r Workspace-master/
rm master.zip

# Set bluetooth power up.
tee "/etc/bluetooth/main.conf" >/dev/null <<'EOF'
[Policy]
AutoEnable=true 
EOF

echo "Please power off, and make sure you run netbird.sh and Update.sh afterwards."
