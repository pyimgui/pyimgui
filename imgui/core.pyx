# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp config-cpp/py_imconfig.cpp
# distutils: include_dirs = imgui-cpp
# cython: embedsignature=True
"""

.. todo:: consider inlining every occurence of ``_cast_args_ImVecX`` (profile)

"""

import cython
from cython.view cimport array as cvarray

from collections import namedtuple
import warnings
from contextlib import contextmanager
try:
    from itertools import izip_longest
except ImportError:
    from itertools import zip_longest as izip_longest

from libc.stdint cimport uintptr_t
from libcpp cimport bool

cimport cimgui
cimport enums

from cpython.version cimport PY_MAJOR_VERSION

# todo: find a way to cimport this directly from imgui.h
DEF TARGET_IMGUI_VERSION = (1, 49)

# ==== Condition enum redefines ====
ALWAYS = enums.ImGuiSetCond_Always
ONCE = enums.ImGuiSetCond_Once
FIRST_USE_EVER = enums.ImGuiSetCond_FirstUseEver
APPEARING = enums.ImGuiSetCond_Appearing

# ==== Style var enum redefines ====
STYLE_ALPHA = enums.ImGuiStyleVar_Alpha # float
STYLE_WINDOW_PADDING = enums.ImGuiStyleVar_WindowPadding  # Vec2
STYLE_WINDOW_ROUNDING = enums.ImGuiStyleVar_WindowRounding  # float
STYLE_WINDOW_MIN_SIZE = enums.ImGuiStyleVar_WindowMinSize  # Vec2
STYLE_CHILD_WINDOW_ROUNDING = enums.ImGuiStyleVar_ChildWindowRounding # float
STYLE_FRAME_PADDING = enums.ImGuiStyleVar_FramePadding # Vec2
STYLE_FRAME_ROUNDING = enums.ImGuiStyleVar_FrameRounding # float
STYLE_ITEM_SPACING = enums.ImGuiStyleVar_ItemSpacing # Vec2
STYLE_ITEM_INNER_SPACING = enums.ImGuiStyleVar_ItemInnerSpacing # Vec2
STYLE_INDENT_SPACING = enums.ImGuiStyleVar_IndentSpacing # float
STYLE_GRAB_MIN_SIZE = enums.ImGuiStyleVar_GrabMinSize # float
IF TARGET_IMGUI_VERSION > (1, 49):
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
KEY_DELETE = enums.ImGuiKey_Delete           # for text edit
KEY_BACKSPACE = enums.ImGuiKey_Backspace     # for text edit
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
WINDOW_SHOW_BORDERS = enums.ImGuiWindowFlags_ShowBorders
WINDOW_NO_SAVED_SETTINGS = enums.ImGuiWindowFlags_NoSavedSettings
WINDOW_NO_INPUTS = enums.ImGuiWindowFlags_NoInputs
WINDOW_MENU_BAR = enums.ImGuiWindowFlags_MenuBar
WINDOW_HORIZONTAL_SCROLLING_BAR = enums.ImGuiWindowFlags_HorizontalScrollbar
WINDOW_NO_FOCUS_ON_APPEARING = enums.ImGuiWindowFlags_NoFocusOnAppearing
WINDOW_NO_BRING_TO_FRONT_ON_FOCUS = enums.ImGuiWindowFlags_NoBringToFrontOnFocus
WINDOW_ALWAYS_VERTICAL_SCROLLBAR = enums.ImGuiWindowFlags_AlwaysVerticalScrollbar
WINDOW_ALWAYS_HORIZONTAL_SCROLLBAR = enums.ImGuiWindowFlags_AlwaysHorizontalScrollbar
WINDOW_ALWAYS_USE_WINDOW_PADDING = enums.ImGuiWindowFlags_AlwaysUseWindowPadding

Vec2 = namedtuple("Vec2", ['x', 'y'])
Vec4 = namedtuple("Vec4", ['x', 'y', 'z', 'w'])


cdef bytes _bytes(str text):
    return <bytes>(text if PY_MAJOR_VERSION < 3 else text.encode('utf-8'))


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
    return Vec4(vec.x, vec.y, vec.w, vec.z)


