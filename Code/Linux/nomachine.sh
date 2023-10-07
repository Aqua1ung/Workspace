#!/bin/bash

# Install NoMachine; do `sudo /etc/NX/nxserver --uninstall` to uninstall.
mkdir -p /etc/pam.d
tar xf /run/media/dad/InstallationKits/nomachine*.tar.gz -C /usr
/usr/NX/nxserver --install fedora
/etc/NX/nxserver --virtualgl yes
/usr/NX/scripts/setup/nxnode --audiosetup /usr/share/pulseaudio
/usr/NX/scripts/setup/nxnode --printingsetup /usr/share/cups
systemctl start nxserver.service