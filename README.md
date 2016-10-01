# pyimgui,

**pyimgui** is a Cython-based binding for impressive 
[dear imgui](https://github.com/ocornut/imgui) C++ library 
- a Bloat-free Immediate Mode Graphical User Interface.
 
It is still unfinished project but I plan to provide minimal fully-functional
binding in incoming few months. Any help would be appreciated.


# development tips
After you checkout the repository don't forget to initialize all git submodules
using:

    git submodule update --init --recursive --remote

To build locally and install inside of your local environment just use standard 
setuptools command:

    python setup.py develop
