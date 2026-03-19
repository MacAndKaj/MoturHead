FROM arm64v8/ros:humble

SHELL ["/bin/bash", "-c"]

ENV ROS_DISTRO=humble
ENV BOOST_VER=boost_1_86_0
ENV BOOST_ROOT=/opt/boost
ENV USER_DIR=/home/user

ARG MOTUR_HEAD_PLATFORM=https://github.com/MacAndKaj/MoturHeadPlatform.git
ARG BOOST_WGET_LINK=https://archives.boost.io/release/1.86.0/source/${BOOST_VER}.tar.gz

RUN apt-get update || true && \
    apt-get install -y curl gnupg2 lsb-release && \
    rm -f /etc/apt/sources.list.d/ros2.list && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
        -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=arm64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" \
        > /etc/apt/sources.list.d/ros2.list

RUN apt-get update

RUN apt-get install -y \
    gcc \
    make\
    build-essential \
    pkg-config \
    git \
    wget \
    unzip \
    tar \
    vim \
    ssh \
    net-tools \
    python3 \
    python3-dev \
    pip	\
    ca-certificates \
    && apt-get clean

RUN cd /tmp                                                     && \
    wget ${BOOST_WGET_LINK}                                     && \
    tar -zxvf ${BOOST_VER}.tar.gz                               && \
    cd ${BOOST_VER}                                             && \
    ./bootstrap.sh --prefix=/usr/local --with-libraries=json    && \
    ./b2 --help                                                 && \
    ./b2 --with-json -j4 install

ENV BOOST_LIBRARIES=date_time,json,log,program_options,filesystem,system,regex

RUN cd /tmp                                 && \
    wget ${BOOST_WGET_LINK}                 && \
    tar -zxvf ${BOOST_VER}.tar.gz           && \
    cd ${BOOST_VER}                         && \
    ./bootstrap.sh --prefix=${BOOST_ROOT}   && \
    ./b2 -j4 install

RUN echo "/opt/boost/lib" > /etc/ld.so.conf.d/boost.conf && ldconfig

WORKDIR ${USER_DIR}

RUN git clone ${MOTUR_HEAD_PLATFORM}    && \
    source /opt/ros/${ROS_DISTRO}/setup.bash   && \
    colcon build

RUN apt-get install -y \
    ros-${ROS_DISTRO}-nav2-msgs \
    ros-${ROS_DISTRO}-nav2-msgs-dgbsym \
    ros-${ROS_DISTRO}-tf2-msgs \
    ros-${ROS_DISTRO}-tf2-msgs-dgbsym \
    ros-${ROS_DISTRO}-sensor-msgs \
    ros-${ROS_DISTRO}-sensor-msgs-dgbsym \
    && apt-get clean

COPY mh_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT [ "/ros_entrypoint.sh" ]
    
CMD [ "bash" ]
