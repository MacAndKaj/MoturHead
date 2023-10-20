FROM osrf/ros:humble-desktop

SHELL ["/bin/bash", "-c"]

ENV USER_DIR=/home/user

ARG MOTUR_HEAD_PLATFORM=https://github.com/MacAndKaj/MoturHeadPlatform/archive/refs/heads/main.zip

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

WORKDIR ${USER_DIR}

RUN wget ${MOTUR_HEAD_PLATFORM} && unzip main.zip && rm main.zip && \
    source /opt/ros/humble/setup.bash && colcon build

COPY mh_entrypoint.sh /mh_entrypoint.sh
RUN chmod +x /mh_entrypoint.sh
ENTRYPOINT [ "/mh_entrypoint.sh" ]
CMD [ "bash" ]
