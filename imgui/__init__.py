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
#: associated type: ``float``.
STYLE_ALPHA = core.STYLE_ALPHA
#: associated type: ``Vec2``.
STYLE_WINDOW_PADDING = core.STYLE_WINDOW_PADDING
#: associated type: ``float``.
STYLE_WINDOW_ROUNDING = core.STYLE_WINDOW_ROUNDING
#: associated type: ``Vec2``.
STYLE_WINDOW_MIN_SIZE = core.STYLE_WINDOW_MIN_SIZE
#: associated type: ``float``.
STYLE_CHILD_WINDOW_ROUNDING = core.STYLE_CHILD_WINDOW_ROUNDING
#: associated type: ``Vec2``.
STYLE_FRAME_PADDING = core.STYLE_FRAME_PADDING
#: associated type: ``float``.
STYLE_FRAME_ROUNDING = core.STYLE_FRAME_ROUNDING
#: associated type: ``Vec2``.
STYLE_ITEM_SPACING = core.STYLE_ITEM_SPACING
#: associated type: ``Vec2``.
STYLE_ITEM_INNER_SPACING = core.STYLE_ITEM_INNER_SPACING
#: associated type: ``float``.
STYLE_INDENT_SPACING = core.STYLE_INDENT_SPACING
#: associated type: ``float``.
STYLE_GRAB_MIN_SIZE = core.STYLE_GRAB_MIN_SIZE

if hasattr(core, 'STYLE_BUTTON_TEXT_ALIGN'):
    #: associated type: flags ImGuiAlign_*.
    STYLE_BUTTON_TEXT_ALIGN = core.STYLE_BUTTON_TEXT_ALIGN

# === Window flag constants (redefines for autodoc)
#: Disable title-bar.
WINDOW_NO_TITLE_BAR = core.WINDOW_NO_TITLE_BAR
#: Disable user resizing with the lower-right grip.
WINDOW_NO_RESIZE = core.WINDOW_NO_RESIZE
#: Disable user moving the window.
WINDOW_NO_MOVE = core.WINDOW_NO_MOVE
#: Disable scrollbars (window can still scroll with mouse or programatically).
WINDOW_NO_SCROLLBAR = core.WINDOW_NO_SCROLLBAR
#: Disable user vertically scrolling with mouse wheel.
WINDOW_NO_SCROLL_WITH_MOUSE = core.WINDOW_NO_SCROLL_WITH_MOUSE
#: Disable user collapsing window by double-clicking on it.
WINDOW_NO_COLLAPSE = core.WINDOW_NO_COLLAPSE
#: Resize every window to its content every frame.
WINDOW_ALWAYS_AUTO_RESIZE = core.WINDOW_ALWAYS_AUTO_RESIZE
#: Show borders around windows and items.
WINDOW_SHOW_BORDERS = core.WINDOW_SHOW_BORDERS
#: Never load/save settings in ``.ini`` file.
WINDOW_NO_SAVED_SETTINGS = core.WINDOW_NO_SAVED_SETTINGS
#: Disable catching mouse or keyboard inputs.
WINDOW_NO_INPUTS = core.WINDOW_NO_INPUTS
#: Has a menu-bar.
WINDOW_MENU_BAR = core.WINDOW_MENU_BAR
#: Allow horizontal scrollbar to appear (off by default).
WINDOW_HORIZONTAL_SCROLLING_BAR = core.WINDOW_HORIZONTAL_SCROLLING_BAR
#: Disable taking focus when transitioning from hidden to visible state.
WINDOW_NO_FOCUS_ON_APPEARING = core.WINDOW_NO_FOCUS_ON_APPEARING
#: Disable bringing window to front when taking focus (e.g. clicking on it or
#: programatically giving it focus).
WINDOW_NO_BRING_TO_FRONT_ON_FOCUS = core.WINDOW_NO_BRING_TO_FRONT_ON_FOCUS
#: Always show vertical scrollbar (even if ContentSize.y < Size.y).
WINDOW_ALWAYS_VERTICAL_SCROLLBAR = core.WINDOW_ALWAYS_VERTICAL_SCROLLBAR
#: Always show horizontal scrollbar (even if ContentSize.x < Size.x).
WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR = core.WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR
#: Ensure child windows without border uses style.WindowPadding (ignored by
#: default for non-bordered child windows, because more convenient).
WINDOW_ALWAYS_USE_WINDOW_PADDING = core.WINDOW_ALWAYS_USE_WINDOW_PADDING

