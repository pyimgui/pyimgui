#!/usr/bin/env bash
# stop on failures immediately
set -e

travis_fold() {
  local action=$1
  local name=$2
  echo -en "travis_fold:${action}:${name}\r"
}

if [[ $DOCKER_IMAGE ]]; then
    travis_fold start docker-pull
    docker pull $DOCKER_IMAGE
    travis_fold end docker-pull
fi
