#!/bin/bash

echo -e "\nsearching for files\n"
KERNEL_FILE=$(find build -name Image-raspberrypi4-64-rdk-broadband.bin -print -quit)
RDKB_FILE=$(find build -name rdk-generic-broadband-image-raspberrypi4-64-rdk-broadband.wic.bz2 -print -quit)
DTB_FILE=$(find build -name bcm2710-rpi-3-b-plus.dtb -print -quit)
echo -e "\nDONE\n"

mkdir -p build/qemu/image

echo -e "\ncopying ${KERNEL_FILE} to build/qemu/image\n"
cp $KERNEL_FILE build/qemu/image
echo -e "\nDONE\n"

echo -e "\ncopying ${RDKB_FILE} to build/qemu/image\n"
cp $RDKB_FILE build/qemu/image
echo -e "\nDONE\n"

echo -e "\ncopying ${DTB_FILE} to build/qemu/image\n"
cp $DTB_FILE build/qemu/
echo -e "\nDONE\n"

tar zcvf rdk-b_artifacts.tar.gz build/qemu
