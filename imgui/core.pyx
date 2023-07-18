# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp imgui-cpp/imgui_widgets.cpp imgui-cpp/imgui_tables.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp ansifeed-cpp
# cython: embedsignature=True
"""

.. todo:: consider inlining every occurence of ``_cast_args_ImVecX`` (profile)
.. todo: verify mem safety of char* variables and check for leaks
"""

import cython
from cython.view cimport array as cvarray
from cython.operator cimport dereference as deref

from collections import namedtuple
import warnings
from contextlib import contextmanager
try:
    from itertools import izip_longest
except ImportError:
    from itertools import zip_longest as izip_longest

from libc.stdlib cimport malloc, realloc, free
from libc.stdint cimport uintptr_t
from libc.string cimport strdup
from libc.string cimport strncpy, strlen
from libc.float  cimport FLT_MIN
from libc.float  cimport FLT_MAX
from libcpp cimport bool

FLOAT_MIN = FLT_MIN
FLOAT_MAX = FLT_MAX

cimport cimgui
cimport core
cimport enums
cimport ansifeed
cimport internal

from cpython.version cimport PY_MAJOR_VERSION

# todo: find a way to cimport this directly from imgui.h
DEF TARGET_IMGUI_VERSION = (1, 82)

cdef unsigned int* _LATIN_ALL = [0x0020, 0x024F , 0]

include "imgui/enums.pyx"
include "imgui/utilities.pyx"

include "imgui/common.pyx"
include "imgui/imgui.base.pyx"
include "imgui/imgui.draw.pyx"
include "imgui/imgui.tables.pyx"
include "imgui/imgui.widgets.pyx"
include "imgui/imgui.demo.pyx"

