#!/bin/sh
#
# Create an image that can by written onto a SD card using dd.
#
# The disk layout used is:
#
#    0                      -> IMAGE_ROOTFS_ALIGNMENT         - reserved for other data
#    IMAGE_ROOTFS_ALIGNMENT -> BOOT_SPACE                     - bootloader and kernel
#    BOOT_SPACE             -> SDIMG_SIZE                     - rootfs
#
#
#                                                     Default Free space = 1.3x
#                                                     Use IMAGE_OVERHEAD_FACTOR to add more space
#                                                     <--------->
#            4MiB              20MiB           SDIMG_ROOTFS
# <-----------------------> <----------> <---------------------->
#  ------------------------ ------------ ------------------------
# | IMAGE_ROOTFS_ALIGNMENT | BOOT_SPACE | ROOTFS_SIZE            |
#  ------------------------ ------------ ------------------------
# ^                        ^            ^                        ^
# |                        |            |                        |
# 0                      4MiB     4MiB + 20MiB       4MiB + 20Mib + SDIMG_ROOTFS

CURRENT_DIR=$1

# SD Card image
SDIMG=${CURRENT_DIR}/rpi-sdcard.img

echo
echo "*** Building SD-card `basename ${SDIMG}` ***"
echo
# Boot partition size [in KiB] (will be rounded up to IMAGE_ROOTFS_ALIGNMENT)

#BOOT_SPACE="20480"
BOOT_SPACE="40960"

# Set alignment to 4MB [in KiB]
IMAGE_ROOTFS_ALIGNMENT="4096"

# Use an uncompressed ext2/3/4 by default as rootfs
SDIMG_ROOTFS_TYPE="ext2"
SDIMG_ROOTFS="${CURRENT_DIR}/rootfs.${SDIMG_ROOTFS_TYPE}"

# Additional files and/or directories to be copied into the vfat partition from the IMAGE_ROOTFS.
FATPAYLOAD=""

# Align partitions
BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
ROOTFS_SIZE=`du -bks ${SDIMG_ROOTFS} | awk '{print $1}'`
# Round up RootFS size to the alignment size as well
ROOTFS_SIZE_ALIGNED=$(expr ${ROOTFS_SIZE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
ROOTFS_SIZE_ALIGNED=$(expr ${ROOTFS_SIZE_ALIGNED} - ${ROOTFS_SIZE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
SDIMG_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + ${ROOTFS_SIZE_ALIGNED})

echo "Creating filesystem with Boot partition ${BOOT_SPACE_ALIGNED} KiB and RootFS ${ROOTFS_SIZE_ALIGNED} KiB"

# Initialize sdcard image file
dd if=/dev/zero of=${SDIMG} bs=1024 count=0 seek=${SDIMG_SIZE}

# Create partition table
parted -s ${SDIMG} mklabel msdos
# Create boot partition and mark it as bootable
parted -s ${SDIMG} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT})
parted -s ${SDIMG} set 1 boot on
# Create rootfs partition to the end of disk
parted -s ${SDIMG} -- unit KiB mkpart primary ext2 $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT}) -1s

# Create a vfat image with boot files
BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDIMG} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
mkfs.vfat -n "Boot" -S 512 -C ${CURRENT_DIR}/boot.img $BOOT_BLOCKS

# Update cmdline.txt with optional boot params
shift
cat $CURRENT_DIR/../../board/raspberrypi/cmdline.txt | sed -e "s/EXTRA_OPTS/$*/g" > $CURRENT_DIR/rpi-firmware/cmdline.txt
# Copy boot files
mcopy -i ${CURRENT_DIR}/boot.img -s ${CURRENT_DIR}/rpi-firmware/* ::/
# Copy kernel
mcopy -i ${CURRENT_DIR}/boot.img -s ${CURRENT_DIR}/zImage ::zImage

# Burn Partitions
dd if=${CURRENT_DIR}/boot.img of=${SDIMG} conv=notrunc seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SPACE_ALIGNED} + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
rm -f ${CURRENT_DIR}/boot.img
echo
echo "**** Done."
echo "You just have to do 'dd if=$(basename ${SDIMG}) of=<SD card device>'"
echo 
