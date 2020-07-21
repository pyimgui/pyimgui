from imgui import core

# ==== Condition enum redefines ====
#: No condition (always set the variable), same as _Always
NONE = core.NONE
#: No condition (always set the variable)
ALWAYS = core.ALWAYS
#: Set the variable once per runtime session (only the first call will succeed)
ONCE = core.ONCE
#: Set the variable if the object/window has no persistently saved data (no entry in .ini file)
FIRST_USE_EVER = core.FIRST_USE_EVER
#: Set the variable if the object/window is appearing after being hidden/inactive (or the first time)
APPEARING = core.APPEARING

# ==== Style var enum redefines ====
#: float     Alpha
STYLE_ALPHA = core.STYLE_ALPHA
#: ImVec2    WindowPadding
STYLE_WINDOW_PADDING = core.STYLE_WINDOW_PADDING
#: float     WindowRounding
STYLE_WINDOW_ROUNDING = core.STYLE_WINDOW_ROUNDING
#: float     WindowBorderSize
STYLE_WINDOW_BORDER_SIZE = core.STYLE_WINDOW_BORDER_SIZE
#: ImVec2    WindowMinSize
STYLE_WINDOW_MIN_SIZE = core.STYLE_WINDOW_MIN_SIZE
#: ImVec2    WindowTitleAlign
STYLE_WINDOW_TITLE_ALIGN = core.STYLE_WINDOW_TITLE_ALIGN
#: float     ChildRounding
STYLE_CHILD_ROUNDING = core.STYLE_CHILD_ROUNDING
#: float     ChildBorderSize
STYLE_CHILD_BORDER_SIZE = core.STYLE_CHILD_BORDER_SIZE
#: float     PopupRounding
STYLE_POPUP_ROUNDING = core.STYLE_POPUP_ROUNDING
#: float     PopupBorderSize
STYLE_POPUP_BORDER_SIZE = core.STYLE_POPUP_BORDER_SIZE
#: ImVec2    FramePadding
STYLE_FRAME_PADDING = core.STYLE_FRAME_PADDING
#: float     FrameRounding
STYLE_FRAME_ROUNDING = core.STYLE_FRAME_ROUNDING
#: float     FrameBorderSize
STYLE_FRAME_BORDER_SIZE = core.STYLE_FRAME_BORDER_SIZE
#: ImVec2    ItemSpacing
STYLE_ITEM_SPACING = core.STYLE_ITEM_SPACING
#: ImVec2    ItemInnerSpacing
STYLE_ITEM_INNER_SPACING = core.STYLE_ITEM_INNER_SPACING
#: float     IndentSpacing
STYLE_INDENT_SPACING = core.STYLE_INDENT_SPACING
#: float     ScrollbarSize
STYLE_SCROLLBAR_SIZE = core.STYLE_SCROLLBAR_SIZE
#: float     ScrollbarRounding
STYLE_SCROLLBAR_ROUNDING = core.STYLE_SCROLLBAR_ROUNDING
#: float     GrabMinSize
STYLE_GRAB_MIN_SIZE = core.STYLE_GRAB_MIN_SIZE
#: float     GrabRounding
STYLE_GRAB_ROUNDING = core.STYLE_GRAB_ROUNDING
#: float     TabRounding
STYLE_TAB_ROUNDING = core.STYLE_TAB_ROUNDING
#: ImVec2    ButtonTextAlign
STYLE_BUTTON_TEXT_ALIGN = core.STYLE_BUTTON_TEXT_ALIGN
#: ImVec2    SelectableTextAlign
STYLE_SELECTABLE_TEXT_ALIGN = core.STYLE_SELECTABLE_TEXT_ALIGN
STYLE_COUNT = core.STYLE_COUNT

