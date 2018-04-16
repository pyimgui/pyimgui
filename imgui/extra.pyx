# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp
# cython: embedsignature=True
"""
This module provides extra utilities that are not part of core ImGui C++ API
but are useful in Python application.

"""
from contextlib import contextmanager

try:
    from itertools import izip_longest
except ImportError:
    from itertools import zip_longest as izip_longest

from libc.stdint cimport uintptr_t

cimport core
import core
cimport cimgui


__all__ = (
    "font",
    "styled",
    "istyled",
    "vertex_buffer_vertex_pos_offset",
    "vertex_buffer_vertex_uv_offset",
    "vertex_buffer_vertex_col_offset",
    "vertex_buffer_vertex_size",
    "index_buffer_index_size",
)


@contextmanager
def font(core._Font font):
    """Use specified font in given context.

    Example:

    .. code-block:: python

        ...
        font_extra = io.fonts.add_font_from_file_ttf(
            "CODE2000.TTF", 30, io.fonts.get_glyph_ranges_latin()
        )
        ...

        # later in application loop
        while True:
            ...
            with imgui.font(font_extra):
                imgui.text("My text with custom font")
            ...

    Args:
        font (_Font): font object retrieved from :any:`add_font_from_file_ttf`.
    """
    core.push_font(font)
    yield
    core.pop_font()

@contextmanager
def styled(cimgui.ImGuiStyleVar variable, value):
    # note: we treat bool value as integer to guess if we are required to pop
    #       anything because IMGUI may simply skip pushing
    count = core.push_style_var(variable, value)
    yield
    core.pop_style_var(count)


@contextmanager
def istyled(*variables_and_values):
    # todo: rename to nstyled?
    count = 0
    iterator = iter(variables_and_values)

    try:
        # note: this is a trick that allows us convert flat list to pairs
        for var, val in izip_longest(iterator, iterator, fillvalue=None):
            # note: since we group into pairs it is impossible to have
            #       var equal to None
            if val is not None:
                count += core.push_style_var(var, val)
            else:
                raise ValueError(
                    "Unsufficient style info: {} variable lacks a value"
                    "".format(var)
                )
    except:
        raise
    else:
        yield

    finally:
        # perf: short wiring despite we have a wrapper for this
        cimgui.PopStyleVar(count)


def vertex_buffer_vertex_pos_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).pos

def vertex_buffer_vertex_uv_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).uv

def vertex_buffer_vertex_col_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).col

def vertex_buffer_vertex_size():
    return sizeof(cimgui.ImDrawVert)

def index_buffer_index_size():
    return sizeof(cimgui.ImDrawIdx)
