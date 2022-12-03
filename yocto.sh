#Docker setup
docker build -t yocto .
sudo docker run --rm -it -v /home/dev:/home/dev <imageID> bash
docker run --rm -it -v /home/dev:/home/dev 479dc68838e1 bash
sudo docker exec -it  <containerID> bash

##########################################################################
# Based from Mastering Embedded Linux Programming by Simmonds, 3rd Edition
~$ git clone -b dunfell git://git.yoctoproject.org/poky.git

#build
~$ source poky/oe-init-build-env build-qemuarm
#edit conf/local.conf, change DL to TOPDIR/../downloads so that all downloads are in common folder

#this will take 2hours in parallels, LAN cable
#30-40mins in M75Q gen2, Ubuntu 22.04, downloads folder already available
bitbake core-image-minimal
bitbake console-image
bitbake qt5-image
#run (works even inside docker)
runqemu qemuarm slirp nographic


##########################################################################
# Based from https://jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Yocto.html
~$ git clone -b dunfell git://git.yoctoproject.org/poky.git
~$ cd poky
~/poky$ git clone -b dunfell git://git.openembedded.org/meta-openembedded
~/poky$ git clone -b dunfell https://github.com/meta-qt5/meta-qt5
~/poky$ git clone -b dunfell git://git.yoctoproject.org/meta-raspberrypi
~/poky$ git clone -b dunfell git://git.yoctoproject.org/meta-security.git
~/poky$ git clone -b dunfell https://github.com/jumpnow/meta-jumpnow
~/poky$ cd ..
~$ git clone -b dunfell https://github.com/jumpnow/meta-rpi.git
#inside docker
~$ source poky/oe-init-build-env build-rpi3/
~/build-rpi3$ mv conf conf.old
~/build-rpi3$ cp -r ../meta-rpi/conf/ .
# edit paths inside bblayers.conf
# edit paths TMPDIR, DL_DIR, and  SSTATE_DIR
    # one common folder for all downloads (simmonds and jumpnowtek)
    # common folder for sstate and tmp for jumpnowtek. This way, we can simultaneously build simmonds and jumpnowtek
# you may remove the user jumpnowtek
~/build-rpi3$ c bitbake console-image
# alternate option is qt5-image


##########################################################################
#Based from https://jumpnowtek.com/beaglebone/BeagleBone-Systems-with-Yocto.html
#use the same poky folder as above
~$ git clone -b dunfell https://github.com/jumpnow/meta-bbb.git
#inside docker
~$ source poky/oe-init-build-env build-bbb/
~/build-bbb$ mv conf conf.old
~/build-bbb$ cp -r ../meta-bbb/conf/ .
#edit local.conf and bblayers.conf
~/build-bbb$ c bitbake console-image
# alternate option is qt5-image and installer-image.bb





###########################################################
# AM335x    
# based on https://software-dl.ti.com/processor-sdk-linux/esd/docs/07_03_00_005/linux/Overview_Building_the_SDK.html
# Install ARM toolchain
$ wget https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz
$ tar -Jxvf gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz -C $HOME
$ wget https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz
$ tar -Jxvf gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz -C $HOME
# Clone the source codes
$ git clone git://arago-project.org/git/projects/oe-layersetup.git tisdk
$ cd tisdk
$ ./oe-layertool-setup.sh -f configs/coresdk/coresdk-<version>-config.txt
$ ./oe-layertool-setup.sh -f configs/processor-sdk/processor-sdk-dunfell-07.01.00.txt
$ ./oe-layertool-setup.sh -f configs/processor-sdk/processor-sdk-08.03.00.19-config.txt
#remember to open the txt file and replace "git" with "https" 
# and http://arago-project.org/git/projects/meta-psdkla.git
# and fix oe-layertool-setup.sh line 876, replace == with =
$ cd build
$ . conf/setenv
$ export TOOLCHAIN_PATH_ARMV7=/home/dev/am335x/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf
$ export TOOLCHAIN_PATH_ARMV8=/home/dev/am335x/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
$ export TOOLCHAIN_PATH_ARMV7=/home/dev/tisdk//gcc/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf
$ export TOOLCHAIN_PATH_ARMV8=/home/dev/tisdk//gcc/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu

