| Windows build | Mac OS X build |
| ------------- | -------------- |
| [![Build status](https://ci.appveyor.com/api/projects/status/s7pud6on7dww89iv?svg=true)](https://ci.appveyor.com/project/swistakm/pyimgui) | [![Build Status](https://travis-ci.org/swistakm/pyimgui.svg?branch=master)](https://travis-ci.org/swistakm/pyimgui)


# pyimgui,

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


# development tips

After you checkout the repository don't forget to initialize all git submodules
using:

    git submodule update --init --recursive --remote

Then setup your environment, build extension and install it locally in the
*development* mode:

    pip install -r doc/requirements-dev.txt
    python setup.py develop
