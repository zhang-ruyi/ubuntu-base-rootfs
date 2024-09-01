#!/bin/bash

LROOT=$PWD
platform=_amd64
export KERNEL_PATH=$LROOT/linux-dbg

SMP="-smp 1"
DBG="-s -S"

run_qemu_ubuntu(){
		qemu-system-x86_64 -m 2G\
            -append "noinintrd console=ttyS0 root=/dev/vda rootfstype=ext4 rw nokaslr loglevel=8" \
			-drive if=none,file=rootfs${platform}.ext4.img,id=hd0 \
			-device virtio-blk-pci,drive=hd0 \
			-nographic $SMP -kernel $KERNEL_PATH/arch/x86/boot/bzImage \
			$DBG
}

run_qemu_ubuntu
