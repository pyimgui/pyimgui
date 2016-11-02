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

# ==== Condition constants (redefines for autodoc)
#: Set the variable always
ALWAYS = core.ALWAYS
#: Only set the variable on the first call per runtime session
ONCE = core.ONCE
#: Only set the variable if the window doesn't exist in the .ini file
FIRST_USE_EVER = core.FIRST_USE_EVER
#: Only set the variable if the window is appearing after being inactive
#: (or the first time)
APPEARING = core.APPEARING


# === Key map constants (redefines for autodoc)
#: for tabbing through fields
KEY_TAB = core.KEY_TAB
#: for text edit
KEY_LEFT_ARROW = core.KEY_LEFT_ARROW
#: for text edit
KEY_RIGHT_ARROW = core.KEY_UP_ARROW
#: for text edit
KEY_UP_ARROW = core.KEY_UP_ARROW
#: for text edit
KEY_DOWN_ARROW = core.KEY_DOWN_ARROW
KEY_PAGE_UP = core.KEY_PAGE_UP
KEY_PAGE_DOWN = core.KEY_PAGE_DOWN
#: for text edit
KEY_HOME = core.KEY_HOME
#: for text edit
KEY_END = core.KEY_END
#: for text edit
KEY_DELETE = core.KEY_DELETE
#: for text edit
KEY_BACKSPACE = core.KEY_BACKSPACE
#: for text edit
KEY_ENTER = core.KEY_ENTER
#: for text edit
KEY_ESCAPE = core.KEY_ESCAPE
#: for text edit CTRL+A: select all
KEY_A = core.KEY_A
#: for text edit CTRL+C: copy
KEY_C = core.KEY_C
#: for text edit CTRL+V: paste
KEY_V = core.KEY_V
#: for text edit CTRL+X: cut
KEY_X = core.KEY_X
#: for text edit CTRL+Y: redo
KEY_Y = core.KEY_Y
#: for text edit CTRL+Z: undo
KEY_Z = core.KEY_Z


# === Style var constants (redefines for autodoc)
#: associated type: ``float``
STYLE_ALPHA = core.STYLE_ALPHA
#: associated type: ``Vec2``
STYLE_WINDOW_PADDING = core.STYLE_WINDOW_PADDING
#: associated type: ``float``
STYLE_WINDOW_ROUNDING = core.STYLE_WINDOW_ROUNDING
#: associated type: ``Vec2``
STYLE_WINDOW_MIN_SIZE = core.STYLE_WINDOW_MIN_SIZE
#: associated type: ``float``
STYLE_CHILD_WINDOW_ROUNDING = core.STYLE_CHILD_WINDOW_ROUNDING
#: associated type: ``Vec2``
STYLE_FRAME_PADDING = core.STYLE_FRAME_PADDING
#: associated type: ``float``
STYLE_FRAME_ROUNDING = core.STYLE_FRAME_ROUNDING
#: associated type: ``Vec2``
STYLE_ITEM_SPACING = core.STYLE_ITEM_SPACING
#: associated type: ``Vec2``
STYLE_ITEM_INNER_SPACING = core.STYLE_ITEM_INNER_SPACING
#: associated type: ``float``
STYLE_INDENT_SPACING = core.STYLE_INDENT_SPACING
#: associated type: ``float``
STYLE_GRAB_MIN_SIZE = core.STYLE_GRAB_MIN_SIZE

if hasattr(core, 'STYLE_BUTTON_TEXT_ALIGN'):
    #: associated type: flags ImGuiAlign_*
    STYLE_BUTTON_TEXT_ALIGN = core.STYLE_BUTTON_TEXT_ALIGN
