.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  clean      to clean local environment from stale build files"
	@echo "  build      to build and install for development"
	@echo "  rebuild    to rebuild from scratch"
	@echo "  livedoc    to serve live documentation"
	@echo "  bootstrap  to bootstrap whole development environment"


bootstrap: .bootstrapped
	@echo "I'm making sure project is bootstrapped ..."


.bootstrapped:
	git submodule update --init
	pip install -r doc/requirements-dev.txt
	@touch .bootstrapped


.PHONY: clean
clean:
	rm -f extensions/*.cpp extensions/*.c extensions/*.h imgui/*.so


.PHONY: build
build: bootstrap
	python setup.py develop


.PHONY: rebuild
rebuild: clean build
	@echo 'Done!'


.PHONY: livedoc
livedoc: build
	sphinx-autobuild doc/source/ doc/build/html
