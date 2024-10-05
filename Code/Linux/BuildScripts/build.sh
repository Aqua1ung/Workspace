#!/bin/bash

# Do not run as root/sudo.
if [ $(id -u) == 0 ]
then
  echo "This script should be NOT run as root! Exiting ..."
  exit 1
fi

# Copy Code folder from Git.
mkdir -p ~/Git
cd ~/Git/
git clone https://github.com/Aqua1ung/Workspace.git

# Copy update.sh file to home, and make shortcut.
cp ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/update.sh ~
sudo chmod +x ~/update.sh
mkdir -p ~/.local/share/applications/
tee "/home/$USER/.local/share/applications/updateComputer.desktop" >/dev/null <<'EOF'
[Desktop Entry]
Type=Application
Name=Update Computer
Exec=~/update.sh
Terminal=true
EOF
sed -i "s/~/\/home\/$USER/g" "/home/$USER/.local/share/applications/updateComputer.desktop" # Desktop files do not understand tilda, so it needs to be replaced w/full path.

cd ~/Downloads

mkdir -p ~/.config/autostart/
mkdir -p ~/.var

# Lid switch fix.
sudo chmod +x ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/lidSwitch.sh
~/Git/Workspace/Code/Linux/UpdateScripts/Applications/lidSwitch.sh

if [ $USER == gabe ]
then
  # Removes kernel module int3403_thermal, to stop the spamming of the log.
  sudo cp ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/rmmod.* /etc/systemd/system
  sudo systemctl enable rmmod.timer
fi

# Install swupd bundles.
sudo swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic nmap nodejs-basic dev-utils-gui audio-pipewire devpkg-libwacom kvm-host hardinfo input-remapper containers-basic virt-manager-gui kdenlive snapshot cabextract

# cd ~/Downloads

# Install remote flatpak bundles.
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install --or-update --noninteractive -y com.github.tchx84.Flatseal org.gnome.Firmware com.mattjakeman.ExtensionManager org.videolan.VLC com.makemkv.MakeMKV org.videolan.VLC.Plugin.makemkv org.rncbc.qpwgraph net.scribus.Scribus com.google.Chrome org.remmina.Remmina net.codeindustry.MasterPDFEditor # org.shotcut.Shotcut fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Add permissions for Solaar to start as root.
sudo mkdir -p /etc/udev/rules.d/
sudo cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Add Solaar rules and other stuff.
mkdir -p ~/.config/solaar
cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/*.yaml ~/.config/solaar

# Autostart Solaar; this can also be done from Tweaks. (Solaar UI is broken atm.)
# cp /run/media/$USER/Git/Workspace/Code/Linux/BuildScripts/Solaar/solaar.desktop ~/.config/autostart

# Start Bluetooth on startup.
sudo tee "/etc/bluetooth/main.conf" >/dev/null <<'EOF'
[Policy]
AutoEnable=true 
EOF

# Turn on Gnome animations. This should rather be done in settings: Accessibility/Seeing.
# gsettings set org.gnome.desktop.interface enable-animations true

# Install Excalidraw.
npm install react react-dom @excalidraw/excalidraw

# Autostart Input Remapper.
sudo systemctl enable input-remapper --now

# Install hid-tools
pip3 install hid-tools

# Add userid to the kvm and libvirt groups.
sudo usermod -G kvm -a $USER
sudo usermod -G libvirt -a $USER

# Enable libvirtd daemon.
sudo systemctl enable libvirtd --now

# Enable Bluetooth service.
sudo systemctl enable bluetooth --now

# Enable Docker daemon.
sudo systemctl enable docker --now

# Patch Chrome permissions in FlatSeal for the installation of PWAs.
sudo chmod +x ~/Git/Workspace/Code/Linux/patchFlatseal.sh
~/Git/Workspace/Code/Linux/patchFlatseal.sh
if [ ! -f ~/.local/share/flatpak/overrides/com.google.Chrome ]
then
  echo "WARNING! Flatseal override did not go through! Check Flatseal Chrome permission settings. Exiting script."
  exit 1
fi

# Start Remmina on autostart.
cp ~/Git/Workspace/Code/Linux/DesktopFiles/Others/remmina-applet.desktop ~/.config/autostart

# Restore Remmina connections. Not here, leave this for the update script.
mkdir -p ~/.var/app/org.remmina.Remmina/data/remmina
# tar -xf ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina.tar.xz -C ~/.var/app/org.remmina.Remmina/data/remmina

# echo "Please power off, and make sure you run netbird.sh and Update.sh afterwards."