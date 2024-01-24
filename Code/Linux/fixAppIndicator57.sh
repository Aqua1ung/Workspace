#!/bin/bash

# Do NOT run as root!
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

gsettings set org.gnome.shell disable-user-extensions true

cd /home/$USER/Downloads
wget -N https://github.com/ubuntu/gnome-shell-extension-appindicator/archive/refs/tags/v57.tar.gz
tar -xf /home/$USER/Downloads/v57.tar.gz
cd /home/$USER/Downloads/gnome-shell-extension-appindicator-57
rm -rf indicator-test-tool lint locale schemas .github
cd -
rm -rf /home/$USER/.local/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com/interfaces-xml
mv -f /home/$USER/Downloads/gnome-shell-extension-appindicator-57/* /home/$USER/.local/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com
# mv -f /home/$USER/Downloads/gnome-shell-extension-appindicator-57/interfaces-xml /home/$USER/.local/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com
# mv -f /home/$USER/Downloads/gnome-shell-extension-appindicator-57/schemas /home/$USER/.local/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com

# gsettings set org.gnome.shell disable-user-extensions false

rm -rf *