cdef class _DrawCmd(object):
    cdef cimgui.ImDrawCmd* _ptr

    # todo: consider using fast instantiation here
    #       see: http://cython.readthedocs.io/en/latest/src/userguide/extension_types.html#fast-instantiation
    @staticmethod
    cdef from_ptr(cimgui.ImDrawCmd* ptr):
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
    cdef cimgui.ImGuiStyle ref

    @property
    def alpha(self):
        """Global alpha blending parameter for windows

        Returns:
            float
        """
        return self.ref.Alpha

    @alpha.setter
    def alpha(self, float value):
        self.ref.Alpha = value

    @property
    def window_padding(self):
        return _cast_ImVec2_tuple(self.ref.WindowPadding)

    @window_padding.setter
    def window_padding(self, value):
        self.ref.WindowPadding = _cast_tuple_ImVec2(value)

    @property
    def window_min_size(self):
        return _cast_ImVec2_tuple(self.ref.WindowMinSize)

    @window_min_size.setter
    def window_min_size(self, value):
        self.ref.WindowMinSize = _cast_tuple_ImVec2(value)

    @property
    def window_rounding(self):
        return self.ref.WindowRounding

    @window_rounding.setter
    def window_rounding(self, float value):
        self.ref.WindowRounding = value

    IF TARGET_IMGUI_VERSION > (1, 49):
        # note: not available as Vec2 in 1.49
        # todo: add support for old input type
        @property
        def window_title_align(self):
            return _cast_ImVec2_tuple(self.ref.WindowTitleAlign)

        @window_title_align.setter
        def window_title_align(self, value):
            self.ref.WindowTitleAlign = _cast_tuple_ImVec2(value)

    @property
    def child_window_rounding(self):
        return self.ref.ChildWindowRounding

    @child_window_rounding.setter
    def child_window_rounding(self, float value):
        self.ref.ChildWindowRounding = value

    @property
    def frame_padding(self):
        return _cast_ImVec2_tuple(self.ref.FramePadding)

    @frame_padding.setter
    def frame_padding(self, value):
        self.ref.FramePadding = _cast_tuple_ImVec2(value)

    @property
    def frame_rounding(self):
        return self.ref.FrameRounding

    @frame_rounding.setter
    def frame_rounding(self, float value):
        self.ref.FrameRounding = value

    @property
    def item_spacing(self):
        return _cast_ImVec2_tuple(self.ref.ItemSpacing)

    @item_spacing.setter
    def item_spacing(self, value):
        self.ref.ItemSpacing = _cast_tuple_ImVec2(value)

    @property
    def item_inner_spacing(self):
        return _cast_ImVec2_tuple(self.ref.ItemInnerSpacing)

    @item_inner_spacing.setter
    def item_inner_spacing(self, value):
        self.ref.ItemInnerSpacing = _cast_tuple_ImVec2(value)

    @property
    def touch_extra_padding(self):
        return _cast_ImVec2_tuple(self.ref.TouchExtraPadding)

    @touch_extra_padding.setter
    def touch_extra_padding(self, value):
        self.ref.TouchExtraPadding = _cast_tuple_ImVec2(value)

    @property
    def indent_spacing(self):
        return self.ref.IndentSpacing

    @indent_spacing.setter
    def indent_spacing(self, float value):
        self.ref.IndentSpacing = value

    @property
    def columns_min_spacing(self):
        return self.ref.ColumnsMinSpacing

    @columns_min_spacing.setter
    def columns_min_spacing(self, float value):
        self.ref.ColumnsMinSpacing = value

    @property
    def scrollbar_size(self):
        return self.ref.ScrollbarSize

    @scrollbar_size.setter
    def scrollbar_size(self, float value):
        self.ref.ScrollbarSize = value

    @property
    def scrollbar_rounding(self):
        return self.ref.ScrollbarRounding

    @scrollbar_rounding.setter
    def scrollbar_rounding(self, float value):
        self.ref.ScrollbarRounding = value

    @property
    def grab_min_size(self):
        return self.ref.GrabMinSize

    @grab_min_size.setter
    def grab_min_size(self, float value):
        self.ref.GrabMinSize = value

    @property
    def grab_rounding(self):
        return self.ref.GrabRounding

    @grab_rounding.setter
    def grab_rounding(self, float value):
        self.ref.GrabRounding = value

    IF TARGET_IMGUI_VERSION > (1, 49):
        # note: not available as Vec2 in 1.49
        # todo: add support for old input type
        @property
        def button_text_align(self):
            return _cast_ImVec2_tuple(self.ref.ButtonTextAlign)

        @button_text_align.setter
        def button_text_align(self, value):
            self.ref.ButtonTextAlign = _cast_tuple_ImVec2(value)

    @property
    def display_window_padding(self):
        return _cast_ImVec2_tuple(self.ref.DisplayWindowPadding)

    @display_window_padding.setter
    def display_window_padding(self, value):
        self.ref.DisplayWindowPadding = _cast_tuple_ImVec2(value)

    @property
    def display_safe_area_padding(self):
        return _cast_ImVec2_tuple(self.ref.DisplaySafeAreaPadding)

    @display_safe_area_padding.setter
    def display_safe_area_padding(self, value):
        self.ref.DisplaySafeAreaPadding = _cast_tuple_ImVec2(value)

    @property
    def anti_aliased_lines(self):
        return self.ref.AntiAliasedLines

    @anti_aliased_lines.setter
    def anti_aliased_lines(self, cimgui.bool value):
        self.ref.AntiAliasedLines = value

    @property
    def anti_aliased_shapes(self):
        return self.ref.AntiAliasedShapes

    @anti_aliased_shapes.setter
    def anti_aliased_shapes(self, cimgui.bool value):
        self.ref.AntiAliasedShapes = value

    @property
    def curve_tessellation_tolerance(self):
        return self.ref.CurveTessellationTol

    @curve_tessellation_tolerance.setter
    def curve_tessellation_tolerance(self, float value):
        self.ref.CurveTessellationTol = value


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