docker run --rm -it -v /home/dev:/home/dev 171 bash
# zsh cannot find bitbake

# Build the SDK
$ MACHINE=<machine> bitbake tisdk-base-image

$ MACHINE=am335x-evm bitbake arago-core-psdkla-bundle # not compatible with AM335x
$ MACHINE=am335x-evm bitbake core-image-full-cmdline


###########################################################
# Based on udemy course beaglebone black linux device driver
# https://github.com/niekiran/linux-device-driver-1
# https://github.com/nghiaphamsg/BeagleBoneBlack_Linux_Device_Driver
# main idea is that the device driver compilation needs to know the linux kernel headers of the target
# either we build the device driver in the target itself, or we build the kernel
# simply copying the kernel headers (/lib/modules/5.xxx) is not enough because we need to pair it with the exact cross-compiler which is difficult to find
# need to build the kernel, replace the kernel in the SD card 
mkdir custom_drivers patches source downloads

# target setup (BBB SD card)
# create BOOT (fat16, flags boot and lba) and ROOTFS (ext4)
# this exact version was used in the course. we will get the rootfs from here
wget -c https://debian.beagleboard.org/images/bone-debian-9.9-iot-armhf-2019-08-03-4gb.img.xz
# decompress the image, the result will be an img file
unxz bone-debian-9.9-iot-armhf-2019-08-03-4gb.img.xz
# mount the image file (right click on image, then mount). Better to do this in ubuntu
# copy everything from image file into ROOTFS
# current version is 4.14.108-ti-r113
# need to restart and observe, maybe the sd did not sync properly aafter copying the rootfs
# seems to work fine after re-flashing
    # if we simply flash the image, the newer images seem to have a different format. there is no more fat16 or fat32 partition.
    # instead, they have an MBR and ext4 partition
    # probably, it is not easy to replace tje zImage inside the MBR
    # that is why we copy just the rootfs to ROOTFS partition 
    # and copy the downloads/pre-built-images/SD-boot to BOOT partition
# try not to install anything else and do not update the system. we'll use this only for flashing 

# host setup (Ubuntu 20.04)
sudo apt-get update
sudo apt-get install build-essential lzop u-boot-tools net-tools bison flex libssl-dev \
    libncurses5-dev libncursesw5-dev unzip chrpath xz-utils minicom wget git-core 


# download tool chain
https://snapshots.linaro.org/gnu-toolchain/11.2-2022.02-1/arm-linux-gnueabihf/
https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads
wget -c https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz     #this is old version, but exactly same as in udemy
export PATH=$PATH:/home/dev/linux_bbb_kiran/downloads/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin

# SD card must be pre=flashed already with the official image
# build kernel
    # clone linux kernel https://github.com/beagleboard/linux/tree/v5.14
    make ARCH=arm distclean
    make ARCH=arm bb.org_defconfig  # for v4.14
    or make ARCH=arm omap2plus_defconfig    #for v5.15
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage dtbs LOADADDR=0x80008000 -j4
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-  modules  -j4
    sudo make ARCH=arm  modules_install #This will copy the modules to  /lib/modules folder, but the size is too big for some reason
    sudo make ARCH=arm  INSTALL_MOD_PATH=<path to rfs> modules_install # better to use this as the size does not get too big, although a bit different from the course
    # copy arch/arm/boot/uImage to sd card BOOT partition
    # copy the /lib/modules/5xxx folder into the sd card ROOTFS//lib/modules/ folder
        # ideally, the dtbs must be updated also
        # ideally, the /boot/uEnv.txt uname-r must be updated also
        # but since the old version and new version are both roughly 4.14, maybe this is not needed
            # if we scp the /lib/modules/<kernel version>, this folder is too big
            # need to install module in another folder, then zip it before scp to a pc that has the sd card
    # reset the board

