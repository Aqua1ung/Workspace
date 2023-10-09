#!/bin/bash
#-------------------------------------------------------------------------------
# Install and update script for Vivaldi stable.
# https://vivaldi.com/download/
#-------------------------------------------------------------------------------

# shellcheck disable=SC2001,SC2143,SC2164

URL=$(
   curl -s 'https://vivaldi.com/download/' |\
   awk 'BEGIN { RS = "href=" } /vivaldi-stable-.*\.x86_64\.rpm/ { print $1; exit }' |\
   cut -d'"' -f2
)

FILE="${URL##*/}"

if [[ -z "$FILE" ]]; then
   echo "ERROR: vivaldi-stable-*.rpm (No such file at download URL)"
   echo "https://vivaldi.com/download/"
   exit 1
fi

NEW_VER=$(echo "$FILE" | cut -d- -f3)
BROWSER_EXE="/opt/vivaldi/vivaldi"

if [[ -x "$BROWSER_EXE" ]]; then
   CUR_VER=$($BROWSER_EXE --version 2>/dev/null | awk '{ print $2 }')
else
   CUR_VER="not-installed"
fi

if [[ "$NEW_VER" == "$CUR_VER" ]]; then
   echo "Vivaldi stable $CUR_VER (current)"
   exit 0
elif [[ "$USER" == "root" ]]; then
   echo "Please run the script as a normal user, exiting..."
   exit 1
fi

# Test sudo, exit if wrong password or terminated.
sudo true >/dev/null || exit 2

# Install dependencies.
if [[ ! -x "/usr/bin/curl" || ! -x "/usr/bin/rpm2cpio" ]]; then
   echo "Installing dependencies."
   sudo swupd bundle-add curl package-utils --quiet
fi

#-------------------------------------------------------------------------------

if [[ ! -x "$BROWSER_EXE" ]]; then
   echo "Installing Vivaldi stable $NEW_VER"
else
   echo "Updating Vivaldi stable $NEW_VER"
   # remove older installation via rpm
   sudo rpm -e vivaldi-stable 2>/dev/null
fi

cd ~/Downloads

if [[ ! -f "$FILE" ]]; then
   curl -LO "$URL"
   if [[ ! -f "$FILE" || -n $(grep "404 Not Found" "$FILE") ]]; then
      rm -f "$FILE"
      echo "ERROR: $FILE (No such file at download URL)"
      echo "https://vivaldi.com/download/"
      exit 1
   fi
fi

mkdir -p /tmp/update.$$ && pushd /tmp/update.$$ >/dev/null
rpm2cpio ~/Downloads/"$FILE" | cpio -idm 2>/dev/null

sudo mkdir -p /opt
sudo rm -rf /opt/vivaldi
sudo cp -a usr/share/* /usr/share/.
sudo mv opt/vivaldi /opt/.

sudo sed -i 's!/usr/bin/vivaldi-stable!/opt/vivaldi/vivaldi!g' \
   /usr/share/applications/vivaldi-stable.desktop
sudo sed -i 's!^\(Exec=\)\(.*\)!\1env FONTCONFIG_PATH=/usr/share/defaults/fonts \2!g' \
   /usr/share/applications/vivaldi-stable.desktop

popd >/dev/null
rm -fr /tmp/update.$$

# Add icons to the system icons; installs to /usr/share/icons/hicolor/.
for icon in \
   product_logo_16.png product_logo_256.png product_logo_24.png product_logo_64.png \
   product_logo_32.png product_logo_128.png product_logo_22.png product_logo_48.png
do 
   size=$(echo "$icon" | sed 's/[^0-9]//g')
   sudo xdg-icon-resource install --size "$size" /opt/vivaldi/${icon} --novendor "vivaldi"
done

sync
echo "OK"