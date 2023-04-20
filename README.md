[![completion](https://img.shields.io/badge/completion-71%25%20%28560%20of%20782%29-blue.svg)](https://github.com/pyimgui/pyimgui)
[![Coverage Status](https://coveralls.io/repos/github/pyimgui/pyimgui/badge.svg?branch=docking)](https://coveralls.io/github/swistakm/pyimgui?branch=docking)
[![Documentation Status](https://readthedocs.org/projects/pyimgui/badge/?version=docking)](https://pyimgui.readthedocs.io/en/latest/?badge=docking)
[![Build status](https://ci.appveyor.com/api/projects/status/mr97t941p6k4c261/branch/docking?svg=true)](https://ci.appveyor.com/project/KinoxKlark/pyimgui/branch/docking)

> :warning: The `docking` branch is a work in progress and may not be used due to missing functionalities

# pyimgui

Python bindings for the amazing
[dear imgui](https://github.com/ocornut/imgui) C++ library - a Bloat-free
Immediate Mode Graphical User Interface.

Documentation: [pyimgui.readthedocs.io](https://pyimgui.readthedocs.io/en/latest/)

> **Notes for contributions:**
> - We have a [`fixes`](https://github.com/pyimgui/pyimgui/tree/fixes) branch
> - Please, read the last section of this file

# Installation

**pyimgui** is available on PyPI so you can easily install it with `pip`:
 
    pip install imgui[full]

Above command will install `imgui` package with additional dependencies for all
built-in rendering backend integrations (pygame, cocos2d, etc.). If you don't
want to install all additional dependencies you can always use bare
`pip install imgui` command or select a specific set of extra requirements:

* for pygame backend use `pip install imgui[pygame]`
* for GLFW3 backend use `pip install imgui[glfw]`
* for SDL2 backend use `pip install imgui[sdl2]`
* for Cocos2d backend use `pip install imgui[cocos2d]`
* for pyglet backend use `pip install imgui[pyglet]`

Package is distributed in form of *built wheels* so it does not require
compilation on most operating systems. For more details about compatibility
with diffferent OSes and Python versions see the *Project ditribution*
section of this documentation page.


# Project status

The `imgui` package provides support for the majority of core DearImGui 1.82 widgets and
functionalities. Some low-level API elements and complex widgets (like plots)
may be missing. We are working hard to provide 100% feature mapping of the core
ImGui library. The *completion badge* shows up-to-date status of that goal.

# Project distribution

This project has a working build pipeline on Appveyor. It builds
succesfully for all major operating systems with different architectures:

* Windows (32bit & 64bit)
* Linux (32bit & 64bit)
* OS X (universal build)

Right now we are ready shipping the built wheels for these three systems
(even for Linux using `manylinux1` wheels). The build pipeline covers multiple
Python versions:

* py36
* py37, pp37
* py38, pp38
* py39, pp39
* py310
* py311

__Note:__ We dropped support for py27, py33, py34, and py35 starting from release 2.0. 
Those were supported until release [1.4.0](https://github.com/pyimgui/pyimgui/releases/tag/1.4.0). 
Pypy is only supported since release 2.0.

If none of these wheels work in your environment you can install the `imgui`
package by compiling it directly from sdist distribution using one of following
commands:

    # will install Cython as extra dependency and compile from Cython sources
    pip install imgui[Cython] --no-binary imgui

    # will compile from pre-generated C++ sources
    pip install imgui --no-binary imgui

**pyimgui** provides documentation with multiple visual examples.
Thanks to custom Sphinx extensions, we are able to render GUI examples off-screen directly from docstring 
snippets. These examples work also as automated functional tests. Documentation is hosted on
[pyimgui.readthedocs.io](https://pyimgui.readthedocs.io/en/latest/index.html).

# Contributing
Contributions are welcomed. If you want to help us by fixing bugs, mapping functions, or adding new features, 
please feel free to do so and propose a pull request.

Development tips and information for developers are given in [HACKING.md](https://github.com/pyimgui/pyimgui/blob/master/HACKING.md).

