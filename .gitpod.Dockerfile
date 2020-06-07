FROM gitpod/workspace-full

USER root

# setup timezone
# RUN echo 'Etc/UTC' > /etc/timezone && \
#     ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
#     apt-get update && apt-get install -q -y tzdata && rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y \
    bash-completion \
    dirmngr \
    gnupg2 \
    lsb-release \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros2-latest.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# install python packages
RUN pip3 install -U \
    argcomplete \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures
# This is a workaround for pytest not found causing builds to fail
# Following RUN statements tests for regression of https://github.com/ros2/ros2/issues/722
RUN pip3 freeze | grep pytest \
    && python3 -m pytest --version

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# clone source
ENV ROS2_WS /opt/ros2_ws
RUN mkdir -p $ROS2_WS/src

# download WRLabs SDK
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3-lark-parser \
    lbzip2 \
    qemu \
    net-tools \
    uml-utilities \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/wrsdk
ARG FILEID=1udiF9ImT28dKNDQWfLK0h_YgDhpRRAaS
ARG FILENAME=wrsdk-vxworks7-qemu-1.7.tar.bz2
# RUN wget --no-check-certificate https://labs.windriver.com/downloads/$FILENAME -O /opt/wrsdk/$FILENAME
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --show-progress --no-check-certificate 'https://docs.google.com/uc?export=download&id=1udiF9ImT28dKNDQWfLK0h_YgDhpRRAaS' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1udiF9ImT28dKNDQWfLK0h_YgDhpRRAaS" -O /opt/wrsdk/$FILENAME && rm -rf /tmp/cookies.txt

# setup tap
# RUN tunctl -u gitpod -t tap0
# RUN ifconfig tap0 192.168.200.254 up

USER gitpod

# uncompress SDK
RUN sudo chown -R gitpod:gitpod /opt/
RUN tar xfv /opt/wrsdk/$FILENAME -C /opt --use-compress-program=lbzip2
