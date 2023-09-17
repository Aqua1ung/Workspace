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
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic # containers-basic

cd /home/$user/Downloads

# Download and install Chrome.
wget -N https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub
rpm -U --nodeps google-chrome*.rpm
sed -i 's\/usr/bin/google-chrome-stable\env FONTCONFIG_PATH=/usr/share/defaults/fonts /usr/bin/google-chrome-stable\g' /usr/share/applications/google-chrome.desktop

# Download and install VSCodium.
location=$(curl -s -L -D - https://github.com/VSCodium/vscodium/releases/latest/ -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
# echo $location
tag=$(echo "$location" | sed 's/location: https.\+tag\///')
wget -N https://github.com/VSCodium/vscodium/releases/download/$tag/codium-$tag-el7.x86_64.rpm
rpm -Uvh --nodeps codium*.rpm

# Install remote flatpak bundles.
sudo -u dad flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo -u dad flatpak install --or-update --noninteractive -y com.github.tchx84.Flatseal org.gnome.Firmware org.remmina.Remmina com.mattjakeman.ExtensionManager com.visualstudio.code org.videolan.VLC com.makemkv.MakeMKV org.videolan.VLC.Plugin.makemkv org.rncbc.qpwgraph # fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Add permissions for Solaar to start as root.
mkdir /etc/udev/rules.d/
cp /run/media/$user/InstallationKits/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Add Solaar rules and other stuff.
sudo -u $user mkdir /home/$user/.config/solaar
sudo -u $user cp /run/media/$user/InstallationKits/Solaar/DadsGram/*.yaml /home/$user/.config/solaar
sudo -u $user cp /run/media/$user/InstallationKits/Solaar/solaar.desktop /home/$user/.config/autostart

# Required by AURGA viewer.
# cp /run/media/$user/InstallationKits/AURGA/LinuxBinaries/99-input-permissions.rules /etc/udev/rules.d/
# udevadm control --reload-rules && udevadm trigger

# Install update scripts.
tar -xf /run/media/$user/InstallationKits/UpdateScripts/UpdateScripts.tar.xz -C /home/$user
rm /home/$user/readme.txt

# Set bluetooth power up.
tee "/etc/bluetooth/main.conf" >/dev/null <<'EOF'
[Policy]
AutoEnable=true 
EOF

echo "Please power off, and make sure you run netbird.sh and Update.sh afterwards."