# ==== Key map enum redefines ====
KEY_TAB = core.KEY_TAB
KEY_LEFT_ARROW = core.KEY_LEFT_ARROW
KEY_RIGHT_ARROW = core.KEY_RIGHT_ARROW
KEY_UP_ARROW = core.KEY_UP_ARROW
KEY_DOWN_ARROW = core.KEY_DOWN_ARROW
KEY_PAGE_UP = core.KEY_PAGE_UP
KEY_PAGE_DOWN = core.KEY_PAGE_DOWN
KEY_HOME = core.KEY_HOME
KEY_END = core.KEY_END
KEY_INSERT = core.KEY_INSERT
KEY_DELETE = core.KEY_DELETE
KEY_BACKSPACE = core.KEY_BACKSPACE
KEY_SPACE = core.KEY_SPACE
KEY_ENTER = core.KEY_ENTER
KEY_ESCAPE = core.KEY_ESCAPE
KEY_KEY_PAD_ENTER = core.KEY_KEY_PAD_ENTER
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
KEY_COUNT = core.KEY_COUNT

# ==== Window flags enum redefines ====
WINDOW_NONE = core.WINDOW_NONE
#: Disable title-bar
WINDOW_NO_TITLE_BAR = core.WINDOW_NO_TITLE_BAR
#: Disable user resizing with the lower-right grip
WINDOW_NO_RESIZE = core.WINDOW_NO_RESIZE
#: Disable user moving the window
WINDOW_NO_MOVE = core.WINDOW_NO_MOVE
#: Disable scrollbars (window can still scroll with mouse or programmatically)
WINDOW_NO_SCROLLBAR = core.WINDOW_NO_SCROLLBAR
#: Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
WINDOW_NO_SCROLL_WITH_MOUSE = core.WINDOW_NO_SCROLL_WITH_MOUSE
#: Disable user collapsing window by double-clicking on it
WINDOW_NO_COLLAPSE = core.WINDOW_NO_COLLAPSE
#: Resize every window to its content every frame
WINDOW_ALWAYS_AUTO_RESIZE = core.WINDOW_ALWAYS_AUTO_RESIZE
#: Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
WINDOW_NO_BACKGROUND = core.WINDOW_NO_BACKGROUND
#: Never load/save settings in .ini file
WINDOW_NO_SAVED_SETTINGS = core.WINDOW_NO_SAVED_SETTINGS
#: Disable catching mouse, hovering test with pass through.
WINDOW_NO_MOUSE_INPUTS = core.WINDOW_NO_MOUSE_INPUTS
#: Has a menu-bar
WINDOW_MENU_BAR = core.WINDOW_MENU_BAR
#: Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
WINDOW_HORIZONTAL_SCROLLBAR = core.WINDOW_HORIZONTAL_SCROLLBAR
#: Disable taking focus when transitioning from hidden to visible state
WINDOW_NO_FOCUS_ON_APPEARING = core.WINDOW_NO_FOCUS_ON_APPEARING
#: Disable bringing window to front when taking focus (e.g. clicking on it or programmatically giving it focus)
WINDOW_NO_BRING_TO_FRONT_ON_FOCUS = core.WINDOW_NO_BRING_TO_FRONT_ON_FOCUS
#: Always show vertical scrollbar (even if ContentSize.y < Size.y)
WINDOW_ALWAYS_VERTICAL_SCROLLBAR = core.WINDOW_ALWAYS_VERTICAL_SCROLLBAR
#: Always show horizontal scrollbar (even if ContentSize.x < Size.x)
WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR = core.WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR
#: Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
WINDOW_ALWAYS_USE_WINDOW_PADDING = core.WINDOW_ALWAYS_USE_WINDOW_PADDING
#: No gamepad/keyboard navigation within the window
WINDOW_NO_NAV_INPUTS = core.WINDOW_NO_NAV_INPUTS
#: No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
WINDOW_NO_NAV_FOCUS = core.WINDOW_NO_NAV_FOCUS
#: Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. When used in a tab/docking context, tab is selected on closure and closure is deferred by one frame to allow code to cancel the closure (with a confirmation popup, etc.) without flicker.
WINDOW_UNSAVED_DOCUMENT = core.WINDOW_UNSAVED_DOCUMENT
WINDOW_NO_NAV = core.WINDOW_NO_NAV
WINDOW_NO_DECORATION = core.WINDOW_NO_DECORATION
WINDOW_NO_INPUTS = core.WINDOW_NO_INPUTS
#: [BETA] Allow gamepad/keyboard navigation to cross over parent border to this child (only use on child that have no scrolling!)
WINDOW_NAV_FLATTENED = core.WINDOW_NAV_FLATTENED
#: Don't use! For internal use by BeginChild()
WINDOW_CHILD_WINDOW = core.WINDOW_CHILD_WINDOW
#: Don't use! For internal use by BeginTooltip()
WINDOW_TOOLTIP = core.WINDOW_TOOLTIP
#: Don't use! For internal use by BeginPopup()
WINDOW_POPUP = core.WINDOW_POPUP
#: Don't use! For internal use by BeginPopupModal()
WINDOW_MODAL = core.WINDOW_MODAL
#: Don't use! For internal use by BeginMenu()
WINDOW_CHILD_MENU = core.WINDOW_CHILD_MENU

