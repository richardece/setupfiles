#####################
#Strategy 1: Run an ubuntu docker and then isntall everything inside
#Problem: error in compiling at 72%

docker run -it ubuntu bash

#Follow official opencv instructions
apt install update -y
apt install -y g++
apt install -y make
apt install -y cmake

apt install -y ninja-build
apt install -y wget unzip
apt install -y git
apt install libgtk2.0-dev pkg-config \
    libavcodec-dev libavformat-dev libswscale-dev -y
apt install -y libopencv-dev yasm libjpeg-dev  libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libv4l-dev python-dev python-numpy libtbb-dev  libgtk2.0-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils pkg-config
#libqt4-dev libjasper-dev
apt install libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev 
apt install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev

OPENCV_VERSION="4.5.0"
mkdir /tmp/openCV-$OPENCV_VERSION
mkdir /tmp/openCV-contrib-$OPENCV_VERSION
git clone --recursive -j6 https://github.com/opencv/opencv.git /tmp/openCV-$OPENCV_VERSION
cd /tmp/openCV-$OPENCV_VERSION
git checkout tags/$OPENCV_VERSION
git clone --recursive -j6 https://github.com/opencv/opencv_contrib.git /tmp/openCV-contrib-$OPENCV_VERSION
cd /tmp/openCV-contrib-$OPENCV_VERSION
git checkout tags/$OPENCV_VERSION
mkdir /tmp/build
cd /tmp/build
cmake -DWITH_GTK=ON -DOPENCV_EXTRA_MODULES_PATH=../openCV-contrib-$OPENCV_VERSION/modules ../openCV-$OPENCV_VERSION
cmake --build . -j6


#Strategy2:
#use dockerfile and install everything including #libqt4-dev libjasper-dev
#still got error at 67%


