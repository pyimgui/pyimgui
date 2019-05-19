# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp imgui-cpp/imgui_widgets.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp
# cython: embedsignature=True
"""

.. todo:: consider inlining every occurence of ``_cast_args_ImVecX`` (profile)
.. todo: verify mem safety of char* variables and check for leaks
"""

import cython
from cython.view cimport array as cvarray
from cython.operator cimport dereference as deref

from collections import namedtuple
import warnings
from contextlib import contextmanager
try:
    from itertools import izip_longest
except ImportError:
    from itertools import zip_longest as izip_longest

from libc.stdlib cimport malloc, free
from libc.stdint cimport uintptr_t
from libc.string cimport strdup
from libc.string cimport strncpy
from libc.float  cimport FLT_MAX
from libcpp cimport bool

cimport cimgui
cimport enums

from cpython.version cimport PY_MAJOR_VERSION

# todo: find a way to cimport this directly from imgui.h
DEF TARGET_IMGUI_VERSION = (1, 65)

cdef unsigned short* _LATIN_ALL = [0x0020, 0x024F , 0]

# ==== Condition enum redefines ====
ALWAYS = enums.ImGuiCond_Always
ONCE = enums.ImGuiCond_Once
FIRST_USE_EVER = enums.ImGuiCond_FirstUseEver
APPEARING = enums.ImGuiCond_Appearing

# ==== Style var enum redefines ====
STYLE_ALPHA = enums.ImGuiStyleVar_Alpha # float
STYLE_WINDOW_PADDING = enums.ImGuiStyleVar_WindowPadding  # Vec2
STYLE_WINDOW_ROUNDING = enums.ImGuiStyleVar_WindowRounding  # float
STYLE_WINDOW_BORDERSIZE = enums.ImGuiStyleVar_WindowBorderSize  # float
STYLE_WINDOW_MIN_SIZE = enums.ImGuiStyleVar_WindowMinSize  # Vec2
STYLE_WINDOW_TITLE_ALIGN = enums.ImGuiStyleVar_WindowTitleAlign  # Vec2
STYLE_CHILD_ROUNDING = enums.ImGuiStyleVar_ChildRounding  # float
STYLE_CHILD_BORDERSIZE = enums.ImGuiStyleVar_ChildBorderSize  # float
STYLE_POPUP_ROUNDING = enums.ImGuiStyleVar_PopupRounding  # float
STYLE_POPUP_BORDERSIZE = enums.ImGuiStyleVar_PopupBorderSize  # float
STYLE_FRAME_PADDING = enums.ImGuiStyleVar_FramePadding # Vec2
STYLE_FRAME_ROUNDING = enums.ImGuiStyleVar_FrameRounding # float
STYLE_FRAME_BORDERSIZE = enums.ImGuiStyleVar_FrameBorderSize  # float
STYLE_ITEM_SPACING = enums.ImGuiStyleVar_ItemSpacing # Vec2
STYLE_ITEM_INNER_SPACING = enums.ImGuiStyleVar_ItemInnerSpacing # Vec2
STYLE_INDENT_SPACING = enums.ImGuiStyleVar_IndentSpacing # float
STYLE_SCROLLBAR_SIZE = enums.ImGuiStyleVar_ScrollbarSize # float
STYLE_SCROLLBAR_ROUNDING = enums.ImGuiStyleVar_ScrollbarRounding # float
STYLE_GRAB_MIN_SIZE = enums.ImGuiStyleVar_GrabMinSize # float
STYLE_GRAB_ROUNDING = enums.ImGuiStyleVar_GrabRounding # float
STYLE_BUTTON_TEXT_ALIGN = enums.ImGuiStyleVar_ButtonTextAlign # flags ImGuiAlign_*

# ==== Key map enum redefines ====
KEY_TAB = enums.ImGuiKey_Tab                 # for tabbing through fields
KEY_LEFT_ARROW = enums.ImGuiKey_LeftArrow    # for text edit
KEY_RIGHT_ARROW = enums.ImGuiKey_RightArrow  # for text edit
KEY_UP_ARROW = enums.ImGuiKey_UpArrow        # for text edit
KEY_DOWN_ARROW = enums.ImGuiKey_DownArrow    # for text edit
KEY_PAGE_UP = enums.ImGuiKey_PageUp
KEY_PAGE_DOWN = enums.ImGuiKey_PageDown
KEY_HOME = enums.ImGuiKey_Home               # for text edit
KEY_END = enums.ImGuiKey_End                 # for text edit
KEY_INSERT = enums.ImGuiKey_Insert           # for text edit
KEY_DELETE = enums.ImGuiKey_Delete           # for text edit
KEY_BACKSPACE = enums.ImGuiKey_Backspace     # for text edit
KEY_SPACE = enums.ImGuiKey_Space             # for text edit
KEY_ENTER = enums.ImGuiKey_Enter             # for text edit
KEY_ESCAPE = enums.ImGuiKey_Escape           # for text edit
KEY_A = enums.ImGuiKey_A                     # for text edit CTRL+A: select all
KEY_C = enums.ImGuiKey_C                     # for text edit CTRL+C: copy
KEY_V = enums.ImGuiKey_V                     # for text edit CTRL+V: paste
KEY_X = enums.ImGuiKey_X                     # for text edit CTRL+X: cut
KEY_Y = enums.ImGuiKey_Y                     # for text edit CTRL+Y: redo
KEY_Z = enums.ImGuiKey_Z                     # for text edit CTRL+Z: undo

# ==== Window flags enum redefines ====
WINDOW_NO_TITLE_BAR = enums.ImGuiWindowFlags_NoTitleBar
WINDOW_NO_RESIZE = enums.ImGuiWindowFlags_NoResize
WINDOW_NO_MOVE = enums.ImGuiWindowFlags_NoMove
WINDOW_NO_SCROLLBAR = enums.ImGuiWindowFlags_NoScrollbar
WINDOW_NO_SCROLL_WITH_MOUSE = enums.ImGuiWindowFlags_NoScrollWithMouse
WINDOW_NO_COLLAPSE = enums.ImGuiWindowFlags_NoCollapse
WINDOW_ALWAYS_AUTO_RESIZE = enums.ImGuiWindowFlags_AlwaysAutoResize
WINDOW_NO_SAVED_SETTINGS = enums.ImGuiWindowFlags_NoSavedSettings
WINDOW_NO_INPUTS = enums.ImGuiWindowFlags_NoInputs
WINDOW_MENU_BAR = enums.ImGuiWindowFlags_MenuBar
WINDOW_HORIZONTAL_SCROLLING_BAR = enums.ImGuiWindowFlags_HorizontalScrollbar
WINDOW_NO_FOCUS_ON_APPEARING = enums.ImGuiWindowFlags_NoFocusOnAppearing
WINDOW_NO_BRING_TO_FRONT_ON_FOCUS = enums.ImGuiWindowFlags_NoBringToFrontOnFocus
WINDOW_ALWAYS_VERTICAL_SCROLLBAR = enums.ImGuiWindowFlags_AlwaysVerticalScrollbar
WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR = enums.ImGuiWindowFlags_AlwaysHorizontalScrollbar
WINDOW_ALWAYS_USE_WINDOW_PADDING = enums.ImGuiWindowFlags_AlwaysUseWindowPadding
WINDOW_NO_NAV_INPUTS = enums.ImGuiWindowFlags_NoNavInputs
WINDOW_NO_NAV_FOCUS = enums.ImGuiWindowFlags_NoNavFocus
WINDOW_NO_NAV = enums.ImGuiWindowFlags_NoNav

# ==== TreeNode flags enum redefines ====
TREE_NODE_SELECTED = enums.ImGuiTreeNodeFlags_Selected
TREE_NODE_FRAMED = enums.ImGuiTreeNodeFlags_Framed
TREE_NODE_ALLOW_ITEM_OVERLAP = enums.ImGuiTreeNodeFlags_AllowItemOverlap
TREE_NODE_NO_TREE_PUSH_ON_OPEN = enums.ImGuiTreeNodeFlags_NoTreePushOnOpen
TREE_NODE_NO_AUTO_OPEN_ON_LOG = enums.ImGuiTreeNodeFlags_NoAutoOpenOnLog
TREE_NODE_DEFAULT_OPEN = enums.ImGuiTreeNodeFlags_DefaultOpen
TREE_NODE_OPEN_ON_DOUBLE_CLICK = enums.ImGuiTreeNodeFlags_OpenOnDoubleClick
TREE_NODE_OPEN_ON_ARROW = enums.ImGuiTreeNodeFlags_OpenOnArrow
TREE_NODE_LEAF = enums.ImGuiTreeNodeFlags_Leaf
TREE_NODE_BULLET = enums.ImGuiTreeNodeFlags_Bullet
TREE_NODE_FRAME_PADDING = enums.ImGuiTreeNodeFlags_FramePadding
TREE_NODE_COLLAPSING_HEADER = enums.ImGuiTreeNodeFlags_CollapsingHeader

# ==== Selectable flags enum redefines ====
SELECTABLE_DONT_CLOSE_POPUPS = enums.ImGuiSelectableFlags_DontClosePopups
SELECTABLE_SPAN_ALL_COLUMNS = enums.ImGuiSelectableFlags_SpanAllColumns
SELECTABLE_ALLOW_DOUBLE_CLICK = enums.ImGuiSelectableFlags_AllowDoubleClick

# ==== Combo flags enum redefines ====

COMBO_POPUP_ALIGN_LEFT = enums.ImGuiComboFlags_PopupAlignLeft
COMBO_HEIGHT_SMALL = enums.ImGuiComboFlags_HeightSmall
COMBO_HEIGHT_REGULAR = enums.ImGuiComboFlags_HeightRegular
COMBO_HEIGHT_LARGE = enums.ImGuiComboFlags_HeightLarge
COMBO_HEIGHT_LARGEST = enums.ImGuiComboFlags_HeightLargest
COMBO_NO_ARROW_BUTTON = enums.ImGuiComboFlags_NoArrowButton
COMBO_NO_PREVIEW = enums.ImGuiComboFlags_NoPreview
COMBO_HEIGHT_MASK = enums.ImGuiComboFlags_HeightMask_

# === Focus flag enum redefines ====
FOCUS_CHILD_WINDOWS = enums.ImGuiFocusedFlags_ChildWindows
FOCUS_ROOT_WINDOW = enums.ImGuiFocusedFlags_RootWindow
FOCUS_ANY_WINDOW = enums.ImGuiFocusedFlags_AnyWindow
FOCUS_ROOT_AND_CHILD_WINDOWS = enums.ImGuiFocusedFlags_RootAndChildWindows

# === Hovered flag enum redefines ====
HOVERED_NONE = enums.ImGuiHoveredFlags_None
HOVERED_CHILD_WINDOWS = enums.ImGuiHoveredFlags_ChildWindows
HOVERED_ROOT_WINDOW = enums.ImGuiHoveredFlags_RootWindow
HOVERED_ANY_WINDOW = enums.ImGuiHoveredFlags_AnyWindow
HOVERED_ALLOW_WHEN_BLOCKED_BY_POPUP = enums.ImGuiHoveredFlags_AllowWhenBlockedByPopup
HOVERED_ALLOW_WHEN_BLOCKED_BY_ACTIVE_ITEM = enums.ImGuiHoveredFlags_AllowWhenBlockedByActiveItem
HOVERED_ALLOW_WHEN_OVERLAPPED = enums.ImGuiHoveredFlags_AllowWhenOverlapped
HOVERED_RECT_ONLY = enums.ImGuiHoveredFlags_RectOnly
HOVERED_ROOT_AND_CHILD_WINDOWS = enums.ImGuiHoveredFlags_RootAndChildWindows

# === Drag Drop flag enum redefines ====
DRAG_DROP_SOURCE_NO_PREVIEW_TOOLTIP = enums.ImGuiDragDropFlags_SourceNoPreviewTooltip
DRAG_DROP_SOURCE_NO_DISABLE_HOVER = enums.ImGuiDragDropFlags_SourceNoDisableHover
DRAG_DROP_SOURCE_NO_HOLD_TO_OPEN_OTHERS = enums.ImGuiDragDropFlags_SourceNoHoldToOpenOthers
DRAG_DROP_SOURCE_ALLOW_NULL_ID = enums.ImGuiDragDropFlags_SourceAllowNullID
DRAG_DROP_SOURCE_EXTERN = enums.ImGuiDragDropFlags_SourceExtern
DRAG_DROP_SOURCE_AUTO_EXPIRE_PAYLOAD = enums.ImGuiDragDropFlags_SourceAutoExpirePayload

# === Accept Drag Drop Payload flag enum redefines ====
DRAG_DROP_ACCEPT_BEFORE_DELIVERY = enums.ImGuiDragDropFlags_AcceptBeforeDelivery
DRAG_DROP_ACCEPT_NO_DRAW_DEFAULT_RECT = enums.ImGuiDragDropFlags_AcceptNoDrawDefaultRect
DRAG_DROP_ACCEPT_NO_PREVIEW_TOOLTIP = enums.ImGuiDragDropFlags_AcceptNoPreviewTooltip
DRAG_DROP_ACCEPT_PEEK_ONLY = enums.ImGuiDragDropFlags_AcceptPeekOnly

# === Cardinal Direction enum redefines ====
DIRECTION_NONE = enums.ImGuiDir_None
DIRECTION_LEFT = enums.ImGuiDir_Left
DIRECTION_RIGHT = enums.ImGuiDir_Right
DIRECTION_UP = enums.ImGuiDir_Up
DIRECTION_DOWN = enums.ImGuiDir_Down

# ==== Mouse Cursors ====
MOUSE_CURSOR_ARROW = enums.ImGuiMouseCursor_Arrow
MOUSE_CURSOR_TEXT_INPUT = enums.ImGuiMouseCursor_TextInput
MOUSE_CURSOR_RESIZE_ALL = enums.ImGuiMouseCursor_ResizeAll
MOUSE_CURSOR_RESIZE_NS = enums.ImGuiMouseCursor_ResizeNS
MOUSE_CURSOR_RESIZE_EW = enums.ImGuiMouseCursor_ResizeEW
MOUSE_CURSOR_RESIZE_NESW = enums.ImGuiMouseCursor_ResizeNESW
MOUSE_CURSOR_RESIZE_NWSE = enums.ImGuiMouseCursor_ResizeNWSE

# ==== Color identifiers for styling ====
COLOR_TEXT = enums.ImGuiCol_Text
COLOR_TEXT_DISABLED = enums.ImGuiCol_TextDisabled
COLOR_WINDOW_BACKGROUND = enums.ImGuiCol_WindowBg
COLOR_CHILD_BACKGROUND = enums.ImGuiCol_ChildBg
COLOR_POPUP_BACKGROUND = enums.ImGuiCol_PopupBg
COLOR_BORDER = enums.ImGuiCol_Border
COLOR_BORDER_SHADOW = enums.ImGuiCol_BorderShadow
COLOR_FRAME_BACKGROUND = enums.ImGuiCol_FrameBg
COLOR_FRAME_BACKGROUND_HOVERED = enums.ImGuiCol_FrameBgHovered
COLOR_FRAME_BACKGROUND_ACTIVE = enums.ImGuiCol_FrameBgActive
COLOR_TITLE_BACKGROUND = enums.ImGuiCol_TitleBg
COLOR_TITLE_BACKGROUND_ACTIVE = enums.ImGuiCol_TitleBgActive
COLOR_TITLE_BACKGROUND_COLLAPSED = enums.ImGuiCol_TitleBgCollapsed
COLOR_MENUBAR_BACKGROUND = enums.ImGuiCol_MenuBarBg
COLOR_SCROLLBAR_BACKGROUND = enums.ImGuiCol_ScrollbarBg
COLOR_SCROLLBAR_GRAB = enums.ImGuiCol_ScrollbarGrab
COLOR_SCROLLBAR_GRAB_HOVERED = enums.ImGuiCol_ScrollbarGrabHovered
COLOR_SCROLLBAR_GRAB_ACTIVE = enums.ImGuiCol_ScrollbarGrabActive
COLOR_CHECK_MARK = enums.ImGuiCol_CheckMark
COLOR_SLIDER_GRAB = enums.ImGuiCol_SliderGrab
COLOR_SLIDER_GRAB_ACTIVE = enums.ImGuiCol_SliderGrabActive
COLOR_BUTTON = enums.ImGuiCol_Button
COLOR_BUTTON_HOVERED = enums.ImGuiCol_ButtonHovered
COLOR_BUTTON_ACTIVE = enums.ImGuiCol_ButtonActive
COLOR_HEADER = enums.ImGuiCol_Header
COLOR_HEADER_HOVERED = enums.ImGuiCol_HeaderHovered
COLOR_HEADER_ACTIVE = enums.ImGuiCol_HeaderActive
COLOR_SEPARATOR = enums.ImGuiCol_Separator
COLOR_SEPARATOR_HOVERED = enums.ImGuiCol_SeparatorHovered
COLOR_SEPARATOR_ACTIVE = enums.ImGuiCol_SeparatorActive
COLOR_RESIZE_GRIP = enums.ImGuiCol_ResizeGrip
COLOR_RESIZE_GRIP_HOVERED = enums.ImGuiCol_ResizeGripHovered
COLOR_RESIZE_GRIP_ACTIVE = enums.ImGuiCol_ResizeGripActive
COLOR_PLOT_LINES = enums.ImGuiCol_PlotLines
COLOR_PLOT_LINES_HOVERED = enums.ImGuiCol_PlotLinesHovered
COLOR_PLOT_HISTOGRAM = enums.ImGuiCol_PlotHistogram
COLOR_PLOT_HISTOGRAM_HOVERED = enums.ImGuiCol_PlotHistogramHovered
COLOR_TEXT_SELECTED_BACKGROUND = enums.ImGuiCol_TextSelectedBg
COLOR_DRAG_DROP_TARGET = enums.ImGuiCol_DragDropTarget
COLOR_NAV_HIGHLIGHT = enums.ImGuiCol_NavHighlight
COLOR_NAV_WINDOWING_HIGHLIGHT = enums.ImGuiCol_NavWindowingHighlight
COLOR_NAV_WINDOWING_DIM_BACKGROUND = enums.ImGuiCol_NavWindowingDimBg
COLOR_MODAL_WINDOW_DIM_BACKGROUND = enums.ImGuiCol_ModalWindowDimBg
COLOR_COUNT = enums.ImGuiCol_COUNT

