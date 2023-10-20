#!/bin/bash

# Exit on any error
set -o errexit

function usage ()
{
  echo "Usage: $0 [-i|--image <image filename>] [-t|--tag <docker image tag]"
  echo "   -i|--image   Set filename for archived docker image."
  echo "   -t|--tag     Set tag name for building docker image."
  exit 0
}

#while getopts ""; do
#
#done


DOCKER_TAG="motur_rel_image"

git submodule update --remote --merge

docker build -f docker/rel/mh_rel_aarch64.dockerfile -t "${DOCKER_TAG}" .

docker save "${DOCKER_TAG}" | gzip > "${DOCKER_TAG}".tar.gz