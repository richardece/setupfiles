#Ideally, this is the installation procedure. But its is looking for some dependencies with cannot be resilved

#So we follow this:
# http://wiki.ros.org/noetic/Installation/Source
#We compile ROS from source

#Install dependencies
sudo apt-get install python3-rosdep python3-rosinstall-generator python3-vcstool build-essential
sudo apt install python-is-python3

#Initialize rosdep
sudo rosdep init
rosdep update

#Download the source code for ROS packages so we can build them
mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws
rosinstall_generator desktop --rosdistro noetic --deps --tar > noetic-desktop.rosinstall
mkdir ./src
vcs import --input noetic-desktop.rosinstall ./src

# Resolve dependencies
rosdep install --from-paths ./src --ignore-packages-from-source --rosdistro noetic -y

# Build catkin workspace
./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3
#it will install everything into ~/ros_catkin_ws/install_isolated

#Inlude this into ~/.bashrc
source ~/ros_catkin_ws/install_isolated/setup.bash

#Udemy course: ROS For Beginners: Basics, Motion and OpenCV
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
cd src
git clone -b ros-noetic https://github.com/aniskoubaa/ros_essentials_cpp.git
cd ..
catkin_make

#test
source ~/.bashrc
roscore
. ~/catkin_ws/devel/setup.bash  #need to run this every time a terminal is opened
rosrun ros_essentials_cpp talker_node
rosrun ros_essentials_cpp listener_node

#ROS package = project
#

#ROS commands
rosrun turtlesim turtlesim_node
rosrun turtlesim turtle_teleop_key
#list all nodes
rosnode list
#list all topics
rostopic list

#Print the publisher and subscriber of the topic
#This will also show the message type of the topic
rostopic info /turtle1/pose

#Print the services, publishers and subscribers of the node
rosnode info /turtle1

#Show the content of a msg
#geometry_msgs/Twist is called message type
rosmsg show geometry_msgs/Twist

#publish a message on a topic
#Supposed to run 10 times, but seems that it won't stop
#/turtle1/cmd_vel is the topic
#geometry_msgs/Twist is the message type
#To find the message type of a topic, use "rostopic info /turtle1/cmd_vel"
rostopic pub -r 10 /turtle1/cmd_vel geometry_msgs/Twist '{linear: {x: 0.1, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}}'

#Show the overview of messages, publishers and subcribers
rosrun rqt_graph rqt_graph

#Print all the contents of the topic when a data is published
rostopic echo /turtle1/cmd_vel


