[![completion](https://img.shields.io/badge/completion-65%25%20%28267%20of%20408%29-blue.svg)](https://github.com/swistakm/pyimgui)
[![Coverage Status](https://coveralls.io/repos/github/swistakm/pyimgui/badge.svg?branch=master)](https://coveralls.io/github/swistakm/pyimgui?branch=master)
[![Documentation Status](https://readthedocs.org/projects/pyimgui/badge/?version=latest)](https://pyimgui.readthedocs.io/en/latest/?badge=latest)

Builds:

* [![Build status](https://ci.appveyor.com/api/projects/status/s7pud6on7dww89iv?svg=true)](https://ci.appveyor.com/project/swistakm/pyimgui) (Windows)
* [![Build Status](https://travis-ci.org/swistakm/pyimgui.svg?branch=master)](https://travis-ci.org/swistakm/pyimgui) (OS X & Linux)


# pyimgui

**pyimgui** is a Cython-based binding for the amazing 
[dear imgui](https://github.com/ocornut/imgui) C++ library - a Bloat-free
Immediate Mode Graphical User Interface.


# installation

**pyimgui** is available on PyPI so you can easily
install it with `pip`:
 
    pip install imgui

`imgui` package integrates easily with various graphic backends. Each backend
requires one or more additional packages. You can install them with `imgui`
using pip's *extras* feature:

* for GLFW3 backend use `pip install imgui[glfw]`
* for SDL2 backend use `pip install imgui[sdl2]`

Package is distributed in form of *built wheels* so it does not require
compilation on most operating systems. For more details about compatibility
with diffferent OSes and Python versions see the *project ditribution*
section of this documentation page.


# project status

The `imgui` package provides support for most of core ImGui widgets and
functionalities. Some low-level API elements and complex widgets (like plots)
may be missing. We are working hard to provide 100% feature mapping of the core
ImGui library. The *completion badge* shows actual progress.


# project distribution

This project has working build pipeline on Appveyor and Travis and builds 
succesfully for all major operating systems with different architectures:

* Windows (32bit & 64bit)
* Linux (32bit & 64bit)
* OS X (universal build)

Right now we are ready to ship working built wheels for these three systems
(even for Linux using `manylinux1` wheels). Build pipeline also works on
different Python versions:

* py27
* py33
* py34
* py35

**pyimgu** has has even working Sphinx documentation with custom extension that
is able to offscreen render GUI examples from docstring snippets. It is already
hosted on ReadTheDocs and images are provided with git-lfs. See for yourself: 
[pyimgui.readthedocs.io](https://pyimgui.readthedocs.io/en/latest/index.html).

In case of any issues with building/testing just ask us for help by creating
GitHub issue. We have tried hard to make the process of bootstraping this
project as simple as possible (see *development tips* section).


# development tips

Make sure you have created and activated virtual environment using `virtualenv`
or `python -m venv` (for newer Python releases). Then you can just run:

    make build
    
This command will bootstrap whole environment (pull git submodules, install 
dev requirements etc.) and build the project. `make` will automatically install
pyimgui in the *development/editable* mode. Then you can run some example in
the `doc/examples` directory to verify if project is working.

For building ducumentation and running tests you will need some additional
requirements from `doc/requirements-test.txt`. You can run tests with:

    py.test
