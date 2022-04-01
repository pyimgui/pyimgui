# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp imgui-cpp/imgui_widgets.cpp imgui-cpp/imgui_tables.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp ansifeed-cpp
# cython: embedsignature=True
# cython: linetrace=False

import sys
from cpython.exc cimport PyErr_NewException

_orig_trace = None


cdef public _SkipWithStatement "_SkipWithStatement" = PyErr_NewException(
    "imgui._skipwith._SkipWithStatement", Exception, {}
)


def _raise_skip_with_statement(*args, **kwargs):
    raise _SkipWithStatement


cdef void _empty_trace(frame, char* event, arg):
    return


cdef void _skip_with_init():
    global _orig_trace

    # Need to set trace to trigger the frame trace. Also need to reset trace after trace errors.
    _orig_trace = sys.gettrace()
    if _orig_trace is None:
        sys.settrace(_empty_trace)

    # Set a stack trace that will raise an error to skip the context block.
    sys._getframe(0).f_trace = _raise_skip_with_statement


cdef void _skip_with_cleanup():
    # Reset the original trace method to resume debugging.
    sys.settrace(_orig_trace)
