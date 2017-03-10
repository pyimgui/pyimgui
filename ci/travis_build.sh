#!/usr/bin/env bash

if [[ $TRAVIS_OS_NAME == "osx" ]]; then
    # if there is no docker image set then make simple OS X build in place
    # using pyenv/virtualenv

    python --version
    python -m pip freeze

    python -m pip install -r doc/requirements-test.txt

    python -m pip wheel . -w dist/
    python -m pip install -e .
    python -m pytest -v

else
    # if docker image is set then run actual Linux build inside of docker
    docker run --rm -v `pwd`:/io $DOCKER_IMAGE $PRE_CMD /io/ci/docker_build_wheels.sh

fi


