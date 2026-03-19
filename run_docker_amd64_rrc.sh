#!/bin/bash

DEFAULT_WORKSPACE=/home/admin/Projects
WORKSPACE=${1:-$DEFAULT_WORKSPACE}

HID_DEVICE=""
#if $2 passed use it as HID_DEVICE, otherwise use default
if [ -n "$2" ]; then
    HID_DEVICE="--device=$2"
    echo "Using HID_DEVICE: $HID_DEVICE"
fi


docker run                                              \
    --rm                                                \
    -it                                                 \
    --network=host				        \
    -e DISPLAY=$DISPLAY					\
    -v "$WORKSPACE":/home/user/workspace                \
    -v ~/.bash_history:/root/.bash_history              \
    -v ~/.ssh:/home/user/.ssh                           \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw			\
    "$HID_DEVICE"                                       \
    macandkaj/motoros:development-amd64-9-148cec93c183