# ==== TreeNode flags enum redefines ====
TREE_NODE_NONE = core.TREE_NODE_NONE
#: Draw as selected
TREE_NODE_SELECTED = core.TREE_NODE_SELECTED
#: Full colored frame (e.g. for CollapsingHeader)
TREE_NODE_FRAMED = core.TREE_NODE_FRAMED
#: Hit testing to allow subsequent widgets to overlap this one
TREE_NODE_ALLOW_ITEM_OVERLAP = core.TREE_NODE_ALLOW_ITEM_OVERLAP
#: Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
TREE_NODE_NO_TREE_PUSH_ON_OPEN = core.TREE_NODE_NO_TREE_PUSH_ON_OPEN
#: Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
TREE_NODE_NO_AUTO_OPEN_ON_LOG = core.TREE_NODE_NO_AUTO_OPEN_ON_LOG
#: Default node to be open
TREE_NODE_DEFAULT_OPEN = core.TREE_NODE_DEFAULT_OPEN
#: Need double-click to open node
TREE_NODE_OPEN_ON_DOUBLE_CLICK = core.TREE_NODE_OPEN_ON_DOUBLE_CLICK
#: Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
TREE_NODE_OPEN_ON_ARROW = core.TREE_NODE_OPEN_ON_ARROW
#: No collapsing, no arrow (use as a convenience for leaf nodes).
TREE_NODE_LEAF = core.TREE_NODE_LEAF
#: Display a bullet instead of arrow
TREE_NODE_BULLET = core.TREE_NODE_BULLET
#: Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
TREE_NODE_FRAME_PADDING = core.TREE_NODE_FRAME_PADDING
#: Extend hit box to the right-most edge, even if not framed. This is not the default in order to allow adding other items on the same line. In the future we may refactor the hit system to be front-to-back, allowing natural overlaps and then this can become the default.
TREE_NODE_SPAN_AVAIL_WIDTH = core.TREE_NODE_SPAN_AVAIL_WIDTH
#: Extend hit box to the left-most and right-most edges (bypass the indented area).
TREE_NODE_SPAN_FULL_WIDTH = core.TREE_NODE_SPAN_FULL_WIDTH
#: (WIP) Nav: left direction may move to this TreeNode() from any of its child (items submitted between TreeNode and TreePop)
TREE_NODE_NAV_LEFT_JUMPS_BACK_HERE = core.TREE_NODE_NAV_LEFT_JUMPS_BACK_HERE
TREE_NODE_COLLAPSING_HEADER = core.TREE_NODE_COLLAPSING_HEADER

