#!/bin/bash

sudo service ssh start
USER=$(whoami)

echo $USER
echo -e "test\ntest" | (sudo passwd $USER)

# Correcting card size
cd ${HOME}/build/qemu/image
bzip2 -d rdk-generic-broadband-image-raspberrypi4-64-rdk-broadband.wic.bz2
qemu-img resize -f raw rdk-generic-broadband-image-raspberrypi4-64-rdk-broadband.wic 4G

#starting QEMU
cd ${HOME}/build/qemu

qemu-system-aarch64 \
    -machine raspi3b \
    -dtb bcm2710-rpi-3-b-plus.dtb \
    -m 1G \
    -smp 4 \
    -nographic \
    -kernel image/Image-raspberrypi4-64-rdk-broadband.bin \
    -drive file=image/rdk-generic-broadband-image-raspberrypi4-64-rdk-broadband.wic,if=sd,id=mmc0,index=0,cache=writeback,format=raw \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
    -device usb-net,netdev=eth0 -netdev user,id=eth0,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80
