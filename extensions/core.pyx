# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_demo.cpp
# distutils: include_dirs = imgui-cpp
import cython
from cython.view cimport array as cvarray

from libc.stdint cimport uintptr_t
from libcpp cimport bool

cimport cimgui


cdef _cast_ImVec2_tuple(cimgui.ImVec2 vec):  # noqa
    # todo: consider using namedtuple
    return vec.x, vec.y


cdef cimgui.ImVec2 _cast_tuple_ImVec2(pair):  # noqa
    cdef cimgui.ImVec2 vec

    if len(pair) != 2:
        raise ValueError("pair param must be length of 2")

    vec.x, vec.y = pair

    return vec


cdef _cast_ImVec4_tuple(cimgui.ImVec4 vec):  # noqa
    # todo: consider using namedtuple
    return vec.x, vec.y, vec.w, vec.z


cdef class _DrawCmd(object):
    cdef cimgui.ImDrawCmd* _ptr

    @staticmethod
    cdef from_ptr(cimgui.ImDrawCmd* ptr):
        instance = _DrawCmd()
        instance._ptr = ptr
        return instance

    property texture_id:
        def __get__(self):
            return <uintptr_t>self._ptr.TextureId

    property clip_rect:
        def __get__(self):
            return _cast_ImVec4_tuple(self._ptr.ClipRect)

    property elem_count:
        def __get__(self):
            return self._ptr.ElemCount


