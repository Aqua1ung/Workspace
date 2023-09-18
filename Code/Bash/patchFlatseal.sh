#!/bin/bash

# Do NOT run as root!

# Patch Chrome permissions in FlatSeal for the installation of PWAs.
flatpak override --user --filesystem=/home/dad/.local/share/applications:create --filesystem=/home/dad/.local/share/icons:create com.google.Chrome
