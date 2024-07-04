#!/bin/bash

# Do not run as root/sudo.

if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

cd ~/.local/bin
tag=$(curl -s -L -D - https://github.com/JakubMelka/PDF4QT/releases/latest/ | grep -n -m 1 "Version " | sed -n 's/^.*Version //p' | sed -n 's/ - Editor.*$//p')
mv PDF4QT.AppImage PDF4QT-$tag-x86_64.AppImage
wget -N https://github.com/JakubMelka/PDF4QT/releases/download/v$tag/PDF4QT-$tag-x86_64.AppImage
mv PDF4QT-$tag-x86_64.AppImage PDF4QT.AppImage
sudo chmod +x PDF4QT.AppImage

if [ ! -f ~/.local/share/applications/PDF4QT.desktop ]
then
  tee "/home/$USER/.local/share/applications/PDF4QT.desktop" >/dev/null <<'EOF'
[Desktop Entry]
Name=PDF4QT
GenericName=PDF Editor
Exec=~/.local/bin/PDF4QT.AppImage %F
Icon=PDF4QT.AppImage
Type=Application
StartupNotify=false
Categories=Office;
Actions=new-empty-window;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=~/.local/bin/PDF4QT.AppImage --new-window %F
Icon=PDF4QT.AppImage
EOF
sed -i "s/~/\/home\/$USER/g" "/home/$USER/.local/share/applications/PDF4QT.desktop" # Desktop files do not understand tilda, so it needs to be replaced w/full path.
fi

cd -