# ==== Selectable flags enum redefines ====
SELECTABLE_NONE = core.SELECTABLE_NONE
#: Clicking this don't close parent popup window
SELECTABLE_DONT_CLOSE_POPUPS = core.SELECTABLE_DONT_CLOSE_POPUPS
#: Selectable frame can span all columns (text will still fit in current column)
SELECTABLE_SPAN_ALL_COLUMNS = core.SELECTABLE_SPAN_ALL_COLUMNS
#: Generate press events on double clicks too
SELECTABLE_ALLOW_DOUBLE_CLICK = core.SELECTABLE_ALLOW_DOUBLE_CLICK
#: Cannot be selected, display grayed out text
SELECTABLE_DISABLED = core.SELECTABLE_DISABLED
#: (WIP) Hit testing to allow subsequent widgets to overlap this one
SELECTABLE_ALLOW_ITEM_OVERLAP = core.SELECTABLE_ALLOW_ITEM_OVERLAP

# ==== Combo flags enum redefines ====
COMBO_NONE = core.COMBO_NONE
#: Align the popup toward the left by default
COMBO_POPUP_ALIGN_LEFT = core.COMBO_POPUP_ALIGN_LEFT
#: Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
COMBO_HEIGHT_SMALL = core.COMBO_HEIGHT_SMALL
#: Max ~8 items visible (default)
COMBO_HEIGHT_REGULAR = core.COMBO_HEIGHT_REGULAR
#: Max ~20 items visible
COMBO_HEIGHT_LARGE = core.COMBO_HEIGHT_LARGE
#: As many fitting items as possible
COMBO_HEIGHT_LARGEST = core.COMBO_HEIGHT_LARGEST
#: Display on the preview box without the square arrow button
COMBO_NO_ARROW_BUTTON = core.COMBO_NO_ARROW_BUTTON
#: Display only a square arrow button
COMBO_NO_PREVIEW = core.COMBO_NO_PREVIEW
COMBO_HEIGHT_MASK_ = core.COMBO_HEIGHT_MASK_

# === Focus flag enum redefines ====
FOCUS_NONE = core.FOCUS_NONE
#: IsWindowFocused(): Return true if any children of the window is focused
FOCUS_CHILD_WINDOWS = core.FOCUS_CHILD_WINDOWS
#: IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
FOCUS_ROOT_WINDOW = core.FOCUS_ROOT_WINDOW
#: IsWindowFocused(): Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use 'io.WantCaptureMouse' instead! Please read the FAQ!
FOCUS_ANY_WINDOW = core.FOCUS_ANY_WINDOW
FOCUS_ROOT_AND_CHILD_WINDOWS = core.FOCUS_ROOT_AND_CHILD_WINDOWS

# === Hovered flag enum redefines ====
#: Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
HOVERED_NONE = core.HOVERED_NONE
#: IsWindowHovered() only: Return true if any children of the window is hovered
HOVERED_CHILD_WINDOWS = core.HOVERED_CHILD_WINDOWS
#: IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
HOVERED_ROOT_WINDOW = core.HOVERED_ROOT_WINDOW
#: IsWindowHovered() only: Return true if any window is hovered
HOVERED_ANY_WINDOW = core.HOVERED_ANY_WINDOW
#: Return true even if a popup window is normally blocking access to this item/window
HOVERED_ALLOW_WHEN_BLOCKED_BY_POPUP = core.HOVERED_ALLOW_WHEN_BLOCKED_BY_POPUP
#: Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
HOVERED_ALLOW_WHEN_BLOCKED_BY_ACTIVE_ITEM = core.HOVERED_ALLOW_WHEN_BLOCKED_BY_ACTIVE_ITEM
#: Return true even if the position is obstructed or overlapped by another window
HOVERED_ALLOW_WHEN_OVERLAPPED = core.HOVERED_ALLOW_WHEN_OVERLAPPED
#: Return true even if the item is disabled
HOVERED_ALLOW_WHEN_DISABLED = core.HOVERED_ALLOW_WHEN_DISABLED
HOVERED_RECT_ONLY = core.HOVERED_RECT_ONLY
HOVERED_ROOT_AND_CHILD_WINDOWS = core.HOVERED_ROOT_AND_CHILD_WINDOWS

