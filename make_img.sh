#!/bin/bash
image_name=rootfs.ext4
set -x
rm -rf tmpfs ${image_name}.img
dd if=/dev/zero of=${image_name}.img bs=1G count=10
mkfs.ext4 ${image_name}.img
mkdir -p tmpfs
mount ${image_name}.img tmpfs
cp -rfp ./rootfs/* ./tmpfs/
umount tmpfs
e2fsck -p -f ${image_name}.img
#resize2fs -M ${image_name}.img
#tar zcf ${image_name}.img.tar.gz ${image_name}.img
