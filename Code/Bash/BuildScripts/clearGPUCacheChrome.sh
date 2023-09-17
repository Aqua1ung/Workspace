#!/bin/bash

# Do NOT run as root! 
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit
fi

find /home/"$USER"/.config/google-chrome -type d -name GPUCache | while read path
do
rm "$path"/*
done