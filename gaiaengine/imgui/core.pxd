"""
This file provides all C/C++ definitions that need to be shared between all
extension modules. This is mostly for the `extra` submodule that provides
some additional utilities that do not belong to `core`.
"""
cimport cimgui

cdef class _Font(object):
    cdef cimgui.ImFont* _ptr

    @staticmethod
    cdef from_ptr(cimgui.ImFont* ptr)
