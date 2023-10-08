#!/bin/bash

# Do NOT run as root!
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit
fi

echo "Fixing PWA fonts ... "
for file in /home/$USER/.local/share/applications/chrome-*-Default.desktop; do
  if [[ $(grep -c "env FONTCONFIG_PATH=/usr/share/defaults/fonts" $file) -eq 0 ]]
  then
    sed -i 's\/opt/google/chrome/google-chrome\env FONTCONFIG_PATH=/usr/share/defaults/fonts /opt/google/chrome/google-chrome\g' $file
  fi
done
echo "Done!"