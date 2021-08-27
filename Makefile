.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  clean       to clean local environment from stale build files"
	@echo "  build       to build and install for development"
	@echo "  rebuild     to rebuild from scratch"
	@echo "  livedoc     to serve live documentation"
	@echo "  bootstrap   to bootstrap whole development environment"
	@echo "  completion  to get detailed overview on completion progress"
	@echo "  coverage    to run tests with coverage"

PYTHON=python

# note: empty recipe as alias for .bootstrapped target
bootstrap: .bootstrapped ;

.bootstrapped:
	@echo "Bootstrapping project environment ..."
	git submodule update --init
	pip install -r doc/requirements-dev.txt
	@touch .bootstrapped


.PHONY: clean
clean:
	rm -rf imgui/*.cpp imgui/*.c imgui/*.h imgui/*.so build/*


.PHONY: build
build: bootstrap
	_CYTHONIZE_WITH_COVERAGE=1 ${PYTHON} -m pip install -e . -v
	${PYTHON} ci/completion.py -o README.md with-pxd imgui/cimgui.pxd imgui/internal.pxd


.PHONY: rebuild
rebuild: clean build
	@echo 'Done!'


.PHONY: livedoc
livedoc: build
	sphinx-autobuild doc/source/ doc/build/html


.PHONY: coverage
coverage: build
	coverage run --source imgui -m pytest
	coverage report
	coverage html


.PHONY: completion
completion:
	_CYTHONIZE_WITH_COVERAGE=1 ${PYTHON} -m pip install -e . -v
	@${PYTHON} ci/completion.py missing `find build/ -name imgui.o -print -quit` `find build/ -name core.o -print -quit`
	@${PYTHON} ci/completion.py with-nm `find build/ -name imgui.o -print -quit` `find build/ -name core.o -print -quit`

.PHONY: ditribute
distribute: clean
	${PYTHON} -m pip install -U Cython setuptools twine
	${PYTHON} setup.py build
	${PYTHON} setup.py sdist
