#!/usr/bin/env bash
travis_fold() {
  local action=$1
  local name=$2
  echo -en "travis_fold:${action}:${name}\r"
}

if [[ $TRAVIS_OS_NAME == "osx" ]]; then

    if [[ "$PY_VERSION" != "2.7" ]]; then
        travis_fold start brew-update
        brew update > /dev/null
        travis_fold end brew-update

        travis_fold start brew-openssl
        brew upgrade openssl
        travis_fold end brew-openssl

        travis_fold start brew-upgrade
        brew outdated pyenv || brew upgrade pyenv
        travis_fold end brew-upgrade

        travis_fold start pyenv-install
        pyenv install --skip-existing $PY_VERSION
        pyenv local $PY_VERSION
        travis_fold end pyenv-install

        eval "$(pyenv init -)"
    fi

elif [[ $DOCKER_IMAGE ]]; then
    docker pull $DOCKER_IMAGE
fi
