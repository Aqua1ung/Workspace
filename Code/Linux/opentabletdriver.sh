cd /home/dad/Downloads
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
sudo -u dad ./dotnet-install.sh --channel 6.0 # Not sudo!
# rm dotnet-install.sh

# Append these two lines to /usr/share/defaults/etc/profile:
tee -a /usr/share/defaults/etc/profile << EOF

export DOTNET_ROOT=/home/dad/.dotnet
export PATH=$PATH:/home/dad/.dotnet:/home/dad/.dotnet/tools
EOF

# Download and install OpenTabletDriver
cd /run/media/dad/InstallationKits
OTDv=$(curl -s -L -D - https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest | grep -n -m 1 "<title>" | sed -n 's/^.*tDriver v//p' | sed -n 's/ · OpenT.*$//p') # Grab the latest version number.
noOD=$(wget -N wget -N https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v$OTDv/opentabletdriver-$OTDv-x64.tar.gz 2>&1 | grep -c "Omitting download") # Download OpenTabletDriver.
if [[ $noOD -eq 0 ]]
then
  tar -xvf opentabletdriver-$OTDv-x64.tar.gz -C / --strip 1
  cp /home/dad/Git/Workspace/Code/Linux/opentabletdriver.service /usr/local/lib/systemd/user
  echo "Done"
  # Start opentabletdriver daemon.
  systemctl --user enable opentabletdriver.service --now
else
  echo "No update required."
fi