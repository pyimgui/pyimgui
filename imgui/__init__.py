# -*- coding: utf-8 -*-
VERSION = (0, 0, 2)  # PEP 386
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
#: Shortcut: ``imgui.TREE_NODE_FRAMED | imgui.TREE_NODE_NO_AUTO_OPEN_ON_LOG``.
TREE_NODE_COLLAPSING_HEADER = core.TREE_NODE_COLLAPSING_HEADER

# === Color flag constants (redefines for autodoc)
COLOR_TEXT = core.COLOR_TEXT
COLOR_TEXT_DISABLED = core.COLOR_TEXT_DISABLED
COLOR_WINDOW_BACKGROUND = core.COLOR_WINDOW_BACKGROUND
COLOR_CHILD_WINDOW_BACKGROUND = core.COLOR_CHILD_WINDOW_BACKGROUND
COLOR_POPUP_BACKGROUND = core.COLOR_POPUP_BACKGROUND
COLOR_BORDER = core.COLOR_BORDER
COLOR_BORDER_SHADOW = core.COLOR_BORDER_SHADOW
COLOR_FRAME_BACKGROUND = core.COLOR_FRAME_BACKGROUND
COLOR_FRAME_BACKGROUND_HOVERED = core.COLOR_FRAME_BACKGROUND_HOVERED
COLOR_FRAME_BACKGROUND_ACTIVE = core.COLOR_FRAME_BACKGROUND_ACTIVE
COLOR_TITLE_BACKGROUND = core.COLOR_TITLE_BACKGROUND
COLOR_TITLE_BACKGROUND_COLLAPSED = core.COLOR_TITLE_BACKGROUND_COLLAPSED
COLOR_TITLE_BACKGROUND_ACTIVE = core.COLOR_TITLE_BACKGROUND_ACTIVE
COLOR_MENUBAR_BACKGROUND = core.COLOR_MENUBAR_BACKGROUND
COLOR_SCROLLBAR_BACKGROUND = core.COLOR_SCROLLBAR_BACKGROUND
COLOR_SCROLLBAR_GRAB = core.COLOR_SCROLLBAR_GRAB
COLOR_SCROLLBAR_GRAB_HOVERED = core.COLOR_SCROLLBAR_GRAB_HOVERED
COLOR_SCROLLBAR_GRAB_ACTIVE = core.COLOR_SCROLLBAR_GRAB_ACTIVE
COLOR_COMBO_BACKGROUND = core.COLOR_COMBO_BACKGROUND
COLOR_CHECK_MARK = core.COLOR_CHECK_MARK
COLOR_SLIDER_GRAB = core.COLOR_SLIDER_GRAB
COLOR_SLIDER_GRAB_ACTIVE = core.COLOR_SLIDER_GRAB_ACTIVE
COLOR_BUTTON = core.COLOR_BUTTON
COLOR_BUTTON_HOVERED = core.COLOR_BUTTON_HOVERED
COLOR_BUTTON_ACTIVE = core.COLOR_BUTTON_ACTIVE
COLOR_HEADER = core.COLOR_HEADER
COLOR_HEADER_HOVERED = core.COLOR_HEADER_HOVERED
COLOR_HEADER_ACTIVE = core.COLOR_HEADER_ACTIVE
COLOR_COLUMN = core.COLOR_COLUMN
COLOR_COLUMN_HOVERED = core.COLOR_COLUMN_HOVERED
COLOR_COLUMN_ACTIVE = core.COLOR_COLUMN_ACTIVE
COLOR_RESIZE_GRIP = core.COLOR_RESIZE_GRIP
COLOR_RESIZE_GRIP_HOVERED = core.COLOR_RESIZE_GRIP_HOVERED
COLOR_RESIZE_GRIP_ACTIVE = core.COLOR_RESIZE_GRIP_ACTIVE
COLOR_CLOSE_BUTTON = core.COLOR_CLOSE_BUTTON
COLOR_CLOSE_BUTTON_HOVERED = core.COLOR_CLOSE_BUTTON_HOVERED
COLOR_CLOSE_BUTTON_ACTIVE = core.COLOR_CLOSE_BUTTON_ACTIVE
COLOR_PLOT_LINES = core.COLOR_PLOT_LINES
COLOR_PLOT_LINES_HOVERED = core.COLOR_PLOT_LINES_HOVERED
COLOR_PLOT_HISTOGRAM = core.COLOR_PLOT_HISTOGRAM
COLOR_PLOT_HISTOGRAM_HOVERED = core.COLOR_PLOT_HISTOGRAM_HOVERED
COLOR_TEXT_SELECTED_BACKGROUND = core.COLOR_TEXT_SELECTED_BACKGROUND
COLOR_MODAL_WINDOW_DARKENING = core.COLOR_MODAL_WINDOW_DARKENING
COLOR_COUNT = core.COLOR_COUNT

