.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  clean      to clean local environment from stale build files"
	@echo "  build      to build and install for development"
	@echo "  rebuild    to rebuild from scratch"
	@echo "  livedoc    to serve live documentation"
	@echo "  bootstrap  to bootstrap whole development environment"


# note: empty recipe as alias for .bootstrapped target
bootstrap: .bootstrapped ;

.bootstrapped:
	@echo "Bootstrapping project environment ..."
	git submodule update --init
	pip install -r doc/requirements-dev.txt
	@touch .bootstrapped


.PHONY: clean
clean:
	rm -f imgui/*.cpp imgui/*.c imgui/*.h imgui/*.so


.PHONY: build
build: bootstrap
	python setup.py develop


.PHONY: rebuild
rebuild: clean build
	@echo 'Done!'


.PHONY: livedoc
livedoc: build
	sphinx-autobuild doc/source/ doc/build/html


.PHONY: completion
completion:
	@python ci/completion.py imgui/cimgui.pxd
