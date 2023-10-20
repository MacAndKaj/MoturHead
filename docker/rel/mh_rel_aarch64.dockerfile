FROM arm64v8/ros:humble

SHELL ["/bin/bash", "-c"]

ENV USER_DIR=/home/user
ENV MOTOROS_DIR=${USER_DIR}/motoros

ARG MOTUR_HEAD_PLATFORM=https://github.com/MacAndKaj/MoturHeadPlatform/archive/refs/heads/main.zip
ARG PLATFORM_CONTROLLER=https://github.com/MacAndKaj/PlatformController/archive/refs/heads/main.zip

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
    && apt-get clean

# RUN useradd -ms /bin/bash user
# USER user
WORKDIR ${USER_DIR}

COPY . .

RUN source /opt/ros/humble/setup.bash && \
    colcon build



