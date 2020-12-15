# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: sources = ansifeed-cpp/AnsiTextColored.cpp
# distutils: include_dirs = imgui-cpp ansifeed-cpp
"""
Notes:
   `✓` marks API element as already mapped in core bindings.
   `✗` marks API element as "yet to be mapped
"""

cimport cimgui

from cimgui cimport ImVec4

cdef extern from "../ansifeed-cpp/AnsiTextColored.h" namespace "ImGui":
    void TextAnsi(const char* fmt, ...) except +  # ✓
    void TextAnsiColored(const ImVec4& col, const char* fmt, ...) except +  # ✓

cdef extern from "../ansifeed-cpp/AnsiTextColored.cpp":
    pass
