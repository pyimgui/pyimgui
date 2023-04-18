# Development tips
We have tried hard to make the process of bootstrapping this project as simple as possible.

In order to build and install the project locally, make sure you have created and activated 
a virtual environment using `virtualenv` or `python -m venv` (for newer Python releases). 
Then you can just run:

    make build
    
This command will bootstrap the whole environment (pull git submodules, install dev requirements, etc.) 
and build the project. `make` will automatically install `imgui` in the *development/editable* mode. 
Then you can run some examples found in the `doc/examples` directory in order to verify if the project is working.

You can install requirements manually using files `doc/requirements-***.txt`. E.g., with

    pip install -r doc/requirements-dev.txt

If you have any problems with building or installing the project, just ask us
for help by creating a GitHub issue.

# Function mapping

The `imgui.h` file that provides the interface with the DearImGui lib is fully mapped in `imgui/cimgui.pxd`. 
We use a mark (`✓`/`✗`) system to estimate how many functionalities are mapped automatically. 
**Please edit the tick mark properly if you want to map an unmapped function**.

Functions listed in the `cimgui.pxd` correspond to mappable functions for the supported version of DearImGui. 
Please refer to the next section for information about version syncing.

# Version syncing

> Pyimgui 2.0 uses DearImGui 1.82

We specifically bind pyimgui releases to a specific stable version of DearImGui. Thus, when upgrading to a newer 
version of DearImGui, some care must be taken.

First, one should update the submodule dependency to point to a specific release tag and not just get the latest 
commits of the `master` branch.

Moreover, the `docking` branch should also be modified accordingly, such that each branch points to the correct DearImGui 
release. (Sync list is given in [https://github.com/pyimgui/pyimgui/issues/259#issuecomment-1039090228](https://github.com/pyimgui/pyimgui/issues/259#issuecomment-1039090228))

When updating the submodule to a recent release, we must update the `imgui/cimgui.pxd` accordingly. This means that 
all new functions must be mapped with the `✗`, all depreciated functions must be indicated as such, and so on. 
Every flag must be properly added and documented in the `imgui/enums.pxd`, `core.pyx`, and `__init__.py`. Idem for 
the `internal` subpackage.

> The easiest way to proceed with updates that skip several releases is to do them one by one. E.g., for going from 1.82 to 1.87, 
I would suggest taking each release note from DearImGui and upgrading to 1.83 first. And then, when it is fully done, 
update to 1.84. And so on. At each step, ensure that `cimgui.pxd` is updated and that all enums are properly added. I would 
also use a file diff software to check the old `imgui.h` with the new one.

Since the process is very time-consuming, please refrain from taking the initiative of upgrading DearImGui before asking via an issue. 
We may have specific plans that you are not informed of.

# Tests

For running tests, you will need some additional
requirements from `doc/requirements-test.txt`.

You can run tests with:

    py.test

Tests of functionalities are automatically extracted from the `visual-example` part of the docstring documentation of 
mapped functions. We also have more in-depth tests of specific features in the `tests/` folder.

# Documentation

For building documentation, you will need some additional
requirements from `doc/requirements-docs.txt`.

Documentation building should be run from the `doc/source/` directory:

    cd doc/source/

Documentation is built using Sphinx. The command used on ReadTheDocs is

    python -m sphinx -W --keep-going -T -E -b HTML -d _build/doctrees -D language=en . _build/HTML

**pyimgui** provides documentation with multiple visual examples.
Thanks to custom Sphinx extensions, we are able to render GUI examples off-screen directly from docstring snippets. 
These examples work also as automated functional tests. Documentation is hosted on
[pyimgui.readthedocs.io](https://pyimgui.readthedocs.io/en/latest/index.html).
