# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: sources = AnsiFeed/AnsiTextColored.cpp
# distutils: include_dirs = imgui-cpp AnsiFeed
"""
Notes:
   `✓` marks API element as already mapped in core bindings.
   `✗` marks API element as "yet to be mapped
"""
# from libcpp cimport bool

# from enums cimport ImGuiKey_, ImGuiCol_

cimport cimgui

from cimgui cimport ImVec4

cdef extern from "../AnsiFeed/AnsiTextColored.h" namespace "ImGui":
   #  void TextTest(const char* fmt, ...)
    void TextAnsi(const char* fmt, ...) except +  # ✓
    void TextAnsiColored(const ImVec4& col, const char* fmt, ...) except +  # ✓

cdef extern from "../AnsiFeed/AnsiTextColored.cpp":
    pass