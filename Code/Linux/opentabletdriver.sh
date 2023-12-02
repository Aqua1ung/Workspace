cd /home/dad/Downloads
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --channel 6.0 # Not sudo!

# Append these two lines to /usr/share/defaults/etc/profile:
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# Download and install OpenTabletDriver
sudo tar -xvf opentabletdriver-0.6.3.0-x64.tar.gz -C / --strip 1
sudo cp /home/dad/Git/Workspace/Code/Linux/opentabletdriver.service /usr/local/lib/systemd/user

# Start opentabletdriver daemon.
systemctl --user enable opentabletdriver.service --now