#on the host
git clone -b dunfell git://git.yoctoproject.org/poky.git
cd poky
git clone -b dunfell git://git.openembedded.org/meta-openembedded
git clone -b dunfell https://github.com/meta-qt5/meta-qt5.git
git clone -b dunfell git://git.yoctoproject.org/meta-security.git

#enter the docker
#Dockerfile must be in the same folder
docker build -t yocto .
sudo docker run --rm -it -v ~/dev/yocto:/home/dev <imageID> bash
sudo docker exec -it  <containerID> bash

#build
source poky/oe-init-build-env build-qemuarm
#this will take 2hours in parallels, LAN cable
bitbake core-image-minimal

bitbake console-image
bitbake qt5-image
#run
runqemu qemuarm slirp nographic

#try if poky is in external ssd

