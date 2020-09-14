#!/bin/bash

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
rm -R cmake*