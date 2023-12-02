cd /home/dad/Downloads
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 6.0

# Append these two lines to /usr/share/defaults/etc/profile:
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# Download and install OpenTabletDriver
sudo cp opentabletdriver-0.6.3.0-x64.tar.gz /
sudo tar -xvf opentabletdriver-0.6.3.0-x64.tar.gz --strip 1
sudo rm opentabletdriver-0.6.3.0-x64.tar.gz

# Start opentabletdriver daemon.
systemctl --user enable opentabletdriver.service --now
or
sudo systemctl enable opentabletdriver.service
