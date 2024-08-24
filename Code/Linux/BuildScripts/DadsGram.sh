#!/bin/bash

# Do NOT run as root/sudo.
if [ "$(id -u)" == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

# Check out the Git folder; configure Git first.
mkdir -p /home/dad/Git
git config --global user.name "Cristian Cocos"
git config --global user.email "cristi@ieee.org"
git clone https://github.com/Aqua1ung/Workspace.git /home/dad/Git/Workspace

# Removes kernel modules int3403_thermal and ucsi_acpi, to stop the spamming of the log and kill the CPU usage bug.
sudo cp /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/rmmod.* /etc/systemd/system
sudo systemctl enable rmmod.timer

# mkdir -p /etc/kernel/cmdline.d
mkdir -p /home/dad/.config/autostart/
mkdir -p /home/dad/.var

# Disable sleep when lid closed.
sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/lidSwitch.sh
/home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/lidSwitch.sh

# Install swupd bundles.
sudo swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina nmap nodejs-basic dev-utils-gui audio-pipewire devpkg-libwacom kvm-host hardinfo xorriso asunder input-remapper containers-basic virt-manager-gui podman kdenlive snapshot cabextract

cd ~/Downloads || exit

# Install remote flatpak bundles.
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install --or-update --noninteractive -y com.github.tchx84.Flatseal org.gnome.Firmware com.mattjakeman.ExtensionManager org.videolan.VLC com.makemkv.MakeMKV org.videolan.VLC.Plugin.makemkv org.rncbc.qpwgraph net.scribus.Scribus org.freac.freac io.podman_desktop.PodmanDesktop # org.shotcut.Shotcut fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles net.codeindustry.MasterPDFEditor

# Install the ClearFraction 3-rd party repository.
~/Git/Workspace/Code/Linux/BuildScripts/cf.sh

# Install ffmpeg.
sudo swupd 3rd-party bundle-add codecs

# Add permissions for Solaar to start as root.
sudo mkdir -p /etc/udev/rules.d/
sudo cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Add Solaar rules and other stuff. (No longer needed since mouse buttons are being handled by input-remapper.)
# mkdir -p /home/dad/.config/solaar
# cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/*.yaml /home/dad/.config/solaar

# Autostart Solaar; this can also be done from Tweaks. (Solaar UI is broken atm.)
# cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/solaar.desktop ~/.config/autostart

# Autostart Input Remapper.
sudo systemctl enable input-remapper --now

# Install Excalidraw.
npm install react react-dom @excalidraw/excalidraw

# Copy Input Remapper rules and other config files.
mkdir -p ~/.config/input-remapper-2/presets/"Logitech M720 Triathlon Multi-Device Mouse"
mkdir -p ~/.config/input-remapper-2/presets/"M720 Triathlon"
cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/Default.json ~/.config/input-remapper-2/presets/"Logitech M720 Triathlon Multi-Device Mouse"
cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/Default.json ~/.config/input-remapper-2/presets/"M720 Triathlon"
cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/config.json ~/.config/input-remapper-2

# Install hid-tools
pip3 install hid-tools

# Add RemoteGo tablet.
sudo mkdir -p /usr/lib/udev/hwdb.d
sudo cp ~/Git/Workspace/Code/Linux/61-evdev-local.hwdb /usr/lib/udev/hwdb.d
sudo systemd-hwdb update
sudo udevadm trigger /dev/input/event*

# Start Bluetooth on startup.
sudo tee "/etc/bluetooth/main.conf" >/dev/null <<'EOF'
[Policy]
AutoEnable=true 
EOF

# Add userid to the kvm and libvirt groups.
sudo usermod -G kvm -a $USER
sudo usermod -G libvirt -a $USER

# Enable libvirtd daemon.
sudo systemctl enable libvirtd --now

# Start the Docker daemon.
sudo systemctl enable docker --now

# Enable Bluetooth service.
sudo systemctl enable bluetooth --now

printf '\n' # Skip to new line.

# Copy update.sh file to home, and make shortcut.
cp ~/Git/Workspace/Code/Linux/updateDadsGram.sh ~
sudo chmod +x ~/updateDadsGram.sh
mkdir -p ~/.local/share/applications/
tee "/home/dad/.local/share/applications/updateComputer.desktop" >/dev/null <<'EOF'
[Desktop Entry]
Type=Application
Name=Update Computer
Exec=/home/dad/updateDadsGram.sh
Terminal=true
EOF

# Start Remmina on autostart.
cp ~/Git/Workspace/Code/Linux/DesktopFiles/Dad/remmina-applet.desktop ~/.config/autostart

# Restore Remmina connections. Not here, leave this for the update script.
mkdir -p ~/.local/share/remmina
# tar -xf ~/Git/Workspace/Code/Linux/UpdateScripts/Applications/remmina.tar.xz -C ~/.local/share/remmina

# Mount drives into folders.
sudo cp ~/Git/Workspace/Code/Linux/BuildScripts/fstab /etc
sudo systemctl daemon-reload

# Turn on Gnome animations. This should rather be done in settings: Accessibility/Seeing.
# gsettings set org.gnome.desktop.interface enable-animations true

# Disable automount.
# gsettings set org.gnome.desktop.media-handling automount false
# gsettings set org.gnome.desktop.media-handling automount-open false
# systemctl restart gdm.service

# echo "Please power off, and make sure you run UpdateDadsGram.sh!"