cdef class _FontAtlas(object):
    cdef cimgui.ImFontAtlas* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImFontAtlas* ptr):
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

        self._ptr.AddFontDefault()

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
    cdef cimgui.ImGuiIO* _ptr
    cdef object _render_callback
    cdef object _fonts

    def __init__(self):
        self._ptr = &cimgui.GetIO()
        self._fonts = _FontAtlas.from_ptr(self._ptr.Fonts)
        self._render_callback = None

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
    def render_callback(self):
        return self._render_callback

    @render_callback.setter
    def render_callback(self, object fn):
        self._render_callback = fn
        self._ptr.RenderDrawListsFn = self._io_render_callback

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
    def framerate(self):
        return self._ptr.Framerate

    @property
    def metrics_allocs(self):
        return self._ptr.MetricsAllocs

    @property
    def metrics_render_vertices(self):
        return self._ptr.MetricsRenderVertices

    @property
    def metrics_active_windows(self):
        return self._ptr.MetricsActiveWindows

    @staticmethod
    cdef void _io_render_callback(cimgui.ImDrawData* data) except +:
        io = get_io()

        if io.render_callback:
            io.render_callback(_DrawData.from_ptr(data))


_io = None
def get_io():
    global _io

    if not _io:
        _io = _IO()

    return _io

def get_style():
    raise NotImplementedError


def new_frame():
    """Start a new frame.

    After calling this you can submit any command from this point until
    next :any:`new_frame()` or :any:`render()`.

    .. wraps::
        void NewFrame()
    """
    cimgui.NewFrame()


def render():
    """Finalize frame, set rendering data, and run render callback (if set).

    .. wraps::
        void Render()
    """
    cimgui.Render()


def shutdown():
    """Shutdown ImGui context.

    .. wraps::
        Shutdown
    """
    cimgui.Shutdown()


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
        cimgui.ShowStyleEditor(&style.ref)
    else:
        cimgui.ShowStyleEditor()


def show_test_window(closable=False):
    """Show ImGui test window.

    .. visual-example::
        :width: 700
        :height: 600
        :auto_layout:

        imgui.show_test_window()

    Args:
        closable (bool): define if window is closable.

    Returns:
        bool: True if window is not closed (False trigerred by close button).

    .. wraps::
        void ShowTestWindow(bool* p_open = NULL)
    """
    cdef cimgui.bool opened = True

    if closable:
        cimgui.ShowTestWindow(&opened)
    else:
        cimgui.ShowTestWindow()

    return opened


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


