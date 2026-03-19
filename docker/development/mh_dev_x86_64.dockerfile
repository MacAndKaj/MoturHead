FROM osrf/ros:humble-desktop

SHELL ["/bin/bash", "-c"]
ENV BOOST_VER=boost_1_86_0
ENV BOOST_ROOT=/opt/boost
ENV USER_DIR=/home/user

ARG MOTUR_HEAD_PLATFORM=https://github.com/MacAndKaj/MoturHeadPlatform.git
ARG BOOST_WGET_LINK=https://archives.boost.io/release/1.86.0/source/${BOOST_VER}.tar.gz

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
    libbz2-dev \
    libzstd-dev \
    liblzma-dev \
    zlib1g-dev \
    libicu-dev \
    libssl-dev \
    libx11-xcb1 \
    libxcb1 \
    libxcb-keysyms1 \
    libxcb-image0 \
    libxcb-shm0 \
    libxcb-icccm4 \
    libxcb-sync1 \
    libxcb-xfixes0 \
    libxcb-shape0 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    libxkbcommon-x11-0 \
    libgl1-mesa-glx \
    libegl1-mesa \
    ca-certificates \
    && apt-get clean

ENV BOOST_LIBRARIES=date_time,json,log,program_options,filesystem,system,regex

RUN cd /tmp                                 && \
    wget ${BOOST_WGET_LINK}                 && \
    tar -zxvf ${BOOST_VER}.tar.gz           && \
    cd ${BOOST_VER}                         && \
    ./bootstrap.sh --prefix=${BOOST_ROOT}   && \
    ./b2 -j4 install

RUN echo "/opt/boost/lib" > /etc/ld.so.conf.d/boost.conf && ldconfig

RUN apt-get install -y \
    ros-${ROS_DISTRO}-nav2-msgs \
    ros-${ROS_DISTRO}-tf2-msgs \
    ros-${ROS_DISTRO}-sensor-msgs \
    && apt-get clean

WORKDIR ${USER_DIR}

RUN git clone ${MOTUR_HEAD_PLATFORM}    && \
    source /opt/ros/humble/setup.bash   && \
    colcon build

COPY mh_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT [ "/ros_entrypoint.sh" ]

CMD [ "bash" ]
