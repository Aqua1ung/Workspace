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
swupd bundle-add lm-sensors firmware-update v4l-utils openssh-server gnome-remote-desktop wine Solaar-gui network-basic xdg-desktop-portal xdg-desktop-portal-gnome x11-tools transcoding-support package-utils java-basic nfs-utils waypipe devpkg-nfs-utils storage-utils python3-basic Remmina nmap # containers-basic

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

# Add ClearFraction repo.
swupd 3rd-party add clearfraction https://download.clearfraction.cf/update
mkdir -p /etc/environment.d /etc/profile.d
sudo tee -a /etc/environment.d/10-cf.conf << 'EOF'
PATH=/usr/bin/haswell:/usr/bin:/usr/local/bin:/opt/3rd-party/bundles/clearfraction/bin:/opt/3rd-party/bundles/clearfraction/usr/bin:/opt/3rd-party/bundles/clearfraction/usr/local/bin
LD_LIBRARY_PATH=/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/local/lib64
XDG_DATA_DIRS=/usr/share:/usr/local/share:/opt/3rd-party/bundles/clearfraction/usr/share:/opt/3rd-party/bundles/clearfraction/usr/local/share
XDG_CONFIG_DIRS=/usr/share/xdg:/etc/xdg:/opt/3rd-party/bundles/clearfraction/usr/share/xdg:/opt/3rd-party/bundles/clearfraction/etc/xdg
FONTCONFIG_PATH=/usr/share/defaults/fonts
GST_PLUGIN_PATH_1_0=/usr/lib64/gstreamer-1.0:/opt/3rd-party/bundles/clearfraction/usr/lib64/gstreamer-1.0
EOF
sudo tee -a /etc/profile.d/10-cf.sh << 'EOF'
[[ ! ${PATH} =~ "/opt/3rd-party/bundles/clearfraction/bin" ]] && \
  PATH=$PATH:/opt/3rd-party/bundles/clearfraction/bin:/opt/3rd-party/bundles/clearfraction/usr/bin:/opt/3rd-party/bundles/clearfraction/usr/local/bin

[[ ! ${LD_LIBRARY_PATH} =~ "/opt/3rd-party/bundles/clearfraction/usr/lib64" ]] && \
  LD_LIBRARY_PATH=/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/local/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

[[ ! ${XDG_DATA_DIRS} =~ "/opt/3rd-party/bundles/clearfraction/usr/share" ]] && \
  XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}:/opt/3rd-party/bundles/clearfraction/usr/share/:/opt/3rd-party/bundles/clearfraction/usr/local/share/

[[ ! ${XDG_CONFIG_DIRS} =~ "/opt/3rd-party/bundles/clearfraction/usr/share/xdg" ]] && \
  XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/usr/share/xdg:/etc/xdg}:/opt/3rd-party/bundles/clearfraction/usr/share/xdg:/opt/3rd-party/bundles/clearfraction/etc/xdg

[[ ! ${FONTCONFIG_PATH} =~ "/usr/share/defaults/fonts" ]] && \
  FONTCONFIG_PATH=/usr/share/defaults/fonts${FONTCONFIG_PATH:+:$FONTCONFIG_PATH}

[[ ! ${GST_PLUGIN_PATH_1_0} =~ "/opt/3rd-party/bundles/clearfraction/usr/lib64/gstreamer-1.0" ]] && \
  GST_PLUGIN_PATH_1_0=${GST_PLUGIN_PATH_1_0:-/usr/lib64/gstreamer-1.0}:/opt/3rd-party/bundles/clearfraction/usr/lib64/gstreamer-1.0
EOF

echo "Please power off, and make sure you run UpdateDadsGram.sh and netbird_dad.sh!"