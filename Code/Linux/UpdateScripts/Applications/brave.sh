#!/bin/bash
#-------------------------------------------------------------------------------
# Install and update script for Brave Browser stable.
# https://github.com/brave/brave-browser/releases
#-------------------------------------------------------------------------------

# shellcheck disable=SC2001,SC2143,SC2164

FILE="" URL="" VER=""

# Query for the latest release version for Linux, excluding pre-release.
for page in {1..10}; do
   RELVERs=$( curl -s "https://github.com/brave/brave-browser/releases?page=${page}" | awk '
      BEGIN {
         RS  = "<div "
         ret = ""
      }
      />Release v[0-9]/ && !/Pre-release/ && /\/brave\/brave-browser\/releases\/tag\// {
         gsub(/^.*\/tag\/v/, "", $0) # trim the left-right sides of version string
         gsub(/".*$/, "", $0)
         ret = ret " " $0
      }
      END {
         print ret
      }
   ')
   if [ "$RELVERs" ]; then
      for VER in $RELVERs; do
         FILE="brave-browser-${VER}-1.x86_64.rpm"
         URL="https://github.com/brave/brave-browser/releases/download/v${VER}/brave-browser-${VER}-1.x86_64.rpm"
         # Check if the remote resource is available (or found), particularly the Linux RPM file.
         http_code=$(curl -o /dev/null --silent -Iw '%{http_code}' "$URL")
         if [ "$http_code" -eq "302" ]; then
            break
         else
            FILE="" URL=""
         fi
      done
   fi
   [ -n "$FILE" ] && break
done

if [ -z "$FILE" ]; then
   echo "ERROR: Cannot determine the latest release version"
   echo "https://github.com/brave/brave-browser/releases"
   exit 1
fi

NEW_VER="$VER"
BROWSER_EXE="/opt/brave.com/brave/brave-browser"

if [[ -x "$BROWSER_EXE" ]]; then
   CUR_VER=$($BROWSER_EXE --version 2>/dev/null | awk '{ print $NF }')
else
   CUR_VER="not-installed"
fi

if [[ "${CUR_VER}" == *".${NEW_VER}"* ]]; then
   echo "Brave Browser stable $CUR_VER (current)"
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
   echo "Installing Brave Browser stable $NEW_VER"
else
   echo "Updating Brave Browser stable $NEW_VER"
   # remove older installation via rpm
   sudo rpm -e brave-browser 2>/dev/null
fi

cd ~/Downloads

if [[ ! -f "$FILE" ]]; then
   curl -LO "$URL"
   if [[ ! -f "$FILE" || -n $(grep "^Not Found" "$FILE") ]]; then
      rm -f "$FILE"
      echo "ERROR: $FILE (No such file at download URL)"
      echo "https://github.com/brave/brave-browser/releases"
      exit 1
   fi
fi

mkdir -p /tmp/update.$$ && pushd /tmp/update.$$ >/dev/null
rpm2cpio ~/Downloads/"$FILE" | cpio -idm 2>/dev/null

sudo mkdir -p /opt/brave.com
sudo rm -rf /opt/brave.com/brave
sudo cp -a usr/share/* /usr/share/.
sudo mv opt/brave.com/brave /opt/brave.com/.

sudo sed -i 's!/usr/bin/brave-browser-stable!/opt/brave.com/brave/brave-browser!g' \
   /usr/share/applications/brave-browser.desktop
sudo sed -i 's!^\(Exec=\)\(.*\)!\1env FONTCONFIG_PATH=/usr/share/defaults/fonts \2!g' \
   /usr/share/applications/brave-browser.desktop

popd >/dev/null
rm -fr /tmp/update.$$

# Add icons to the system icons; installs to /usr/share/icons/hicolor/.
for icon in \
   product_logo_64.png product_logo_48.png product_logo_16.png product_logo_32.png \
   product_logo_24.png product_logo_256.png product_logo_128.png
do 
   size=$(echo "$icon" | sed 's/[^0-9]//g')
   sudo xdg-icon-resource install --size "$size" /opt/brave.com/brave/${icon} "brave-browser"
done

sync
echo "OK"