# === Tree node flag constants (redefines for autodoc)
#: Draw as selected
TREE_NODE_SELECTED = core.TREE_NODE_SELECTED
#: Full colored frame (e.g. for :func:`imgui.core.collapsing_header`).
TREE_NODE_FRAMED = core.TREE_NODE_FRAMED
#: Hit testing to allow subsequent widgets to overlap this one.
TREE_NODE_ALLOW_OVERLAP_MODE = core.TREE_NODE_ALLOW_OVERLAP_MODE
#: Don't do a ``TreePush()`` when open
#: (e.g. for :func:`imgui.core.collapsing_header`).
#: No extra indent nor pushing on ID stack.
TREE_NODE_NO_TREE_PUSH_ON_OPEN = core.TREE_NODE_NO_TREE_PUSH_ON_OPEN
#: Don't automatically and temporarily open node when Logging is active
#: (by default logging will automatically open tree nodes).
TREE_NODE_NO_AUTO_OPEN_ON_LOG = core.TREE_NODE_NO_AUTO_OPEN_ON_LOG
#: Default node to be open.
TREE_NODE_DEFAULT_OPEN = core.TREE_NODE_DEFAULT_OPEN
#: Need double-click to open node.
TREE_NODE_OPEN_ON_DOUBLE_CLICK = core.TREE_NODE_OPEN_ON_DOUBLE_CLICK
#: Only open when clicking on the arrow part. If
#: :py:data:`TREE_NODE_OPEN_ON_DOUBLE_CLICK` is also set,
#: single-click arrow or double-click all box to open.
TREE_NODE_OPEN_ON_ARROW = core.TREE_NODE_OPEN_ON_ARROW
#: No collapsing, no arrow (use as a convenience for leaf nodes).
TREE_NODE_LEAF = core.TREE_NODE_LEAF
#: Display a bullet instead of arrow.
TREE_NODE_BULLET = core.TREE_NODE_BULLET
#: Shortcut: ``imgui.TREE_NODE_FRAMED | imgui.TREE_NODE_NO_AUTO_OPEN_ON_LOG``
TREE_NODE_COLLAPSING_HEADER = core.TREE_NODE_COLLAPSING_HEADER

# === Selectable flag constants (redefines for autodoc)
#: Clicking this don't close parent popup window.
SELECTABLE_DONT_CLOSE_POPUPS = core.SELECTABLE_DONT_CLOSE_POPUPS
#: Selectable frame can span all columns
#: (text will still fit in current column).
SELECTABLE_SPAN_ALL_COLUMNS = core.SELECTABLE_SPAN_ALL_COLUMNS
#: Generate press events on double clicks too.
SELECTABLE_ALLOW_DOUBLE_CLICK = core.SELECTABLE_ALLOW_DOUBLE_CLICK

MOUSE_CURSOR_ARROW = core.MOUSE_CURSOR_ARROW
#: When hovering over InputText, etc.
MOUSE_CURSOR_TEXT_INPUT = core.MOUSE_CURSOR_TEXT_INPUT
#: Unused
MOUSE_CURSOR_MOVE = core.MOUSE_CURSOR_MOVE
#: Unused
MOUSE_CURSOR_RESIZE_NS = core.MOUSE_CURSOR_RESIZE_NS
#: When hovering over a column
MOUSE_CURSOR_RESIZE_EW = core.MOUSE_CURSOR_RESIZE_EW
#: Unused
MOUSE_CURSOR_RESIZE_NESW = core.MOUSE_CURSOR_RESIZE_NESW
#: When hovering over the bottom-right corner of a window
MOUSE_CURSOR_RESIZE_NWSE = core.MOUSE_CURSOR_RESIZE_NWSE
