#!/bin/bash

DEFAULT_WORKSPACE=/home/admin/Projects
WORKSPACE=${1:-$DEFAULT_WORKSPACE}

docker run                                          \
    --rm                                            \
    -it                                             \
    --network=host				                    \
    -v "$WORKSPACE":/home/user/workspace            \
    -v ~/.bash_history:/root/.bash_history          \
    -v ~/.ssh:/home/user/.ssh                       \
    macandkaj/motoros:development-amd64-9-148cec93c183