# === Drag Drop flag enum redefines ====
DRAG_DROP_NONE = core.DRAG_DROP_NONE
#: By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
DRAG_DROP_SOURCE_NO_PREVIEW_TOOLTIP = core.DRAG_DROP_SOURCE_NO_PREVIEW_TOOLTIP
#: By default, when dragging we clear data so that IsItemHovered() will return false, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
DRAG_DROP_SOURCE_NO_DISABLE_HOVER = core.DRAG_DROP_SOURCE_NO_DISABLE_HOVER
#: Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
DRAG_DROP_SOURCE_NO_HOLD_TO_OPEN_OTHERS = core.DRAG_DROP_SOURCE_NO_HOLD_TO_OPEN_OTHERS
#: Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
DRAG_DROP_SOURCE_ALLOW_NULL_ID = core.DRAG_DROP_SOURCE_ALLOW_NULL_ID
#: External source (from outside of dear imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
DRAG_DROP_SOURCE_EXTERN = core.DRAG_DROP_SOURCE_EXTERN
#: Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
DRAG_DROP_SOURCE_AUTO_EXPIRE_PAYLOAD = core.DRAG_DROP_SOURCE_AUTO_EXPIRE_PAYLOAD
#: AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
DRAG_DROP_ACCEPT_BEFORE_DELIVERY = core.DRAG_DROP_ACCEPT_BEFORE_DELIVERY
#: Do not draw the default highlight rectangle when hovering over target.
DRAG_DROP_ACCEPT_NO_DRAW_DEFAULT_RECT = core.DRAG_DROP_ACCEPT_NO_DRAW_DEFAULT_RECT
#: Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
DRAG_DROP_ACCEPT_NO_PREVIEW_TOOLTIP = core.DRAG_DROP_ACCEPT_NO_PREVIEW_TOOLTIP
#: For peeking ahead and inspecting the payload before delivery.
DRAG_DROP_ACCEPT_PEEK_ONLY = core.DRAG_DROP_ACCEPT_PEEK_ONLY

# === Cardinal Direction enum redefines ====
DIRECTION_NONE = core.DIRECTION_NONE
DIRECTION_LEFT = core.DIRECTION_LEFT
DIRECTION_RIGHT = core.DIRECTION_RIGHT
DIRECTION_UP = core.DIRECTION_UP
DIRECTION_DOWN = core.DIRECTION_DOWN
DIRECTION_COUNT = core.DIRECTION_COUNT

# ==== Mouse Cursors ====
MOUSE_CURSOR_NONE = core.MOUSE_CURSOR_NONE
MOUSE_CURSOR_ARROW = core.MOUSE_CURSOR_ARROW
#: When hovering over InputText, etc.
MOUSE_CURSOR_TEXT_INPUT = core.MOUSE_CURSOR_TEXT_INPUT
#: (Unused by Dear ImGui functions)
MOUSE_CURSOR_RESIZE_ALL = core.MOUSE_CURSOR_RESIZE_ALL
#: When hovering over an horizontal border
MOUSE_CURSOR_RESIZE_NS = core.MOUSE_CURSOR_RESIZE_NS
#: When hovering over a vertical border or a column
MOUSE_CURSOR_RESIZE_EW = core.MOUSE_CURSOR_RESIZE_EW
#: When hovering over the bottom-left corner of a window
MOUSE_CURSOR_RESIZE_NESW = core.MOUSE_CURSOR_RESIZE_NESW
#: When hovering over the bottom-right corner of a window
MOUSE_CURSOR_RESIZE_NWSE = core.MOUSE_CURSOR_RESIZE_NWSE
#: (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
MOUSE_CURSOR_HAND = core.MOUSE_CURSOR_HAND
#: When hovering something with disallowed interaction. Usually a crossed circle.
MOUSE_CURSOR_NOT_ALLOWED = core.MOUSE_CURSOR_NOT_ALLOWED
MOUSE_CURSOR_COUNT = core.MOUSE_CURSOR_COUNT

