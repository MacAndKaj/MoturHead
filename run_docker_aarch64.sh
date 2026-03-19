#!/bin/bash

docker run \
    --rm \
    --privileged \
    multiarch/qemu-user-static \
    --reset \
    -p yes

docker run \
    -it \
    -v /home/admin/Projects:/home/user/workspace \
    -v ~/.bash_history:/root/.bash_history \
    macandkaj/motoros:development-aarch64-3-ff1c1d867445
