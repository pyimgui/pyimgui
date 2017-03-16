#!/usr/bin/env bash
travis_fold() {
  local action=$1
  local name=$2
  echo -en "travis_fold:${action}:${name}\r"
}

# note: we do not target py26 and also it is not supported by latest Cython
rm -rf /opt/python/cp26*
echo -e "\n\nWill build wheels for:"
for PY in /opt/python/*/bin/python; do echo "* $(${PY} --version 2>&1)"; done

for PYBIN in /opt/python/*/bin; do
    echo -e "\n\nBuilding wheel for $(${PYBIN}/python --version 2>&1)"

    travis_fold start wheel-${PYBIN}
    ${PYBIN}/pip install -r /io/doc/requirements-test.txt
    ${PYBIN}/pip wheel /io/ -w /io/dist-wip/
    travis_fold end wheel-${PYBIN}
done


# Bundle external shared libraries into the wheels and fix platform tags
echo -e "\n\nAuditing wheels:"
for whl in /io/dist-wip/*.whl; do
    auditwheel repair $whl -w /io/dist/
done
