# To be run manually.
vi /usr/sbin/truenas-install
sed -i “s/sgdisk -n3:0:0 -t3:BF01/sgdisk -n3:0:+100GiB -t3:BF01/g” “/usr/sbin/truenas-install”
/usr/sbin/truenas-install

# Do a shutdown and remove the TrueNAS installation kit drive. Start TrueNAS box.

zpool status boot-pool
lsblk
fdisk -l
sgdisk -n5:0:+100GiB -t5:BF01 /dev/sda
sgdisk -n6:0:0 -t6:BF01 /dev/sda
partprobe
fdisk -lx /dev/sda
zpool create -f nas0_app /dev/disk/by-partuuid/<sda5_uuid>
zpool create -f nas0_data /dev/disk/by-partuuid/<sda6_uuid>
zpool export nas0_app
zpool export nas0_data