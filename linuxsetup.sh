#!/bin/bash

sudo apt update
sudo apt upgrade

#7z, can be used to mount iso files
# 7z x ubuntu-16.10-server-amd64.iso
sudo apt-get install p7zip-full p7zip-rar


#Visual studio code
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code

# or
sudo snap install code --classic
#other configurations like git lens, c++, cmake recognition?

#sudo snap install --classic code

#Gitkraken
sudo snap install gitkraken --classic



#Git
sudo apt install git
#git config --global user.name "Your Name"
#git config --global user.email "youremail@domain.com"



#Cmake
sudo apt install libssl-dev
sudo apt-get purge cmake    #delete old version
###Get whatever is the latest version
version=3.21.3
wget https://github.com/Kitware/CMake/releases/download/v$version/cmake-$version.tar.gz
tar -zxvf cmake-$version.tar.gz
cd cmake-$version
./bootstrap
make
sudo make install
cmake --version
cd ..
rm -R cmake-$version

#GCC for beaglebone

#OpenCV4

#Qt v5

#qemu emulator

#MISC
sudo apt install graphviz
sudo apt-get install -y picocom

#Eclipse
sudo apt install default-jre
#get the latest version from https://www.eclipse.org/downloads/packages/
#at the  moment, download manually and paste to the same location as this script

sudo mv eclipse-cpp-2020-06-R-linux-gtk-x86_64.tar.gz  /opt/
cd /opt

sudo tar -xvzf eclipse-cpp-2020-06-R-linux-gtk-x86_64.tar.gz
sudo touch eclipse.desktop
sudo cat > eclipse.desktop <<EOL
[Desktop Entry]
Name=Eclipse
Type=Application
Exec=/opt/eclipse/eclipse
Terminal=false
Icon=/opt/eclipse/icon.xpm
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse
Name[en_US]=Eclipse
EOL
sudo desktop-file-install eclipse.desktop


#Qt

#Matlab2020
#installed in usr/local/Polyspace/R2020a/bin/matlab
sudo apt-get install matlab-support

#Similar to tmux in mac
sudo apt-get install terminator

#virtualbox guest additions
sudo apt install virtualbox-guest-utils virtualbox-guest-dkms
sudo apt-get install make gcc linux-headers-$(uname -r)
sudo usermod -a -G vboxsf $USER
#then run virtualboxguestadditions CD

#mount filesystem remotely
sudo apt-get install sshfs
#transfer bootloader and image via tftp
sudo apt install tftpd-hpa
sudo systemctl status tftpd-hpa #check status of tftp
sudo gedit /etc/default/tftpd-hpa    #configure tftp settings like directory, 
                                    # for all files inside /var/lib/tftpboot, sudo chmod 777
sudo systemctl restart tftpd-hpa    #restart tftp

#mounting filesystem via nfs
sudo apt install nfs-kernel-server
#edit /etc/exports
    # /srv/nfs/bbb       192.168.3.2(rw,sync,no_root_squash,no_subtree_check)
        # export the directory called /srv/nfs/bbb as rw to bbb
        # 192.168.3.2 is assumed to be the bbb ip addr
        # rw: This exports the directory as read-write.
        # sync: This option selects the synchronous version of the NFS protocol,
        # no_subtree_check: This option disables subtree checking, which has mild security implications, but can improve reliability in some circumstances.
        # no_root_squash: This option allows requests from user ID 0 to be processed without squashing to a different user ID. It is necessary to allow the target to correctly access the files owned by root.
sudo exportfs -arv    # export all directories
sudo service nfs-kernel-server restart  #restart nfs
    #if you cannot connect via nfs, try tail -f /var/log/syslog
sudo service rpc-statd start    #this is needed so that the client can access the server
                                # try this command in mac to test nfs
                                # sudo mount -o resvport -t nfs 192.168.0.166:/srv/nfs/bbb /private/nfs
                                # bbb still can't nfs, but at least mac can
                                    # now try nfs server inside mac

#Conan
# https://docs.conan.io/en/latest/installation.html
# Keep in mind that conan works only in python3
sudo apt install python3-pip
pip3 install conan
source ~/.profile

# qemu
sudo apt install -y qemu-system-arm
sudo apt-get install -y git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev
sudo apt-get install -y charpath diffstat g++ gawk
# for mender
sudo apt install jq
sudo apt  install docker-compose

# visualize disk usage
sudo apt install baobab

#/home/richard/ssd2/ti-processor-sdk-linux-j7-evm-08_00_00_08
# cannot be installed in ubuntu20
# install under docker instead

#docker
# https://docs.docker.com/engine/install/ubuntu/
# https://docs.docker.com/engine/install/linux-postinstall/
# https://docs.docker.com/compose/install/
    # don't forget to use the latest version

#ssh
sudo apt-get install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

#for balenaetcher
sudo apt install fuse