# ==== Text input flags ====
INPUT_TEXT_CHARS_DECIMAL = enums.ImGuiInputTextFlags_CharsDecimal
INPUT_TEXT_CHARS_HEXADECIMAL = enums.ImGuiInputTextFlags_CharsHexadecimal
INPUT_TEXT_CHARS_UPPERCASE = enums.ImGuiInputTextFlags_CharsUppercase
INPUT_TEXT_CHARS_NO_BLANK = enums.ImGuiInputTextFlags_CharsNoBlank
INPUT_TEXT_AUTO_SELECT_ALL = enums.ImGuiInputTextFlags_AutoSelectAll
INPUT_TEXT_ENTER_RETURNS_TRUE = enums.ImGuiInputTextFlags_EnterReturnsTrue
INPUT_TEXT_CALLBACK_COMPLETION = enums.ImGuiInputTextFlags_CallbackCompletion
INPUT_TEXT_CALLBACK_HISTORY = enums.ImGuiInputTextFlags_CallbackHistory
INPUT_TEXT_CALLBACK_ALWAYS = enums.ImGuiInputTextFlags_CallbackAlways
INPUT_TEXT_CALLBACK_CHAR_FILTER = enums.ImGuiInputTextFlags_CallbackCharFilter
INPUT_TEXT_ALLOW_TAB_INPUT = enums.ImGuiInputTextFlags_AllowTabInput
INPUT_TEXT_CTRL_ENTER_FOR_NEW_LINE = enums.ImGuiInputTextFlags_CtrlEnterForNewLine
INPUT_TEXT_NO_HORIZONTAL_SCROLL = enums.ImGuiInputTextFlags_NoHorizontalScroll
INPUT_TEXT_ALWAYS_INSERT_MODE = enums.ImGuiInputTextFlags_AlwaysInsertMode
INPUT_TEXT_READ_ONLY = enums.ImGuiInputTextFlags_ReadOnly
INPUT_TEXT_PASSWORD = enums.ImGuiInputTextFlags_Password
INPUT_TEXT_NO_UNDO_REDO = enums.ImGuiInputTextFlags_NoUndoRedo


Vec2 = namedtuple("Vec2", ['x', 'y'])
Vec4 = namedtuple("Vec4", ['x', 'y', 'z', 'w'])


cdef bytes _bytes(str text):
    return <bytes>(text if PY_MAJOR_VERSION < 3 else text.encode('utf-8'))


cdef str _from_bytes(bytes text):
    return <str>(text if PY_MAJOR_VERSION < 3 else text.decode('utf-8'))


cdef _cast_ImVec2_tuple(cimgui.ImVec2 vec):  # noqa
    return Vec2(vec.x, vec.y)


cdef cimgui.ImVec2 _cast_tuple_ImVec2(pair) except *:  # noqa
    cdef cimgui.ImVec2 vec

    if len(pair) != 2:
        raise ValueError("pair param must be length of 2")

    vec.x, vec.y = pair

    return vec


cdef cimgui.ImVec2 _cast_args_ImVec2(float x, float y) except *:  # noqa
    cdef cimgui.ImVec2 vec

    vec.x, vec.y = x, y

    return vec


cdef cimgui.ImVec4 _cast_tuple_ImVec4(quadruple):  # noqa
    cdef cimgui.ImVec4 vec

    if len(quadruple) != 4:
        raise ValueError("quadruple param must be length of 4")

    vec.x, vec.y, vec.z, vec.w = quadruple

    return vec


cdef cimgui.ImVec4 _cast_args_ImVec4(float x, float y, float z, float w):  # noqa
    cdef cimgui.ImVec4 vec

    vec.x, vec.y, vec.z, vec.w = x, y, z, w

    return vec


cdef _cast_ImVec4_tuple(cimgui.ImVec4 vec):  # noqa
    return Vec4(vec.x, vec.y, vec.z, vec.w)


cdef class _ImGuiContext(object):
    cdef cimgui.ImGuiContext* _ptr

    @staticmethod
    cdef from_ptr(cimgui.ImGuiContext* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiContext()
        instance._ptr = ptr
        return instance

    def __eq__(_ImGuiContext self, _ImGuiContext other):
        return other._ptr == self._ptr


cdef class _DrawCmd(object):
    cdef cimgui.ImDrawCmd* _ptr

    # todo: consider using fast instantiation here
    #       see: http://cython.readthedocs.io/en/latest/src/userguide/extension_types.html#fast-instantiation
    @staticmethod
    cdef from_ptr(cimgui.ImDrawCmd* ptr):
        if ptr == NULL:
            return None

        instance = _DrawCmd()
        instance._ptr = ptr
        return instance

    @property
    def texture_id(self):
        return <object>self._ptr.TextureId

    @property
    def clip_rect(self):
        return _cast_ImVec4_tuple(self._ptr.ClipRect)

    @property
    def elem_count(self):
        return self._ptr.ElemCount


cdef class _DrawList(object):
    cdef cimgui.ImDrawList* _ptr

    @staticmethod
    cdef from_ptr(cimgui.ImDrawList* ptr):
        if ptr == NULL:
            return None

        instance = _DrawList()
        instance._ptr = ptr
        return instance

    @property
    def cmd_buffer_size(self):
        return self._ptr.CmdBuffer.Size

    @property
    def cmd_buffer_data(self):
        return <uintptr_t>self._ptr.CmdBuffer.Data

    @property
    def vtx_buffer_size(self):
        return self._ptr.VtxBuffer.Size

    @property
    def vtx_buffer_data(self):
        return <uintptr_t>self._ptr.VtxBuffer.Data

    @property
    def idx_buffer_size(self):
        return self._ptr.IdxBuffer.Size

    @property
    def idx_buffer_data(self):
        return <uintptr_t>self._ptr.IdxBuffer.Data


    def add_rect_filled(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col,
            # note: optional
            float rounding = 0.0,
            cimgui.ImGuiWindowFlags rounding_corners_flags = 0xF,
        ):
        """Add a filled rectangle to the draw list.
        Args:
            upper_left_x (float): X coordinate of top-left
            upper_left_y (float): Y coordinate of top-left
            lower_right_x (float): X coordinate of lower-right
            lower_right_y (float): Y coordinate of lower-right
            col (ImU32): RGBA color specification
            # note: optional
            rounding (float): Degree of rounding, defaults to 0.0
            rounding_corners_flags (ImDrawCornerFlags): Draw flags, defaults to ImDrawCornerFlags_ALL

        .. wraps::
            void ImDrawList::AddRectFilled(
                const ImVec2&,
                const ImVec2&,
                ImU32,
                # note: optional
                float, int
            )
        """
        #_DrawList.from_ptr(self._ptr).AddRectFilled(
        self._ptr.AddRectFilled(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col,
            rounding,
            rounding_corners_flags,
        )


    def add_line(
            self,
            float start_x, float start_y,
            float end_x, float end_y,
            cimgui.ImU32 col,
            # note: optional
            float thickness=1.0,
        ):
        """Add a straight line to the draw list.

        .. wraps::
            void ImDrawList::AddLine(const ImVec2& a, const ImVec2& b, ImU32 col, float thickness = 1.0f)

        """
        self._ptr.AddLine(
            _cast_args_ImVec2(start_x, start_y),
            _cast_args_ImVec2(end_x, end_y),
            col,
            thickness,
        )


    def add_rect(
            self,
            float upper_left_x, float upper_left_y,
            float lower_right_x, float lower_right_y,
            cimgui.ImU32 col,
            # note: optional
            float rounding = 0.0,
            cimgui.ImGuiWindowFlags rounding_corners_flags = 0xF,
            float thickness = 1.0,
        ):
        """Add a rectangle outline to the draw list.

        Args:
            upper_left_x (float): X coordinate of top-left
            upper_left_y (float): Y coordinate of top-left
            lower_right_x (float): X coordinate of lower-right
            lower_right_y (float): Y coordinate of lower-right
            col (ImU32): RGBA color specification
            # note: optional
            rounding (float): Degree of rounding, defaults to 0.0
            rounding_corners_flags (ImDrawCornerFlags): Draw flags, defaults to ImDrawCornerFlags_ALL
            thickness (float): Line thickness, defaults to 1.0

        .. wraps::
            void ImDrawList::AddRect(
                const ImVec2& a,
                const ImVec2& b,
                ImU32 col,
                float rounding = 0.0f,
                int rounding_corners_flags = ImDrawCornerFlags_All,
                float thickness = 1.0f
            )
        """
        self._ptr.AddRect(
            _cast_args_ImVec2(upper_left_x, upper_left_y),
            _cast_args_ImVec2(lower_right_x, lower_right_y),
            col,
            rounding,
            rounding_corners_flags,
            thickness,
        )



    # channels

    def channels_split(self, int channels_count):
        """
        Warning - be careful with using channels as "layers".
        Child windows are always drawn after their parent, so they will
        paint over its channels.
        To paint over child windows, use `OverlayDrawList`.
        """
        # TODO: document
        self._ptr.ChannelsSplit(channels_count)


    def channels_set_current(self, int idx):
        # TODO: document
        self._ptr.ChannelsSetCurrent(idx)


    def channels_merge(self):
        # TODO: document
        self._ptr.ChannelsMerge()


    @property
    def commands(self):
        return [
            # todo: consider operator overloading in pxd file
            _DrawCmd.from_ptr(&self._ptr.CmdBuffer.Data[idx])
            # perf: short-wiring instead of using property
            # note: add py3k compat
            for idx in xrange(self._ptr.CmdBuffer.Size)
        ]


cdef class GuiStyle(object):
    """
    Container for ImGui style information

    """
    cdef cimgui.ImGuiStyle* _ptr
    cdef bool _owner

    def __cinit__(self):
        self._ptr = NULL
        self._owner = False

    def __dealloc__(self):
        if self._owner:
            del self._ptr
            self._ptr = NULL


    cdef inline _check_ptr(self):
        if self._ptr is NULL:
            raise RuntimeError(
                "Improperly initialized, use imgui.get_style() or "
                "GuiStyle.created() to obtain style classes"
            )

    def __eq__(GuiStyle self, GuiStyle other):
        return other._ptr == self._ptr

    @staticmethod
    def create():
        return GuiStyle._create()

    @staticmethod
    cdef GuiStyle from_ref(cimgui.ImGuiStyle& ref):
        cdef GuiStyle instance = GuiStyle()
        instance._ptr = &ref
        return instance

    @staticmethod
    cdef GuiStyle _create():
        cdef cimgui.ImGuiStyle* _ptr = new cimgui.ImGuiStyle()
        cdef GuiStyle instance = GuiStyle.from_ref(deref(_ptr))
        instance._owner = True
        return instance

    @property
    def alpha(self):
        """Global alpha blending parameter for windows

        Returns:
            float
        """
        self._check_ptr()
        return self._ptr.Alpha

    @alpha.setter
    def alpha(self, float value):
        self._check_ptr()
        self._ptr.Alpha = value

    @property
    def window_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.WindowPadding)

    @window_padding.setter
    def window_padding(self, value):
        self._check_ptr()
        self._ptr.WindowPadding = _cast_tuple_ImVec2(value)

    @property
    def window_min_size(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.WindowMinSize)

    @window_min_size.setter
    def window_min_size(self, value):
        self._check_ptr()
        self._ptr.WindowMinSize = _cast_tuple_ImVec2(value)

    @property
    def window_rounding(self):
        self._check_ptr()
        return self._ptr.WindowRounding

    @window_rounding.setter
    def window_rounding(self, float value):
        self._check_ptr()
        self._ptr.WindowRounding = value

    @property
    def window_border_size(self):
        self._check_ptr()
        return self._ptr.WindowBorderSize

    @window_border_size.setter
    def window_border_size(self, float value):
        self._check_ptr()
        self._ptr.WindowBorderSize = value

    @property
    def child_rounding(self):
        self._check_ptr()
        return self._ptr.ChildRounding

    @child_rounding.setter
    def child_rounding(self, float value):
        self._check_ptr()
        self._ptr.ChildRounding = value

    @property
    def child_border_size(self):
        self._check_ptr()
        return self._ptr.ChildBorderSize

    @child_border_size.setter
    def child_border_size(self, float value):
        self._check_ptr()
        self._ptr.ChildBorderSize = value

    @property
    def popup_rounding(self):
        self._check_ptr()
        return self._ptr.PopupRounding

    @popup_rounding.setter
    def popup_rounding(self, float value):
        self._check_ptr()
        self._ptr.PopupRounding = value

    @property
    def popup_border_size(self):
        self._check_ptr()
        return self._ptr.PopupBorderSize

    @popup_border_size.setter
    def popup_border_size(self, float value):
        self._check_ptr()
        self._ptr.ChildBorderSize = value

    @property
    def window_title_align(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.WindowTitleAlign)

    @window_title_align.setter
    def window_title_align(self, value):
        self._check_ptr()
        self._ptr.WindowTitleAlign = _cast_tuple_ImVec2(value)

    @property
    def frame_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.FramePadding)

    @frame_padding.setter
    def frame_padding(self, value):
        self._check_ptr()
        self._ptr.FramePadding = _cast_tuple_ImVec2(value)

    @property
    def frame_rounding(self):
        self._check_ptr()
        return self._ptr.FrameRounding

    @frame_rounding.setter
    def frame_rounding(self, float value):
        self._check_ptr()
        self._ptr.FrameRounding = value

    @property
    def frame_border_size(self):
        self._check_ptr()
        return self._ptr.FrameBorderSize

    @frame_border_size.setter
    def frame_border_size(self, float value):
        self._check_ptr()
        self._ptr.FrameBorderSize = value

    @property
    def item_spacing(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.ItemSpacing)

    @item_spacing.setter
    def item_spacing(self, value):
        self._check_ptr()
        self._ptr.ItemSpacing = _cast_tuple_ImVec2(value)

    @property
    def item_inner_spacing(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.ItemInnerSpacing)

    @item_inner_spacing.setter
    def item_inner_spacing(self, value):
        self._check_ptr()
        self._ptr.ItemInnerSpacing = _cast_tuple_ImVec2(value)

    @property
    def touch_extra_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.TouchExtraPadding)

    @touch_extra_padding.setter
    def touch_extra_padding(self, value):
        self._check_ptr()
        self._ptr.TouchExtraPadding = _cast_tuple_ImVec2(value)

    @property
    def indent_spacing(self):
        self._check_ptr()
        return self._ptr.IndentSpacing

    @indent_spacing.setter
    def indent_spacing(self, float value):
        self._check_ptr()
        self._ptr.IndentSpacing = value

    @property
    def columns_min_spacing(self):
        self._check_ptr()
        return self._ptr.ColumnsMinSpacing

    @columns_min_spacing.setter
    def columns_min_spacing(self, float value):
        self._check_ptr()
        self._ptr.ColumnsMinSpacing = value

    @property
    def scrollbar_size(self):
        self._check_ptr()
        return self._ptr.ScrollbarSize

    @scrollbar_size.setter
    def scrollbar_size(self, float value):
        self._check_ptr()
        self._ptr.ScrollbarSize = value

    @property
    def scrollbar_rounding(self):
        self._check_ptr()
        return self._ptr.ScrollbarRounding

    @scrollbar_rounding.setter
    def scrollbar_rounding(self, float value):
        self._check_ptr()
        self._ptr.ScrollbarRounding = value

    @property
    def grab_min_size(self):
        self._check_ptr()
        return self._ptr.GrabMinSize

    @grab_min_size.setter
    def grab_min_size(self, float value):
        self._check_ptr()
        self._ptr.GrabMinSize = value

    @property
    def grab_rounding(self):
        self._check_ptr()
        return self._ptr.GrabRounding

    @grab_rounding.setter
    def grab_rounding(self, float value):
        self._check_ptr()
        self._ptr.GrabRounding = value

    @property
    def button_text_align(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.ButtonTextAlign)

    @button_text_align.setter
    def button_text_align(self, value):
        self._check_ptr()
        self._ptr.ButtonTextAlign = _cast_tuple_ImVec2(value)

    @property
    def display_window_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.DisplayWindowPadding)

    @display_window_padding.setter
    def display_window_padding(self, value):
        self._check_ptr()
        self._ptr.DisplayWindowPadding = _cast_tuple_ImVec2(value)

    @property
    def display_safe_area_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.DisplaySafeAreaPadding)

    @display_safe_area_padding.setter
    def display_safe_area_padding(self, value):
        self._check_ptr()
        self._ptr.DisplaySafeAreaPadding = _cast_tuple_ImVec2(value)

    @property
    def mouse_cursor_scale(self):
        self._check_ptr()
        return self._ptr.MouseCursorScale

    @mouse_cursor_scale.setter
    def mouse_cursor_scale(self, value):
        self._check_ptr()
        self._ptr.MouseCursorScale = value

    @property
    def anti_aliased_lines(self):
        self._check_ptr()
        return self._ptr.AntiAliasedLines

    @anti_aliased_lines.setter
    def anti_aliased_lines(self, cimgui.bool value):
        self._check_ptr()
        self._ptr.AntiAliasedLines = value

    @property
    def anti_aliased_fill(self):
        self._check_ptr()
        return self._ptr.AntiAliasedFill

    @anti_aliased_fill.setter
    def anti_aliased_fill(self, cimgui.bool value):
        self._check_ptr()
        self._ptr.AntiAliasedFill = value

    @property
    def curve_tessellation_tolerance(self):
        self._check_ptr()
        return self._ptr.CurveTessellationTol

    @curve_tessellation_tolerance.setter
    def curve_tessellation_tolerance(self, float value):
        self._check_ptr()
        self._ptr.CurveTessellationTol = value

    def color(self, cimgui.ImGuiCol variable):
        if not (0 <= variable < enums.ImGuiStyleVar_Count_):
            raise ValueError("Unknown style variable: {}".format(variable))

        self._check_ptr()
        cdef int ix = variable
        return _cast_ImVec4_tuple(self._ptr.Colors[ix])


cdef class _DrawData(object):
    cdef cimgui.ImDrawData* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImDrawData* ptr):
        if ptr == NULL:
            return None

        instance = _DrawData()
        instance._ptr = ptr
        return instance

    def deindex_all_buffers(self):
        self._require_pointer()
        self._ptr.DeIndexAllBuffers()

    def scale_clip_rects(self, width, height):
        self._require_pointer()
        self._ptr.ScaleClipRects(_cast_args_ImVec2(width, height))

    @property
    def valid(self):
        self._require_pointer()
        return self._ptr.Valid

    @property
    def cmd_count(self):
        self._require_pointer()
        return self._ptr.CmdListsCount

    @property
    def total_vtx_count(self):
        self._require_pointer()
        return self._ptr.TotalVtxCount

    @property
    def total_idx_count(self):
        self._require_pointer()
        return self._ptr.TotalIdxCount

    @property
    def commands_lists(self):
        return [
            _DrawList.from_ptr(self._ptr.CmdLists[idx])
            # perf: short-wiring instead of using property
            for idx in xrange(self._ptr.CmdListsCount)
        ]


cdef class _StaticGlyphRanges(object):
    cdef const cimgui.ImWchar* ranges_ptr

    @staticmethod
    cdef from_ptr(const cimgui.ImWchar* ptr):
        if ptr == NULL:
            return None

        instance = _StaticGlyphRanges()
        instance.ranges_ptr = ptr
        return instance


cdef class _Font(object):
    @staticmethod
    cdef from_ptr(cimgui.ImFont* ptr):
        if ptr == NULL:
            return None

        instance = _Font()
        instance._ptr = ptr
        return instance


