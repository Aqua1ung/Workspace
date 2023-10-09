#!/bin/bash
#-------------------------------------------------------------------------------
# Install and update script for Google Chrome stable.
# https://pkgs.org/search/?q=google%20chrome
#-------------------------------------------------------------------------------

# shellcheck disable=SC2001,SC2143,SC2164

URL1='https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable'
URL2='https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable'

NEW_VER=$(curl -s "$URL1" | awk -F'>' '/Version:/ { print $NF; exit }')
BROWSER_EXE="/opt/google/chrome/google-chrome"

if [[ -x "$BROWSER_EXE" ]]; then
   CUR_VER=$($BROWSER_EXE --version 2>/dev/null | awk '{ print $NF }')
else
   CUR_VER="not-installed"
fi

if [[ "$NEW_VER" =~ ^$CUR_VER ]]; then
   echo "Google Chrome stable $CUR_VER (current)"
   exit
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
   echo "Installing Google Chrome stable ${NEW_VER%%-*}"
else
   echo "Updating Google Chrome stable ${NEW_VER%%-*}"
   # remove older installation via rpm
   sudo rpm -e google-chrome-stable 2>/dev/null
fi

FILE="google-chrome-stable-${NEW_VER}.x86_64.rpm"

cd ~/Downloads

if [[ ! -f "$FILE" ]]; then
   curl -LO "${URL2}-${NEW_VER}.x86_64.rpm"
   if [[ ! -f "$FILE" || -n $(grep "Error 404 (Not Found)" "$FILE") ]]; then
      rm -f "$FILE"
      echo "ERROR: $FILE (No such file at download URL)"
      echo "https://dl.google.com/linux/chrome/rpm/stable/x86_64/"
      exit 1
   fi
fi

mkdir -p /tmp/update.$$ && pushd /tmp/update.$$ >/dev/null
rpm2cpio ~/Downloads/"$FILE" | cpio -idm 2>/dev/null

sudo mkdir -p /opt/google
sudo rm -rf /opt/google/chrome
sudo cp -a usr/share/* /usr/share/.
sudo mv opt/google/chrome /opt/google/.

sudo sed -i 's!/usr/bin/google-chrome-stable!/opt/google/chrome/google-chrome!g' \
   /usr/share/applications/google-chrome.desktop

popd >/dev/null
rm -fr /tmp/update.$$

# Add icons to the system icons; installs to /usr/share/icons/hicolor/.
for icon in \
   product_logo_32.png product_logo_48.png product_logo_256.png product_logo_128.png \
   product_logo_16.png product_logo_64.png product_logo_24.png
do 
   size=$(echo "$icon" | sed 's/[^0-9]//g')
   sudo xdg-icon-resource install --size "$size" /opt/google/chrome/${icon} "google-chrome"
done

sync
echo "OK"