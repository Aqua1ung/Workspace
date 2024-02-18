#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

printf '\n' # Skip to new line.

read -p "Type in your Linux username, followed by Enter: " user
printf '\n' # Skip to new line.
if [ $user != mom ] && [ $user != gabe ] && [ $user != paul ]
then
  echo "You have mistyped the user name. Exiting ..."
  exit 1
fi

# Install update scripts.
cd /home/$user/Downloads
sudo -u $user wget https://github.com/Aqua1ung/Workspace/archive/refs/heads/master.zip
sudo -u $user unzip master.zip
sudo -u $user cp -r Workspace-master/Code/Linux/UpdateScripts/Applications /home/$user/
rm -rf Workspace-master/
rm master.zip

# Lid switch fix.
chmod +x /home/$user/Applications/lidSwitch.sh
/home/$user/Applications/lidSwitch.sh

if [ $user == gabe ]
then
  # Removes kernel module int3403_thermal, to stop the spamming of the log.
  cp /home/$user/Applications/rmmod.* /etc/systemd/system
  systemctl enable rmmod.timer
  sudo -u gabe mkdir /home/$user/.config/autostart/
  sudo -u gabe  mkdir /home/$user/.var
fi

# Install swupd bundles.
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina nmap nodejs-basic dev-utils-gui audio-pipewire devpkg-libwacom kvm-host hardinfo FreeRDP # containers-basic

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
sudo -u $user wget https://github.com/Aqua1ung/Workspace/archive/refs/heads/master.zip
sudo -u $user unzip master.zip
sudo -u $user cp -r Workspace-master/Code/Linux/UpdateScripts/Applications /home/$user/
rm -rf Workspace-master/
rm master.zip

# Set bluetooth power up.
tee "/etc/bluetooth/main.conf" >/dev/null <<'EOF'
[Policy]
AutoEnable=true 
EOF

# Turn on Gnome animations.
gsettings set org.gnome.desktop.interface enable-animations true

# Install Excalidraw.
npm install react react-dom @excalidraw/excalidraw

# Install hid-tools
pip3 install hid-tools

echo "Please power off, and make sure you run netbird.sh and Update.sh afterwards."