cdef class _FontAtlas(object):
    """Font atlas object responsible for controling and loading fonts.

    This class is not intended to be instantiated by user (thus `_`
    name prefix). It should be accessed through :any:`_IO.fonts` attribute
    of :class:`_IO` obtained with :func:`get_io` function.

    Example::

        import imgui

        io = imgui.get_io()
        io.fonts.add_font_default()

    """
    cdef cimgui.ImFontAtlas* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImFontAtlas* ptr):
        if ptr == NULL:
            return None

        instance = _FontAtlas()
        instance._ptr = ptr
        return instance

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

        return self._ptr != NULL

    def add_font_default(self):
        self._require_pointer()

        return _Font.from_ptr(self._ptr.AddFontDefault(NULL))

    def add_font_from_file_ttf(
        self, str filename, float size_pixels,
        _StaticGlyphRanges glyph_ranges=None,
    ):
        self._require_pointer()
        # note: cannot use cimgui.ImWchar here due to Cython bug
        # note: whole unicode
        cdef char* in_glyph_ranges

        return _Font.from_ptr(self._ptr.AddFontFromFileTTF(
            _bytes(filename), size_pixels,  NULL,
            glyph_ranges.ranges_ptr if glyph_ranges is not None else NULL
        ))

    def clear_tex_data(self):
        self._ptr.ClearTexData()

    def clear_input_data(self):
        self._ptr.ClearInputData()

    def clear_fonts(self):
        self._ptr.ClearFonts()

    def clear(self):
        self._ptr.Clear()

    def get_glyph_ranges_default(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesDefault())

    def get_glyph_ranges_korean(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesKorean())

    def get_glyph_ranges_japanese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesJapanese())

    def get_glyph_ranges_chinese_full(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesChineseFull())

    def get_glyph_ranges_chinese(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesChineseSimplifiedCommon())

    def get_glyph_ranges_cyrillic(self):
        return _StaticGlyphRanges.from_ptr(self._ptr.GetGlyphRangesCyrillic())

    def get_glyph_ranges_latin(self):
        # note: this is a custom glyph range with full latin character set
        return _StaticGlyphRanges.from_ptr(_LATIN_ALL)

    def get_tex_data_as_alpha8(self):
        self._require_pointer()

        cdef int width
        cdef int height
        cdef unsigned char* pixels

        self._ptr.GetTexDataAsAlpha8(&pixels, &width, &height)

        return width, height, bytes(pixels[:width*height])

    def get_tex_data_as_rgba32(self):
        self._require_pointer()

        cdef int width
        cdef int height
        cdef unsigned char* pixels
        self._ptr.GetTexDataAsRGBA32(&pixels, &width, &height)

        return width, height, bytes(pixels[:width*height*4])

    @property
    def texture_id(self):
        """
        Note: difference in mapping (maps actual TexID and not TextureID)

        Note: texture ID type is implementation dependent. It is usually
        integer (at least for OpenGL).

        """
        return <object>self._ptr.TexID

    @texture_id.setter
    def texture_id(self, value):
        self._ptr.TexID = <void *> value


cdef class _IO(object):
    """Main ImGui I/O context class used for ImGui configuration.

    This class is not intended to be instantiated by user (thus `_`
    name prefix). It should be accessed through obtained with :func:`get_io`
    function.

    Example::

        import imgui

        io = imgui.get_io()
    """

    cdef cimgui.ImGuiIO* _ptr
    cdef object _fonts

    def __init__(self):
        self._ptr = &cimgui.GetIO()
        self._fonts = _FontAtlas.from_ptr(self._ptr.Fonts)

    # ... maping of input properties ...
    @property
    def display_size(self):
        return _cast_ImVec2_tuple(self._ptr.DisplaySize)

    @display_size.setter
    def display_size(self, value):
        self._ptr.DisplaySize = _cast_tuple_ImVec2(value)

    @property
    def delta_time(self):
        return self._ptr.DeltaTime

    @delta_time.setter
    def delta_time(self, float time):
        self._ptr.DeltaTime = time

    @property
    def ini_saving_rate(self):
        return self._ptr.IniSavingRate

    @ini_saving_rate.setter
    def ini_saving_rate(self, float value):
        self._ptr.IniSavingRate = value

    @property
    def log_file_name(self):
        return self._ptr.LogFilename

    @log_file_name.setter
    def log_file_name(self, char* value):
        self._ptr.LogFilename = value

    @property
    def mouse_double_click_time(self):
        return self._ptr.MouseDoubleClickTime

    @mouse_double_click_time.setter
    def mouse_double_click_time(self, float value):
        self._ptr.MouseDoubleClickTime = value

    @property
    def mouse_double_click_max_distance(self):
        return self._ptr.MouseDoubleClickMaxDist

    @mouse_double_click_max_distance.setter
    def mouse_double_click_max_distance(self, float value):
        self._ptr.MouseDoubleClickMaxDist = value

    @property
    def mouse_drag_threshold(self):
        return self._ptr.MouseDragThreshold

    @mouse_drag_threshold.setter
    def mouse_drag_threshold(self, float value):
        self._ptr.MouseDragThreshold = value

    @property
    def key_map(self):
        cdef cvarray key_map = cvarray(
            shape=(enums.ImGuiKey_COUNT,),
            format='i',
            itemsize=sizeof(int),
            allocate_buffer=False
        )
        key_map.data = <char*>self._ptr.KeyMap
        return key_map

    @property
    def key_repeat_delay(self):
        return self._ptr.KeyRepeatDelay

    @key_repeat_delay.setter
    def key_repeat_delay(self, float value):
        self._ptr.KeyRepeatDelay = value

    @property
    def key_repeat_rate(self):
        return self._ptr.KeyRepeatRate

    @key_repeat_rate.setter
    def key_repeat_rate(self, float value):
        self._ptr.KeyRepeatRate = value

    @property
    def fonts(self):
        return self._fonts

    @property
    def font_global_scale(self):
        return self._ptr.FontGlobalScale

    @font_global_scale.setter
    def font_global_scale(self, float value):
        self._ptr.FontGlobalScale = value

    @property
    def font_allow_user_scaling(self):
        return self._ptr.FontAllowUserScaling

    @font_allow_user_scaling.setter
    def font_allow_user_scaling(self, cimgui.bool value):
        self._ptr.FontAllowUserScaling = value

    @property
    def display_fb_scale(self):
        return _cast_ImVec2_tuple(self._ptr.DisplayFramebufferScale)

    @display_fb_scale.setter
    def display_fb_scale(self, value):
        self._ptr.DisplayFramebufferScale = _cast_tuple_ImVec2(value)

    @property
    def display_visible_min(self):
        return _cast_ImVec2_tuple(self._ptr.DisplayVisibleMin)

    @display_visible_min.setter
    def display_visible_min(self,  value):
        self._ptr.DisplayVisibleMin = _cast_tuple_ImVec2(value)

    @property
    def display_visible_max(self):
        return _cast_ImVec2_tuple(self._ptr.DisplayVisibleMax)

    @display_visible_max.setter
    def display_visible_max(self,  value):
        self._ptr.DisplayVisibleMax = _cast_tuple_ImVec2(value)

    @property
    def config_mac_osx_behaviors(self):
        return self._ptr.ConfigMacOSXBehaviors

    @config_mac_osx_behaviors.setter
    def config_mac_osx_behaviors(self, cimgui.bool value):
        self._ptr.ConfigMacOSXBehaviors = value

    @property
    def config_cursor_blink(self):
        return self._ptr.ConfigInputTextCursorBlink

    @config_cursor_blink.setter
    def config_cursor_blink(self, cimgui.bool value):
        self._ptr.ConfigInputTextCursorBlink = value

    @property
    def config_resize_windows_from_edges(self):
        return self._ptr.ConfigResizeWindowsFromEdges

    @config_resize_windows_from_edges.setter
    def config_resize_windows_from_edges(self, cimgui.bool value):
        self._ptr.ConfigResizeWindowsFromEdges = value

    @property
    def mouse_pos(self):
        return _cast_ImVec2_tuple(self._ptr.MousePos)

    @mouse_pos.setter
    def mouse_pos(self, value):
        self._ptr.MousePos = _cast_tuple_ImVec2(value)

    @property
    def mouse_down(self):
        # todo: consider adding setter despite the fact that it can be
        # todo: modified in place
        cdef cvarray mouse_down = cvarray(
            shape=(5,),
            format='b',
            itemsize=sizeof(bool),
            allocate_buffer=False
        )
        mouse_down.data = <char*>self._ptr.MouseDown
        return mouse_down

    @property
    def mouse_wheel(self):
        return self._ptr.MouseWheel

    @mouse_wheel.setter
    def mouse_wheel(self, float value):
        self._ptr.MouseWheel = value

    @property
    def mouse_draw_cursor(self):
        return self._ptr.MouseDrawCursor

    @mouse_draw_cursor.setter
    def mouse_draw_cursor(self, cimgui.bool value):
        self._ptr.MouseDrawCursor = value

    @property
    def key_ctrl(self):
        return self._ptr.KeyCtrl

    @key_ctrl.setter
    def key_ctrl(self, cimgui.bool value):
        self._ptr.KeyCtrl = value

    @property
    def key_shift(self):
        return self._ptr.KeyShift

    @key_shift.setter
    def key_shift(self, cimgui.bool value):
        self._ptr.KeyShift = value

    @property
    def key_alt(self):
        return self._ptr.KeyAlt

    @key_alt.setter
    def key_alt(self, cimgui.bool value):
        self._ptr.KeyAlt = value

    @property
    def key_super(self):
        return self._ptr.KeySuper

    @key_super.setter
    def key_super(self, cimgui.bool value):
        self._ptr.KeySuper = value

    @property
    def keys_down(self):
        # todo: consider adding setter despite the fact that it can be
        # todo: modified in place
        cdef cvarray keys_down = cvarray(
            shape=(512,),
            format='b',
            itemsize=sizeof(bool),
            allocate_buffer=False
        )
        keys_down.data = <char*>self._ptr.KeysDown
        return keys_down

    def add_input_character(self, cimgui.ImWchar c):
        self._ptr.AddInputCharacter(c)

    # ... mapping of output properties ...
    @property
    def want_capture_mouse(self):
        return self._ptr.WantCaptureMouse

    @property
    def want_capture_keyboard(self):
        return self._ptr.WantCaptureKeyboard

    @property
    def want_text_input(self):
        return self._ptr.WantTextInput

    @property
    def want_set_mouse_pos(self):
        return self._ptr.WantSetMousePos

    @property
    def want_save_ini_setting(self):
        return self._ptr.WantSaveIniSettings

    @property
    def nav_active(self):
        return self._ptr.NavActive

    @property
    def nav_visible(self):
        return self._ptr.NavVisible

    @property
    def framerate(self):
        return self._ptr.Framerate

    @property
    def metrics_render_vertices(self):
        return self._ptr.MetricsRenderVertices

    @property
    def metrics_active_windows(self):
        return self._ptr.MetricsActiveWindows


_io = None
def get_io():
    global _io

    if not _io:
        _io = _IO()

    return _io

def get_style():
    return GuiStyle.from_ref(cimgui.GetStyle())


def new_frame():
    """Start a new frame.

    After calling this you can submit any command from this point until
    next :any:`new_frame()` or :any:`render()`.

    .. wraps::
        void NewFrame()
    """
    cimgui.NewFrame()


def end_frame():
    """End a frame.

    ends the ImGui frame. automatically called by Render(), so most likely
    don't need to ever call that yourself directly. If you don't need to
    render you may call end_frame() but you'll have wasted CPU already.
    If you don't need to render, better to not create any imgui windows
    instead!

    .. wraps::
        void EndFrame()
    """
    cimgui.EndFrame()


def render():
    """Finalize frame, set rendering data, and run render callback (if set).

    .. wraps::
        void Render()
    """
    cimgui.Render()


def show_user_guide():
    """Show ImGui user guide editor.

    .. visual-example::
        :width: 700
        :height: 500
        :auto_layout:

        imgui.begin("Example: user guide")
        imgui.show_user_guide()
        imgui.end()


    .. wraps::
        void ShowUserGuide()
    """
    cimgui.ShowUserGuide()


def get_version():
    """Get the version of Dear ImGui.

    .. wraps::
        void GetVersion()
    """
    cdef const char* c_string = cimgui.GetVersion()
    cdef bytes py_string = c_string
    return c_string.decode("utf-8")


def style_colors_dark(GuiStyle dst = None):
    """Set the style to Dark.

       new, recommended style (default)

    .. wraps::
        void StyleColorsDark(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsDark(dst._ptr)
    else:
        cimgui.StyleColorsDark(NULL)


def style_colors_classic(GuiStyle dst = None):
    """Set the style to Classic.

       classic imgui style.

    .. wraps::
        void StyleColorsClassic(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsClassic(dst._ptr)
    else:
        cimgui.StyleColorsClassic(NULL)



def style_colors_light(GuiStyle dst = None):
    """Set the style to Light.

       best used with borders and a custom, thicker font

    .. wraps::
        void StyleColorsLight(ImGuiStyle* dst = NULL)
    """
    if dst:
        cimgui.StyleColorsLight(dst._ptr)
    else:
        cimgui.StyleColorsLight(NULL)


def show_style_editor(GuiStyle style=None):
    """Show ImGui style editor.

    .. visual-example::
        :width: 300
        :height: 300
        :auto_layout:

        imgui.begin("Example: my style editor")
        imgui.show_style_editor()
        imgui.end()

    Args:
        style (GuiStyle): style editor state container.

    .. wraps::
        void ShowStyleEditor(ImGuiStyle* ref = NULL)
    """
    if style:
        cimgui.ShowStyleEditor(style._ptr)
    else:
        cimgui.ShowStyleEditor()


def show_demo_window(closable=False):
    """Show ImGui demo window.

    .. visual-example::
        :width: 700
        :height: 600
        :auto_layout:

        imgui.show_demo_window()

    Args:
        closable (bool): define if window is closable.

    Returns:
        bool: True if window is not closed (False trigerred by close button).

    .. wraps::
        void ShowDemoWindow(bool* p_open = NULL)
    """
    cdef cimgui.bool opened = True

    if closable:
        cimgui.ShowDemoWindow(&opened)
    else:
        cimgui.ShowDemoWindow()

    return opened


def show_test_window():
    """Show ImGui demo window.

    .. visual-example::
        :width: 700
        :height: 600
        :auto_layout:

        imgui.show_test_window()

    .. wraps::
        void ShowDemoWindow()
    """
    cimgui.ShowDemoWindow()



def show_metrics_window(closable=False):
    """Show ImGui metrics window.

    .. visual-example::
        :width: 700
        :height: 200
        :auto_layout:

        imgui.show_metrics_window()

    Args:
        closable (bool): define if window is closable.

    Returns:
        bool: True if window is not closed (False trigerred by close button).

    .. wraps::
        void ShowMetricsWindow(bool* p_open = NULL)
    """
    cdef cimgui.bool opened = True

    if closable:
        cimgui.ShowMetricsWindow(&opened)
    else:
        cimgui.ShowMetricsWindow()

    return opened


def show_style_selector(str label):
    return cimgui.ShowStyleSelector(label)


def show_font_selector(str label):
    cimgui.ShowStyleSelector(label)


def begin(str label, closable=False, cimgui.ImGuiWindowFlags flags=0):
    """Begin a window.

    .. visual-example::
        :auto_layout:

        imgui.begin("Example: empty window")
        imgui.end()

    Args:
        label (str): label of the window.
        closable (bool): define if window is closable.
        flags: Window flags. See:
            :ref:`list of available flags <window-flag-options>`.

    Returns:
        tuple: ``(expanded, opened)`` tuple of bools. If window is collapsed
        ``expanded==True``. The value of ``opened`` is always True for
        non-closable and open windows but changes state to False on close
        button click for closable windows.

    .. wraps::
        Begin(
            const char* name,
            bool* p_open = NULL,
            ImGuiWindowFlags flags = 0
        )
    """
    cdef cimgui.bool opened = True

    return cimgui.Begin(_bytes(label), &opened if closable else NULL, flags), opened


def get_draw_data():
    """Get draw data.

    valid after :any:`render()` and until the next call
    to :any:`new_frame()`.  This is what you have to render.

    Returns:
        _DrawData: draw data for all draw calls required to display gui

    .. wraps::
        ImDrawData* GetDrawData()
    """
    return _DrawData.from_ptr(cimgui.GetDrawData())


def end():
    """End a window.

    This finishes appending to current window, and pops it off the window
    stack. See: :any:`begin()`.

    .. wraps::
        void End()
    """
    cimgui.End()


ctypedef fused child_id:
    str
    cimgui.ImGuiID


def begin_child(
    child_id label, float width = 0, float height = 0, bool border = False,
    cimgui.ImGuiWindowFlags flags = 0
):
    """Begin a scrolling region.

    **Note:** sizing of child region allows for three modes:
    * ``0.0`` - use remaining window size
    * ``>0.0`` - fixed size
    * ``<0.0`` - use remaining window size minus abs(size)

    .. visual-example::
        :width: 200
        :height: 200
        :auto_layout:

        imgui.begin("Example: child region")

        imgui.begin_child("region", 150, -50, border=True)
        imgui.text("inside region")
        imgui.end_child()

        imgui.text("outside region")
        imgui.end()

    Args:
        label (str or int): Child region identifier.
        width (float): Region width. See note about sizing.
        height (float): Region height. See note about sizing.
        border (bool): True if should display border. Defaults to False.
        flags: Window flags. See:
            :ref:`list of available flags <window-flag-options>`.

    Returns:
        bool: True if region is visible

    .. wraps::
        bool BeginChild(
            const char* str_id,
            const ImVec2& size = ImVec2(0,0),
            bool border = false,
            ImGuiWindowFlags flags = 0
        )

        bool BeginChild(
            ImGuiID id,
            const ImVec2& size = ImVec2(0,0),
            bool border = false,
            ImGuiWindowFlags flags = 0
        )
    """
    # note: we do not take advantage of C++ function overloading
    #       in order to take adventage of Python keyword arguments
    return cimgui.BeginChild(
        _bytes(label), _cast_args_ImVec2(width, height), border, flags
    )

def end_child():
    """End scrolling region.

    .. wraps::
        void EndChild()
    """
    cimgui.EndChild()


def get_content_region_max():
    """Get current content boundaries in window coordinates.

    Typically window boundaries include scrolling, or current
    column boundaries.

    Returns:
        Vec2: content boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetContentRegionMax()
    """
    return _cast_ImVec2_tuple(cimgui.GetContentRegionMax())


def get_content_region_available():
    """Get available content region.

    It is shortcut for:

    .. code-block: python
        imgui.get_content_region_max() - imgui.get_cursor_position()

    Returns:
        Vec2: available content region size two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetContentRegionMax()
    """
    return _cast_ImVec2_tuple(cimgui.GetContentRegionAvail())


def get_content_region_available_width():
    """Get available content region width.

    Returns:
        float: available content region width.

    .. wraps::
        float GetContentRegionAvailWidth()
    """
    return cimgui.GetContentRegionAvailWidth()


def get_window_content_region_min():
    """Get minimal current window content boundaries in window coordinates.

    It translates roughly to: ``(0, 0) - Scroll``

    Returns:
        Vec2: content boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetWindowContentRegionMin()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowContentRegionMin())


def get_window_content_region_max():
    """Get maximal current window content boundaries in window coordinates.

    It translates roughly to: ``(0, 0) + Size - Scroll``

    Returns:
        Vec2: content boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetWindowContentRegionMin()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowContentRegionMax())


def get_window_content_region_width():
    """Get available current window content region width.

    Returns:
        float: available content region width.

    .. wraps::
        float GetWindowContentRegionWidth()
    """
    return cimgui.GetWindowContentRegionWidth()


def set_window_focus():
    """Set window to be focused

    .. wraps::
        void SetWindowFocus()
    """
    cimgui.SetWindowFocus()


def get_scroll_x():
    """get scrolling amount [0..GetScrollMaxX()]

    Returns:
        float: the current scroll X value

    .. wraps::
        int GetScrollX()
    """
    return cimgui.GetScrollX()