# ==== Color identifiers for styling ====
COLOR_TEXT = core.COLOR_TEXT
COLOR_TEXT_DISABLED = core.COLOR_TEXT_DISABLED
#: Background of normal windows
COLOR_WINDOW_BG = core.COLOR_WINDOW_BG
#: Background of child windows
COLOR_CHILD_BG = core.COLOR_CHILD_BG
#: Background of popups, menus, tooltips windows
COLOR_POPUP_BG = core.COLOR_POPUP_BG
COLOR_BORDER = core.COLOR_BORDER
COLOR_BORDER_SHADOW = core.COLOR_BORDER_SHADOW
#: Background of checkbox, radio button, plot, slider, text input
COLOR_FRAME_BG = core.COLOR_FRAME_BG
COLOR_FRAME_BG_HOVERED = core.COLOR_FRAME_BG_HOVERED
COLOR_FRAME_BG_ACTIVE = core.COLOR_FRAME_BG_ACTIVE
COLOR_TITLE_BG = core.COLOR_TITLE_BG
COLOR_TITLE_BG_ACTIVE = core.COLOR_TITLE_BG_ACTIVE
COLOR_TITLE_BG_COLLAPSED = core.COLOR_TITLE_BG_COLLAPSED
COLOR_MENU_BAR_BG = core.COLOR_MENU_BAR_BG
COLOR_SCROLLBAR_BG = core.COLOR_SCROLLBAR_BG
COLOR_SCROLLBAR_GRAB = core.COLOR_SCROLLBAR_GRAB
COLOR_SCROLLBAR_GRAB_HOVERED = core.COLOR_SCROLLBAR_GRAB_HOVERED
COLOR_SCROLLBAR_GRAB_ACTIVE = core.COLOR_SCROLLBAR_GRAB_ACTIVE
COLOR_CHECK_MARK = core.COLOR_CHECK_MARK
COLOR_SLIDER_GRAB = core.COLOR_SLIDER_GRAB
COLOR_SLIDER_GRAB_ACTIVE = core.COLOR_SLIDER_GRAB_ACTIVE
COLOR_BUTTON = core.COLOR_BUTTON
COLOR_BUTTON_HOVERED = core.COLOR_BUTTON_HOVERED
COLOR_BUTTON_ACTIVE = core.COLOR_BUTTON_ACTIVE
#: Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
COLOR_HEADER = core.COLOR_HEADER
COLOR_HEADER_HOVERED = core.COLOR_HEADER_HOVERED
COLOR_HEADER_ACTIVE = core.COLOR_HEADER_ACTIVE
COLOR_SEPARATOR = core.COLOR_SEPARATOR
COLOR_SEPARATOR_HOVERED = core.COLOR_SEPARATOR_HOVERED
COLOR_SEPARATOR_ACTIVE = core.COLOR_SEPARATOR_ACTIVE
COLOR_RESIZE_GRIP = core.COLOR_RESIZE_GRIP
COLOR_RESIZE_GRIP_HOVERED = core.COLOR_RESIZE_GRIP_HOVERED
COLOR_RESIZE_GRIP_ACTIVE = core.COLOR_RESIZE_GRIP_ACTIVE
COLOR_TAB = core.COLOR_TAB
COLOR_TAB_HOVERED = core.COLOR_TAB_HOVERED
COLOR_TAB_ACTIVE = core.COLOR_TAB_ACTIVE
COLOR_TAB_UNFOCUSED = core.COLOR_TAB_UNFOCUSED
COLOR_TAB_UNFOCUSED_ACTIVE = core.COLOR_TAB_UNFOCUSED_ACTIVE
COLOR_PLOT_LINES = core.COLOR_PLOT_LINES
COLOR_PLOT_LINES_HOVERED = core.COLOR_PLOT_LINES_HOVERED
COLOR_PLOT_HISTOGRAM = core.COLOR_PLOT_HISTOGRAM
COLOR_PLOT_HISTOGRAM_HOVERED = core.COLOR_PLOT_HISTOGRAM_HOVERED
COLOR_TEXT_SELECTED_BG = core.COLOR_TEXT_SELECTED_BG
COLOR_DRAG_DROP_TARGET = core.COLOR_DRAG_DROP_TARGET
#: Gamepad/keyboard: current highlighted item
COLOR_NAV_HIGHLIGHT = core.COLOR_NAV_HIGHLIGHT
#: Highlight window when using CTRL+TAB
COLOR_NAV_WINDOWING_HIGHLIGHT = core.COLOR_NAV_WINDOWING_HIGHLIGHT
#: Darken/colorize entire screen behind the CTRL+TAB window list, when active
COLOR_NAV_WINDOWING_DIM_BG = core.COLOR_NAV_WINDOWING_DIM_BG
#: Darken/colorize entire screen behind a modal window, when one is active
COLOR_MODAL_WINDOW_DIM_BG = core.COLOR_MODAL_WINDOW_DIM_BG
COLOR_COUNT = core.COLOR_COUNT

