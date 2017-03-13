#!/usr/bin/env bash
set -v

if [[ $TRAVIS_OS_NAME == "osx" ]]; then
    # if there is no docker image set then make simple OS X build in place
    # using pyenv/virtualenv

    python --version
    python -m pip freeze

    python -m pip install -r doc/requirements-test.txt

    python -m pip wheel . -w dist/
    python -m pip install -e .
    python -m pytest -v --ignore=build-env --color=yes

elif [[ $DOCKER_IMAGE ]]; then
    # if docker image is set then run actual Linux build inside of docker
    docker run --rm -v `pwd`:/io $DOCKER_IMAGE $PRE_CMD /io/ci/docker_build_wheels.sh

else
   # note: if it is not a docker-based build then just run coverage on python3
   #       and do not create wheels (they will not be uploaded).
   python3 --version
   python3 -m pip freeze

   python3 -m pip install -r doc/requirements-test.txt
   python3 -m pip install coverage
   python3 -m pip install coveralls

   _CYTHONIZE_WITH_COVERAGE=1 pip install -e .
   python3 -m coverage run --source imgui -m pytest
   python3 -m coverage report
   coveralls
fi
