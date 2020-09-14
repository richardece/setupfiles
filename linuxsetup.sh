#!/bin/bash

sudo apt update
sudo apt upgrade

#Visual studio code
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code
#other configurations like git lens, c++, cmake recognition?

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
version=3.18.2
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

#Eclipse
sudo apt install default-jre
#get the latest version from https://www.eclipse.org/downloads/packages/
#at the  moment, download manually and paste to the same location as this script

sudo mv eclipse-cpp-2020-06-R-linux-gtk-x86_64.tar.gz  /opt/
cd /opt

sudo tar -xvzf eclipse-cpp-2020-06-R-linux-gtk-x86_64.tar.gz
touch eclipse.desktop
cat > eclipse.desktop <<EOL
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



