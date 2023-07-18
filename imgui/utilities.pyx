
#-------------------------------------------------------------------------
# [SECTION] CALLBACKS
#-------------------------------------------------------------------------

cdef class _callback_user_info(object):
    
    cdef object callback_fn
    cdef user_data

    def __init__(self):
        pass
    
    def __cinit__(self):
        text_input_buffer = NULL
        text_input_buffer_size = 0
    
    def populate(self, callback_fn, user_data):
        if callable(callback_fn):
            self.callback_fn = callback_fn
            self.user_data = user_data
        else:
            raise ValueError("callback_fn is not a callable: %s" % str(callback_fn))
    
    cdef set_text_input_buffer(self, char* text_input_buffer, int text_input_buffer_size):
        self.text_input_buffer = text_input_buffer
        self.text_input_buffer_size = text_input_buffer_size

cdef void _ImGuiSizeCallback(cimgui.ImGuiSizeCallbackData* data):
    cdef _ImGuiSizeCallbackData callback_data = _ImGuiSizeCallbackData.from_ptr(data)
    callback_data._require_pointer()
    (<_callback_user_info>callback_data._ptr.UserData).callback_fn(callback_data)
    return

cdef class _ImGuiSizeCallbackData(object):
    
    cdef cimgui.ImGuiSizeCallbackData* _ptr

    def __init__(self):
        pass

    @staticmethod
    cdef from_ptr(cimgui.ImGuiSizeCallbackData* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiSizeCallbackData()
        instance._ptr = ptr
        return instance

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

        return self._ptr != NULL
        
    @property
    def user_data(self):
        self._require_pointer()
        return (<_callback_user_info>self._ptr.UserData).user_data
    
    @property
    def pos(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.Pos)
        
    @property
    def current_size(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.CurrentSize)
    
    @property
    def desired_size(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.DesiredSize)
    
    @desired_size.setter
    def desired_size(self, tuple size):
        self._require_pointer()
        self._ptr.DesiredSize = _cast_args_ImVec2(size[0], size[1])

#-------------------------------------------------------------------------
# [SECTION] BUFFERS
#-------------------------------------------------------------------------

cdef class _InputTextSharedBuffer(object):

    cdef char* buffer
    cdef int size
    cdef int capacity

    def __cinit__(self):
        self.buffer = NULL
        self.size = 0
        self.capacity = 0
    
    cdef reserve_memory(self, int buffer_size):
        if self.buffer is NULL:
            self.buffer = <char*>malloc(buffer_size*sizeof(char))
            self.size = buffer_size
            self.capacity = buffer_size
        elif buffer_size > self.capacity:
            while self.capacity < buffer_size:
                self.capacity = self.capacity * 2
            self.buffer = <char*>realloc(self.buffer, self.capacity*sizeof(char))
            self.size = buffer_size
        else:
            self.size = buffer_size
    
    cdef free_memory(self):
        if self.buffer != NULL:
            free(self.buffer)
            self.buffer = NULL
            self.size = 0
            self.capacity = 0

    def __dealloc__(self):
        self.free_memory()

cdef _InputTextSharedBuffer _input_text_shared_buffer = _InputTextSharedBuffer() 

#-------------------------------------------------------------------------
# [SECTION] ANSIFEED
#-------------------------------------------------------------------------

def _ansifeed_text_ansi(str text):
    """Add ANSI-escape-formatted text to current widget stack.

    Similar to imgui.text, but with ANSI parsing.
    imgui.text documentation below:

    .. visual-example::
        :title: simple text widget
        :height: 80
        :auto_layout:

        imgui.begin("Example: simple text")
        imgui.extra.text_ansi("Default \033[31m colored \033[m default")
        imgui.end()

    Args:
        text (str): text to display.

    .. wraps::
        Text(const char* fmt, ...)
    """
    # note: "%s" required for safety and to favor of Python string formating
    ansifeed.TextAnsi("%s", _bytes(text))

def _ansifeed_text_ansi_colored(str text, float r, float g, float b, float a=1.):
    """Add pre-colored ANSI-escape-formatted text to current widget stack.

    Similar to imgui.text_colored, but with ANSI parsing.
    imgui.text_colored documentation below:

    It is a shortcut for:

    .. code-block:: python

        imgui.push_style_color(imgui.COLOR_TEXT, r, g, b, a)
        imgui.extra.text_ansi(text)
        imgui.pop_style_color()


    .. visual-example::
        :title: colored text widget
        :height: 100
        :auto_layout:

        imgui.begin("Example: colored text")
        imgui.text_ansi_colored("Default \033[31m colored \033[m default", 1, 0, 0)
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
    ansifeed.TextAnsiColored(_cast_args_ImVec4(r, g, b, a), "%s", _bytes(text))

#-------------------------------------------------------------------------
# [SECTION] ANSIFEED
#-------------------------------------------------------------------------

@contextmanager
@cython.binding(True)
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
@cython.binding(True)
def _py_styled(cimgui.ImGuiStyleVar variable, value):
    # note: we treat bool value as integer to guess if we are required to pop
    #       anything because IMGUI may simply skip pushing
    count = push_style_var(variable, value)
    yield
    pop_style_var(count)

@contextmanager
@cython.binding(True)
def _py_colored(
    cimgui.ImGuiCol variable,
    float r,
    float g,
    float b,
    float a = 1.
):
    # note: we treat bool value as integer to guess if we are required to pop
    #       anything because IMGUI may simply skip pushing
    count = push_style_color(variable, r, g, b, a)
    yield
    pop_style_color(count)

@contextmanager
@cython.binding(True)
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

@contextmanager
@cython.binding(True)
def _py_scoped(str str_id):
    """Use scoped ID within a block of code.

    This context manager can be used to distinguish widgets sharing
    same implicit identifiers without manual calling of :func:`push_id`
    :func:`pop_id` functions.

    Example:

    Args:
        str_id (str): ID to push and pop within marked scope
    """
    push_id(str_id)
    yield
    pop_id()

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