# inspired from https://github.com/gramaziokohler/ros_docker/blob/master/ros-noetic-base/Dockerfile


FROM ros:noetic as basic_build
SHELL ["/bin/bash","-c"]

#install packages
RUN apt-get update \
    && apt-get install -y \
    # Basic utilities
    git \
    net-tools \ 
    iputils-ping \
    dnsutils \
    vim\
    # ROS bridge server and related packages
    ros-noetic-rosbridge-server \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV CATKIN_WS=/workspace/catkin_ws
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS/src

# Initialize local catkin workspace
RUN source /opt/ros/noetic/setup.bash \
    && apt-get update \
    # Install dependencies
    && cd $CATKIN_WS \
    && rosdep install -y --from-paths . --ignore-src --rosdistro noetic \
    # Build catkin workspace
    && catkin_make