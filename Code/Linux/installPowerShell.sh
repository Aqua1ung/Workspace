#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit 1
fi

# echo "Installing or updating PowerShell ..."
location=$(curl -s -L -D - https://github.com/PowerShell/PowerShell/releases/latest/ -o /dev/null -w '%{url_effective}' | grep location | tr -d '\r')
tag=$(echo "$location" | sed 's/location: https.\+tag\///')
ver=$(echo "$tag" | sed 's/v//') # Replace "v" with nothing.
iV=$(pwsh --version | sed 's/PowerShell //')
if [[ "$iV" != "$ver" ]]
then
  sudo -u dad curl -L -o powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/$tag/powershell-$ver-linux-x64.tar.gz
  # rm -rf /opt/microsoft/powershell
  mkdir -p /opt/microsoft/powershell
  tar zxf powershell.tar.gz -C /opt/microsoft/powershell
  chmod +x /opt/microsoft/powershell/pwsh
  ln -s -f /opt/microsoft/powershell/pwsh /usr/bin/pwsh
else
  echo "No PowerShell update required."
fi