# ==== Text input flags ====
INPUT_TEXTNONE = core.INPUT_TEXTNONE
#: Allow 0123456789.+-*/
INPUT_TEXTCHARS_DECIMAL = core.INPUT_TEXTCHARS_DECIMAL
#: Allow 0123456789ABCDEFabcdef
INPUT_TEXTCHARS_HEXADECIMAL = core.INPUT_TEXTCHARS_HEXADECIMAL
#: Turn a..z into A..Z
INPUT_TEXTCHARS_UPPERCASE = core.INPUT_TEXTCHARS_UPPERCASE
#: Filter out spaces, tabs
INPUT_TEXTCHARS_NO_BLANK = core.INPUT_TEXTCHARS_NO_BLANK
#: Select entire text when first taking mouse focus
INPUT_TEXTAUTO_SELECT_ALL = core.INPUT_TEXTAUTO_SELECT_ALL
#: Return 'true' when Enter is pressed (as opposed to every time the value was modified). Consider looking at the IsItemDeactivatedAfterEdit() function.
INPUT_TEXTENTER_RETURNS_TRUE = core.INPUT_TEXTENTER_RETURNS_TRUE
#: Callback on pressing TAB (for completion handling)
INPUT_TEXTCALLBACK_COMPLETION = core.INPUT_TEXTCALLBACK_COMPLETION
#: Callback on pressing Up/Down arrows (for history handling)
INPUT_TEXTCALLBACK_HISTORY = core.INPUT_TEXTCALLBACK_HISTORY
#: Callback on each iteration. User code may query cursor position, modify text buffer.
INPUT_TEXTCALLBACK_ALWAYS = core.INPUT_TEXTCALLBACK_ALWAYS
#: Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
INPUT_TEXTCALLBACK_CHAR_FILTER = core.INPUT_TEXTCALLBACK_CHAR_FILTER
#: Pressing TAB input a '\t' character into the text field
INPUT_TEXTALLOW_TAB_INPUT = core.INPUT_TEXTALLOW_TAB_INPUT
#: In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
INPUT_TEXTCTRL_ENTER_FOR_NEW_LINE = core.INPUT_TEXTCTRL_ENTER_FOR_NEW_LINE
#: Disable following the cursor horizontally
INPUT_TEXTNO_HORIZONTAL_SCROLL = core.INPUT_TEXTNO_HORIZONTAL_SCROLL
#: Insert mode
INPUT_TEXTALWAYS_INSERT_MODE = core.INPUT_TEXTALWAYS_INSERT_MODE
#: Read-only mode
INPUT_TEXTREAD_ONLY = core.INPUT_TEXTREAD_ONLY
#: Password mode, display all characters as '*'
INPUT_TEXTPASSWORD = core.INPUT_TEXTPASSWORD
#: Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
INPUT_TEXTNO_UNDO_REDO = core.INPUT_TEXTNO_UNDO_REDO
#: Allow 0123456789.+-*/eE (Scientific notation input)
INPUT_TEXTCHARS_SCIENTIFIC = core.INPUT_TEXTCHARS_SCIENTIFIC
#: Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
INPUT_TEXTCALLBACK_RESIZE = core.INPUT_TEXTCALLBACK_RESIZE
#: For internal use by InputTextMultiline()
INPUT_TEXTMULTILINE = core.INPUT_TEXTMULTILINE
#: For internal use by functions using InputText() before reformatting data
INPUT_TEXTNO_MARK_EDITED = core.INPUT_TEXTNO_MARK_EDITED