def begin(str name, closable=False, cimgui.ImGuiWindowFlags flags=0):
    """Begin a window.

    .. visual-example::
        :auto_layout:

        imgui.begin("Example: empty window")
        imgui.end()

    Args:
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

    return cimgui.Begin(_bytes(name), &opened if closable else NULL, flags), opened


def get_draw_data():
    """Get draw data.

    Draw data value is same as passed to your ``io.render_callback()``
    function. It is valid after :any:`render()` and until the next call
    to :any:`new_frame()`

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
    cython.p_char
    cimgui.ImGuiID


def begin_child(
    child_id name, float width=0, float height=0, bool border=False,
    cimgui.ImGuiWindowFlags flags=0
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
        name (str or int): Child region identifier.
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
            ImGuiWindowFlags extra_flags = 0
        )

        bool BeginChild(
            ImGuiID id,
            const ImVec2& size = ImVec2(0,0),
            bool border = false,
            ImGuiWindowFlags extra_flags = 0
        )
    """
    # note: we do not take advantage of C++ function overloading
    #       in order to take adventage of Python keyword arguments
    return cimgui.BeginChild(
        name, _cast_args_ImVec2(width, height), border, flags
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
    cimgui.bool collapsed, cimgui.ImGuiSetCond condition=ALWAYS
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
             bool collapsed, ImGuiSetCond cond = 0
         )

    """
    cimgui.SetNextWindowCollapsed(collapsed, condition)


def set_next_window_focus():
    """Set next window to be focused (most front).

    .. wraps::
        void SetNextWindowFocus()
    """
    cimgui.SetNextWindowFocus()


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
    float x, float y, cimgui.ImGuiSetCond condition=ALWAYS
):
    """Set next window position.

    Call before :func:`begin()`.

    Args:
        x (float): x window coordinate
        y (float): y window coordinate
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: window positioning
        :height: 50

        imgui.set_next_window_size(20, 20)

        for index in range(5):
            imgui.set_next_window_position(index * 40, 5)
            imgui.begin(str(index))
            imgui.end()

    .. wraps::
        void SetNextWindowPos(const ImVec2& pos, ImGuiSetCond cond = 0)

    """
    cimgui.SetNextWindowPos(_cast_args_ImVec2(x, y), condition)


def set_next_window_centered(cimgui.ImGuiSetCond condition=ALWAYS):
    """Set next window position to be centered on screen.

    Call before :func:`begin()`.

    Args:
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: window centering
        :height: 100
        :width: 600

        imgui.set_next_window_size(200, 50)
        imgui.set_next_window_centered()
        imgui.begin("Example: centered")
        imgui.end()


    .. wraps::
        void SetNextWindowPosCenter(ImGuiSetCond cond = 0)
    """
    cimgui.SetNextWindowPosCenter(condition)


