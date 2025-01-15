#!/bin/bash

# Do NOT run as root/sudo.
if [ "$(id -u)" == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

# Copy Input Remapper rules and other config files.
# mkdir -p ~/.config/input-remapper-2/presets/"Logitech M720 Triathlon Multi-Device Mouse"
# mkdir -p ~/.config/input-remapper-2/presets/"M720 Triathlon"
# mkdir -p ~/.config/input-remapper-2/presets/"Logitech M720 Triathlon"
mkdir -p ~/.config/input-remapper-2/presets/"Logitech USB Receiver"
# cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/Default.json ~/.config/input-remapper-2/presets/"Logitech M720 Triathlon Multi-Device Mouse"
# cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/Default.json ~/.config/input-remapper-2/presets/"M720 Triathlon"
# cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/Default.json ~/.config/input-remapper-2/presets/"Logitech M720 Triathlon"
cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/Default.json ~/.config/input-remapper-2/presets/"Logitech USB Receiver"
cp ~/Git/Workspace/Code/Linux/BuildScripts/InputRemapper/config.json ~/.config/input-remapper-2