cd /home/dad/Downloads
wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 6.0 # Not sudo!
rm dotnet-install.sh
printf '\n' # Skip to new line.

#echo "DOTNET_ROOT is: " $DOTNET_ROOT
if [[ ! -v DOTNET_ROOT ]] # If variable is not set ...
then
  echo "DOTNET_ROOT needs to be set ..."
  # then set it, i.e. append these two lines to /usr/share/defaults/etc/profile:
sudo tee -a /usr/share/defaults/etc/profile << EOF

export DOTNET_ROOT=/home/dad/.dotnet
export PATH=$PATH:/home/dad/.dotnet:/home/dad/.dotnet/tools
EOF
else
  echo "No need to set DOTNET_ROOT."
fi
printf '\n' # Skip to new line.

# Download and install OpenTabletDriver
cd /run/media/dad/InstallationKits
# sudo cp -u /home/dad/Git/Workspace/Code/Linux/70-opentabletdriver.rules /etc/udev/rules.d
mkdir -p /home/dad/.local/share/OpenTabletDriver/Configurations
cp -u /home/dad/Git/Workspace/Code/Linux/RMGL01.json /home/dad/.local/share/OpenTabletDriver/Configurations
OTDv=$(curl -s -L -D - https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest | grep -n -m 1 "<title>" | sed -n 's/^.*tDriver v//p' | sed -n 's/ · OpenT.*$//p') # Grab the latest version number.
noOD=$(wget -q -N wget -q -N https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v$OTDv/opentabletdriver-$OTDv-x64.tar.gz 2>&1 | grep -c "Omitting download") # Download OpenTabletDriver.
if [[ $noOD -eq 0 ]]
then
  sudo tar -xvf opentabletdriver-$OTDv-x64.tar.gz -C / --strip 1
  sudo cp -u /home/dad/Git/Workspace/Code/Linux/opentabletdriver.service /usr/local/lib/systemd/user
  echo "Done"
  # Start opentabletdriver daemon.
  systemctl --user enable opentabletdriver.service --now
  # sudo udevadm control --reload-rules && sudo udevadm trigger
else
  echo "No OpenTabletDriver update required."
fi
printf '\n' # Skip to new line.