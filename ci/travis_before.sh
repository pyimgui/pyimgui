#!/usr/bin/env bash

if [[ $TRAVIS_OS_NAME == "osx" ]]; then

    if [[ "$PY_VERSION" != "2.7" ]]; then
        brew update
        brew outdated pyenv || brew upgrade pyenv
        pyenv install $PY_VERSION
        pyenv local $PY_VERSION
        eval "$(pyenv init -)"
    fi

else
    docker pull $DOCKER_IMAGE
fi
