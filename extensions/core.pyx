# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp
# distutils: include_dirs = imgui-cpp
import cython
from cython.view cimport array as cvarray

from collections import namedtuple
import warnings
from contextlib import contextmanager
from itertools import izip_longest

from libc.stdint cimport uintptr_t
from libcpp cimport bool

cimport cimgui
cimport enums

Vec2 = namedtuple("Vec2", ['x', 'y'])
Vec4 = namedtuple("Vec4", ['x', 'y', 'z', 'w'])


cdef _cast_ImVec2_tuple(cimgui.ImVec2 vec):  # noqa
    return Vec2(vec.x, vec.y)


cdef cimgui.ImVec2 _cast_tuple_ImVec2(pair) except *:  # noqa
    cdef cimgui.ImVec2 vec

    if len(pair) != 2:
        raise ValueError("pair param must be length of 2")

    vec.x, vec.y = pair

    return vec


cdef cimgui.ImVec4 _cast_tuple_ImVec4(quadruple):  # noqa
    cdef cimgui.ImVec4 vec

    if len(quadruple) != 4:
        raise ValueError("quadruple param must be length of 4")

    vec.x, vec.y, vec.z, vec.w = quadruple

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
        return <uintptr_t>self._ptr.TextureId

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
            # perd: short-wiring instead of using property
            for idx in xrange(self._ptr.CmdBuffer.Size)
        ]


cdef class GuiStyle(object):
    cdef cimgui.ImGuiStyle ref

    @property
    def alpha(self):
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
        self._ptr.ScaleClipRects(_cast_tuple_ImVec2((width, height)))

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
        :return:
        """
        return <uintptr_t>self._ptr.TexID

    @texture_id.setter
    def texture_id(self, int value):
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
    cdef void _io_render_callback(cimgui.ImDrawData* data) except *:
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


def get_draw_data():
    raise NotImplementedError


def new_frame():
    cimgui.NewFrame()


def render():
    cimgui.Render()


def shutdown():
    cimgui.Shutdown()


def show_user_guide():
    cimgui.ShowUserGuide()


def show_style_editor(GuiStyle style=None):
    if style:
        cimgui.ShowStyleEditor(&style.ref)
    else:
        cimgui.ShowStyleEditor()


def show_test_window(closable=False):
    # note: on win initialization seems to be important
    cdef cimgui.bool opened

    if closable:
        # todo: consider using special collapsed state object that will
        # todo: wrap everything here instead of changing return type
        return cimgui.ShowTestWindow(&opened), opened
    else:
        return cimgui.ShowTestWindow()


def show_metrics_window(closable=False):
    # note: on win initialization seems to be important
    cdef cimgui.bool opened

    if closable:
        return cimgui.ShowMetricsWindow(&opened), opened
    else:
        return cimgui.ShowMetricsWindow()


cpdef begin(char* name, closable=False):
    # note: on win initialization seems to be important
    cdef cimgui.bool opened = True

    if closable:
        return cimgui.Begin(name, &opened), opened
    else:
        return cimgui.Begin(name)


def get_draw_data():
    return _DrawData.from_ptr(cimgui.GetDrawData())


def end():
    cimgui.End()


ctypedef fused child_id:
    cython.p_char
    cimgui.ImGuiID


def begin_child(child_id name):
    cimgui.BeginChild(name)


def end_child():
    cimgui.EndChild()


def set_window_font_scale(float scale):
    cimgui.SetWindowFontScale(scale)


def get_windown_position():
    return _cast_ImVec2_tuple(cimgui.GetWindowPos())


def get_window_size():
    return _cast_ImVec2_tuple(cimgui.GetWindowSize())


def get_window_width():
    return cimgui.GetWindowWidth()


def get_window_height():
    return cimgui.GetWindowHeight()


def is_window_collapsed():
    return cimgui.IsWindowCollapsed()


def text(char* text):
    cimgui.Text(text)


def text_colored(char* text, float r, float g, float b, float a=1.):
    cimgui.TextColored(_cast_tuple_ImVec4((r, g, b, a)), text)


cpdef push_style_var(cimgui.ImGuiStyleVar variable, value, force=False):
    # todo: add documentation warning about possibility of segmentation
    # todo: fault if not used with care; recommend context manager
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
    # todo: add documentation warning about possibility of segmentation
    # todo: fault if not used with care; recommend context manager
    cimgui.PopStyleVar(count)


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
STYLE_BUTTON_TEXT_ALIGN = enums.ImGuiStyleVar_ButtonTextAlign # flags ImGuiAlign_*



# === Python/C++ cross API for error handling ===
from cpython.exc cimport PyErr_NewException

cdef public _ImGuiException "ImGuiException" = PyErr_NewException(
    "imgui.core.ImGuiException", Exception, {}
)

ImGuiException = _ImGuiException # make visible to Python
