FROM osrf/ros:humble-desktop

# Tell the container to use the C.UTF-8 locale for its language settings
ENV LANG C.UTF-8

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install required packages
RUN apt-get update && apt-get install -y \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-ros2-control \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-joint-state-publisher \
    ros-humble-robot-state-publisher \
    ros-humble-xacro \
    ros-humble-tf2-ros \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-ament-cmake-gtest \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Link python3 to python otherwise ROS scripts fail when using the OSRF contianer
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set up the ros2_ws workspace
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws/src
COPY fastbot/fastbot_gazebo ./fastbot_gazebo
COPY fastbot/fastbot_description ./fastbot_description
COPY fastbot_waypoints ./fastbot_waypoints

# Make the test script executable
RUN chmod +x /ros2_ws/src/fastbot_waypoints/scripts/run_test.sh

# build
WORKDIR /ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc \
 && echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# Set up the Network Configuration
# Example with the ROS_MASTER_URI value set as the one running on the Host System
# ENV ROS_MASTER_URI http://1_simulation:11311

# Cleanup
RUN rm -rf /root/.cache

# Start a test
CMD ["bash", "-c", \
"source /opt/ros/humble/setup.bash && \
 source /ros2_ws/install/setup.bash && \
 /ros2_ws/src/fastbot_waypoints/scripts/run_test.sh"]