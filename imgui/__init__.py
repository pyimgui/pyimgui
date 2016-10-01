# -*- coding: utf-8 -*-
VERSION = (0, 0, 0)  # PEP 386
__version__ = ".".join([str(x) for x in VERSION])

from imgui.core import *  # noqa
from imgui import core


VERTEX_BUFFER_POS_OFFSET = core.vertex_buffer_vertex_pos_offset()
VERTEX_BUFFER_UV_OFFSET = core.vertex_buffer_vertex_uv_offset()
VERTEX_BUFFER_COL_OFFSET = core.vertex_buffer_vertex_col_offset()
VERTEX_SIZE = core.vertex_buffer_vertex_size()
INDEX_SIZE = core.index_buffer_index_size()
