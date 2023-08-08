# ubuntu-base-rootfs
qemu+vscode+ubuntu-base-rootfs debug kernel&amp;modules

## 下载base镜像：
* http://cdimage.ubuntu.com/ubuntu-base/releases/xx.xx.xx/release/
解压：
* tar -zxf ubuntu-xx-base-amd64.tar.gz -C rootfs/
## install host software
* apt-get install qemu-user-static
## copy host config
cp /usr/bin/qemu-amd64-static rootfs/usr/bin
cp -b /etc/resolv.conf rootfs/etc/

## chroot to rootfs 
* chroot_u_mount.sh
``` bash
  #!/bin/bash
  # 
  function mnt() {
      echo "MOUNTING"
      sudo mount -t proc /proc ${2}proc
      sudo mount -t sysfs /sys ${2}sys
      sudo mount -o bind /dev ${2}dev
      sudo mount -o bind /dev/pts ${2}dev/pts		
      sudo chroot ${2}
  }
  function umnt() {
      echo "UNMOUNTING"
      sudo umount ${2}proc
      sudo umount ${2}sys
      sudo umount ${2}dev/pts
      sudo umount ${2}dev
  }
  if [ "$1" == "-m" ] && [ -n "$2" ] ;
  then
      mnt $1 $2
  elif [ "$1" == "-u" ] && [ -n "$2" ];
  then
      umnt $1 $2
  else
      echo ""
      echo "Either 1'st, 2'nd or both parameters were missing"
      echo ""
      echo "1'st parameter can be one of these: -m(mount) OR -u(umount)"
      echo "2'nd parameter is the full path of rootfs directory(with trailing '/')"
      echo ""
      echo "For example: ch-mount -m /media/sdcard/"
      echo ""
      echo 1st parameter : ${1}
      echo 2nd parameter : ${2}
  fi
```
* chmod +x chroot_u_mount.sh
* ./chroot_u_mount.sh -m rootfs/

## install essentials software
``` bash
apt-get install \
  language-pack-en-base \
  sudo \
  ssh \
  net-tools \
  network-manager \
  iputils-ping \
  rsyslog \
  bash-completion 
  
apt install gcc gdb tmux wget curl vim kmod -y
```
## add user && change passwd
* useradd -s '/bin/bash' -m -G adm,sudo yourusername
* passwd yourusername
* passwd root

## chroot to host
* exit
* ./chroot_u_mount.sh -u rootfs/

## Make rootfs.img#!/bin/bash
* make_rootfs_img.sh
* chmod +x make_rootfs_img.sh
* sudo make_rootfs_img.sh
``` bash
  image_name=$1
  set -x
  rm -rf tmpfs ${image_name}.img ${image_name}.img.tar.gz
  dd if=/dev/zero of=${image_name}.img bs=1G count=4
  mkfs.ext4 ${image_name}.img
  mkdir -p tmpfs
  mount ${image_name}.img tmpfs
  cp -rfp ./ubuntu-amd64/* ./tmpfs/
  umount tmpfs
  e2fsck -p -f ${image_name}.img
  resize2fs -M ${image_name}.img
  tar zcf ${image_name}.img.tar.gz ${image_name}.img
```

ref: https://www.e-learn.cn/topic/314415
