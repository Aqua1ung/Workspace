#!/bin/bash

# Do NOT run as root! 
if [ $(id -u) == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

echo "Clearing Chrome's GPUCache ..."
for i in $(find ~/.config ~/.var -type d -name "GPUCache" 2>/dev/null); do rm -rf ${i}; done
echo "Done. In case you notice 'cannot remove' error messages, that means that the cache was already empty."