# === Selectable flag constants (redefines for autodoc)
#: Clicking this don't close parent popup window.
SELECTABLE_DONT_CLOSE_POPUPS = core.SELECTABLE_DONT_CLOSE_POPUPS
#: Selectable frame can span all columns
#: (text will still fit in current column).
SELECTABLE_SPAN_ALL_COLUMNS = core.SELECTABLE_SPAN_ALL_COLUMNS
#: Generate press events on double clicks too.
SELECTABLE_ALLOW_DOUBLE_CLICK = core.SELECTABLE_ALLOW_DOUBLE_CLICK

# === Mouse cursor flag constants (redefines for autodoc)
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

# === Text input flag constants (redefines for autodoc)
#: Allow ``0123456789.+-*/``
INPUT_TEXT_CHARS_DECIMAL = core.INPUT_TEXT_CHARS_DECIMAL
#: Allow ``0123456789ABCDEFabcdef``
INPUT_TEXT_CHARS_HEXADECIMAL = core.INPUT_TEXT_CHARS_HEXADECIMAL
#: Turn a..z into A..Z
INPUT_TEXT_CHARS_UPPERCASE = core.INPUT_TEXT_CHARS_UPPERCASE
#: Filter out spaces, tabs
INPUT_TEXT_CHARS_NO_BLANK = core.INPUT_TEXT_CHARS_NO_BLANK
#: Select entire text when first taking mouse focus
INPUT_TEXT_AUTO_SELECT_ALL = core.INPUT_TEXT_AUTO_SELECT_ALL
#: Return 'true' when Enter is pressed (as opposed to when the
#: value was modified)
INPUT_TEXT_ENTER_RETURNS_TRUE = core.INPUT_TEXT_ENTER_RETURNS_TRUE
#: Call user function on pressing TAB (for completion handling)
INPUT_TEXT_CALLBACK_COMPLETION = core.INPUT_TEXT_CALLBACK_COMPLETION
#: Call user function on pressing Up/Down arrows (for history handling)
INPUT_TEXT_CALLBACK_HISTORY = core.INPUT_TEXT_CALLBACK_HISTORY
#: Call user function every time. User code may query cursor position,
#: modify text buffer.
INPUT_TEXT_CALLBACK_ALWAYS = core.INPUT_TEXT_CALLBACK_ALWAYS
#: Call user function to filter character. Modify data->EventChar to
#: replace/filter input, or return 1 to discard character.
INPUT_TEXT_CALLBACK_CHAR_FILTER = core.INPUT_TEXT_CALLBACK_CHAR_FILTER
#: Pressing TAB input a '\t' character into the text field
INPUT_TEXT_ALLOW_TAB_INPUT = core.INPUT_TEXT_ALLOW_TAB_INPUT
#: In multi-line mode, allow exiting edition by pressing Enter.
#: Ctrl+Enter to add new line (by default adds new lines with Enter).
INPUT_TEXT_CTRL_ENTER_FOR_NEW_LINE = core.INPUT_TEXT_CTRL_ENTER_FOR_NEW_LINE
#: Disable following the cursor horizontally
INPUT_TEXT_NO_HORIZONTAL_SCROLL = core.INPUT_TEXT_NO_HORIZONTAL_SCROLL
#: Insert mode
INPUT_TEXT_ALWAYS_INSERT_MODE = core.INPUT_TEXT_ALWAYS_INSERT_MODE
#: Read-only mode
INPUT_TEXT_READ_ONLY = core.INPUT_TEXT_READ_ONLY
#: Password mode, display all characters as '*'
INPUT_TEXT_PASSWORD = core.INPUT_TEXT_PASSWORD
