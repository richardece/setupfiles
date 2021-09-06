#Install build dependencies
sudo apt install git bc bison flex libssl-dev make libc6-dev libncurses5-dev

#Install 32-bit toolchain for 32-bit kernel
sudo apt install crossbuild-essential-armhf

#Clone kernel source
git clone --depth=1 -b rpi-5.4.y https://github.com/raspberrypi/linux

#Compile the kernel, modules and Device Tree files.
#Apply default configuration
cd linux
KERNEL=kernel7
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
make -j4 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs


###########
#TIPS
#1. Use docker to build the kernel
#2. Use Virtualbox to flash the image