cdef class _DrawList(object):
    cdef cimgui.ImDrawList* _ptr

    @staticmethod
    cdef from_ptr(cimgui.ImDrawList* ptr):
        instance = _DrawList()
        instance._ptr = ptr
        return instance

    property cmd_buffer_size:
        def __get__(self):
            return self._ptr.CmdBuffer.Size

    property cmd_buffer_data:
        def __get__(self):
            return <uintptr_t>self._ptr.CmdBuffer.Data

    property vtx_buffer_size:
        def __get__(self):
            return self._ptr.VtxBuffer.Size

    property vtx_buffer_data:
        def __get__(self):
            return <uintptr_t>self._ptr.VtxBuffer.Data

    property idx_buffer_size:
        def __get__(self):
            return self._ptr.IdxBuffer.Size

    property idx_buffer_data:
        def __get__(self):
            return <uintptr_t>self._ptr.IdxBuffer.Data

    property commands:
        def __get__(self):
            return [
                # todo: consider operator overloading in pxd file
                _DrawCmd.from_ptr(&self._ptr.CmdBuffer.Data[idx])
                # perd: short-wiring instead of using property
                for idx in xrange(self._ptr.CmdBuffer.Size)
            ]


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

    property valid:
        def __get__(self):
            self._require_pointer()
            return self._ptr.Valid

    property cmd_count:
        def __get__(self):
            self._require_pointer()
            return self._ptr.CmdListsCount

    property total_vtx_count:
        def __get__(self):
            self._require_pointer()
            return self._ptr.TotalVtxCount

    property total_idx_count:
        def __get__(self):
            self._require_pointer()
            return self._ptr.TotalIdxCount

    property commands_lists:
        def __get__(self):
            return [
                _DrawList.from_ptr(self._ptr.CmdLists[idx])
                # perd: short-wiring instead of using property
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
        return width, height, pixels

    def get_tex_data_as_rgba32(self):
        self._require_pointer()

        cdef int width
        cdef int height
        cdef unsigned char* pixels
        self._ptr.GetTexDataAsRGBA32(&pixels, &width, &height)

        return width, height, bytes(pixels[:width*height*4])


    property tex_id:
        def __get__(self):
            return <uintptr_t>self._ptr.TexID

        def __set__(self, int value):
            self._ptr.TexID = <void *> value


cdef class _IO(object):
    cdef cimgui.ImGuiIO* _io_cref
    cdef object _render_callback
    cdef object _fonts

    def __init__(self):
        self._io_cref = &cimgui.GetIO()
        self._fonts = _FontAtlas.from_ptr(self._io_cref.Fonts)

    property display_size:
        def __get__(self):
            return _cast_ImVec2_tuple(self._io_cref.DisplaySize)

        def __set__(self, value):
            self._io_cref.DisplaySize = _cast_tuple_ImVec2(value)

    property render_callback:
        def __get__(self):
            return self._render_callback

        def __set__(self, object fn):
            self._render_callback = fn
            self._io_cref.RenderDrawListsFn = self._io_render_callback

    property delta_time:
        def __get__(self):
            return self._io_cref.DeltaTime

        def __set__(self, float time):
            self._io_cref.DeltaTime = time

    property fonts:
        def __get__(self):
            return self._fonts

    property display_fb_scale:
        def __get__(self):
            return _cast_ImVec2_tuple(self._io_cref.DisplayFramebufferScale)

        def __set__(self, value):
            self._io_cref.DisplayFramebufferScale = _cast_tuple_ImVec2(value)

    property mouse_pos:
        def __get__(self):
            return _cast_ImVec2_tuple(self._io_cref.MousePos)

        def __set__(self, value):
            self._io_cref.MousePos = _cast_tuple_ImVec2(value)

    property mouse_down:
        def __get__(self):
            cdef cvarray mouse_down = cvarray(
                shape=(5,),
                format='b',
                itemsize=sizeof(bool),
                allocate_buffer=False
            )
            mouse_down.data = <char*>self._io_cref.MouseDown
            return mouse_down

    property mouse_wheel:
        def __get__(self):
            return self._io_cref.MouseWheel

        def __set__(self, float value):
            self._io_cref.MouseWheel = value


    @staticmethod
    cdef void _io_render_callback(cimgui.ImDrawData* data) except *:
        io = get_io()

        if io.render_callback:
            io.render_callback(_DrawData.from_ptr(data))


_io = None
# H section: Main
def get_io():
    #IMGUI_API ImGuiIO&      GetIO();
    global _io

    if not _io:
        # imgui_io = cimgui.GetIO()
        _io = _IO()

    return _io

def get_style():
    #IMGUI_API ImGuiStyle&   GetStyle();
    raise NotImplementedError


def get_draw_data():
    #IMGUI_API ImDrawData*   GetDrawData();
    raise NotImplementedError


def new_frame():
    cimgui.NewFrame()


def render():
    cimgui.Render()


def shutdown():
    cimgui.Shutdown()


def show_user_guide():
    cimgui.ShowUserGuide()


def show_style_editor(style=None):
    # IMGUI_API void          ShowStyleEditor(ImGuiStyle* ref = NULL);
    # // style editor block. you can pass in a reference ImGuiStyle structure
    # to compare to, revert to and save to (else it uses the default style)
    raise NotImplementedError


def show_test_window(open_callback=None):
    # IMGUI_API void          ShowTestWindow(bool* p_open = NULL);
    # // test window demonstrating ImGui features
    cdef cimgui.bool p_open

    cimgui.ShowTestWindow(&p_open)

    if open_callback:
        open_callback(p_open)


def show_metrics_window(open_callback=None):
    # IMGUI_API void          ShowMetricsWindow(bool* p_open = NULL);
    # // metrics window for debugging ImGui
    cdef cimgui.bool p_open

    cimgui.ShowTestWindow(&p_open)

    if open_callback:
        open_callback(p_open)


def begin(char* name, open_callback=None):
    # IMGUI_API bool          Begin(const char* name, bool* p_open = NULL, ImGuiWindowFlags flags = 0);
    cdef cimgui.bool p_open

    non_collapsed = cimgui.Begin(name, &p_open, 0)

    if open_callback:
        open_callback(p_open)

    return non_collapsed


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


def text(char* text):
    cimgui.Text(text)


# additional helpers
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