def get_scroll_y():
    """get scrolling amount [0..GetScrollMaxY()]

    Returns:
        float: the current scroll Y value

    .. wraps::
        int GetScrollY()
    """
    return cimgui.GetScrollY()


def get_scroll_max_x():
    """get maximum scrolling amount ~~ ContentSize.X - WindowSize.X

    Returns:
        float: the maximum scroll X amount

    .. wraps::
        int GetScrollMaxX()
    """
    return cimgui.GetScrollMaxX()


def get_scroll_max_y():
    """get maximum scrolling amount ~~ ContentSize.X - WindowSize.X

    Returns:
        float: the maximum scroll Y amount

    .. wraps::
        int GetScrollMaxY()
    """
    return cimgui.GetScrollMaxY()


def set_scroll_x(float scroll_x):
    """set scrolling amount [0..SetScrollMaxX()]

    .. wraps::
        int SetScrollX(float)
    """
    cimgui.SetScrollX(scroll_x)


def set_scroll_y(float scroll_y):
    """set scrolling amount [0..SetScrollMaxY()]

    .. wraps::
        int SetScrollY(flot)
    """
    return cimgui.SetScrollY(scroll_y)


def set_window_font_scale(float scale):
    """Adjust per-window font scale for current window.

    Function should be called inside window context so after calling
    :any:`begin()`.

    Note: use ``get_io().font_global_scale`` if you want to scale all windows.

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: font scale")
        imgui.set_window_font_scale(2.0)
        imgui.text("Bigger font")
        imgui.end()

    Args:
        scale (float): font scale

    .. wraps::
        void SetWindowFontScale(float scale)
    """
    cimgui.SetWindowFontScale(scale)


def set_next_window_collapsed(
    cimgui.bool collapsed, cimgui.ImGuiCond condition=ALWAYS
):
    """Set next window collapsed state.

    .. visual-example::
        :auto_layout:
        :height: 60
        :width: 400

        imgui.set_next_window_collapsed(True)
        imgui.begin("Example: collapsed window")
        imgui.end()


    Args:
        collapsed (bool): set to True if window has to be collapsed.
        condition (:ref:`condition flag <condition-options>`): defines on
            which condition value should be set. Defaults to
            :any:`imgui.ALWAYS`.

    .. wraps::
         void SetNextWindowCollapsed(
             bool collapsed, ImGuiCond cond = 0
         )

    """
    cimgui.SetNextWindowCollapsed(collapsed, condition)


def set_next_window_focus():
    """Set next window to be focused (most front).

    .. wraps::
        void SetNextWindowFocus()
    """
    cimgui.SetNextWindowFocus()


def set_next_window_bg_alpha(float alpha):
    """set next window background color alpha. helper to easily modify ImGuiCol_WindowBg/ChildBg/PopupBg.

    .. wraps::
        void SetNextWindowBgAlpha(float)
    """
    cimgui.SetNextWindowBgAlpha(alpha)


def get_window_draw_list():
    """Get the draw list associated with the window, to append your own drawing primitives

    It may be useful if you want to do your own drawing via the DrawList
    api.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 10 10


        pos_x = 10
        pos_y = 10
        sz = 20

        draw_list = imgui.get_window_draw_list()

        for i in range(0, imgui.COLOR_COUNT):
            name = imgui.get_style_color_name(i);
            draw_list.add_rect_filled(pos_x, pos_y, pos_x+sz, pos_y+sz, imgui.get_color_u32_idx(i));
            imgui.dummy(sz, sz);
            imgui.same_line();

        rgba_color = imgui.get_color_u32_rgba(1, 1, 0, 1);
        draw_list.add_rect_filled(pos_x, pos_y, pos_x+sz, pos_y+sz, rgba_color);


    Returns:
        ImDrawList*

    .. wraps::
        ImDrawList* GetWindowDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetWindowDrawList())


def get_overlay_draw_list():
    """Get a special draw list that will be drawn last (over all windows).

    Useful for drawing overlays.

    Returns:
        ImDrawList*

    .. wraps::
        ImDrawList* GetWindowDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetOverlayDrawList())


def get_window_position():
    """Get current window position.

    It may be useful if you want to do your own drawing via the DrawList
    api.

    Returns:
        Vec2: two-tuple of window coordinates in screen space.

    .. wraps::
        ImVec2 GetWindowPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowPos())


def get_window_size():
    """Get current window size.

    Returns:
        Vec2: two-tuple of window dimensions.

    .. wraps::
        ImVec2 GetWindowSize()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowSize())


def get_window_width():
    """Get current window width.

    Returns:
        float: width of current window.

    .. wraps::
        float GetWindowWidth()
    """
    return cimgui.GetWindowWidth()


def get_window_height():
    """Get current window height.

    Returns:
        float: height of current window.

    .. wraps::
        float GetWindowHeight()
    """
    return cimgui.GetWindowHeight()


def set_next_window_position(
    float x, float y, cimgui.ImGuiCond condition=ALWAYS, float pivot_x=0, float pivot_y=0
):
    """Set next window position.

    Call before :func:`begin()`.

    Args:
        x (float): x window coordinate
        y (float): y window coordinate
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.
        pivot_x (float): pivot x window coordinate
        pivot_y (float): pivot y window coordinate

    .. visual-example::
        :title: window positioning
        :height: 50

        imgui.set_next_window_size(20, 20)

        for index in range(5):
            imgui.set_next_window_position(index * 40, 5)
            imgui.begin(str(index))
            imgui.end()

    .. wraps::
        void SetNextWindowPos(
            const ImVec2& pos,
            ImGuiCond cond = 0,
            const ImVec2& pivot = ImVec2(0,0)
        )

    """
    cimgui.SetNextWindowPos(_cast_args_ImVec2(x, y), condition, _cast_args_ImVec2(pivot_x, pivot_y))


def set_next_window_size(
    float width, float height, cimgui.ImGuiCond condition=ALWAYS
):
    """Set next window size.

    Call before :func:`begin()`.

    Args:
        width (float): window width. Value 0.0 enables autofit.
        height (float): window height. Value 0.0 enables autofit.
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: window sizing
        :height: 200

        imgui.set_next_window_position(io.display_size.x * 0.5, io.display_size.y * 0.5, 1, pivot_x = 0.5, pivot_y = 0.5)

        imgui.set_next_window_size(80, 180)
        imgui.begin("High")
        imgui.end()


    .. wraps::
        void SetNextWindowSize(
            const ImVec2& size, ImGuiCond cond = 0
        )
    """
    cimgui.SetNextWindowSize(_cast_args_ImVec2(width, height), condition)


def is_window_collapsed():
    """Check if current window is collapsed.

    Returns:
        bool: True if window is collapsed
    """
    return cimgui.IsWindowCollapsed()


def is_window_appearing():
    """Check if current window is appearing.

    Returns:
        bool: True if window is appearing
    """
    return cimgui.IsWindowAppearing()



def tree_node(str text, cimgui.ImGuiTreeNodeFlags flags=0):
    """Draw a tree node.

    Returns 'true' if the node is drawn, call :func:`tree_pop()` to finish.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        imgui.begin("Example: tree node")
        if imgui.tree_node("Expand me!", imgui.TREE_NODE_DEFAULT_OPEN):
            imgui.text("Lorem Ipsum")
            imgui.tree_pop()
        imgui.end()

    Args:
        text (str): Tree node label
        flags: TreeNode flags. See:
            :ref:`list of available flags <treenode-flag-options>`.

    Returns:
        bool: True if tree node is displayed (opened).

    .. wraps::
        bool TreeNode(const char* label)
        bool TreeNodeEx(const char* label, ImGuiTreeNodeFlags flags = 0)
    """
    return cimgui.TreeNodeEx(_bytes(text), flags)


def tree_pop():
    """Called to clear the tree nodes stack and return back the identation.

    Same as calls to :func:`unindent()` and :func:`pop_id()`.
    For a tree example see :func:`tree_node()`.

    .. wraps::
        void TreePop()
    """
    cimgui.TreePop()


def collapsing_header(
    str text,
    visible=None,
    cimgui.ImGuiTreeNodeFlags flags=0
):
    """Collapsable/Expandable header view.

    Returns 'true' if the header is open. Doesn't indent or push to stack,
    so no need to call any pop function.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        visible = True

        imgui.begin("Example: collapsing header")
        expanded, visible = imgui.collapsing_header("Expand me!", visible)

        if expanded:
            imgui.text("Now you see me!")
        imgui.end()

    Args:
        text (str): Tree node label
        visible (bool or None): Force visibility of a header. If set to True
            shows additional (X) close button. If set to False header is not
            visible at all. If set to None header is always visible and close
            button is not displayed.
        flags: TreeNode flags. See:
            :ref:`list of available flags <treenode-flag-options>`.

    Returns:
        tuple: a ``(expanded, visible)`` two-tuple indicating if item was
        expanded and whether the header is visible or not (only if ``visible``
        input argument is True/False).

    .. wraps::
        bool CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0)

        bool CollapsingHeader(
            const char* label,
            bool* p_open,
            ImGuiTreeNodeFlags flags = 0
        )
    """
    cdef cimgui.bool inout_opened = visible
    if visible is None:
        clicked = cimgui.CollapsingHeader(_bytes(text), NULL, flags)
    else:
        clicked = cimgui.CollapsingHeader(_bytes(text), &inout_opened, flags)
    return clicked, None if visible is None else inout_opened


def selectable(
    str label,
    selected=False,
    cimgui.ImGuiTreeNodeFlags flags=0,
    width=0,
    height=0
):
    """Selectable text. Returns 'true' if the item is pressed.

    Width of 0.0 will use the available width in the parent container.
    Height of 0.0 will use the available height in the parent container.

    .. visual-example::
        :auto_layout:
        :height: 200
        :width: 200
        :click: 80 40

        selected = [False, False]
        imgui.begin("Example: selectable")
        _, selected[0] = imgui.selectable(
            "1. I am selectable", selected[0]
        )
        _, selected[1] = imgui.selectable(
            "2. I am selectable too", selected[1]
        )
        imgui.text("3. I am not selectable")
        imgui.end()

    Args:
        label (str): The label.
        selected (bool): defines if item is selected or not.
        flags: Selectable flags. See:
            :ref:`list of available flags <selectable-flag-options>`.
        width (float): button width.
        height (float): button height.

    Returns:
        tuple: a ``(opened, selected)`` two-tuple indicating if item was
        clicked by the user and the current state of item.

    .. wraps::
        bool Selectable(
            const char* label,
            bool selected = false,
            ImGuiSelectableFlags flags = 0,
            const ImVec2& size = ImVec2(0,0)
        )

        bool Selectable(
            const char* label,
            bool* selected,
            ImGuiSelectableFlags flags = 0,
            const ImVec2& size = ImVec2(0,0)
        )
    """
    cdef cimgui.bool inout_selected = selected
    return cimgui.Selectable(
        _bytes(label),
        &inout_selected,
        flags,
        _cast_args_ImVec2(width, height)), inout_selected


def listbox(
    str label,
    int current,
    list items,
    int height_in_items=-1
):
    """Show listbox widget.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200

        current = 2
        imgui.begin("Example: listbox widget")

        clicked, current = imgui.listbox(
            "List", current, ["first", "second", "third"]
        )

        imgui.end()

    Args:
        label (str): The label.
        current (int): index of selected item.
        items (list): list of string labels for items.
        height_in_items (int): height of dropdown in items. Defaults to -1
            (autosized).

    Returns:
        tuple: a ``(changed, current)`` tuple indicating change of selection
        and current index of selected item.

    .. wraps::
        bool ListBox(
            const char* label,
            int* current_item,
            const char* items[],
            int items_count,
            int height_in_items = -1
        )

    """

    cdef int inout_current = current
    cdef const char** in_items = <const char**> malloc(len(items) * sizeof(char*))

    for index, item in enumerate(items):
        in_items[index] = strdup(_bytes(item))

    opened = cimgui.ListBox(
        _bytes(label),
        &inout_current,
        in_items,
        len(items),
        height_in_items
    )

    for i in range(len(items)):
        free(<char*>in_items[i])

    free(in_items)

    return opened, inout_current


def listbox_header(
    str label,
    width=0,
    height=0
):
    """For use if you want to reimplement :func:`listbox()` with custom data
    or interactions. You need to call :func:`listbox_footer()` at the end.

    .. visual-example::
        :auto_layout:
        :height: 200
        :width: 200
        :click: 80 40

        imgui.begin("Example: custom listbox")

        imgui.listbox_header("List", 200, 100)

        imgui.selectable("Selected", True)
        imgui.selectable("Not Selected", False)

        imgui.listbox_footer()

        imgui.end()

    Args:
        label (str): The label.
        width (float): button width.
        height (float): button height.

    Returns:
        opened (bool): If the item is opened or closed.

    .. wraps::
        bool ListBoxHeader(
            const char* label,
            const ImVec2& size = ImVec2(0,0)
        )
    """
    return cimgui.ListBoxHeader(
        _bytes(label),
        _cast_args_ImVec2(width, height)
    )


def listbox_footer():
    """Closing the listbox, previously opened by :func:`listbox_header()`.

    See :func:`listbox_header()` for usage example.

    .. wraps::
        void ListBoxFooter()
    """
    cimgui.ListBoxFooter()


