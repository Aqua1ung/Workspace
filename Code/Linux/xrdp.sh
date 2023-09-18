#!/bin/bash

# Run as root/sudo.

swupd bundle-add x11-tools
mkdir -p /etc/xrdp
openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/xrdp/key.pem -out /etc/xrdp/cert.pem -days 730
sed -i 's/certificate=/certificate=\/etc\/xrdp\/cert.pem/' /usr/share/defaults/xrdp/xrdp.ini
sed -i 's/key_file=/key_file=\/etc\/xrdp\/key.pem/' /usr/share/defaults/xrdp/xrdp.ini
ln -s /usr/share/pam.d/xrdp-sesman /usr/share/pam.d/gdm
systemctl enable xrdp
@echo "Please reboot!"
