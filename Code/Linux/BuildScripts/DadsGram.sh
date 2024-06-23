#!/bin/bash

# Do not run as root/sudo.
if [ $(id -u) == 0 ]
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

# Masks the gpe6E flag on boot, in order to fix high CPU usage; superseded by rmmod ucsi_acpi (see rmmod.service).
# cp /run/media/dad/InstallationKits/params.conf /etc/kernel/cmdline.d
# clr-boot-manager update

# Disable sleep when lid closed.
sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/lidSwitch.sh
/home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/lidSwitch.sh

# Install swupd bundles.
sudo swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina nmap nodejs-basic dev-utils-gui audio-pipewire devpkg-libwacom kvm-host hardinfo xorriso asunder input-remapper containers-basic virt-manager-gui podman

cd /home/dad/Downloads

# Install remote flatpak bundles.
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install --or-update --noninteractive -y com.github.tchx84.Flatseal org.gnome.Firmware com.mattjakeman.ExtensionManager org.videolan.VLC com.makemkv.MakeMKV org.videolan.VLC.Plugin.makemkv org.rncbc.qpwgraph net.scribus.Scribus net.codeindustry.MasterPDFEditor org.freac.freac io.podman_desktop.PodmanDesktop # fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Add permissions for Solaar to start as root.
sudo mkdir -p /etc/udev/rules.d/
sudo cp /run/media/dad/InstallationKits/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Add Solaar rules and other stuff.
mkdir -p /home/dad/.config/solaar
cp /run/media/dad/InstallationKits/Solaar/DadsGram/*.yaml /home/dad/.config/solaar
# cp /run/media/dad/InstallationKits/Solaar/solaar.desktop /home/dad/.config/autostart

# Add update (and other) script desktop links.
cp -n /run/media/dad/InstallationKits/DesktopFiles/*.desktop /home/dad/.local/share/applications
# cp -n /run/media/dad/InstallationKits/DesktopFiles/Flatpak/*.desktop /usr/share/applications # Broken Flatpak install (or to /usr/share/applications?).
# cp -n /run/media/dad/InstallationKits/DesktopFiles/mountUSB.desktop /home/dad/.local/share/applications

# Install Excalidraw.
npm install react react-dom @excalidraw/excalidraw

# Install hid-tools
pip3 install hid-tools

# Add RemoteGo tablet.
sudo mkdir -p /usr/lib/udev/hwdb.d
sudo cp /run/media/dad/InstallationKits/RemoteGo/61-evdev-local.hwdb /usr/lib/udev/hwdb.d
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
cp /home/dad/Git/Workspace/Code/Linux/updateDadsGram.sh ~
sudo chmod +x ~/updateDadsGram.sh
mkdir -p ~/.local/share/applications/
tee "/home/dad/.local/share/applications/updateComputer.desktop" >/dev/null <<'EOF'
[Desktop Entry]
Type=Application
Name=Update Computer
Exec=~/updateDadsGram.sh
Terminal=true
EOF

# Turn on Gnome animations. This should rather be done in settings: Accessibility/Seeing.
# gsettings set org.gnome.desktop.interface enable-animations true

# Disable automount.
# gsettings set org.gnome.desktop.media-handling automount false
# gsettings set org.gnome.desktop.media-handling automount-open false
# systemctl restart gdm.service

# echo "Please power off, and make sure you run UpdateDadsGram.sh!"
