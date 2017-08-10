[![completion](https://img.shields.io/badge/completion-66%25%20%28270%20of%20409%29-blue.svg)](https://github.com/swistakm/pyimgui)
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

`imgui` package integrates easily with various graphic backends and
Python-based game engines. Each backend requires one or more additional
packages. You can install them with `imgui` using pip's *extras* feature:

* for GLFW3 backend use `pip install imgui[glfw]`
* for SDL2 backend use `pip install imgui[sdl2]`

Package is distributed in form of *built wheels* so it does not require
compilation on most operating systems. For more details about compatibility
with diffferent OSes and Python versions see the *project ditribution*
section of this documentation page.


# project status

The `imgui` package provides support for the majority of core ImGui widgets and
functionalities. Some low-level API elements and complex widgets (like plots)
may be missing. We are working hard to provide 100% feature mapping of the core
ImGui library. The *completion badge* shows up-to-date status of that goal.


# project distribution

This project has working build pipeline on Appveyor and Travis and builds 
succesfully for all major operating systems with different architectures:

* Windows (32bit & 64bit)
* Linux (32bit & 64bit)
* OS X (universal build)

Right now we are ready to shipping the built wheels for these three systems
(even for Linux using `manylinux1` wheels). The build pipeline covers multiple
Python versions:

* py27
* py33
* py34
* py35
* py36

**pyimgui** provides documentation with multiple visual examples.
Thanks to custom Sphinx extensions we are able to render GUI examples off
screen directly from docstring snippets. These examples work also as automated
functional tests. Documentation is hosted on
[pyimgui.readthedocs.io](https://pyimgui.readthedocs.io/en/latest/index.html).

If none of these wheels work in your environment you can install the `imgui`
package by compiling it directly from sdist distribution using one of following
commands:

    # will install Cython as extra dependency and compile from Cython sources
    pip install imgui[Cython] --no-binary imgui

    # will compile from pre-generated C++ sources
    pip install imgui --no-binary imgui


# development tips
We have tried hard to make the process of bootstraping this project as simple
as possible.

In order to build and install project locally ,ake sure you have created and
activated virtual environment using `virtualenv` or `python -m venv` (for newer
Python releases). Then you can just run:

    make build
    
This command will bootstrap whole environment (pull git submodules, install 
dev requirements etc.) and build the project. `make` will automatically install
`imgui` in the *development/editable* mode. Then you can run some examples
found in the `doc/examples` directory in order to verify if project is working.

For building ducumentation and running tests you will need some additional
requirements from `doc/requirements-test.txt`.

You can run tests with:

    py.test


If you have any problems with building or installing the project just ask us
for help by creating GitHub issue.
