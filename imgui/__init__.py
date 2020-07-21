# -*- coding: utf-8 -*-
VERSION = (1, 2, 0)  # PEP 386
__version__ = ".".join([str(x) for x in VERSION])

from imgui import core, extra, _compat, flags  # noqa
from imgui.core import *  # noqa
from imgui.extra import *  # noqa
from imgui.flags import *  # noqa


VERTEX_BUFFER_POS_OFFSET = extra.vertex_buffer_vertex_pos_offset()
VERTEX_BUFFER_UV_OFFSET = extra.vertex_buffer_vertex_uv_offset()
VERTEX_BUFFER_COL_OFFSET = extra.vertex_buffer_vertex_col_offset()
VERTEX_SIZE = extra.vertex_buffer_vertex_size()
INDEX_SIZE = extra.index_buffer_index_size()
