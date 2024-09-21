# To be run manually. Mutatis mutandis for other nases.
vi /usr/sbin/truenas-install
sed -i "s/sgdisk -n3:0:0 -t3:BF01/sgdisk -n3:0:+100GiB -t3:BF01/g" "/usr/sbin/truenas-install"
/usr/sbin/truenas-install
# Pick the TrueNAS install option, and do an install.
# Do a shutdown and remove the TrueNAS installation kit drive. Start TrueNAS box.
# Pick the shell option, and run the commands below:
zpool status boot-pool
lsblk
fdisk -l
sgdisk -n5:0:+100GiB -t5:BF01 /dev/sda # Allocate a 100GB partition for apps/containers/VMs. Can do more (or less) if desired.
sgdisk -n6:0:0 -t6:BF01 /dev/sda # Allocate the rest of the space for data.
partprobe
fdisk -lx /dev/sda
zpool create -f nas0_app /dev/disk/by-partuuid/<sda5_uuid>
zpool create -f nas0_data /dev/disk/by-partuuid/<sda6_uuid>
zpool export nas0_app
zpool export nas0_data