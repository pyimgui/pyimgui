"""
This module provides extra utilities that are not part of core ImGui C++ API
but are useful in Python application.

"""
from contextlib import contextmanager
from . import core

__all__ = (
    "font",
    "styled",
    "istyled",
    "colored",
    "vertex_buffer_vertex_pos_offset",
    "vertex_buffer_vertex_uv_offset",
    "vertex_buffer_vertex_col_offset",
    "vertex_buffer_vertex_size",
    "index_buffer_index_size",
    "scope",
)

font = core._py_font
styled = core._py_styled
istyled = core._py_istyled
colored = core._py_colored
vertex_buffer_vertex_pos_offset = core._py_vertex_buffer_vertex_pos_offset
vertex_buffer_vertex_uv_offset = core._py_vertex_buffer_vertex_uv_offset
vertex_buffer_vertex_col_offset = core._py_vertex_buffer_vertex_col_offset
vertex_buffer_vertex_size = core._py_vertex_buffer_vertex_size
index_buffer_index_size = core._py_index_buffer_index_size

@contextmanager
def scope(arg):
    """
    Push an id scope for the duration of the context manager. `arg` should be
    something that will persist between ui draws.
    """
    core.push_id(arg)
    yield
    core.pop_id()