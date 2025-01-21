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
# git clone https://github.com/jenv/jenv.git ~/.jenv

# Removes kernel modules int3403_thermal and ucsi_acpi, to stop the spamming of the log and kill the CPU usage bug.
sudo cp /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/rmmod.* /etc/systemd/system
sudo systemctl enable rmmod.timer

# mkdir -p /etc/kernel/cmdline.d
mkdir -p /home/dad/.config/autostart/
mkdir -p /home/dad/.var

# Disable sleep when lid closed.
sudo mkdir -p /etc/systemd/logind.conf.d
sudo ln -sf /dev/null /etc/systemd/logind.conf.d/80-lidswitch.conf
# A different method:
# echo "LID0" | sudo tee /proc/acpi/wakeup

# Install swupd bundles.
sudo swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina nmap nodejs-basic dev-utils-gui audio-pipewire devpkg-libwacom kvm-host hardinfo xorriso asunder input-remapper containers-basic virt-manager-gui snapshot dfu-util winegui cabextract fdupes desktop-dev devpkg-pkcs11-helper # desktop-kde kdenlive

cd ~/Downloads || exit

# Install remote flatpak bundles.
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install --or-update --noninteractive -y com.github.tchx84.Flatseal org.gnome.Firmware com.mattjakeman.ExtensionManager com.makemkv.MakeMKV org.rncbc.qpwgraph net.scribus.Scribus org.freac.freac com.github.qarmin.czkawka org.kde.kdenlive io.github.vikdevelop.SaveDesktop org.videolan.VLC org.videolan.VLC.Plugin.makemkv com.rustdesk.RustDesk # io.podman_desktop.PodmanDesktop io.github.JakubMelka.Pdf4qt org.shotcut.Shotcut fr.romainvigier.MetadataCleaner com.poweriso.PowerISO com.usebottles.bottles

# Add libmmbd to lib64 path.
# sudo ln -s /var/lib/flatpak/app/com.makemkv.MakeMKV/x86_64/stable/active/files/lib/libmmbd.so.0 /usr/lib64/libmmbd.so.0

# Install the ClearFraction 3-rd party repository.
~/Git/Workspace/Code/Linux/BuildScripts/cf.sh

# Install ffmpeg.
sudo swupd 3rd-party bundle-add codecs

# Add permissions for Solaar to start as root.
sudo mkdir -p /etc/udev/rules.d/
sudo cp ~/Git/Workspace/Code/Linux/BuildScripts/Solaar/DadsGram/42-logitech-unify-permissions.rules /etc/udev/rules.d

# Set Solaar settings.
sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/solaar.sh
~/Git/Workspace/Code/Linux/UpdateScripts/Applications/solaar.sh

# Autostart Input Remapper.
sudo systemctl enable input-remapper --now

# Install Excalidraw.
# npm install react react-dom @excalidraw/excalidraw

# Install MasterPDF Editor
sudo rpm -Uvh --nodeps ~/Git/Workspace/Code/Linux/mpe.rpm

# Configure Input Remapper.
sudo chmod +x /home/dad/Git/Workspace/Code/Linux/UpdateScripts/Applications/input-remapper.sh
~/Git/Workspace/Code/Linux/UpdateScripts/Applications/input-remapper.sh

# Install hid-tools
pip3 install hid-tools

# Add RemoteGo tablet.
sudo mkdir -p /usr/lib/udev/hwdb.d
sudo cp ~/Git/Workspace/Code/Linux/61-evdev-local.hwdb /usr/lib/udev/hwdb.d
sudo systemd-hwdb update
sudo udevadm trigger /dev/input/event*

# Start Bluetooth on startup.
# sudo tee "/etc/bluetooth/main.conf" >/dev/null <<'EOF'
# [Policy]
# AutoEnable=true
# EOF

# Add userid to the kvm and libvirt groups.
sudo usermod -G kvm -a $USER
sudo usermod -G libvirt -a $USER
sudo usermod -aG docker ${USER}
# newgrp docker

# Enable libvirtd daemon.
sudo systemctl enable libvirtd --now

# Start the Docker daemon.
sudo systemctl enable docker.service --now
sudo systemctl enable containerd.service --now

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

# Install Portainer agent.
# docker run -d   -p 9001:9001   --name PortainerAgentDadsGram   --restart=always   -v /var/run/docker.sock:/var/run/docker.sock   -v /var/lib/docker/volumes:/var/lib/docker/volumes   -v /:/host   portainer/agent:2.26.0

# Configure jEnv.
# echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bashrc
# echo 'eval "$(jenv init -)"' >> ~/.bashrc
# eval "$(jenv init -)"
# jenv enable-plugin export
# exec $SHELL -l

# Turn on Gnome animations. This should rather be done in settings: Accessibility/Seeing.
# gsettings set org.gnome.desktop.interface enable-animations true

# Disable automount.
# gsettings set org.gnome.desktop.media-handling automount false
# gsettings set org.gnome.desktop.media-handling automount-open false
# systemctl restart gdm.service

# echo "Please power off, and make sure you run UpdateDadsGram.sh!"