def set_next_window_size(
    float width, float height, cimgui.ImGuiSetCond condition=ALWAYS
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

        imgui.set_next_window_centered()
        imgui.set_next_window_size(80, 180)
        imgui.begin("High")
        imgui.end()


    .. wraps::
        void SetNextWindowSize(
            const ImVec2& size, ImGuiSetCond cond = 0
        )
    """
    cimgui.SetNextWindowSize(_cast_args_ImVec2(width, height), condition)


def is_window_collapsed():
    """Check if current window is collapsed.

    Returns:
        bool: True if window is collapsed
    """
    return cimgui.IsWindowCollapsed()


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
        :width: 100
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
    str name, str shortcut=None, cimgui.bool selected=None, enabled=True
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
        tuple: a ``(clicked, state)`` two-tuple idicating if item was
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
            _bytes(name),
            NULL,
            &inout_selected,
            <bool>enabled
        )
    else:
        clicked = cimgui.MenuItem(
            _bytes(name),
            _bytes(shortcut),
            &inout_selected,
            <bool>enabled
        )
    return clicked, inout_selected


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


def invisible_button(char* identifier, width, height):
    """Create invisible button.

    .. visual-example::
        :auto_layout:
        :height: 100
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
    return cimgui.InvisibleButton(identifier, _cast_args_ImVec2(width, height))


def color_button(
        float r, float g, float b, a=1.,
        cimgui.bool small_height=False,
        cimgui.bool outline_border=True,
):
    """Display colored button.

    .. visual-example::
        :auto_layout:
        :height: 150

        imgui.begin("Example: color button")
        imgui.color_button(1, 0, 0, 1, True, True)
        imgui.color_button(0, 1, 0, 1, True, False)
        imgui.color_button(0, 0, 1, 1, False, True)
        imgui.color_button(1, 0, 1, 1, False, False)
        imgui.end()

    Args:
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.
        small_height (bool): Small height. Default to False
        outline_border (bool): Diplay outline border. Defaults to True.

    Returns:
        bool: True if button is clicked.

    .. wraps::
        bool ColorButton(
            const ImVec4& col,
            bool small_height = false,
            bool outline_border = true
        )
    """
    return cimgui.ColorButton(
        _cast_args_ImVec4(r, g, b, a), small_height, outline_border
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

        imgui.begin("Example: checkboxes")

        c1_output = imgui.checkbox("Checkbox 1", True)
        c2_output = imgui.checkbox("Checkbox 2", False)

        imgui.text("Checkbox 1 return value: {}".format(c1_output))
        imgui.text("Checkbox 2 return value: {}".format(c2_output))

        imgui.end()

    Args:
        label (str): text label for checkbox widget.
        state (bool): current (desired) state of the checkbox. If it has to
            change, the new state will be returned as a second item of
            the return value.

    Returns:
        tuple: a ``(clicked, state)`` two-tuple idicating click event and the
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
        tuple: a ``(clicked, flags)`` two-tuple idicating click event and the
        current state of the flags controlled with this checkbox.

    .. wraps::
        bool CheckboxFlags(
            const char* label, unsigned int* flags,
            unsigned int flags_value
        )
    """
    cdef unsigned int inout_flags = flags

    return cimgui.CheckboxFlags(_bytes(label), &inout_flags, flags_value), inout_flags


def radio_button(char* label, cimgui.bool active):
    """Display radio button widget

    .. visual-example::
        :auto_layout:
        :height: 100

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
    return cimgui.RadioButton(label, active)


def combo(str label, int current, list items, int height_in_items=-1):
    """Display combo widget.

    .. visual-example::
        :auto_layout:
        :height: 100

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

    in_items = "\0".join(items)

    return cimgui.Combo(
        _bytes(label), &inout_current, in_items, height_in_items
    ), inout_current


def color_edit3(char* label, float r, float g, float b):
    """Display color edit widget for color without alpha value.

    .. visual-example::
        :auto_layout:
        :width: 300

        color_1 = 1., .0, .5
        color_2 = 0., .8, .3

        imgui.begin("Example: color edit without alpha")

        changed, color_1 = imgui.color_edit3("Color 1", *color_1)
        changed, color_2 = imgui.color_edit3("Color 2", *color_2)

        imgui.end()

    Args:
        label (str): color edit label.
        r (float): red color intensity.
        g (float): green color intensity.
        b (float): blue color instensity.
        a (float): alpha intensity.

    Returns:
        tuple: a ``(changed, color)`` tuple that contains indicator of color
        change and current value of color

    .. wraps::
        bool ColorEdit3(const char* label, float col[3])
    """

    cdef float[3] inout_color = [r, g, b]

    return cimgui.ColorEdit3(
        label, <float *>(&inout_color)
    ), (inout_color[0], inout_color[1], inout_color[2])


def color_edit4(
    char* label, float r, float g, float b, float a, cimgui.bool show_alpha=True
):
    """Display color edit widget for color with alpha value.

    .. visual-example::
        :auto_layout:
        :width: 400

        color = 1., .0, .5, 1.

        imgui.begin("Example: color edit with alpha")

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
        tuple: a ``(changed, color)`` tuple that contains indicator of color
        change and current value of color

    .. wraps::
        ColorEdit4(
            const char* label, float col[4], bool show_alpha = true
        )
    """
    cdef float[4] inout_color = [r, g, b, a]

    return cimgui.ColorEdit4(
        label, <float *>(&inout_color), show_alpha
    ), (inout_color[0], inout_color[1], inout_color[2], inout_color[3])


def drag_float(
    char* label, float value,
    float change_speed = 1.0,
    float max_value=0.0,
    float min_value=0.0,
    str display_format = "%.3f",
    float power = 1.
):
    """Display float drag widget.

    .. todo::
        Consider replacing ``display_format`` with something that allows
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
            "Less precise", value, display_format="%.1f"
        )
        imgui.text("Changed: %s, Value: %s" % (changed, value))
        imgui.end()

    Args:
        label (str): widget label.
        value (float): drag values,
        change_speed (float): how fast values change on drag.
        max_value (float): max value allowed by widget.
        min_value (float): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float inout_value = value

    return cimgui.DragFloat(
        label, &inout_value,
        change_speed, max_value, min_value, display_format, power
    ), inout_value


def drag_float2(
    char* label, float value0, float value1,
    float change_speed = 1.0,
    float max_value=0.0,
    float min_value=0.0,
    str display_format = "%.3f",
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
            "Less precise", *values, display_format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1 (float): drag values.
        change_speed (float): how fast values change on drag.
        max_value (float): max value allowed by widget.
        min_value (float): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[2] inout_values = [value0, value1]
    return cimgui.DragFloat2(
        label, <float*>&inout_values,
        change_speed, max_value, min_value, display_format, power
    ), (inout_values[0], inout_values[1])


def drag_float3(
    char* label, float value0, float value1, float value2,
    float change_speed = 1.0,
    float max_value=0.0,
    float min_value=0.0,
    str display_format = "%.3f",
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
            "Less precise", *values, display_format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2 (float): drag values.
        change_speed (float): how fast values change on drag.
        max_value (float): max value allowed by widget.
        min_value (float): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[3] inout_values = [value0, value1, value2]
    return cimgui.DragFloat3(
        label, <float*>&inout_values,
        change_speed, max_value, min_value, display_format, power
    ), (inout_values[0], inout_values[1], inout_values[2])


def drag_float4(
    char* label, float value0, float value1, float value2, float value3,
    float change_speed = 1.0,
    float max_value=0.0,
    float min_value=0.0,
    str display_format = "%.3f",
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
            "Less precise", *values, display_format="%.1f"
        )
        imgui.text("Changed: %s, Values: %s" % (changed, values))
        imgui.end()

    Args:
        label (str): widget label.
        value0, value1, value2, value3 (float): drag values.
        change_speed (float): how fast values change on drag.
        max_value (float): max value allowed by widget.
        min_value (float): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.3f",
            float power = 1.0f
        )
    """
    cdef float[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragFloat4(
        label, <float*>&inout_values,
        change_speed, max_value, min_value, display_format, power
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def drag_int(
    char* label, int value,
    float change_speed = 1.0,
    int max_value=0,
    int min_value=0,
    str display_format = "%.f"
):
    """Display int drag widget.

    .. todo::
        Consider replacing ``display_format`` with something that allows
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
        max_value (int): max value allowed by widget.
        min_value (int): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.f",
        )
    """
    cdef int inout_value = value

    return cimgui.DragInt(
        label, &inout_value,
        change_speed, max_value, min_value, display_format
    ), inout_value


def drag_int2(
    char* label, int value0, int value1,
    float change_speed = 1.0,
    int max_value=0,
    int min_value=0,
    str display_format = "%.f"
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
        max_value (int): max value allowed by widget.
        min_value (int): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.f",
        )
    """
    cdef int[2] inout_values = [value0, value1]
    return cimgui.DragInt2(
        label, <int*>&inout_values,
        change_speed, max_value, min_value, display_format,
    ), (inout_values[0], inout_values[1])


def drag_int3(
    char* label, int value0, int value1, int value2,
    float change_speed = 1.0,
    int max_value=0,
    int min_value=0,
    str display_format = "%.f"
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
        max_value (int): max value allowed by widget.
        min_value (int): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.f",
        )
    """
    cdef int[3] inout_values = [value0, value1, value2]
    return cimgui.DragInt3(
        label, <int*>&inout_values,
        change_speed, max_value, min_value, display_format,
    ), (inout_values[0], inout_values[1], inout_values[2])


def drag_int4(
    char* label, int value0, int value1, int value2, int value3,
    float change_speed = 1.0,
    int max_value=0,
    int min_value=0,
    str display_format = "%.f"
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
        max_value (int): max value allowed by widget.
        min_value (int): min value allowed by widget.
        display_format (str): display format string as C-style ``printf``
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
            const char* display_format = "%.f",
        )
    """
    cdef int[4] inout_values = [value0, value1, value2, value3]
    return cimgui.DragInt4(
        label, <int*>&inout_values,
        change_speed, max_value, min_value, display_format,
    ), (inout_values[0], inout_values[1], inout_values[2], inout_values[3])


def is_item_hovered():
    """Check if the last item is hovered by mouse.

    Returns:
        bool: True if item is hovered by mouse, otherwise False.

    .. wraps::
        bool IsItemHovered()
    """
    return cimgui.IsItemHovered()


def is_item_hovered_rect():
    """Was the last item hovered by mouse? Even if
    another item is active or window is blocked by popup
    while we are hovering this.

    Returns:
        bool: True if item is hovered by mouse, otherwise False.

    .. wraps::
        bool IsItemHoveredRect()
    """
    return cimgui.IsItemHoveredRect()


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


def is_window_hovered():
    """Is current window hovered and hoverable (not blocked by a popup).
    Differentiate child windows from each others.

    Returns:
        bool: True if current window is hovered, otherwise False.

    .. wraps::
        bool IsWindowHovered()
    """
    return cimgui.IsWindowHovered()


def is_window_focused():
    """Is current window focused.

    Returns:
        bool: True if current window is on focus, otherwise False.

    .. wraps::
        bool IsWindowFocused()
    """
    return cimgui.IsWindowFocused()


def is_root_window_focused():
    """Is root window focused.

    Returns:
        bool: True if root window is on focus, otherwise False.

    .. wraps::
        bool IsRootWindowFocused()
    """
    return cimgui.IsRootWindowFocused()


def is_root_window_or_any_child_focused():
    """Is the current root window or any of its children on focus.

    Returns:
        bool: True if any of the windows is on focus, otherwise False.

    .. wraps::
        bool IsRootWindowOrAnyChildFocused()
    """
    return cimgui.IsRootWindowOrAnyChildFocused()


def is_root_window_or_any_child_hovered():
    """Is the current root window or any of its children
    hovered with the mouse.

    Returns:
        bool: True if any of the windows is hovered, otherwise False.

    .. wraps::
        bool IsRootWindowOrAnyChildHovered()
    """
    return cimgui.IsRootWindowOrAnyChildHovered()


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


def is_pos_hovering_any_window(float position_x, float position_y):
    """Test if position is hovering any active ImGui window.

    Args:
        position_x (float): width of the rect
        position_y (float): height of the rect

    Returns:
        bool: True if rect is visible, otherwise False.

    .. wraps::
        bool IsPosHoveringAnyWindow(const ImVec2& size)
    """
    return cimgui.IsPosHoveringAnyWindow(
        _cast_args_ImVec2(position_x, position_y)
    )


def is_mouse_hovering_any_window():
    """Test if mouse is hovering any visible window.

    Returns:
        bool: True if any item is hovered, otherwise False.

    .. wraps::
        bool IsMouseHoveringAnyWindow()
    """
    return cimgui.IsMouseHoveringAnyWindow()


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
        :title: style variables
        :auto_window:
        :width: 200
        :height: 80

        imgui.push_style_var(imgui.STYLE_ALPHA, 0.2)
        imgui.text("Alpha text")
        imgui.pop_style_var(1)

    Args:
        variable: imgui style variable constant
        value (float or two-tuple): style variable value


    .. wraps::
        PushStyleVar(ImGuiStyleVar idx, float val)
    """
    IF TARGET_IMGUI_VERSION > (1, 49):
        # note: this check is not available on imgui<=1.49
        if  not  (0 <= variable < enums.ImGuiStyleVar_Count_):
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


def end_group():
    """End group (see: :any:`begin_group`).

    .. wraps::
        void EndGroup()
    """
    cimgui.EndGroup()

# additional helpers
# todo: move to separate extension module (extra?)

@contextmanager
def styled(cimgui.ImGuiStyleVar variable, value):
    # note: we treat bool value as integer to guess if we are required to pop
    #       anything because IMGUI may simply skip pushing
    count = push_style_var(variable, value)
    yield
    pop_style_var(count)


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


# === Python/C++ cross API for error handling ===
from cpython.exc cimport PyErr_NewException

cdef public _ImGuiError "ImGuiError" = PyErr_NewException(
    "imgui.core.ImGuiError", Exception, {}
)

ImGuiError = _ImGuiError # make visible to Python
