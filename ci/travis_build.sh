#!/usr/bin/env bash
# stop on failures immediately
set -e

travis_fold() {
  local action=$1
  local name=$2
  echo -en "travis_fold:${action}:${name}\r"
}

if [[ $DOCKER_IMAGE ]]; then
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
   PYTHONDEVMODE=1 python3 -m coverage run --source imgui -m pytest -v --color=yes
   python3 -m coverage report
   coveralls
fi