# to build:
    # exit docker
    export PATH=$PATH:/home/dev/linux_bbb_kiran/downloads/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin
    make # run in target
    make host # run in host
    make deploy # scp ko file to target
    # good Makefile
    obj-m := main.o
    ARCH=arm
    CROSS_COMPILE=arm-linux-gnueabihf-
    KERN_DIR = /home/dev/linux_bbb_kiran/source/linux_bbb_4.14/
    HOST_KERN_DIR = /lib/modules/$(shell uname -r)/build/

    all:
        make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERN_DIR) M=$(PWD) modules
    clean:
        make -C $(HOST_KERN_DIR) M=$(PWD) clean
        make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERN_DIR) M=$(PWD) clean
    help:
        make ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERN_DIR) M=$(PWD) help
    host:
        make -C $(HOST_KERN_DIR) M=$(PWD) modules
    deploy:
        scp *.ko debian@192.168.0.122:/home/debian
    


###########################################################
# LDD beaglebone black by Derek Molloy
# https://github.com/derekmolloy/exploringBB
# He compiles the device driver inside the BBB itself
# Setup
    # Find the kernel version of the BBB
    uname -a
    # Download the correspondin glinux headers
    apt-cache search linux-headers-$(uname -r)
    sudo apt install linux-headers-$(uname -r)
    # kernle headers iwll be stored in /lib/modules/



###########################################################
# use the SDK to build the kernel
# SDK and target image copied to Ubuntu parallels. need to flash and test


###########################################################
# Follow https://elinux.org/EBC_Exercise_08_Installing_Development_Tools_4.4
# He describes an easier way to build the BBB linux kernel and updating the sd card


###########################################################
#  linux  driver development with Raspberry pi 3  - Practical labs
# https://github.com/ALIBERA/linux_raspberrypi_book
# this one uses 32-bit toolchain for a 32-bit kernel: crossbuild-essential-armhf (installed in ryo Dockerfile)
git clone --depth=1 -b rpi-5.4.y https://github.com/raspberrypi/linux
KERNEL=kernel7
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig  #rpi3b only
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
Device drivers >
    [*] SPI support  --->
        <*>   User mode SPI device driver support
Device drivers >
    <*> Industrial I/O support  --->
        -*-   Enable buffer support within IIO
        -*- Industrial I/O buffering based on kfifo
        <*> Enable IIO configuration via configfs
        -*- Enable triggered sampling support
        <*> Enable software IIO device support
        <*> Enable software triggers support
            Triggers - standalone  --->
                <*> High resolution timer trigger
                <*> SYSFS trigger
Device drivers >
    <*> Userspace I/O drivers  --->
        <*>   Userspace I/O platform driver with generic IRQ handling
Device drivers >
    Input device support  --->
        -*-   Generic input layer (needed for keyboard, mouse, ...)
            <*>   Polled input device skeleton
Device drivers >
    <*> Industrial I/O support  > Humidity sensors --->
        <*> STMicroelectronics HTS221 sensor Driver

make -j4 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs


# This can now be compiled in host
# need to follow instruction show to update the rpi3+ software in sd card





##########################################################################
# Based from Embedded Linux Development Using Yocto Project Cookbook 2nd ed by Alex Gonzalez 
# How to get the sources (execute inside the host)
# mkdir ~/bin
# curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    # repo is a script that will download the sources for us
# chmod a+x ~/bin/repo
# export PATH=${PATH}:~/bin
# mkdir -p fsl-community-bsp && cd fsl-community-bsp 
# repo init -u https://github.com/Freescale/fsl-community-bsp-platform -b rocko
    # if there is a python error
    # sudoo apt-get install python-as-python3
# repo sync

# How to build (inside docker)
# docker run -it --rm -v /home/dev/:/home/dev/ <image ID of imx6-gonzales>
# cd fsl-community-bsp 
# mkdir -p wandboard
# MACHINE=wandboard DISTRO=poky source setup-environment build-wandboard
# bitbake core-image-minimal
# bitbake core-image-minimal -c populate_sdk_ext #got error, but was previously ok. why?? solution is to do clean build
