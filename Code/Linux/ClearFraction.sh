#!/bin/bash

# Run as root/sudo.
if [ ! $(id -u) == 0 ]
then
  echo "This script should be run as root! Exiting ..."
  exit
fi

swupd 3rd-party add clearfraction https://download.clearfraction.cf/update
mkdir -p /etc/environment.d /etc/profile.d
tee -a /etc/environment.d/10-cf.conf << 'EOF'
PATH=$PATH:/opt/3rd-party/bundles/clearfraction/bin:/opt/3rd-party/bundles/clearfraction/usr/bin:/opt/3rd-party/bundles/clearfraction/usr/local/bin
LD_LIBRARY_PATH=/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/lib64:/opt/3rd-party/bundles/clearfraction/usr/local/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}:/opt/3rd-party/bundles/clearfraction/usr/share/:/opt/3rd-party/bundles/clearfraction/usr/local/share/
XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/usr/share/xdg:/etc/xdg}:/opt/3rd-party/bundles/clearfraction/usr/share/xdg:/opt/3rd-party/bundles/clearfraction/etc/xdg
FONTCONFIG_PATH=/usr/share/defaults/fonts${FONTCONFIG_PATH:+:$FONTCONFIG_PATH}
GST_PLUGIN_PATH_1_0=${GST_PLUGIN_PATH_1_0:-/usr/lib64/gstreamer-1.0}:/opt/3rd-party/bundles/clearfraction/usr/lib64/gstreamer-1.0
EOF

tee -a /etc/profile.d/10-cf.sh << 'EOF'
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

echo "Reboot!"