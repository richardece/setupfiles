
sudo apt-get install build-essential lzop u-boot-tools net-tools bison flex libssl-dev libncurses5-dev libncursesw5-dev unzip chrpath xz-utils minicom wget git-core

#Download linux source
git init
git clone https://github.com/beagleboard/linux.git linux_bbb_4.14

#Compile steps
#STEP 1: ​
/*
 *removes all the temporary folder, object files, images generated during the previous build. 
 *This step also deletes the .config file if created previously 
 */ ​
#make ARCH=arm distclean​
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean

#STEP 2:​
/*creates a .config file by using default config file given by the vendor */ ​
#make ARCH=arm bb.org_defconfig​
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bb.org_defconfig 

#STEP 3:​
/*This step is optional. Run this command only if you want to change some kernel settings before compilation */ ​
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig​
​
#STEP 4:​
/*Kernel source code compilation. This stage creates a kernel image "uImage" also all the device tree source files will be compiled, and dtbs will be generated */ ​
​make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage dtbs LOADADDR=0x80008000 -j4​
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- LOADADDR=0x80008000 uImage dtbs -j4

#STEP 5:​
/*This step builds and generates in-tree loadable(M) kernel modules(.ko) */​
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-  modules  

#STEP 6:​
/* This step installs all the generated .ko files in the default path of the computer (/lib/modules/<kernel_ver>) */​
#sudo make ARCH=arm  modules_install​
sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-  modules_install


#U-Boot
# https://gitlab.denx.de/u-boot/u-boot
git clone https://gitlab.denx.de/u-boot/u-boot.git u-boot-v2019.04
cd u-boot-v2019.04
git checkout v2019.04
#make ARCH=arm am335x_evm_defconfig
#make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- am335x_evm_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- am335x_boneblack_vboot_defconfig
#change delay from 2 to 5 seconds
make ARCH=arm menuconfig​
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig​
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4






