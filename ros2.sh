#Based from https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html
# set locale
locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

#Setup sources
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

#Install ROS2
sudo apt update
sudo apt upgrade
    #Desktop Install (Recommended): ROS, RViz, demos, tutorials.
sudo apt install ros-foxy-desktop python3-argcomplete
    #Development tools: Compilers and other tools to build ROS packages
sudo apt install ros-dev-tools

#Source ROS startup script
echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

#Install turtlesim
sudo apt update
sudo apt install ros-foxy-turtlesim

#Install rqt
sudo apt update
sudo apt install ~nros-foxy-rqt*

#Setup colcon_cd
echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc
echo "export _colcon_cd_root=/opt/ros/foxy/" >> ~/.bashrc
echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc

#setup workspace based from book, A Concise Introduction to Robot Programming with ROS2
mkdir -p bookros2_ws/src
cd bookros2_ws/src
git clone -b foxy-devel https://github.com/fmrico/book_ros2.git

cd ∼/bookros2_ws/src
vcs import . < book_ros2/third_parties.repos

cd ∼/bookros2_ws
rosdep install --from-paths src --ignore-src -r -y
colcon build --symlink-install

    #to use the packages built inside this folder
    . install/setup.bash

#setup workspace based from tutorial website, https://docs.ros.org/en/foxy/Tutorials.html
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws

git clone https://github.com/ros2/examples src/examples -b foxy

colcon build --symlink-install
colcon test

. install/setup.bash