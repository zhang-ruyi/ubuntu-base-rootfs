#!/bin/bash

LROOT=$PWD
export KERNEL_PATH=$LROOT/linux_dbg

SMP="-smp 4"
DBG="-s -S"



run_qemu_ubuntu(){
		qemu-system-x86_64 -m 2G\
            -append "noinintrd console=ttyS0 root=/dev/vda rootfstype=ext4 rw loglevel=8" \
			-drive if=none,file=rootfs.ext4.img,id=hd0 \
			-device virtio-blk-pci,drive=hd0 \
			-nographic $SMP -kernel $KERNEL_PATH/arch/x86/boot/bzImage \
			$DBG
}

run_qemu_ubuntu
