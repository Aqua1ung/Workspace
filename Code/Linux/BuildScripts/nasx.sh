# To be run manually. Mutatis mutandis for other nases.
vi /usr/sbin/truenas-install
sed -i "s/sgdisk -n3:0:0 -t3:BF01/sgdisk -n3:0:+100GiB -t3:BF01/g" "/usr/sbin/truenas-install"
/usr/sbin/truenas-install
# Pick the TrueNAS install option, and do an install.
# Do a shutdown and remove the TrueNAS installation kit drive. Start TrueNAS box.
# Pick the shell option, and run the commands below:
zpool status boot-pool
lsblk # To figure out what <drive> you want to store apps/containers/VMs on.
fdisk -l
sgdisk -n5:0:+100GiB -t5:BF01 /dev/<drive> # Allocate a 100GB partition for apps/containers/VMs. Can do more (or less) if desired.
sgdisk -n6:0:0 -t6:BF01 /dev/<drive> # Allocate the rest of the space for data.
partprobe
fdisk -lx /dev/<drive>
zpool create -f nas<x>_app /dev/disk/by-partuuid/<drive_uuid>
# Ignore any "cannot mount" errors.
zpool create -f nas<x>_data /dev/disk/by-partuuid/<drive_uuid>
zpool export nas<x>_app
zpool export nas<x>_data