# ==== Config Flags ====
CONFIG_NONE = core.CONFIG_NONE
#: Master keyboard navigation enable flag. NewFrame() will automatically fill io.NavInputs[] based on io.KeysDown[].
CONFIG_NAV_ENABLE_KEYBOARD = core.CONFIG_NAV_ENABLE_KEYBOARD
#: Master gamepad navigation enable flag. This is mostly to instruct your imgui back-end to fill io.NavInputs[]. Back-end also needs to set ImGuiBackendFlags_HasGamepad.
CONFIG_NAV_ENABLE_GAMEPAD = core.CONFIG_NAV_ENABLE_GAMEPAD
#: Instruct navigation to move the mouse cursor. May be useful on TV/console systems where moving a virtual mouse is awkward. Will update io.MousePos and set io.WantSetMousePos=true. If enabled you MUST honor io.WantSetMousePos requests in your binding, otherwise ImGui will react as if the mouse is jumping around back and forth.
CONFIG_NAV_ENABLE_SET_MOUSE_POS = core.CONFIG_NAV_ENABLE_SET_MOUSE_POS
#: Instruct navigation to not set the io.WantCaptureKeyboard flag when io.NavActive is set.
CONFIG_NAV_NO_CAPTURE_KEYBOARD = core.CONFIG_NAV_NO_CAPTURE_KEYBOARD
#: Instruct imgui to clear mouse position/buttons in NewFrame(). This allows ignoring the mouse information set by the back-end.
CONFIG_NO_MOUSE = core.CONFIG_NO_MOUSE
#: Instruct back-end to not alter mouse cursor shape and visibility. Use if the back-end cursor changes are interfering with yours and you don't want to use SetMouseCursor() to change mouse cursor. You may want to honor requests from imgui by reading GetMouseCursor() yourself instead.
CONFIG_NO_MOUSE_CURSOR_CHANGE = core.CONFIG_NO_MOUSE_CURSOR_CHANGE
#: Application is SRGB-aware.
CONFIG_IS_SRGB = core.CONFIG_IS_SRGB
#: Application is using a touch screen instead of a mouse.
CONFIG_IS_TOUCH_SCREEN = core.CONFIG_IS_TOUCH_SCREEN

# ==== Backend Flags ====
BACKEND_NONE = core.BACKEND_NONE
#: Back-end Platform supports gamepad and currently has one connected.
BACKEND_HAS_GAMEPAD = core.BACKEND_HAS_GAMEPAD
#: Back-end Platform supports honoring GetMouseCursor() value to change the OS cursor shape.
BACKEND_HAS_MOUSE_CURSORS = core.BACKEND_HAS_MOUSE_CURSORS
#: Back-end Platform supports io.WantSetMousePos requests to reposition the OS mouse position (only used if ImGuiConfigFlags_NavEnableSetMousePos is set).
BACKEND_HAS_SET_MOUSE_POS = core.BACKEND_HAS_SET_MOUSE_POS
#: Back-end Renderer supports ImDrawCmd::VtxOffset. This enables output of large meshes (64K+ vertices) while still using 16-bit indices.
BACKEND_RENDERER_HAS_VTX_OFFSET = core.BACKEND_RENDERER_HAS_VTX_OFFSET
