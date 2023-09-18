#!/bin/bash

# Run as root/sudo.

rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub
rpm -Uvh --nodeps --force google-chrome*.rpm
sed -i 's\/usr/bin/google-chrome-stable\env FONTCONFIG_PATH=/usr/share/defaults/fonts /usr/bin/google-chrome-stable\g' /usr/share/applications/google-chrome.desktop
