cd /home/dad/Downloads
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
sudo -u $user ./dotnet-install.sh --channel 6.0 # Not sudo!
rm dotnet-install.sh

# Append these two lines to /usr/share/defaults/etc/profile:
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# Download and install OpenTabletDriver
cd /run/media/dad/InstallationKits
OTDv=$(curl -s -L -D - https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest | grep -n -m 1 "<title>" | sed -n 's/^.*tDriver v//p' | sed -n 's/ · OpenT.*$//p') # Grab the latest version number.
noOD=$(wget -N wget -N https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v$OTDv/opentabletdriver-$OTDv-x64.tar.gz 2>&1 | grep -c "Omitting download") # Download OpenTabletDriver nightly.
  if [[ $noOD -eq 0 ]]
  then
    tar -xvf opentabletdriver-0.6.3.0-x64.tar.gz -C / --strip 1
    cp /home/dad/Git/Workspace/Code/Linux/opentabletdriver.service /usr/local/lib/systemd/user
  else
    echo "No update required."
  fi
else
  echo "Skipping OpenTabletDriver install/update."
fi
printf '\n' # Insert blank line.

# Start opentabletdriver daemon.
systemctl --user enable opentabletdriver.service --now