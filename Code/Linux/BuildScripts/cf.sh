#!/bin/bash

# Do NOT run as root/sudo.
if [ "$(id -u)" == 0 ]
then
  echo "This script should NOT be run as root! Exiting ..."
  exit 1
fi

case $1 in

  --remove | -rm)
    echo "Removing ClearFraction 3-rd party repository ..."
    sudo swupd 3rd-party remove clearfraction # && sudo swupd 3rd-party add clearfraction https://clearfraction.vercel.app/update
    ;;

  *)
    echo "Adding ClearFraction repository ..."
    # Add ClearFraction repo.
    sudo swupd 3rd-party add clearfraction https://clearfraction.vercel.app/update
    sudo mkdir -p /etc/environment.d /etc/profile.d
    sudo tee -a /etc/environment.d/10-cf.conf << EOF
PATH=/usr/bin/haswell:/usr/bin:/usr/local/bin:/opt/3rd-party/bundles/clearfraction/bin:/opt/3rd-party/bundles/clearfraction/usr/bin:/opt/3rd-party/bundles/clearfraction/usr/local/bin
LD_LIBRARY_PATH=/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/local/lib64
XDG_DATA_DIRS=/usr/share:/usr/local/share:/opt/3rd-party/bundles/clearfraction/usr/share:/opt/3rd-party/bundles/clearfraction/usr/local/share:/home/$USER/.local/share/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share
XDG_CONFIG_DIRS=/usr/share/xdg:/etc/xdg:/opt/3rd-party/bundles/clearfraction/usr/share/xdg:/opt/3rd-party/bundles/clearfraction/etc/xdg
FONTCONFIG_PATH=/usr/share/defaults/fonts
GST_PLUGIN_PATH_1_0=/usr/lib64/gstreamer-1.0:/opt/3rd-party/bundles/clearfraction/usr/lib64/gstreamer-1.0
EOF

    sudo tee -a /etc/profile.d/10-cf.sh << 'EOF'
[[ ! ${PATH} =~ "/opt/3rd-party/bundles/clearfraction/bin" ]] && \
  PATH=$PATH:/opt/3rd-party/bundles/clearfraction/bin:/opt/3rd-party/bundles/clearfraction/usr/bin:/opt/3rd-party/bundles/clearfraction/usr/local/bin

[[ ! ${LD_LIBRARY_PATH} =~ "/opt/3rd-party/bundles/clearfraction/usr/lib64" ]] && \
  LD_LIBRARY_PATH=/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/local/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

[[ ! ${XDG_DATA_DIRS} =~ "/opt/3rd-party/bundles/clearfraction/usr/share" ]] && \
  XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}:/opt/3rd-party/bundles/clearfraction/usr/share/:/opt/3rd-party/bundles/clearfraction/usr/local/share/

[[ ! ${XDG_CONFIG_DIRS} =~ "/opt/3rd-party/bundles/clearfraction/usr/share/xdg" ]] && \
  XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/usr/share/xdg:/etc/xdg}:/opt/3rd-party/bundles/clearfraction/usr/share/xdg:/opt/3rd-party/bundles/clearfraction/etc/xdg

[[ ! ${FONTCONFIG_PATH} =~ "/usr/share/defaults/fonts" ]] && \
  FONTCONFIG_PATH=/usr/share/defaults/fonts${FONTCONFIG_PATH:+:$FONTCONFIG_PATH}

[[ ! ${GST_PLUGIN_PATH_1_0} =~ "/opt/3rd-party/bundles/clearfraction/usr/lib64/gstreamer-1.0" ]] && \
  GST_PLUGIN_PATH_1_0=${GST_PLUGIN_PATH_1_0:-/usr/lib64/gstreamer-1.0}:/opt/3rd-party/bundles/clearfraction/usr/lib64/gstreamer-1.0
EOF
      ;;
esac