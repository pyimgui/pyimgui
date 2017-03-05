[![completion](https://img.shields.io/badge/completion-55%25%20%28216%20of%20389%29-blue.svg)](https://github.com/swistakm/pyimgui)

Builds:

* [![Build status](https://ci.appveyor.com/api/projects/status/s7pud6on7dww89iv?svg=true)](https://ci.appveyor.com/project/swistakm/pyimgui) (Windows)
* [![Build Status](https://travis-ci.org/swistakm/pyimgui.svg?branch=master)](https://travis-ci.org/swistakm/pyimgui) (OS X & Linux)


# pyimgui

**pyimgui** is a Cython-based binding for impressive 
[dear imgui](https://github.com/ocornut/imgui) C++ library - 
a Bloat-free Immediate Mode Graphical User Interface.
 
It is still unfinished project but I plan to provide minimal fully-functional
binding in incoming few months. Any help would be appreciated.


# why?

**dear imgui** looks very interesting. I wanted to give it a try becasue I was
looking for simple GUI solution for my little Python-based game engine (to be
opensourced soon!). Offical **dear imgui** Wiki used to say that there is some
other Python binding available ([cyimgui](https://github.com/chromy/cyimgui)) 
but it quickly turned out that it far from completion and isn't even barely 
usable.

In fact, my initial experimental work on this project was based on the cyimgui 
code base. After only three days of developlment my code had almost nothing in 
common with the **cyimgui**. This fact and vanity made me start my own project 
instead of forking the **cyimgui**.


# project status

pyimgui is working! It's not feature complete and only small subset of ImGui
API is mapped right now. But you can run examples with ImGui test windows (see:
`docs/examples/glfw3/`) and everything should work wihout any issues.

Example integration with `glfw` supports all inputs and renders GUI as expected.

Project has working build pipeline on Appveyor and Travis and builds 
succesfully for all major operating systems with different architectures:

* Windows (32bit & 64bit)
* Linux (32bit & 64bit)
* OS X (universal build)

Right now I am ready to ship working built wheels for all these systems (even 
for Linux using `manylinux1` wheels). Build pipeline also works on different
Python versions:

* py27
* py33
* py34
* py35


Project has has even working Sphinx documentation with custom extension that
is able to offscreen render GUI examples from docstring snippets. It is already
hosted on ReadTheDocs and images are provided with git-lfs. See for yourself: 
[pyimgui.readthedocs.io](http://pyimgui.readthedocs.io/en/latest/index.html).



The only thing that is stopping me from publishing it on PyPI is lack of
support for most of the ImGui core widgets. Anyway, the hardest parts are
already done (like wiring C assert macros to custom Python exceptions, creating build 
pipeline for Python wheels, or integrating with GLFW). Adding new functions, 
widgets or integrations (e.g. Pygame, GLUT) should be simple from now.

Unfortunately this is really toilsome work. A lot of copy-pasting and
manual type-casting. It will take me weeks to provide minimal usable feature
set if I have to work alone. This is why I encourage anyone (even unexperienced
Python/Cython programmers) to contribute. It's not a rocket science and it
will help me to release project officially sooner.

In case of any issues with building/testing just ask me for help by creating
GitHub issue. I have tried hard to make project building and bootstraping as 
simple as possible (see development tips) but it still may not be perfect.


# development tips

Make sure you have created and activated virtual environment using `virtualenv`
or `python -m venv` (on newer Python releases). Then you can just run:

    make build
    
Following will bootstrap whole environment (pull git submodules, install 
dev requirements etc.) and build the project. Make will automatically install
pyimgui in "development" mode. Then you can run example in `doc/examples`
to see if it is working.

For testing string documentation you will need some additional requirements
from `doc/requirements-docs.txt`.
