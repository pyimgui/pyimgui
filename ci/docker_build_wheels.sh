#!/usr/bin/env bash

for PYBIN in /opt/python/*/bin; do
    # note: latest version of cython does not support py26 so make sure we
    #       skip building wheels for this dist
    if [[ ! $PYBIN == *"26"* ]]; then
        echo -e "\n\nBuilding wheel for $PYBIN"

        ${PYBIN}/pip install -r /io/doc/requirements-dev.txt
        ${PYBIN}/pip wheel /io/ -w /io/dist/

    fi
done