def set_tooltip(str text):
    """Set tooltip under mouse-cursor.

    Usually used with :func:`is_item_hovered()`.
    For a complex tooltip window see :func:`begin_tooltip()`.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 80 40

        imgui.begin("Example: tooltip")
        imgui.button("Hover me!")
        if imgui.is_item_hovered():
            imgui.set_tooltip("Please?")
        imgui.end()

    .. wraps::
        void SetTooltip(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formatting
    cimgui.SetTooltip("%s", _bytes(text))


def begin_tooltip():
    """Use to create full-featured tooltip windows that aren't just text.

    .. visual-example::
        :auto_layout:
        :width: 600
        :height: 200
        :click: 80 40

        imgui.begin("Example: tooltip")
        imgui.button("Click me!")
        if imgui.is_item_hovered():
            imgui.begin_tooltip()
            imgui.text("This button is clickable.")
            imgui.text("This button has full window tooltip.")
            texture_id = imgui.get_io().fonts.texture_id
            imgui.image(texture_id, 512, 64, border_color=(1, 0, 0, 1))
            imgui.end_tooltip()
        imgui.end()

    .. wraps::
        void BeginTooltip()
    """
    cimgui.BeginTooltip()


def end_tooltip():
    """End tooltip window.

    See :func:`begin_tooltip()` for full usage example.

    .. wraps::
        void EndTooltip()
    """
    cimgui.EndTooltip()


def begin_main_menu_bar():
    """Create new full-screen menu bar.

     Only call :func:`end_main_menu_bar` if this function returns ``True``!

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 200
        :click: 10 10

        if imgui.begin_main_menu_bar():
            # first menu dropdown
            if imgui.begin_menu('File', True):
                imgui.menu_item('New', 'Ctrl+N', False, True)
                imgui.menu_item('Open ...', 'Ctrl+O', False, True)

                # submenu
                if imgui.begin_menu('Open Recent', True):
                    imgui.menu_item('doc.txt', None, False, True)
                    imgui.end_menu()

                imgui.end_menu()

            imgui.end_main_menu_bar()

    Returns:
        bool: True if main menu bar is displayed (opened).

    .. wraps::
        bool BeginMainMenuBar()
    """
    return cimgui.BeginMainMenuBar()


def end_main_menu_bar():
    """Close main menu bar context.

    Only call this function if the :func:`end_main_menu_bar` returns ``True``.

    For practical example how to use this function see documentation of
    :func:`begin_main_menu_bar`.

    .. wraps::
        bool EndMainMenuBar()
    """
    cimgui.EndMainMenuBar()


def begin_menu_bar():
    """Append new menu menu bar to current window.

    This function is different from :func:`begin_main_menu_bar`, as this is
    child-window specific. Only call :func:`end_menu_bar` if this returns
    ``True``!

    **Note:** this requires :ref:`WINDOW_MENU_BAR <window-flag-options>` flag
    to be set for the current window. Without this flag set the
    ``begin_menu_bar()`` function will always return ``False``.

    .. visual-example::
        :auto_layout:
        :click: 25 30

        flags = imgui.WINDOW_MENU_BAR

        imgui.begin("Child Window - File Browser", flags=flags)

        if imgui.begin_menu_bar():
            if imgui.begin_menu('File'):
                imgui.menu_item('Close')
                imgui.end_menu()

            imgui.end_menu_bar()

        imgui.end()

    Returns:
        bool: True if menu bar is displayed (opened).

    .. wraps::
        bool BeginMenuBar()
    """
    return cimgui.BeginMenuBar()


def end_menu_bar():
    """Close menu bar context.

    Only call this function if the :func:`begin_menu_bar` returns true.

    For practical example how to use this function see documentation of
    :func:`begin_menu_bar`.

    .. wraps::
        void EndMenuBar()
    """
    cimgui.EndMenuBar()


def begin_menu(str label, enabled=True):
    """Create new expandable menu in current menu bar.

    Only call :func:`end_menu` if this returns ``True``!

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    Args:
        label (str): label of the menu.
        enabled (bool): define if menu is enabled or disabled.

    Returns:
        bool: True if the menu is displayed (opened).

    .. wraps::
        bool BeginMenu(
            const char* label,
            bool enabled
        )
    """
    return cimgui.BeginMenu(_bytes(label), enabled)


def end_menu():
    """Close menu context.

    Only call this function if the :func:`begin_menu` returns ``True``.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    .. wraps::
        void EndMenu()
    """
    cimgui.EndMenu()


def menu_item(
    str label, str shortcut=None, cimgui.bool selected=False, enabled=True
):
    """Create a menu item.

    Item shortcuts are displayed for convenience but not processed by ImGui at
    the moment. Using ``selected`` arguement it is possible to show and trigger
    a check mark next to the menu item label.

    For practical example how to use this function, please see documentation
    of :func:`begin_main_menu_bar` or :func:`begin_menu_bar`.

    Args:
        label (str): label of the menu item.
        shortcut (str): shortcut text of the menu item.
        selected (bool): define if menu item is selected.
        enabled (bool): define if menu item is enabled or disabled.

    Returns:
        tuple: a ``(clicked, state)`` two-tuple indicating if item was
        clicked by the user and the current state of item (visibility of
        the check mark).

    .. wraps::
        MenuItem(
            const char* label,
            const char* shortcut,
            bool* p_selected,
            bool enabled = true
        )
    """
    cdef cimgui.bool inout_selected = selected

    # note: wee need to split this into two separate calls depending
    #       on the value of shortcut in order to support None instead
    #       of empty strings.
    if shortcut is None:
        clicked = cimgui.MenuItem(
            _bytes(label),
            NULL,
            &inout_selected,
            <bool>enabled
        )
    else:
        clicked = cimgui.MenuItem(
            _bytes(label),
            _bytes(shortcut),
            &inout_selected,
            <bool>enabled
        )
    return clicked, inout_selected


def open_popup(str label):
    """Open a popup window.

    Marks a popup window as open. Popups are closed when user click outside,
    or activate a pressable item, or :func:`close_current_popup()` is
    called within a :func:`begin_popup()`/:func:`end_popup()` block.
    Popup identifiers are relative to the current ID-stack
    (so :func:`open_popup` and :func:`begin_popup` needs to be at
    the same level).

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        imgui.begin("Example: simple popup")
        if imgui.button('Toggle..'):
            imgui.open_popup("toggle")
        if imgui.begin_popup("toggle"):
            if imgui.begin_menu('Sub-menu'):
                _, _ = imgui.menu_item('Click me')
                imgui.end_menu()
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of the modal window.

    .. wraps::
        void OpenPopup(
            const char* str_id
        )
    """
    cimgui.OpenPopup(_bytes(label))


def begin_popup(str label, cimgui.ImGuiWindowFlags flags=0):
    """Open a popup window.

    Returns ``True`` if the popup is open and you can start outputting
    content to it. Only call :func:`end_popup()` if :func:`begin_popup()`
    returned true.

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        imgui.begin("Example: simple popup")

        if imgui.button("select"):
            imgui.open_popup("select-popup")

        imgui.same_line()

        if imgui.begin_popup("select-popup"):
            imgui.text("Select one")
            imgui.separator()
            imgui.selectable("One")
            imgui.selectable("Two")
            imgui.selectable("Three")
            imgui.end_popup()

        imgui.end()

    Args:
        label (str): label of the modal window.

    Returns:
        opened (bool): True if popup is opened.

    .. wraps::
        bool BeginPopup(
            const char* str_id,
            ImGuiWindowFlags flags = 0
        )
    """
    return cimgui.BeginPopup(_bytes(label), flags)


def begin_popup_modal(str title, visible=None, cimgui.ImGuiWindowFlags flags=0):
    """Begin pouring popup contents.

    Differes from :func:`begin_popup()` with its modality - meaning it
    opens up on top of every other window.

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        imgui.begin("Example: simple popup modal")

        if imgui.button("Open Modal popup"):
            imgui.open_popup("select-popup")

        imgui.same_line()

        if imgui.begin_popup_modal("select-popup")[0]:
            imgui.text("Select an option:")
            imgui.separator()
            imgui.selectable("One")
            imgui.selectable("Two")
            imgui.selectable("Three")
            imgui.end_popup()

        imgui.end()

    Args:
        title (str): label of the modal window.
        visible (bool): define if popup is visible or not.
        flags: Window flags. See:
            :ref:`list of available flags <window-flag-options>`.

    Returns:
        tuple: ``(opened, visible)`` tuple of bools.
        opened can be ``False`` when the popup is completely clipped
        (e.g. zero size display).

    .. wraps::
        bool BeginPopupModal(
            const char* name,
            bool* p_open = NULL,
            ImGuiWindowFlags extra_flags = 0
        )
    """
    cdef cimgui.bool inout_visible = visible

    return cimgui.BeginPopupModal(
        _bytes(title),
        &inout_visible if visible is not None else NULL,
        flags
    ), inout_visible


def begin_popup_context_item(str label = None, int mouse_button = 1):
    """This is a helper function to handle the most simple case of associating
    one named popup to one given widget.

    .. visual-example::
        :title: Popup context view
        :height: 100
        :width: 200
        :auto_layout:
        :click: 40 40

        imgui.begin("Example: popup context view")
        imgui.text("Right-click to set value.")
        if imgui.begin_popup_context_item("Item Context Menu", mouse_button=0):
            imgui.selectable("Set to Zero")
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of item.
        mouse_button (int): mouse button identifier: 0 - left button,
            1 - right button, 2 - middle button

    Returns:
        opened (bool): opened can be False when the popup is completely
        clipped (e.g. zero size display).

    .. wraps::
        bool BeginPopupContextItem(
            const char* str_id = NULL,
            int mouse_button = 1
        )
    """
    if label is None:
        return cimgui.BeginPopupContextItem(NULL, mouse_button)
    else:
        return cimgui.BeginPopupContextItem(_bytes(label), mouse_button)


def begin_popup_context_window(
    str label = None,
    bool also_over_items = True,
    int mouse_button = 1
):
    """Helper function to open and begin popup when clicked on current window.

    As all popup functions it should end with :func:`end_popup()`.

    .. visual-example::
        :title: Popup context view
        :height: 100
        :width: 200
        :auto_layout:
        :click: 40 40

        imgui.begin("Example: popup context window")
        if imgui.begin_popup_context_window(mouse_button=0):
            imgui.selectable("Clear")
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of the window
        also_over_items (bool): display on top of widget.
        mouse_button (int): mouse button identifier:
            0 - left button
            1 - right button
            2 - middle button

    Returns:
        opened (bool): if the context window is opened.

    .. wraps::
        bool BeginPopupContextWindow(
            const char* str_id = NULL,
            bool also_over_items = true,
            int mouse_button = 1
        )
    """
    if label is None:
        return cimgui.BeginPopupContextWindow(
            NULL,
            also_over_items,
            mouse_button
        )
    else:
        return cimgui.BeginPopupContextWindow(
            _bytes(label),
            also_over_items,
            mouse_button
        )


def end_popup():
    """End a popup window.

    Should be called after each XYZPopupXYZ function.

    For practical example how to use this function, please see documentation
    of :func:`open_popup`.

    .. wraps::
        void EndPopup()
    """
    cimgui.EndPopup()


def close_current_popup():
    """Close the current popup window begin-ed directly above this call.
    Clicking on a :func:`menu_item()` or :func:`selectable()` automatically
    close the current popup.

    For practical example how to use this function, please see documentation
    of :func:`open_popup`.

    .. wraps::
        void CloseCurrentPopup()
    """
    cimgui.CloseCurrentPopup()


def text(str text):
    """Add text to current widget stack.

    .. visual-example::
        :title: simple text widget
        :height: 80
        :auto_layout:

        imgui.begin("Example: simple text")
        imgui.text("Simple text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        Text(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.Text("%s", _bytes(text))


def text_colored(str text, float r, float g, float b, float a=1.):
    """Add colored text to current widget stack.

    It is a shortcut for:

    .. code-block:: python

        imgui.push_style_color(imgui.COLOR_TEXT, r, g, b, a)
        imgui.text(text)
        imgui.pop_style_color()


    .. visual-example::
        :title: colored text widget
        :height: 100
        :auto_layout:

        imgui.begin("Example: colored text")
        imgui.text_colored("Colored text", 1, 0, 0)
        imgui.end()

    Args:
        text (str): text to display.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.

    .. wraps::
        TextColored(const ImVec4& col, const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.TextColored(_cast_args_ImVec4(r, g, b, a), "%s", _bytes(text))


def label_text(str label, str text):
    """Display text+label aligned the same way as value+label widgets.

    .. visual-example::
        :auto_layout:
        :height: 80
        :width: 300

        imgui.begin("Example: text with label")
        imgui.label_text("my label", "my text")
        imgui.end()

    Args:
        label (str): label to display.
        text (str): text to display.

    .. wraps::
        void LabelText(const char* label, const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.LabelText(_bytes(label), "%s", _bytes(text))


def text_unformatted(str text):
    """Big area text display - the size is defined by it's container.
    Recommended for long chunks of text.

    .. visual-example::
        :title: simple text widget
        :height: 100
        :width: 200
        :auto_layout:

        imgui.begin("Example: unformatted text")
        imgui.text_unformatted("Really ... long ... text")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        TextUnformatted(const char* text, const char* text_end = NULL)
    """
    cimgui.TextUnformatted(_bytes(text))


def bullet():
    """Display a small circle and keep the cursor on the same line.

    .. advance cursor x position by GetTreeNodeToLabelSpacing(),
       same distance that TreeNode() uses

    .. visual-example::
        :auto_layout:
        :height: 80

        imgui.begin("Example: bullets")

        for i in range(10):
            imgui.bullet()

        imgui.end()

    .. wraps::
        void Bullet()
    """
    cimgui.Bullet()


def bullet_text(str text):
    """Display bullet and text.

    This is shortcut for:

    .. code-block:: python

        imgui.bullet()
        imgui.text(text)

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: bullet text")
        imgui.bullet_text("Bullet 1")
        imgui.bullet_text("Bullet 2")
        imgui.bullet_text("Bullet 3")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        void BulletText(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    cimgui.BulletText("%s", _bytes(text))


def button(str label, width=0, height=0):
    """Display button.

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: button")
        imgui.button("Button 1")
        imgui.button("Button 2")
        imgui.end()

    Args:
        label (str): button label.
        width (float): button width.
        height (float): button height.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool Button(const char* label, const ImVec2& size = ImVec2(0,0))
    """
    return cimgui.Button(_bytes(label), _cast_args_ImVec2(width, height))


def small_button(str label):
    """Display small button (with 0 frame padding).

    .. visual-example::
        :auto_layout:
        :height: 100

        imgui.begin("Example: button")
        imgui.small_button("Button 1")
        imgui.small_button("Button 2")
        imgui.end()

    Args:
        label (str): button label.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool SmallButton(const char* label)
    """
    return cimgui.SmallButton(_bytes(label))


def invisible_button(str identifier, width, height):
    """Create invisible button.

    .. visual-example::
        :auto_layout:
        :height: 300
        :width: 300

        imgui.begin("Example: invisible button :)")
        imgui.invisible_button("Button 1", 200, 200)
        imgui.small_button("Button 2")
        imgui.end()

    Args:
        identifier (str): Button identifier. Like label on :any:`button()`
            but it is not displayed.
        width (float): button width.
        height (float): button height.

    Returns:
        bool: True if button is clicked.

    .. wraps::
        bool InvisibleButton(const char* str_id, const ImVec2& size)
    """
    return cimgui.InvisibleButton(
        _bytes(identifier),
        _cast_args_ImVec2(width, height)
    )


def color_button(
        str desc_id,
        float r, float g, float b, a=1.,
        flags=0,
        float width=0, float height=0,
):
    """Display colored button.

    .. visual-example::
        :auto_layout:
        :height: 150

        imgui.begin("Example: color button")
        imgui.color_button("Button 1", 1, 0, 0, 1, 0, 10, 10)
        imgui.color_button("Button 2", 0, 1, 0, 1, 0, 10, 10)
        imgui.color_button("Wide Button", 0, 0, 1, 1, 0, 20, 10)
        imgui.color_button("Tall Button", 1, 0, 1, 1, 0, 10, 20)
        imgui.end()

    Args:
        #r (float): red color intensity.
        #g (float): green color intensity.
        #b (float): blue color instensity.
        #a (float): alpha intensity.
        #ImGuiColorEditFlags: Color edit flags.  Zero for none.
        #width (float): Width of the color button
        #height (float): Height of the color button

    Returns:
        bool: True if button is clicked.

    .. wraps::
        bool ColorButton(
            const char* desc_id,
            const ImVec4& col,
            ImGuiColorEditFlags flags,
            ImVec2 size
        )
    """
    return cimgui.ColorButton(
        _bytes(desc_id), _cast_args_ImVec4(r, g, b, a), flags, _cast_args_ImVec2(width, height)
    )


def image_button(
    texture_id,
    float width,
    float height,
    tuple uv0=(0, 0),
    tuple uv1=(1, 1),
    tuple tint_color=(1, 1, 1, 1),
    tuple border_color=(0, 0, 0, 0),
    int frame_padding=-1,
):
    """Display image.

    .. todo:: add example with some preconfigured image

    Args:
        texture_id (object): user data defining texture id. Argument type
            is implementation dependent. For OpenGL it is usually an integer.
        size (Vec2): image display size two-tuple.
        uv0 (Vec2): UV coordinates for 1st corner (lower-left for OpenGL).
            Defaults to ``(0, 0)``.
        uv1 (Vec2): UV coordinates for 2nd corner (upper-right for OpenGL).
            Defaults to ``(1, 1)``.
        tint_color (Vec4): Image tint color. Defaults to white.
        border_color (Vec4): Image border color. Defaults to transparent.
        frame_padding (int): Frame padding (``0``: no padding, ``<0`` default
            padding).

    Returns:
        bool: True if clicked.

    .. wraps::
        bool ImageButton(
            ImTextureID user_texture_id,
            const ImVec2& size,
            const ImVec2& uv0 = ImVec2(0,0),
            const ImVec2& uv1 = ImVec2(1,1),
            int frame_padding = -1,
            const ImVec4& bg_col = ImVec4(0,0,0,0),
            const ImVec4& tint_col = ImVec4(1,1,1,1)
        )
    """
    return cimgui.ImageButton(
        <void*>texture_id,
        _cast_args_ImVec2(width, height),  # todo: consider inlining
        _cast_tuple_ImVec2(uv0),
        _cast_tuple_ImVec2(uv1),
        # note: slightly different order of params than in ImGui::Image()
        frame_padding,
        _cast_tuple_ImVec4(border_color),
        _cast_tuple_ImVec4(tint_color),
    )


def image(
    texture_id,
    float width,
    float height,
    tuple uv0=(0, 0),
    tuple uv1=(1, 1),
    tuple tint_color=(1, 1, 1, 1),
    tuple border_color=(0, 0, 0, 0),
):
    """Display image.

    .. visual-example::
        :auto_layout:
        :width: 550
        :height: 200

        texture_id = imgui.get_io().fonts.texture_id

        imgui.begin("Example: image display")
        imgui.image(texture_id, 512, 64, border_color=(1, 0, 0, 1))
        imgui.end()

    Args:
        texture_id (object): user data defining texture id. Argument type
            is implementation dependent. For OpenGL it is usually an integer.
        size (Vec2): image display size two-tuple.
        uv0 (Vec2): UV coordinates for 1st corner (lower-left for OpenGL).
            Defaults to ``(0, 0)``.
        uv1 (Vec2): UV coordinates for 2nd corner (upper-right for OpenGL).
            Defaults to ``(1, 1)``.
        tint_color(Vec4): Image tint color. Defaults to white.
        border_color(Vec4): Image border color. Defaults to transparent.

    .. wraps::
        void Image(
            ImTextureID user_texture_id,
            const ImVec2& size,
            const ImVec2& uv0 = ImVec2(0,0),
            const ImVec2& uv1 = ImVec2(1,1),
            const ImVec4& tint_col = ImVec4(1,1,1,1),
            const ImVec4& border_col = ImVec4(0,0,0,0)
        )
    """
    cimgui.Image(
        <void*>texture_id,
        _cast_args_ImVec2(width, height),  # todo: consider inlining
        _cast_tuple_ImVec2(uv0),
        _cast_tuple_ImVec2(uv1),
        _cast_tuple_ImVec4(tint_color),
        _cast_tuple_ImVec4(border_color),
    )


def checkbox(str label, cimgui.bool state):
    """Display checkbox widget.

    .. visual-example::
        :auto_layout:
        :width: 400


        # note: these should be initialized outside of the main interaction
        #       loop
        checkbox1_enabled = True
        checkbox2_enabled = False

        imgui.new_frame()
        imgui.begin("Example: checkboxes")

        # note: first element of return two-tuple notifies if there was a click
        #       event in currently processed frame and second element is actual
        #       checkbox state.
        _, checkbox1_enabled = imgui.checkbox("Checkbox 1", checkbox1_enabled)
        _, checkbox2_enabled = imgui.checkbox("Checkbox 2", checkbox2_enabled)

        imgui.text("Checkbox 1 state value: {}".format(checkbox1_enabled))
        imgui.text("Checkbox 2 state value: {}".format(checkbox2_enabled))

        imgui.end()


    Args:
        label (str): text label for checkbox widget.
        state (bool): current (desired) state of the checkbox. If it has to
            change, the new state will be returned as a second item of
            the return value.

    Returns:
        tuple: a ``(clicked, state)`` two-tuple indicating click event and the
        current state of the checkbox.

    .. wraps::
        bool Checkbox(const char* label, bool* v)
    """
    cdef cimgui.bool inout_state = state
    return cimgui.Checkbox(_bytes(label), &inout_state), inout_state


def checkbox_flags(str label, unsigned int flags, unsigned int flags_value):
    """Display checkbox widget that handle integer flags (bit fields).

    It is useful for handling window/style flags or any kind of flags
    implemented as integer bitfields.

    .. visual-example::
        :auto_layout:
        :width: 500

        flags = imgui.WINDOW_NO_RESIZE | imgui.WINDOW_NO_MOVE

        imgui.begin("Example: checkboxes for flags", flags=flags)

        clicked, flags = imgui.checkbox_flags(
            "No resize", flags, imgui.WINDOW_NO_RESIZE
        )
        clicked, flags = imgui.checkbox_flags(
            "No move", flags, imgui.WINDOW_NO_MOVE
        )
        clicked, flags = imgui.checkbox_flags(
            "No collapse", flags, imgui.WINDOW_NO_COLLAPSE
        )
        # note: it also allows to use multiple flags at once
        clicked, flags = imgui.checkbox_flags(
            "No resize & no move", flags,
            imgui.WINDOW_NO_RESIZE | imgui.WINDOW_NO_MOVE
        )
        imgui.text("Current flags value: {0:b}".format(flags))
        imgui.end()

    Args:
        label (str): text label for checkbox widget.
        flags (int): current state of the flags associated with checkbox.
            Actual state of checkbox (toggled/untoggled) is calculated from
            this argument and ``flags_value`` argument. If it has to change,
            the new state will be returned as a second item of the return
            value.
        flags_value (int): values of flags this widget can toggle. Represents
            bitmask in flags bitfield. Allows multiple flags to be toggled
            at once (specify using bit OR operator `|`, see example above).

    Returns:
        tuple: a ``(clicked, flags)`` two-tuple indicating click event and the
        current state of the flags controlled with this checkbox.

    .. wraps::
        bool CheckboxFlags(
            const char* label, unsigned int* flags,
            unsigned int flags_value
        )
    """
    cdef unsigned int inout_flags = flags

    return cimgui.CheckboxFlags(_bytes(label), &inout_flags, flags_value), inout_flags


def radio_button(str label, cimgui.bool active):
    """Display radio button widget

    .. visual-example::
        :auto_layout:
        :height: 100

        # note: the variable that contains the state of the radio_button, should be initialized
        #       outside of the main interaction loop
        radio_active = True

        imgui.begin("Example: radio buttons")

        if imgui.radio_button("Radio button", radio_active):
            radio_active = not radio_active

        imgui.end()

    Args:
        label (str): button label.
        active (bool): state of the radio button.

    Returns:
        bool: True if clicked.

    .. wraps::
        bool RadioButton(const char* label, bool active)
    """
    return cimgui.RadioButton(_bytes(label), active)


def combo(str label, int current, list items, int height_in_items=-1):
    """Display combo widget.

    .. visual-example::
        :auto_layout:
        :height: 200
        :click: 80 40

        current = 2
        imgui.begin("Example: combo widget")

        clicked, current = imgui.combo(
            "combo", current, ["first", "second", "third"]
        )

        imgui.end()

    Args:
        label (str): combo label.
        current (int): index of selected item.
        items (list): list of string labels for items.
        height_in_items (int): height of dropdown in items. Defaults to -1
            (autosized).

    Returns:
        tuple: a ``(changed, current)`` tuple indicating change of selection
        and current index of selected item.

    .. wraps::
        bool Combo(
            const char* label, int* current_item,
            const char* items_separated_by_zeros,
            int height_in_items = -1
        )

    """
    cdef int inout_current = current

    in_items = "\0".join(items) + "\0"

    return cimgui.Combo(
        _bytes(label), &inout_current, _bytes(in_items), height_in_items
    ), inout_current


def color_edit3(str label, float r, float g, float b):
    """Display color edit widget for color without alpha value.

    .. visual-example::
        :auto_layout:
        :width: 300

        # note: the variable that contains the color data, should be initialized
        #       outside of the main interaction loop
        color_1 = 1., .0, .5
        color_2 = 0., .8, .3

        imgui.begin("Example: color edit without alpha")

        # note: first element of return two-tuple notifies if the color was changed
        #       in currently processed frame and second element is current value
        #       of color
        changed, color_1 = imgui.color_edit3("Color 1", *color_1)
        changed, color_2 = imgui.color_edit3("Color 2", *color_2)

        imgui.end()

    Args:
        label (str): color edit label.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.

    Returns:
        tuple: a ``(bool changed, float color[3])`` tuple that contains indicator of color
        change and current value of color

    .. wraps::
        bool ColorEdit3(const char* label, float col[3])
    """

    cdef float[3] inout_color = [r, g, b]

    return cimgui.ColorEdit3(
        _bytes(label), <float *>(&inout_color)
    ), (inout_color[0], inout_color[1], inout_color[2])


def color_edit4(
    str label, float r, float g, float b, float a, cimgui.bool show_alpha=True
):
    """Display color edit widget for color with alpha value.

    .. visual-example::
        :auto_layout:
        :width: 400

        # note: the variable that contains the color data, should be initialized
        #       outside of the main interaction loop
        color = 1., .0, .5, 1.

        imgui.begin("Example: color edit with alpha")

        # note: first element of return two-tuple notifies if the color was changed
        #       in currently processed frame and second element is current value
        #       of color and alpha
        _, color = imgui.color_edit4("Alpha", *color, show_alpha=True)
        _, color = imgui.color_edit4("No alpha", *color, show_alpha=False)

        imgui.end()

    Args:
        label (str): color edit label.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.
        show_alpha (bool): if set to True wiget allows to modify alpha

    Returns:
        tuple: a ``(bool changed, float color[4])`` tuple that contains indicator of color
        change and current value of color and alpha

    .. wraps::
        ColorEdit4(
            const char* label, float col[4], bool show_alpha = true
        )
    """
    cdef float[4] inout_color = [r, g, b, a]

    return cimgui.ColorEdit4(
        _bytes(label), <float *>(&inout_color), show_alpha
    ), (inout_color[0], inout_color[1], inout_color[2], inout_color[3])


def drag_float(
    str label, float value,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    float power = 1.
):
    """Display float drag widget.

    .. todo::
        Consider replacing ``format`` with something that allows
        for safer way to specify display format without loosing the
        functionality of wrapped function.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 42.0

        imgui.begin("Example: drag float")
        changed, value = imgui.drag_float(
            "Default", value,
        )
        changed, value = imgui.drag_float(
            "Less precise", value, format="%.1f"
        )
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): drag values,
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** Highly unsafe when used without care.
            May lead to segmentation faults and other memory violation issues.
        power (float): index of the power function applied to the value.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the current drag value.

    .. wraps::
        bool DragFloat(
            const char* label,
            float* v,
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float inout_value = value

    return cimgui.DragFloat(
        _bytes(label), &inout_value,
        change_speed, min_value, max_value, _bytes(format), power
    ), inout_value


def drag_float2(
    str label, float value0, float value1,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    float power = 1.
):
    """Display float drag widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float2(
            "Default", *values
        )
        changed, values = imgui.drag_float2(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        power (float): index of the power function applied to the value.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat2(
            const char* label,
            float v[2],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[2] inout_values = [value0, value1]
    return cimgui.DragFloat2(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), power
    ), (inout_values[0], inout_values[1])


def drag_float3(
    str label, float value0, float value1, float value2,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    float power = 1.
):
    """Display float drag widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0, 69.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float3(
            "Default", *values
        )
        changed, values = imgui.drag_float3(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        power (float): index of the power function applied to the value.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat3(
            const char* label,
            float v[3],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[3] inout_values = [value0, value1, value2]
    return cimgui.DragFloat3(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), power
    ), (inout_values[0], inout_values[1], inout_values[2])


def drag_float4(
    str label, float value0, float value1, float value2, float value3,
    float change_speed = 1.0,
    float min_value=0.0,
    float max_value=0.0,
    str format = "%.3f",
    float power = 1.
):
    """Display float drag widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.0, 42.0, 69.0, 0.0

        imgui.begin("Example: drag float")
        changed, values = imgui.drag_float4(
            "Default", *values
        )
        changed, values = imgui.drag_float4(
            "Less precise", *values, format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): drag values.
        change_speed (float): how fast values change on drag.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_float()`.
        power (float): index of the power function applied to the value.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragFloat4(
            const char* label,
            float v[4],
            float v_speed = 1.0f,
            float v_min = 0.0f,
            float v_max = 0.0f,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragFloat4(
        _bytes(label), <float*>&inout_values,
        change_speed, min_value, max_value, _bytes(format), power
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def drag_int(
    str label, int value,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d"
):
    """Display int drag widget.

    .. todo::
        Consider replacing ``format`` with something that allows
        for safer way to specify display format without loosing the
        functionality of wrapped function.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 42

        imgui.begin("Example: drag int")
        changed, value = imgui.drag_int("drag int", value,)
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): drag value,
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** Highly unsafe when used without care.
            May lead to segmentation faults and other memory violation issues.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the current drag value.

    .. wraps::
        bool DragInt(
            const char* label,
            int* v,
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
        )
    """
    cdef int inout_value = value

    return cimgui.DragInt(
        _bytes(label), &inout_value,
        change_speed, min_value, max_value, _bytes(format)
    ), inout_value


def drag_int2(
    str label, int value0, int value1,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d"
):
    """Display int drag widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int2(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt2(
            const char* label,
            int v[2],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
        )
    """
    cdef int[2] inout_values = [value0, value1]
    return cimgui.DragInt2(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format),
    ), (inout_values[0], inout_values[1])


def drag_int3(
    str label, int value0, int value1, int value2,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d"
):
    """Display int drag widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int3(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt3(
            const char* label,
            int v[3],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]
    return cimgui.DragInt3(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format),
    ), (inout_values[0], inout_values[1], inout_values[2])


def drag_int4(
    str label, int value0, int value1, int value2, int value3,
    float change_speed = 1.0,
    int min_value=0,
    int max_value=0,
    str format = "%d"
):
    """Display int drag widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69, 0

        imgui.begin("Example: drag int")
        changed, values = imgui.drag_int4(
            "drag ints", *values
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): drag values.
        change_speed (float): how fast values change on drag.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe. See :any:`drag_int()`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current drag values.

    .. wraps::
        bool DragInt4(
            const char* label,
            int v[4],
            float v_speed = 1.0f,
            int v_min = 0.0f,
            int v_max = 0.0f,
            const char* format = "%d",
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragInt4(
        _bytes(label), <int*>&inout_values,
        change_speed, min_value, max_value, _bytes(format),
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def input_text(
    str label,
    str value,
    int buffer_length,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display text input widget.

    ``buffer_length`` is the maximum allowed length of the content.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        text_val = 'Please, type the coefficient here.'
        imgui.begin("Example: text input")
        changed, text_val = imgui.input_text(
            'Amount:',
            text_val,
            256
        )
        imgui.text('You wrote:')
        imgui.same_line()
        imgui.text(text_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (str): textbox value
        buffer_length (int): length of the content buffer
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. wraps::
        bool InputText(
            const char* label,
            char* buf,
            size_t buf_size,
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """
    # todo: pymalloc
    cdef char* inout_text = <char*>malloc(buffer_length * sizeof(char))
    # todo: take special care of terminating char
    strncpy(inout_text, _bytes(value), buffer_length)

    changed = cimgui.InputText(
        _bytes(label), inout_text, buffer_length, flags, NULL, NULL
    )
    output = _from_bytes(inout_text)

    free(inout_text)
    return changed, output


def input_text_multiline(
    str label,
    str value,
    int buffer_length,
    float width=0,
    float height=0,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display multiline text input widget.

    ``buffer_length`` is the maximum allowed length of the content.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 200

        text_val = 'Type the your message here.'
        imgui.begin("Example: text input")
        changed, text_val = imgui.input_text_multiline(
            'Message:',
            text_val,
            2056
        )
        imgui.text('You wrote:')
        imgui.same_line()
        imgui.text(text_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (str): textbox value
        buffer_length (int): length of the content buffer
        width (float): width of the textbox
        height (float): height of the textbox
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current text contents.

    .. wraps::
        bool InputTextMultiline(
            const char* label,
            char* buf,
            size_t buf_size,
            const ImVec2& size = ImVec2(0,0),
            ImGuiInputTextFlags flags = 0,
            ImGuiInputTextCallback callback = NULL,
            void* user_data = NULL
        )
    """
    cdef char* inout_text = <char*>malloc(buffer_length * sizeof(char))
    # todo: take special care of terminating char
    strncpy(inout_text, _bytes(value), buffer_length)

    changed = cimgui.InputTextMultiline(
        _bytes(label), inout_text, buffer_length,
        _cast_args_ImVec2(width, height), flags,
        NULL, NULL
    )
    output = _from_bytes(inout_text)

    free(inout_text)
    return changed, output


def input_float(
    str label,
    float value,
    float step=0.0,
    float step_fast=0.0,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        float_val = 0.4
        imgui.begin("Example: float input")
        changed, float_val = imgui.input_float('Type coefficient:', float_val)
        imgui.text('You wrote: %f' % float_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (float): textbox value
        step (float): incremental step
        step_fast (float): fast incremental step
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputFloat(
            const char* label,
            float* v,
            float step = 0.0f,
            float step_fast = 0.0f,
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float inout_value = value

    return cimgui.InputFloat(
        _bytes(label), &inout_value, step,
        step_fast, _bytes(format), flags
    ), inout_value


def input_float2(
    str label,
    float value0, float value1,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display two-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2
        imgui.begin("Example: two float inputs")
        changed, values = imgui.input_float2('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat2(
            const char* label,
            float v[2],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[2] inout_values = [value0, value1]

    return cimgui.InputFloat2(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1])


def input_float3(
    str label,
    float value0, float value1, float value2,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display three-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2, 29.3
        imgui.begin("Example: three float inputs")
        changed, values = imgui.input_float3('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat3(
            const char* label,
            float v[3],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[3] inout_values = [value0, value1, value2]

    return cimgui.InputFloat3(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2])


def input_float4(
    str label,
    float value0, float value1, float value2, float value3,
    str format = "%.3f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display four-float input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 0.4, 3.2, 29.3, 12.9
        imgui.begin("Example: four float inputs")
        changed, values = imgui.input_float4('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): input values.
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        textbox state change and the tuple of current values.

    .. wraps::
        bool InputFloat4(
            const char* label,
            float v[4],
            const char* format = "%.3f",
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef float[4] inout_values = [value0, value1, value2, value3]

    return cimgui.InputFloat4(
        _bytes(label), <float*>&inout_values,
        _bytes(format), flags
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def input_int(
    str label,
    int value,
    int step=1,
    int step_fast=100,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        int_val = 3
        imgui.begin("Example: integer input")
        changed, int_val = imgui.input_int('Type multiplier:', int_val)
        imgui.text('You wrote: %i' % int_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (int): textbox value
        step (int): incremental step
        step_fast (int): fast incremental step
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt(
            const char* label,
            int* v,
            int step = 1,
            int step_fast = 100,
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int inout_value = value

    return cimgui.InputInt(
        _bytes(label), &inout_value, step, step_fast, flags
    ), inout_value


def input_int2(
    str label,
    int value0, int value1,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display two-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12
        imgui.begin("Example: two int inputs")
        changed, values = imgui.input_int2('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt2(
            const char* label,
            int v[2],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[2] inout_values = [value0, value1]

    return cimgui.InputInt2(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1]]


def input_int3(
    str label,
    int value0, int value1, int value2,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display three-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12, 28
        imgui.begin("Example: three int inputs")
        changed, values = imgui.input_int3('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt3(
            const char* label,
            int v[3],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]

    return cimgui.InputInt3(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1], inout_values[2]]


def input_int4(
    str label,
    int value0, int value1, int value2, int value3,
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display four-integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        values = 4, 12, 28, 73
        imgui.begin("Example: four int inputs")
        changed, values = imgui.input_int4('Type here:', *values)
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (int): textbox values
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt4(
            const char* label,
            int v[4],
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]

    return cimgui.InputInt4(
        _bytes(label), <int*>&inout_values, flags
    ), [inout_values[0], inout_values[1], inout_values[2], inout_values[3]]


def input_double(
    str label,
    int value,
    int step=1,
    int step_fast=100,
    str format = "%.6f",
    cimgui.ImGuiInputTextFlags flags=0
):
    """Display integer input widget.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 100

        double_val = 3.14159265358979323846
        imgui.begin("Example: integer input")
        changed, double_val = imgui.input_double('Type multiplier:', double_val)
        imgui.text('You wrote: %i' % double_val)
        imgui.end()

    Args:
        label (str): widget label.
        value (int): textbox value
        step (int): incremental step
        step_fast (int): fast incremental step
        format = (str): format string
        flags: InputText flags. See:
            :ref:`list of available flags <inputtext-flag-options>`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        textbox state change and the current textbox content.

    .. wraps::
        bool InputInt(
            const char* label,
            int* v,
            int step = 1,
            int step_fast = 100,
            _bytes(format),
            ImGuiInputTextFlags extra_flags = 0
        )
    """
    cdef int inout_value = value

    return cimgui.InputInt(
        _bytes(label), &inout_value, step, step_fast, flags
    ), inout_value



def slider_float(
    str label,
    float value,
    float min_value,
    float max_value,
    str format = "%.3f",
    float power=1.0
):
    """Display float slider widget.
    Use power different from 1.0 for logarithmic sliders.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 88.2

        imgui.begin("Example: slider float")
        changed, value = imgui.slider_float(
            "slide floats", value,
            min_value=0.0, max_value=100.0,
            format="%.0f",
            power=1.0
        )
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        power (float): how fast values changes on slide.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the current slider value.

    .. wraps::
        bool SliderFloat(
            const char* label,
            float v,
            float v_min,
            float v_max,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float inout_value = value
    return cimgui.SliderFloat(
        _bytes(label), <float*>&inout_value,
        min_value, max_value, _bytes(format), power
    ), inout_value


def slider_float2(
    str label,
    float value0, float value1,
    float min_value,
    float max_value,
    str format = "%.3f",
    float power=1.0
):
    """Display float slider widget with 2 values.
    Use power different from 1.0 for logarithmic sliders.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6

        imgui.begin("Example: slider float2")
        changed, values = imgui.slider_float2(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f",
            power=1.0
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()
    Args:
        label (str): widget label.
        value0, value1 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        power (float): how fast values changes on slide.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat2(
            const char* label,
            float v[2],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[2] inout_values = [value0, value1]
    return cimgui.SliderFloat2(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), power
    ), (inout_values[0], inout_values[1])


def slider_float3(
    str label,
    float value0, float value1, float value2,
    float min_value,
    float max_value,
    str format = "%.3f",
    float power=1.0
):
    """Display float slider widget with 3 values.
    Use power different from 1.0 for logarithmic sliders.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6, 69.1

        imgui.begin("Example: slider float3")
        changed, values = imgui.slider_float3(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f",
            power=1.0
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        power (float): how fast values changes on slide.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat3(
            const char* label,
            float v[3],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[3] inout_values = [value0, value1, value2]
    return cimgui.SliderFloat3(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), power
    ), (inout_values[0], inout_values[1], inout_values[2])


def slider_float4(
    str label,
    float value0, float value1, float value2, float value3,
    float min_value,
    float max_value,
    str format = "%.3f",
    float power=1.0
):
    """Display float slider widget with 4 values.
    Use power different from 1.0 for logarithmic sliders.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88.2, 42.6, 69.1, 0.3

        imgui.begin("Example: slider float4")
        changed, values = imgui.slider_float4(
            "slide floats", *values,
            min_value=0.0, max_value=100.0,
            format="%.0f",
            power=1.0
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): slider values.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        power (float): how fast values changes on slide.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderFloat4(
            const char* label,
            float v[4],
            float v_min,
            float v_max,
            const char* format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[4] inout_values = [value0, value1, value2, value3]
    return cimgui.SliderFloat4(
        _bytes(label), <float*>&inout_values,
        min_value, max_value, _bytes(format), power
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def slider_int(
    str label,
    int value,
    int min_value,
    int max_value,
    str format = "%.f"
):
    """Display int slider widget

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        value = 88

        imgui.begin("Example: slider int")
        changed, values = imgui.slider_int(
            "slide ints", value,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): slider value.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool SliderInt(
            const char* label,
            int v,
            int v_min,
            int v_max,
            const char* format = "%.3f"
        )
    """
    cdef int inout_value = value
    return cimgui.SliderInt(
        _bytes(label), <int*>&inout_value,
        min_value, max_value, _bytes(format)
    ), inout_value


def slider_int2(
    str label,
    int value0, int value1,
    int min_value,
    int max_value,
    str format = "%.f"
):
    """Display int slider widget with 2 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 27

        imgui.begin("Example: slider int2")
        changed, values = imgui.slider_int2(
            "slide ints2", *values,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt2(
            const char* label,
            int v[2],
            int v_min,
            int v_max,
            const char* format = "%.3f"
        )
    """
    cdef int[2] inout_values = [value0, value1]
    return cimgui.SliderInt2(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format)
    ), (inout_values[0], inout_values[1])


def slider_int3(
    str label,
    int value0, int value1, int value2,
    int min_value,
    int max_value,
    str format = "%.f"
):
    """Display int slider widget with 3 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 27, 3

        imgui.begin("Example: slider int3")
        changed, values = imgui.slider_int3(
            "slide ints3", *values,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt3(
            const char* label,
            int v[3],
            int v_min,
            int v_max,
            const char* format = "%.3f"
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]
    return cimgui.SliderInt3(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format)
    ), (inout_values[0], inout_values[1], inout_values[2])


def slider_int4(
    str label,
    int value0, int value1, int value2, int value3,
    int min_value,
    int max_value,
    str format = "%.f"
):
    """Display int slider widget with 4 values.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        values = 88, 42, 69, 0

        imgui.begin("Example: slider int4")
        changed, values = imgui.slider_int4(
            "slide ints", *values,
            min_value=0, max_value=100, format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (int): slider values.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.

    Returns:
        tuple: a ``(changed, values)`` tuple that contains indicator of
        widget state change and the tuple of current slider values.

    .. wraps::
        bool SliderInt4(
            const char* label,
            int v[4],
            int v_min,
            int v_max,
            const char* format = "%.3f"
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]
    return cimgui.SliderInt4(
        _bytes(label), <int*>&inout_values,
        min_value, max_value, _bytes(format)
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def v_slider_float(
    str label,
    float width,
    float height,
    float value,
    float min_value,
    float max_value,
    str format = "%.f",
    float power=1.0
):
    """Display vertical float slider widget with the specified width and
    height.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        width = 20
        height = 100
        value = 88

        imgui.begin("Example: vertical slider float")
        changed, values = imgui.v_slider_float(
            "vertical slider float",
            width, height, value,
            min_value=0, max_value=100,
            format="%0.3f", power = 1.0
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): slider value.
        min_value (float): min value allowed by widget.
        max_value (float): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_float()`.
        power (float): how fast values changes on slide.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool VSliderFloat(
            const char* label,
            const ImVec2& size,
            float v,
            float v_min,
            floatint v_max,
            const char* format = "%.3f",
            float power=1.0
        )
    """
    cdef float inout_value = value
    return cimgui.VSliderFloat(
        _bytes(label), _cast_args_ImVec2(width, height),
        <float*>&inout_value,
        min_value, max_value, _bytes(format), power
    ), inout_value


def v_slider_int(
    str label,
    float width,
    float height,
    int value,
    int min_value,
    int max_value,
    str format = "%d"
):
    """Display vertical int slider widget with the specified width and height.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        width = 20
        height = 100
        value = 88

        imgui.begin("Example: vertical slider int")
        changed, values = imgui.v_slider_int(
            "vertical slider int",
            width, height, value,
            min_value=0, max_value=100,
            format="%d"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value (int): slider value.
        min_value (int): min value allowed by widget.
        max_value (int): max value allowed by widget.
        format (str): display format string as C-style ``printf``
            format string. **Warning:** highly unsafe.
            See :any:`slider_int()`.

    Returns:
        tuple: a ``(changed, value)`` tuple that contains indicator of
        widget state change and the slider value.

    .. wraps::
        bool VSliderInt(
            const char* label,
            const ImVec2& size,
            int v,
            int v_min,
            int v_max,
            const char* format = "%.3f"
        )
    """
    cdef int inout_value = value
    return cimgui.VSliderInt(
        _bytes(label), _cast_args_ImVec2(width, height),
        <int*>&inout_value,
        min_value, max_value, _bytes(format)
    ), inout_value


def plot_lines(
        str label not None,
        const float[:] values not None,
        int values_count  = -1,
        int values_offset = 0,
        str overlay_text = None,
        float scale_min = FLT_MAX,
        float scale_max = FLT_MAX,
        graph_size = (0, 0),
        int stride = sizeof(float),
    ):

    """
    Plot a 1D array of float values.

    Args:
        label (str): A plot label that will be displayed on the plot's right
            side. If you want the label to be invisible, add :code:`"##"`
            before the label's text: :code:`"my_label" -> "##my_label"`

        values (array of floats): the y-values.
            It must be a type that supports Cython's Memoryviews,
            (See: http://docs.cython.org/en/latest/src/userguide/memoryviews.html)
            for example a numpy array.

        overlay_text (str or None, optional): Overlay text.

        scale_min (float, optional): y-value at the bottom of the plot.
        scale_max (float, optional): y-value at the top of the plot.

        graph_size (tuple of two floats, optional): plot size in pixels.
            **Note:** In ImGui 1.49, (-1,-1) will NOT auto-size the plot.
            To do that, use :func:`get_content_region_available` and pass
            in the right size.

    **Note:** These low-level parameters are exposed if needed for
    performance:

    * **values_offset** (*int*): Index of first element to display
    * **values_count** (*int*): Number of values to display. -1 will use the
        entire array.
    * **stride** (*int*): Number of bytes to move to read next element.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        from array import array
        from math import sin
        # NOTE: this example will not work under py27 due do incompatible
        # implementation of array and memmory view.
        plot_values = array('f', [sin(x * 0.1) for x in range(100)])

        imgui.begin("Plot example")
        imgui.plot_lines("Sin(t)", plot_values)
        imgui.end()

    .. wraps::
            void PlotLines(
                const char* label, const float* values, int values_count,

                int values_offset = 0,
                const char* overlay_text = NULL,
                float scale_min = FLT_MAX,
                float scale_max = FLT_MAX,
                ImVec2 graph_size = ImVec2(0,0),
                int stride = sizeof(float)
            )
    """
    if values_count == -1:
        values_count = values.shape[0]

    # Would be nicer as something like
    #   _bytes(overlay_text) if overlay_text is not None else NULL
    # but then Cython complains about either types or pointers to temporary references.
    cdef const char* overlay_text_ptr = NULL
    cdef bytes overlay_text_b
    if overlay_text is not None:
        overlay_text_b = _bytes(overlay_text) # must be assigned to a variable
        overlay_text_ptr = overlay_text_b # auto-convert bytes to char*

    cimgui.PlotLines(
        _bytes(label), &values[0], values_count,
        values_offset,
        overlay_text_ptr,
        scale_min, scale_max,
        _cast_tuple_ImVec2(graph_size),
        stride
    )


def plot_histogram(
        str label not None,
        const float[:] values not None,
        int values_count  = -1,
        int values_offset = 0,
        str overlay_text = None,
        float scale_min = FLT_MAX,
        float scale_max = FLT_MAX,
        graph_size = (0, 0),
        int stride = sizeof(float),
    ):
    """
    Plot a histogram of float values.

    Args:
        label (str): A plot label that will be displayed on the plot's right
            side. If you want the label to be invisible, add :code:`"##"`
            before the label's text: :code:`"my_label" -> "##my_label"`

        values (array of floats): the y-values.
            It must be a type that supports Cython's Memoryviews,
            (See: http://docs.cython.org/en/latest/src/userguide/memoryviews.html)
            for example a numpy array.

        overlay_text (str or None, optional): Overlay text.

        scale_min (float, optional): y-value at the bottom of the plot.
        scale_max (float, optional): y-value at the top of the plot.

        graph_size (tuple of two floats, optional): plot size in pixels.
            **Note:** In ImGui 1.49, (-1,-1) will NOT auto-size the plot.
            To do that, use :func:`get_content_region_available` and pass
            in the right size.

    **Note:** These low-level parameters are exposed if needed for
    performance:

    * **values_offset** (*int*): Index of first element to display
    * **values_count** (*int*): Number of values to display. -1 will use the
        entire array.
    * **stride** (*int*): Number of bytes to move to read next element.

    .. visual-example::
        :auto_layout:
        :width: 400
        :height: 130

        from array import array
        from random import random

        # NOTE: this example will not work under py27 due do incompatible
        # implementation of array and memmory view.
        histogram_values = array('f', [random() for _ in range(20)])

        imgui.begin("Plot example")
        imgui.plot_histogram("histogram(random())", histogram_values)
        imgui.end()

    .. wraps::
            void PlotHistogram(
                const char* label, const float* values, int values_count,
                # note: optional
                int values_offset,
                const char* overlay_text,
                float scale_min,
                float scale_max,
                ImVec2 graph_size,
                int stride
            )
    """
    if values_count == -1:
        values_count = values.shape[0]

    # Would be nicer as something like
    #   _bytes(overlay_text) if overlay_text is not None else NULL
    # but then Cython complains about either types or pointers to temporary references.
    cdef const char* overlay_text_ptr = NULL
    cdef bytes overlay_text_b

    if overlay_text is not None:
        overlay_text_b = _bytes(overlay_text) # must be assigned to a variable
        overlay_text_ptr = overlay_text_b # auto-convert bytes to char*

    cimgui.PlotHistogram(
        _bytes(label), &values[0], values_count,
        values_offset,
        overlay_text_ptr,
        scale_min, scale_max,
        _cast_tuple_ImVec2(graph_size),
        stride
    )


def set_item_default_focus():
    """Make last item the default focused item of a window.
    Please use instead of "if (is_window_appearing()) set_scroll_here()" to signify "default item".

    .. wraps::
        void SetItemDefaultFocus()
    """
    cimgui.SetItemDefaultFocus()


def set_keyboard_focus_here(int offset = 0):
    """Focus keyboard on the next widget.
    Use positive 'offset' to access sub components of a multiple component widget. Use -1 to access previous widget.

    .. wraps::
        void SetKeyboardFocusHere(int offset = 0)
    """
    return cimgui.SetKeyboardFocusHere(offset)


def is_item_hovered(
        cimgui.ImGuiHoveredFlags flags=0
    ):
    """Check if the last item is hovered by mouse.

    Returns:
        bool: True if item is hovered by mouse, otherwise False.

    .. wraps::
        bool IsItemHovered(ImGuiHoveredFlags flags = 0)
    """
    return cimgui.IsItemHovered(flags)


def is_item_focused():
    """Check if the last item is focused

    Returns:
        bool: True if item is focused, otherwise False.

    .. wraps::
        bool IsItemFocused()
    """
    return cimgui.IsItemFocused()


def is_item_active():
    """Was the last item active? For ex. button being held or text field
    being edited. Items that don't interact will always return false.

    Returns:
        bool: True if item is active, otherwise False.

    .. wraps::
        bool IsItemActive()
    """
    return cimgui.IsItemActive()


def is_item_clicked(int mouse_button = 0):
    """Was the last item clicked? For ex. button or node that was
    just being clicked on.

    Returns:
        bool: True if item is clicked, otherwise False.

    .. wraps::
        bool IsItemClicked(int mouse_button = 0)
    """
    return cimgui.IsItemClicked(mouse_button)


def is_item_visible():
    """Was the last item visible? Aka not out of sight due to
    clipping/scrolling.

    Returns:
        bool: True if item is visible, otherwise False.

    .. wraps::
        bool IsItemVisible()
    """
    return cimgui.IsItemVisible()


def is_any_item_hovered():
    """Was any of the items hovered.

    Returns:
        bool: True if any item is hovered, otherwise False.

    .. wraps::
        bool IsAnyItemHovered()
    """
    return cimgui.IsAnyItemHovered()


def is_any_item_active():
    """Was any of the items active.

    Returns:
        bool: True if any item is active, otherwise False.

    .. wraps::
        bool IsAnyItemActive()
    """
    return cimgui.IsAnyItemActive()


def is_any_item_focused():
    """Is any of the items focused.

    Returns:
        bool: True if any item is focused, otherwise False.

    .. wraps::
        bool IsAnyItemFocused()
    """
    return cimgui.IsAnyItemFocused()


def get_item_rect_min():
    """Get bounding rect of the last item in screen space.

    Returns:
        Vec2: item minimum boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetItemRectMin()
    """
    return _cast_ImVec2_tuple(cimgui.GetItemRectMin())


def get_item_rect_max():
    """Get bounding rect of the last item in screen space.

    Returns:
        Vec2: item maximum boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetItemRectMax()
    """
    return _cast_ImVec2_tuple(cimgui.GetItemRectMax())


def get_item_rect_size():
    """Get bounding rect of the last item in screen space.

    Returns:
        Vec2: item boundaries two-tuple ``(width, height)``

    .. wraps::
        ImVec2 GetItemRectSize()
    """
    return _cast_ImVec2_tuple(cimgui.GetItemRectSize())


def set_item_allow_overlap():
    """Allow last item to be overlapped by a subsequent item.
    Sometimes useful with invisible buttons, selectables, etc.
    to catch unused area.

    .. wraps::
        void SetItemAllowOverlap()
    """
    cimgui.SetItemAllowOverlap()


def is_window_hovered(
        cimgui.ImGuiHoveredFlags flags=0
    ):
    """Is current window hovered and hoverable (not blocked by a popup).
    Differentiate child windows from each others.

    Returns:
        bool: True if current window is hovered, otherwise False.

    .. wraps::
        bool IsWindowHovered(ImGuiFocusedFlags flags = 0)
    """
    return cimgui.IsWindowHovered(flags)


def is_window_focused(
        cimgui.ImGuiHoveredFlags flags=0
    ):
    """Is current window focused.

    Returns:
        bool: True if current window is on focus, otherwise False.

    .. wraps::
        bool IsWindowFocused(ImGuiFocusedFlags flags = 0)
    """
    return cimgui.IsWindowFocused(flags)


def is_rect_visible(float size_width, float size_height):
    """Test if a rectangle of the given size, starting from the cursor
    position is visible (not clipped).

    Args:
        size_width (float): width of the rect
        size_height (float): height of the rect

    Returns:
        bool: True if rect is visible, otherwise False.

    .. wraps::
        bool IsRectVisible(const ImVec2& size)
    """
    return cimgui.IsRectVisible(_cast_args_ImVec2(size_width, size_height))


def get_style_color_name(int index):
    """Get the style color name for a given ImGuiCol index.

    .. wraps::
        const char* GetStyleColorName(ImGuiCol idx)
    """
    cdef const char* c_string = cimgui.GetStyleColorName(index)
    cdef bytes py_string = c_string
    return c_string.decode("utf-8")


def get_time():
    """Seconds since program start.

    Returns:
        float: the time (seconds since program start)

    .. wraps::
        float GetTime()
    """
    return cimgui.GetTime()


def is_mouse_hovering_rect(
    float r_min_x, float r_min_y,
    float r_max_x, float r_max_y,
    bool clip=True
):
    """Test if mouse is hovering rectangle with given coordinates.

    Args:
        r_min_x, r_min_y (float): x,y coordinate of the upper-left corner
        r_max_x, r_max_y (float): x,y coordinate of the lower-right corner

    Returns:
        bool: True if mouse is hovering the rectangle.

    .. wraps::
        bool IsMouseHoveringRect(
            const ImVec2& r_min,
            const ImVec2& r_max,
            bool clip = true
        )
    """
    return cimgui.IsMouseHoveringRect(
        _cast_args_ImVec2(r_min_x, r_min_y),
        _cast_args_ImVec2(r_max_x, r_max_y),
        clip
    )


def is_mouse_double_clicked(int button = 0):
    """Return True if mouse was double-clicked.

    **Note:** A double-click returns false in IsMouseClicked().

    Args:
        button (int): mouse button index.

    Returns:
        bool: if mouse is double clicked.

    .. wraps::
         bool IsMouseDoubleClicked(int button);
    """
    return cimgui.IsMouseDoubleClicked(button)


def is_mouse_clicked(int button = 0, bool repeat = False):
    """Returns if the mouse was clicked this frame.

    Args:
        button (int): mouse button index.
        repeat (float):

    Returns:
        bool: if the mouse was clicked this frame.

    .. wraps::
        bool IsMouseClicked(int button, bool repeat = false)
    """
    return cimgui.IsMouseClicked(button, repeat)


def is_mouse_released(int button = 0):
    """Returns if the mouse was released this frame.

    Args:
        button (int): mouse button index.

    Returns:
        bool: if the mouse was released this frame.

    .. wraps::
        bool IsMouseReleased(int button)
    """
    return cimgui.IsMouseReleased(button)


def is_mouse_down(int button = 0):
    """Returns if the mouse is down.

    Args:
        button (int): mouse button index.

    Returns:
        bool: if the mouse is down.

    .. wraps::
        bool IsMouseDown(int button)
    """
    return cimgui.IsMouseDown(button)


def is_mouse_dragging(int button = 0, float lock_threshold = -1.0):
    """Returns if mouse is dragging.

    Args:
        button (int): mouse button index.
        lock_threshold (float): if less than -1.0
            uses io.MouseDraggingThreshold.

    Returns:
        bool: if mouse is dragging.

    .. wraps::
        bool IsMouseDragging(int button = 0, float lock_threshold = -1.0f)
    """
    return cimgui.IsMouseDragging(button, lock_threshold)


def get_mouse_drag_delta(int button=0, float lock_threshold = -1.0):
    """Dragging amount since clicking.

    Args:
        button (int): mouse button index.
        lock_threshold (float): if less than -1.0
            uses io.MouseDraggingThreshold.

    Returns:
        Vec2: mouse position two-tuple ``(x, y)``

    .. wraps::
        ImVec2 GetMouseDragDelta(int button = 0, float lock_threshold = -1.0f)
    """
    return _cast_ImVec2_tuple(
        cimgui.GetMouseDragDelta(button, lock_threshold)
    )


def get_mouse_pos():
    """Current mouse position.

    Returns:
        Vec2: mouse position two-tuple ``(x, y)``

    .. wraps::
        ImVec2 GetMousePos()
    """
    return _cast_ImVec2_tuple(
        cimgui.GetMousePos()
    )

get_mouse_position = get_mouse_pos


def reset_mouse_drag_delta(int button = 0):
    """Reset the mouse dragging delta.

    Args:
        button (int): mouse button index.

    .. wraps::
        void ResetMouseDragDelta(int button = 0)
    """
    cimgui.ResetMouseDragDelta(button)


def get_mouse_cursor():
    """Return the mouse cursor id.

    .. wraps::
        ImGuiMouseCursor GetMouseCursor()
    """
    return cimgui.GetMouseCursor()


def set_mouse_cursor(cimgui.ImGuiMouseCursor mouse_cursor_type):
    """Set the mouse cursor id.

    Args:
        mouse_cursor_type (ImGuiMouseCursor): mouse cursor type.

    .. wraps::
        void SetMouseCursor(ImGuiMouseCursor type)
    """
    return cimgui.SetMouseCursor(mouse_cursor_type)


def set_scroll_here(float center_y_ratio = 0.5):
    """Set scroll here.

    adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.

    Args:
        float center_y_ratio = 0.5f

    .. wraps::
        void SetScrollHere(float center_y_ratio = 0.5f)
    """
    return cimgui.SetScrollHere(center_y_ratio)


def set_scroll_from_pos_y(float pos_y, float center_y_ratio = 0.5):
    """Set scroll from position Y

    adjust scrolling amount to make given position valid. use GetCursorPos() or GetCursorStartPos()+offset to get valid positions.

    Args:
        float pos_y
        float center_y_ratio = 0.5f

    .. wraps::
        void SetScrollFromPosY(float pos_y, float center_y_ratio = 0.5f)
    """
    return cimgui.SetScrollFromPosY(pos_y, center_y_ratio)


def push_font(_Font font):
    """Push font on a stack.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 320

        io = imgui.get_io()

        new_font = io.fonts.add_font_from_file_ttf(
            "DroidSans.ttf", 20,
        )
        impl.refresh_font_texture()

        # later in frame code

        imgui.begin("Default Window")

        imgui.text("Text displayed using default font")

        imgui.push_font(new_font)
        imgui.text("Text displayed using custom font")
        imgui.pop_font()

        imgui.end()

    **Note:** Pushed fonts should be poped with :func:`pop_font()` within the
    same frame. In order to avoid manual push/pop functions you can use the
    :func:`font()` context manager.

    Args:
        font (_Font): font object retrieved from :any:`add_font_from_file_ttf`.

    .. wraps::
        void PushFont(ImFont*)
    """
    cimgui.PushFont(font._ptr)

def pop_font():
    """Pop font on a stack.

    For example usage see :func:`push_font()`.

    Args:
        font (_Font): font object retrieved from :any:`add_font_from_file_ttf`.

    .. wraps::
        void PopFont()
    """
    cimgui.PopFont()

cpdef push_style_var(cimgui.ImGuiStyleVar variable, value):
    """Push style variable on stack.

    This function accepts both float and float two-tuples as ``value``
    argument. ImGui core implementation will verify if passed value has
    type compatibile with given style variable. If not, it will raise
    exception.

    **Note:** variables pushed on stack need to be poped using
    :func:`pop_style_var()` until the end of current frame. This
    implementation guards you from segfaults caused by redundant stack pops
    (raises exception if this happens) but generally it is safer and easier to
    use :func:`styled` or :func:`istyled` context managers.

    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 80

        imgui.begin("Example: style variables")
        imgui.push_style_var(imgui.STYLE_ALPHA, 0.2)
        imgui.text("Alpha text")
        imgui.pop_style_var(1)
        imgui.end()

    Args:
        variable: imgui style variable constant
        value (float or two-tuple): style variable value


    .. wraps::
        PushStyleVar(ImGuiStyleVar idx, float val)
    """
    if not (0 <= variable < enums.ImGuiStyleVar_Count_):
        warnings.warn("Unknown style variable: {}".format(variable))
        return False

    try:
        if isinstance(value, (tuple, list)):
            cimgui.PushStyleVar(variable, _cast_tuple_ImVec2(value))
        else:
            cimgui.PushStyleVar(variable, float(value))
    except ValueError:
        raise ValueError(
            "Style value must be float or two-elements list/tuple"
        )
    else:
        return True


cpdef push_style_color(
    cimgui.ImGuiCol variable,
    float r,
    float g,
    float b,
    float a = 1.
):
    """Push style color on stack.

    **Note:** variables pushed on stack need to be popped using
    :func:`pop_style_color()` until the end of current frame. This
    implementation guards you from segfaults caused by redundant stack pops
    (raises exception if this happens) but generally it is safer and easier to
    use :func:`styled` or :func:`istyled` context managers.

    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 80

        imgui.begin("Example: Color variables")
        imgui.push_style_color(imgui.COLOR_TEXT, 1.0, 0.0, 0.0)
        imgui.text("Colored text")
        imgui.pop_style_color(1)
        imgui.end()

    Args:
        variable: imgui style color constant
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.

    .. wraps::
        PushStyleColor(ImGuiCol idx, const ImVec4& col)
    """
    if not (0 <= variable < enums.ImGuiStyleVar_Count_):
        warnings.warn("Unknown style variable: {}".format(variable))
        return False

    cimgui.PushStyleColor(variable, _cast_args_ImVec4(r, g, b, a))


cpdef pop_style_var(unsigned int count=1):
    """Pop style variables from stack.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :any:`push_style_var()`.

    Args:
        count (int): number of variables to pop from style variable stack.

    .. wraps::
        void PopStyleVar(int count = 1)
    """
    cimgui.PopStyleVar(count)


cpdef get_font_size():
    """get current font size (= height in pixels) of current font with current scale applied

    Returns:
        float: current font size (height in pixels)

    .. wraps::
        float GetFontSize()
    """
    return cimgui.GetFontSize()



# TODO: Can we implement function overloading? Prefer these are all named 'get_color_u32' with different signatures
# https://www.python.org/dev/peps/pep-0443/
# Neither singledispatch nor multipledispatch seems to be available in Cython :-/

cpdef get_color_u32_idx(cimgui.ImGuiCol idx, float alpha_mul = 1.0):
    """ retrieve given style color with style alpha applied and optional extra alpha multiplier

    Returns:
        ImU32: 32-bit RGBA color

    .. wraps::
        ImU32 GetColorU32(ImGuiCol idx, alpha_mul)
    """
    return cimgui.GetColorU32(idx, alpha_mul)


cpdef get_color_u32_rgba(float r, float g, float b, float a):
    """ retrieve given color with style alpha applied

    Returns:
        ImU32: 32-bit RGBA color

    .. wraps::
        ImU32 GetColorU32(const ImVec4& col)
    """
    return cimgui.GetColorU32( _cast_args_ImVec4(r, g, b, a) )


cpdef get_color_u32(cimgui.ImU32 col):
    """retrieve given style color with style alpha applied and optional extra alpha multiplier

    Returns:
        ImU32: 32-bit RGBA color

    .. wraps::
        ImU32 GetColorU32(ImU32 col)
    """
    return cimgui.GetColorU32(col)



cpdef push_item_width(float item_width):
    """Push item width in the stack.

    **Note:** sizing of child region allows for three modes:

    * ``0.0`` - default to ~2/3 of windows width
    * ``>0.0`` - width in pixels
    * ``<0.0`` - align xx pixels to the right of window
      (so -1.0f always align width to the right side)

    **Note:** width pushed on stack need to be poped using
    :func:`pop_item_width()` or it will be applied to all subsequent
    children components.

    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 200

        imgui.begin("Example: item width")

        # custom width
        imgui.push_item_width(imgui.get_window_width() * 0.33)
        imgui.text('Lorem Ipsum ...')
        imgui.slider_float('float slider', 10.2, 0.0, 20.0, '%.2f', 1.0)
        imgui.pop_item_width()

        # default width
        imgui.text('Lorem Ipsum ...')
        imgui.slider_float('float slider', 10.2, 0.0, 20.0, '%.2f', 1.0)

        imgui.end()

    Args:
        item_width (float): width of the component

    .. wraps::
        void PushItemWidth(float item_width)
    """
    cimgui.PushItemWidth(item_width)


cpdef pop_item_width():
    """Reset width back to the default width.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :any:`push_item_width()`.

    .. wraps::
        void PopItemWidth()
    """
    cimgui.PopItemWidth()


cpdef calculate_item_width():
    """Calculate and return the current item width.

    Returns:
        float: calculated item width.

    .. wraps::
        float CalcItemWidth()
    """
    return cimgui.CalcItemWidth()


cpdef push_text_wrap_pos(float wrap_pos_x = 0.0):
    """Word-wrapping function for text*() commands.

    **Note:** wrapping position allows these modes:
    * ``0.0`` - wrap to end of window (or column)
    * ``>0.0`` - wrap at 'wrap_pos_x' position in window local space
    * ``<0.0`` - no wrapping

    Args:
        wrap_pos_x (float): calculated item width.

    .. wraps::
        float PushTextWrapPos(float wrap_pos_x = 0.0f)
    """
    cimgui.PushTextWrapPos(wrap_pos_x)

push_text_wrap_position = push_text_wrap_pos

cpdef pop_text_wrap_pos():
    """Pop the text wrapping position from the stack.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :func:`push_text_wrap_pos()`.

    .. wraps::
        void PopTextWrapPos()
    """
    cimgui.PopTextWrapPos()

pop_text_wrap_position = pop_text_wrap_pos


cpdef pop_style_color(unsigned int count=1):
    """Pop style color from stack.

    **Note:** This implementation guards you from segfaults caused by
    redundant stack pops (raises exception if this happens) but generally
    it is safer and easier to use :func:`styled` or :func:`istyled` context
    managers. See: :any:`push_style_color()`.

    Args:
        count (int): number of variables to pop from style color stack.

    .. wraps::
        void PopStyleColor(int count = 1)
    """
    cimgui.PopStyleColor(count)


def separator():
    """Add vertical line as a separator beween elements.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: separators")

        imgui.text("Some text with bullets")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.separator()

        imgui.text("Another text with bullets")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.end()

    .. wraps::
        void Separator()
    """
    cimgui.Separator()


def same_line(float position=0.0, float spacing=-1.0):
    """Call between widgets or groups to layout them horizontally.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: same line widgets")

        imgui.text("same_line() with defaults:")
        imgui.button("yes"); imgui.same_line()
        imgui.button("no")

        imgui.text("same_line() with fixed position:")
        imgui.button("yes"); imgui.same_line(position=50)
        imgui.button("no")

        imgui.text("same_line() with spacing:")
        imgui.button("yes"); imgui.same_line(spacing=50)
        imgui.button("no")

        imgui.end()

    Args:
        position (float): fixed horizontal position position.
        spacing (float): spacing between elements.

    .. wraps::
        void SameLine(float pos_x = 0.0f, float spacing_w = -1.0f)
    """
    cimgui.SameLine(position, spacing)


def new_line():
    """Undo :any:`same_line()` call.

    .. wraps::
        void NewLine()
    """
    cimgui.NewLine()


def spacing():
    """Add vertical spacing beween elements.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: vertical spacing")

        imgui.text("Some text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.spacing(); imgui.spacing()

        imgui.text("Another text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet A")

        imgui.end()

    .. wraps::
        void Spacing()
    """
    cimgui.Spacing()


def dummy(width, height):
    """Add dummy element of given size.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: dummy elements")

        imgui.text("Some text with bullets:")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet B")

        imgui.dummy(0, 50)
        imgui.bullet_text("Text after dummy")

        imgui.end()

    .. wraps::
        void Dummy(const ImVec2& size)
    """
    cimgui.Dummy(_cast_args_ImVec2(width, height))


def indent(float width=0.0):
    """Move content to right by indent width.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: item indenting")

        imgui.text("Some text with bullets:")

        imgui.bullet_text("Bullet A")
        imgui.indent()
        imgui.bullet_text("Bullet B (first indented)")
        imgui.bullet_text("Bullet C (indent continues)")
        imgui.unindent()
        imgui.bullet_text("Bullet D (indent cleared)")

        imgui.end()

    Args:
        width (float): fixed width of indent. If less or equal 0 it defaults
            to global indent spacing or value set using style value  stack
            (see :any:`push_style_var`).

    .. wraps::
        void Indent(float indent_w = 0.0f)
    """
    cimgui.Indent(width)


def unindent(float width=0.0):
    """Move content to left by indent width.

    .. visual-example::
        :auto_layout:
        :width: 300

        imgui.begin("Example: item unindenting")

        imgui.text("Some text with bullets:")

        imgui.bullet_text("Bullet A")
        imgui.unindent(10)
        imgui.bullet_text("Bullet B (first unindented)")
        imgui.bullet_text("Bullet C (unindent continues)")
        imgui.indent(10)
        imgui.bullet_text("Bullet C (unindent cleared)")

        imgui.end()

    Args:
        width (float): fixed width of indent. If less or equal 0 it defaults
            to global indent spacing or value set using style value stack
            (see :any:`push_style_var`).

    .. wraps::
        void Unindent(float indent_w = 0.0f)
    """
    cimgui.Unindent(width)


def columns(int count=1, str identifier=None, bool border=True):
    """Setup number of columns. Use an identifier to distinguish multiple
    column sets. close with ``columns(1)``.

    .. visual-example::
        :auto_layout:
        :width: 500
        :height: 300

        imgui.begin("Example: Columns - File list")
        imgui.columns(4, 'fileLlist')
        imgui.separator()
        imgui.text("ID")
        imgui.next_column()
        imgui.text("File")
        imgui.next_column()
        imgui.text("Size")
        imgui.next_column()
        imgui.text("Last Modified")
        imgui.next_column()
        imgui.separator()
        imgui.set_column_offset(1, 40)

        imgui.next_column()
        imgui.text('FileA.txt')
        imgui.next_column()
        imgui.text('57 Kb')
        imgui.next_column()
        imgui.text('12th Feb, 2016 12:19:01')
        imgui.next_column()

        imgui.next_column()
        imgui.text('ImageQ.png')
        imgui.next_column()
        imgui.text('349 Kb')
        imgui.next_column()
        imgui.text('1st Mar, 2016 06:38:22')
        imgui.next_column()

        imgui.columns(1)
        imgui.end()

    Args:
        count (int): Columns count.
        identifier (str): Table identifier.
        border (bool): Display border, defaults to ``True``.

    .. wraps::
        void Columns(
            int count = 1,
            const char* id = NULL,
            bool border = true
        )
    """
    if identifier is None:
        cimgui.Columns(count, NULL, border)
    else:
        cimgui.Columns(count, _bytes(identifier), border)


def next_column():
    """Move to the next column drawing.

    For a complete example see :func:`columns()`.

    .. wraps::
        void NextColumn()
    """
    cimgui.NextColumn()


def get_column_index():
    """Returns the current column index.

    For a complete example see :func:`columns()`.

    Returns:
        int: the current column index.

    .. wraps::
        int GetColumnIndex()
    """
    return cimgui.GetColumnIndex()


def get_column_offset(int column_index=-1):
    """Returns position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column, otherwise 0 to
    :func:`get_columns_count()`. Column 0 is usually 0.0f and not resizable
    unless you call this method.

    For a complete example see :func:`columns()`.

    Args:
        column_index (int): index of the column to get the offset for.

    Returns:
        float: the position in pixels from the left side.

    .. wraps::
        float GetColumnOffset(int column_index = -1)
    """
    return cimgui.GetColumnOffset(column_index)


def set_column_offset(int column_index, float offset_x):
    """Set the position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column.

    For a complete example see :func:`columns()`.

    Args:
        column_index (int): index of the column to get the offset for.
        offset_x (float): offset in pixels.

    .. wraps::
        void SetColumnOffset(int column_index, float offset_x)
    """
    cimgui.SetColumnOffset(column_index, offset_x)


def get_column_width(int column_index=-1):
    """Return the column width.

    For a complete example see :func:`columns()`.

    Args:
        column_index (int): index of the column to get the width for.

    .. wraps::
        void GetColumnWidth(int column_index = -1)
    """
    cimgui.GetColumnWidth(column_index)


def set_column_width(int column_index, float width):
    """Set the position of column line (in pixels, from the left side of the
    contents region). Pass -1 to use current column.

    For a complete example see :func:`columns()`.

    Args:
        column_index (int): index of the column to set the width for.
        width (float): width in pixels.

    .. wraps::
        void SetColumnWidth(int column_index, float width)
    """
    cimgui.SetColumnWidth(column_index, width)


def get_columns_count():
    """Get count of the columns in the current table.

    For a complete example see :func:`columns()`.

    Returns:
        int: columns count.

    .. wraps::
        int GetColumnsCount()
    """
    return cimgui.GetColumnsCount()


def begin_group():
    """Start item group and lock its horizontal starting position.

    Captures group bounding box into one "item". Thanks to this you can use
    :any:`is_item_hovered()` or layout primitives such as :any:`same_line()`
    on whole group, etc.

    .. visual-example::
        :auto_layout:
        :width: 500

        imgui.begin("Example: item groups")

        imgui.begin_group()
        imgui.text("First group (buttons):")
        imgui.button("Button A")
        imgui.button("Button B")
        imgui.end_group()

        imgui.same_line(spacing=50)

        imgui.begin_group()
        imgui.text("Second group (text and bullet texts):")
        imgui.bullet_text("Bullet A")
        imgui.bullet_text("Bullet B")
        imgui.end_group()

        imgui.end()

    .. wraps::
        void BeginGroup()
    """
    cimgui.BeginGroup()


def end_group():
    """End group (see: :any:`begin_group`).

    .. wraps::
        void EndGroup()
    """
    cimgui.EndGroup()


def get_cursor_pos():
    """Get the cursor position.

    .. wraps::
        ImVec2 GetCursorPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorPos())


def set_cursor_pos(local_pos):
    """Set the cursor position in local coordinates [0..<window size>] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 SetCursorScreenPos(const ImVec2& screen_pos)
    """
    cimgui.SetCursorPos(_cast_tuple_ImVec2(local_pos))


def get_cursor_start_pos():
    """Get the initial cursor position.

    .. wraps::
        ImVec2 GetCursorStartPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorStartPos())


def get_cursor_screen_pos():
    """Get the cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 GetCursorScreenPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorScreenPos())


def set_cursor_screen_pos(screen_pos):
    """Set the cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 SetCursorScreenPos(const ImVec2& screen_pos)
    """
    cimgui.SetCursorScreenPos(_cast_tuple_ImVec2(screen_pos))


get_cursor_position = get_cursor_pos
set_cursor_position = set_cursor_pos
get_cursor_start_position = get_cursor_start_pos
get_cursor_screen_position = get_cursor_screen_pos
set_cursor_screen_position = set_cursor_screen_pos


def get_text_line_height():
    """Get text line height.

    Returns:
        int: text line height.

    .. wraps::
        void GetTextLineHeight()
    """
    return cimgui.GetTextLineHeight()


def get_text_line_height_with_spacing():
    """Get text line height, with spacing.

    Returns:
        int: text line height, with spacing.

    .. wraps::
        void GetTextLineHeightWithSpacing()
    """
    return cimgui.GetTextLineHeightWithSpacing()


def get_frame_height():
    """~ FontSize + style.FramePadding.y * 2

    .. wraps::
        float GetFrameHeight()
    float GetFrameHeightWithSpacing() except +
    """
    return cimgui.GetFrameHeight()


def get_frame_height_with_spacing():
    """~ FontSize + style.FramePadding.y * 2 + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of framed widgets)

    .. wraps::
        float GetFrameHeightWithSpacing()
    """
    return cimgui.GetFrameHeightWithSpacing()


def create_context(_FontAtlas shared_font_atlas = None):
    """CreateContext

    .. todo::
        Add an example

    .. wraps::
        ImGuiContext* CreateContext(
                # note: optional
                ImFontAtlas* shared_font_atlas = NULL);
        )
    """

    cdef cimgui.ImGuiContext* _ptr

    if (shared_font_atlas):
        _ptr = cimgui.CreateContext(shared_font_atlas._ptr)
    else:
        _ptr = cimgui.CreateContext(NULL)

    return _ImGuiContext.from_ptr(_ptr)


def destroy_context(_ImGuiContext ctx = None):
    """DestroyContext

    .. wraps::
        DestroyContext(
                # note: optional
                ImGuiContext* ctx = NULL);
    """

    if ctx and ctx._ptr != NULL:
        cimgui.DestroyContext(ctx._ptr)
        ctx._ptr = NULL
    else:
        raise RuntimeError("Context invalid (None or destroyed)")


def get_current_context():
    """GetCurrentContext

    .. wraps::
        ImGuiContext* GetCurrentContext();
    """

    cdef cimgui.ImGuiContext* _ptr
    _ptr = cimgui.GetCurrentContext()
    return _ImGuiContext.from_ptr(_ptr)


def set_current_context(_ImGuiContext ctx):
    """SetCurrentContext

    .. wraps::
        SetCurrentContext(
                ImGuiContext *ctx);
    """
    cimgui.SetCurrentContext(ctx._ptr)


# === Python/C++ cross API for error handling ===
from cpython.exc cimport PyErr_NewException

cdef public _ImGuiError "ImGuiError" = PyErr_NewException(
    "imgui.core.ImGuiError", Exception, {}
)

ImGuiError = _ImGuiError # make visible to Python


# === Extra utilities ====

@contextmanager
def _py_font(_Font font):
    """Use specified font in given context.

    .. visual-example::
        :auto_layout:
        :height: 100
        :width: 320

        io = imgui.get_io()

        new_font = io.fonts.add_font_from_file_ttf("DroidSans.ttf", 20)
        impl.refresh_font_texture()

        # later in frame code

        imgui.begin("Default Window")

        imgui.text("Text displayed using default font")
        with imgui.font(new_font):
            imgui.text("Text displayed using custom font")

        imgui.end()

    Args:
        font (_Font): font object retrieved from :any:`add_font_from_file_ttf`.
    """
    push_font(font)
    yield
    pop_font()


@contextmanager
def _py_styled(cimgui.ImGuiStyleVar variable, value):
    # note: we treat bool value as integer to guess if we are required to pop
    #       anything because IMGUI may simply skip pushing
    count = push_style_var(variable, value)
    yield
    pop_style_var(count)


@contextmanager
def _py_istyled(*variables_and_values):
    # todo: rename to nstyled?
    count = 0
    iterator = iter(variables_and_values)

    try:
        # note: this is a trick that allows us convert flat list to pairs
        for var, val in izip_longest(iterator, iterator, fillvalue=None):
            # note: since we group into pairs it is impossible to have
            #       var equal to None
            if val is not None:
                count += push_style_var(var, val)
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


def _py_vertex_buffer_vertex_pos_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).pos

def _py_vertex_buffer_vertex_uv_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).uv

def _py_vertex_buffer_vertex_col_offset():
    return <uintptr_t><size_t>&(<cimgui.ImDrawVert*>NULL).col

def _py_vertex_buffer_vertex_size():
    return sizeof(cimgui.ImDrawVert)

def _py_index_buffer_index_size():
    return sizeof(cimgui.ImDrawIdx)
