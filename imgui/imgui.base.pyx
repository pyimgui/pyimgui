#-----------------------------------------------------------------------------
# DOCUMENTATION
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] INCLUDES
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-------------------------------------------------------------------------
# [SECTION] FORWARD DECLARATIONS
#-------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] CONTEXT AND MEMORY ALLOCATORS
#-----------------------------------------------------------------------------

_contexts = {}
cdef class _ImGuiContext(object):
    cdef cimgui.ImGuiContext* _ptr

    # For objects that cimgui stores as void* (such as texture_id) but need to be kept alive for rendering.
    # The cache is cleared on new_frame().
    _keepalive_cache = []

    @staticmethod
    cdef from_ptr(cimgui.ImGuiContext* ptr):
        if ptr == NULL:
            return None

        if (<uintptr_t>ptr) not in _contexts:
            instance = _ImGuiContext()
            instance._ptr = ptr
            _contexts[<uintptr_t>ptr] = instance

        return _contexts[<uintptr_t>ptr]

    def __eq__(_ImGuiContext self, _ImGuiContext other):
        return other._ptr == self._ptr

#-----------------------------------------------------------------------------
# [SECTION] USER FACING STRUCTURES (ImGuiStyle, ImGuiIO)
#-----------------------------------------------------------------------------

cdef class _Colors(object):
    cdef GuiStyle _style

    def __cinit__(self):
        self._style = None

    def __init__(self, GuiStyle gui_style):
        self._style = gui_style

    cdef inline _check_color(self, cimgui.ImGuiCol variable):
        if not (0 <= variable < enums.ImGuiCol_COUNT):
            raise ValueError("Unknown style variable: {}".format(variable))

    def __getitem__(self, cimgui.ImGuiCol variable):
        self._check_color(variable)
        self._style._check_ptr()
        cdef int ix = variable
        return _cast_ImVec4_tuple(self._style._ptr.Colors[ix])

    def __setitem__(self, cimgui.ImGuiCol variable, value):
        self._check_color(variable)
        self._style._check_ptr()
        cdef int ix = variable
        self._style._ptr.Colors[ix] = _cast_tuple_ImVec4(value)

cdef class GuiStyle(object):
    """
    Container for ImGui style information

    """
    cdef cimgui.ImGuiStyle* _ptr
    cdef bool _owner
    cdef _Colors _colors

    def __cinit__(self):
        self._ptr = NULL
        self._owner = False
        self._colors = None

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
        instance._colors = _Colors(instance)
        return instance

    @staticmethod
    cdef GuiStyle _create():
        cdef cimgui.ImGuiStyle* _ptr = new cimgui.ImGuiStyle()
        cdef GuiStyle instance = GuiStyle.from_ref(deref(_ptr))
        instance._owner = True
        instance._colors = _Colors(instance)
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
    def window_menu_button_position(self):
        self._check_ptr()
        return self._ptr.WindowMenuButtonPosition

    @window_menu_button_position.setter
    def window_menu_button_position(self, cimgui.ImGuiDir value):
        self._check_ptr()
        self._ptr.WindowMenuButtonPosition = value

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
    def cell_padding(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.CellPadding)
    
    @cell_padding.setter
    def cell_padding(self, value):
        self._check_ptr()
        self._ptr.CellPadding = _cast_tuple_ImVec2(value)

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
    def log_slider_deadzone(self):
        self._check_ptr()
        return self._ptr.LogSliderDeadzone

    @log_slider_deadzone.setter
    def log_slider_deadzone(self, float value):
        self._check_ptr()
        self._ptr.LogSliderDeadzone = value
    
    @property
    def tab_rounding(self):
        self._check_ptr()
        return self._ptr.TabRounding

    @tab_rounding.setter
    def tab_rounding(self, float value):
        self._check_ptr()
        self._ptr.TabRounding = value
    
    @property
    def tab_border_size(self):
        self._check_ptr()
        return self._ptr.TabBorderSize

    @tab_border_size.setter
    def tab_border_size(self, float value):
        self._check_ptr()
        self._ptr.TabBorderSize= value
    
    @property
    def tab_min_width_for_close_button(self):
        self._check_ptr()
        return self._ptr.TabMinWidthForCloseButton

    @tab_min_width_for_close_button.setter
    def tab_min_width_for_close_button(self, float value):
        self._check_ptr()
        self._ptr.TabMinWidthForCloseButton = value
        
    @property
    def color_button_position(self):
        self._check_ptr()
        return self._ptr.ColorButtonPosition

    @color_button_position.setter
    def color_button_position(self, cimgui.ImGuiDir value):
        self._check_ptr()
        self._ptr.ColorButtonPosition = value

    @property
    def button_text_align(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.ButtonTextAlign)

    @button_text_align.setter
    def button_text_align(self, value):
        self._check_ptr()
        self._ptr.ButtonTextAlign = _cast_tuple_ImVec2(value)
    
    @property
    def selectable_text_align(self):
        self._check_ptr()
        return _cast_ImVec2_tuple(self._ptr.SelectableTextAlign)

    @selectable_text_align.setter
    def selectable_text_align(self, value):
        self._check_ptr()
        self._ptr.SelectableTextAlign = _cast_tuple_ImVec2(value)

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
    def anti_aliased_line_use_tex(self):
        self._check_ptr()
        return self._ptr.AntiAliasedLinesUseTex

    @anti_aliased_line_use_tex.setter
    def anti_aliased_line_use_tex(self, cimgui.bool value):
        self._check_ptr()
        self._ptr.AntiAliasedLinesUseTex = value

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
    
    # OBSOLETED in 1.82 (from Mars 2021)
    @property
    def circle_segment_max_error(self):
        self._check_ptr()
        return self._ptr.CircleTessellationMaxError
    
    # OBSOLETED in 1.82 (from Mars 2021)
    @circle_segment_max_error.setter
    def circle_segment_max_error(self, float value):
        self._check_ptr()
        self._ptr.CircleTessellationMaxError = value
    
    @property
    def circle_tessellation_max_error(self):
        self._check_ptr()
        return self._ptr.CircleTessellationMaxError
    
    @circle_tessellation_max_error.setter
    def circle_tessellation_max_error(self, float value):
        self._check_ptr()
        self._ptr.CircleTessellationMaxError = value

    def color(self, cimgui.ImGuiCol variable):
        if not (0 <= variable < enums.ImGuiCol_COUNT):
            raise ValueError("Unknown style variable: {}".format(variable))

        self._check_ptr()
        cdef int ix = variable
        return _cast_ImVec4_tuple(self._ptr.Colors[ix])

    @property
    def colors(self):
        """Retrieve and modify style colors through list-like interface.

        .. visual-example::
            :width: 700
            :height: 500
            :auto_layout:

            style = imgui.get_style()
            imgui.begin("Color window")
            imgui.columns(4)
            for color in range(0, imgui.COLOR_COUNT):
                imgui.text("Color: {}".format(color))
                imgui.color_button("color#{}".format(color), *style.colors[color])
                imgui.next_column()

            imgui.end()
        """
        self._check_ptr()
        return self._colors

    def scale_all_sizes(self, float scale_factor):
        self._require_pointer()
        self._ptr.ScaleAllSizes(scale_factor)


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
    cdef bytes _keep_ini_alive
    cdef bytes _keep_logfile_alive

    def __init__(self):
        
        self._ptr = &cimgui.GetIO()
        self._fonts = _FontAtlas.from_ptr(self._ptr.Fonts)

        if <uintptr_t>cimgui.GetCurrentContext() not in _io_clipboard:
            _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()] = {'_get_clipboard_text_fn': None,
                                                                    '_set_clipboard_text_fn': None}

    # ... mapping of input properties ...
    @property
    def config_flags(self):
        return self._ptr.ConfigFlags

    @config_flags.setter
    def config_flags(self, cimgui.ImGuiConfigFlags value):
        self._ptr.ConfigFlags = value

    @property
    def backend_flags(self):
        return self._ptr.BackendFlags

    @backend_flags.setter
    def backend_flags(self, cimgui.ImGuiBackendFlags value):
        self._ptr.BackendFlags = value

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
        if(self._ptr.LogFilename == NULL): return None
        else: return _from_bytes(self._ptr.LogFilename)

    @log_file_name.setter
    def log_file_name(self, value):
        assert (value is None or isinstance(value, str) or isinstance(value, bytes)), "`log_file_name` must be a string or None"

        cdef char* value_c = NULL
        cdef bytes value_bytes = None
        cdef str value_str

        if value is None:
            pass
        elif isinstance(value, str):
            value_str = value
            value_bytes = _bytes(value_str)
            value_c = _charptr(value_bytes)
        elif isinstance(value, bytes):
            value_bytes = value
            value_c = _charptr(value_bytes)

        self._keep_logfile_alive = value_bytes  # Keep the bytes object alive
        self._ptr.LogFilename = value_c

    @property
    def ini_file_name(self):
        if(self._ptr.IniFilename == NULL): return None
        else: return _from_bytes(self._ptr.IniFilename)

    @ini_file_name.setter
    def ini_file_name(self, value):
        assert (value is None or isinstance(value, str) or isinstance(value, bytes)), "`ini_file_name` must be a string or None"

        cdef char* value_c = NULL
        cdef bytes value_bytes = None
        cdef str value_str

        if value is None:
            pass
        elif isinstance(value, str):
            value_str = value
            value_bytes = _bytes(value_str)
            value_c = _charptr(value_bytes)
        elif isinstance(value, bytes):
            value_bytes = value
            value_c = _charptr(value_bytes)

        self._keep_ini_alive = value_bytes  # Keep the bytes object alive
        self._ptr.IniFilename = value_c

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

    # DEPRECIATED
    #@property
    #def display_visible_min(self):
    #    return _cast_ImVec2_tuple(self._ptr.DisplayVisibleMin)

    # DEPRECIATED
    #@display_visible_min.setter
    #def display_visible_min(self,  value):
    #    self._ptr.DisplayVisibleMin = _cast_tuple_ImVec2(value)

    # DEPRECIATED
    #@property
    #def display_visible_max(self):
    #    return _cast_ImVec2_tuple(self._ptr.DisplayVisibleMax)

    # DEPRECIATED
    #@display_visible_max.setter
    #def display_visible_max(self,  value):
    #    self._ptr.DisplayVisibleMax = _cast_tuple_ImVec2(value)

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
    def config_drag_click_to_input_text(self):
        return self._ptr.ConfigDragClickToInputText
    
    @config_drag_click_to_input_text.setter
    def config_drag_click_to_input_text(self, cimgui.bool value):
        self._ptr.ConfigDragClickToInputText = value

    # RENAMED from config_resize_windows_from_edges
    @property
    def config_windows_resize_from_edges(self):
        return self._ptr.ConfigWindowsResizeFromEdges
    
    # RENAMED from config_resize_windows_from_edges
    @config_windows_resize_from_edges.setter
    def config_windows_resize_from_edges(self, cimgui.bool value):
        self._ptr.ConfigWindowsResizeFromEdges = value

    @property
    def config_windows_move_from_title_bar_only(self):
        return self._ptr.ConfigWindowsMoveFromTitleBarOnly
    
    @config_windows_move_from_title_bar_only.setter
    def config_windows_move_from_title_bar_only(self, cimgui.bool value):
        self._ptr.ConfigWindowsMoveFromTitleBarOnly = value

    @property
    def config_memory_compact_timer(self):
        return self._ptr.ConfigMemoryCompactTimer
    
    @config_memory_compact_timer.setter
    def config_memory_compact_timer(self, float value):
        self._ptr.ConfigMemoryCompactTimer = value

    @staticmethod
    cdef const char* _get_clipboard_text(void* user_data):
        text = _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_get_clipboard_text_fn']()
        
        # get_clipboard_text_fn() may return None
        # (e.g. if the user copied non text data)
        if text is None:
            return ""
        
        if type(text) is bytes:
            return text
        return _bytes(text)

    @property
    def get_clipboard_text_fn(self):
        return _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_get_clipboard_text_fn']

    @get_clipboard_text_fn.setter
    def get_clipboard_text_fn(self, func):
        if callable(func):
            _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_get_clipboard_text_fn'] = func
            self._ptr.GetClipboardTextFn = self._get_clipboard_text
        else:
            raise ValueError("func is not a callable: %s" % str(func))

    @staticmethod
    cdef void _set_clipboard_text(void* user_data, const char* text):
        _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_set_clipboard_text_fn'](_from_bytes(text))

    @property
    def set_clipboard_text_fn(self):
        return _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_set_clipboard_text_fn']

    @set_clipboard_text_fn.setter
    def set_clipboard_text_fn(self, func):
        if callable(func):
            _io_clipboard[<uintptr_t>cimgui.GetCurrentContext()]['_set_clipboard_text_fn'] = func
            self._ptr.SetClipboardTextFn = self._set_clipboard_text
        else:
            raise ValueError("func is not a callable: %s" % str(func))
    
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
    def mouse_wheel_horizontal(self):
        return self._ptr.MouseWheelH

    @mouse_wheel_horizontal.setter
    def mouse_wheel_horizontal(self, float value):
        self._ptr.MouseWheelH = value

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
        
    @property
    def nav_inputs(self):
        cdef cvarray nav_inputs = cvarray(
            shape=(enums.ImGuiNavInput_COUNT,),
            format='f',
            itemsize=sizeof(float),
            allocate_buffer=False
        )
        nav_inputs.data = <char*>self._ptr.NavInputs
        return nav_inputs

    def add_input_character(self, unsigned int c):
        self._ptr.AddInputCharacter(c)
    
    def add_input_character_utf16(self, str utf16_chars):
        self._ptr.AddInputCharacterUTF16(_bytes(utf16_chars))

    def add_input_characters_utf8(self, str utf8_chars):
        self._ptr.AddInputCharactersUTF8(_bytes(utf8_chars))

    def clear_input_characters(self):
        self._ptr.ClearInputCharacters()

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
    def want_save_ini_settings(self):
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
    def metrics_render_indices(self):
        return self._ptr.MetricsRenderIndices

    @property
    def metrics_render_windows(self):
        return self._ptr.MetricsRenderWindows

    @property
    def metrics_active_windows(self):
        return self._ptr.MetricsActiveWindows

    @property
    def metrics_active_allocations(self):
        return self._ptr.MetricsActiveAllocations

    @property
    def mouse_delta(self):
        return _cast_ImVec2_tuple(self._ptr.MouseDelta)

    @property
    def config_docking_no_split(self):
        return self._ptr.ConfigDockingNoSplit

    @property
    def config_docking_with_shift(self):
        return self._ptr.ConfigDockingWithShift

    @property
    def config_docking_always_tab_bar(self):
        return self._ptr.ConfigDockingAlwaysTabBar

    @property
    def config_docking_transparent_payload(self):
        return self._ptr.ConfigDockingTransparentPayload

    @property
    def config_viewports_no_auto_merge(self):
        return self._ptr.ConfigViewportsNoAutoMerge

    @property
    def config_viewports_no_task_bar_icon(self):
        return self._ptr.ConfigViewportsNoTaskBarIcon

    @property
    def config_viewports_no_decoration(self):
        return self._ptr.ConfigViewportsNoDecoration

    @property
    def config_viewports_no_default_parent(self):
        return self._ptr.ConfigViewportsNoDefaultParent

    @property
    def mouse_hovered_viewport(self):
        return self._ptr.MouseHoveredViewport
        

#-----------------------------------------------------------------------------
# [SECTION] MISC HELPERS/UTILITIES (Geometry functions)
#-----------------------------------------------------------------------------

def color_convert_u32_to_float4(cimgui.ImU32 in_):
    """Convert an unsigned int 32 to 4 component r, g, b, a

    Args:
        in_ (ImU32): Color in unsigned int 32 format

    Return:
        tuple: r, g, b, a components of the color

    .. wraps::
        ImVec4 ColorConvertU32ToFloat4(ImU32 in)
    """
    return _cast_ImVec4_tuple(cimgui.ColorConvertU32ToFloat4(in_))

def color_convert_float4_to_u32(float r, float g, float b, float a):
    """Convert a set of r, g, b, a floats to unsigned int 32 color

    Args:
        r, g, b, a (float): Components of the color

    Returns:
        ImU32: Unsigned int 32 color format

    .. wraps::
        ImU32 ColorConvertFloat4ToU32(const ImVec4& in)
    """
    cdef cimgui.ImVec4 color = _cast_args_ImVec4(r,g,b,a)
    return cimgui.ColorConvertFloat4ToU32(color)

def color_convert_rgb_to_hsv(float r, float g, float b):
    """Convert color from RGB space to HSV space

    Args:
        r, g, b (float): RGB color format

    Returns:
        tuple: h, s, v HSV color format

    .. wraps::
        void ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v)
    """
    cdef float out_h, out_s, out_v
    out_h = out_s = out_v = 0
    cimgui.ColorConvertRGBtoHSV(r,g,b,out_h,out_s,out_v)
    return out_h, out_s, out_v

def color_convert_hsv_to_rgb(float h, float s, float v):
    """Convert color from HSV space to RGB space

    Args:
        h, s, v (float): HSV color format

    Returns:
        tuple: r, g, b RGB color format

    .. wraps::
        void ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b)
    """
    cdef float out_r, out_g, out_b
    out_r = out_g = out_b = 0
    cimgui.ColorConvertHSVtoRGB(h,s,v,out_r,out_g,out_b)
    return out_r, out_g, out_b

#-----------------------------------------------------------------------------
# [SECTION] MISC HELPERS/UTILITIES (String, Format, Hash functions)
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] MISC HELPERS/UTILITIES (File functions)
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] MISC HELPERS/UTILITIES (ImText* functions)
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] MISC HELPERS/UTILITIES (Color functions)
# Note: The Convert functions are early design which are not consistent with other API.
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] ImGuiStorage
# Helper: Key->value storage
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] ImGuiTextFilter
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] ImGuiTextBuffer
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] ImGuiListClipper
# This is currently not as flexible/powerful as it should be and really confusing/spaghetti, mostly because we changed
# the API mid-way through development and support two ways to using the clipper, needs some rework (see TODO)
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] STYLING
#-----------------------------------------------------------------------------

def get_style():
    return GuiStyle.from_ref(cimgui.GetStyle())

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

cpdef get_style_color_vec_4(cimgui.ImGuiCol idx):
    return _cast_ImVec4_tuple(cimgui.GetStyleColorVec4(idx))

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
    if not (0 <= variable < enums.ImGuiCol_COUNT):
        warnings.warn("Unknown style variable: {}".format(variable))
        return False

    cimgui.PushStyleColor(variable, _cast_args_ImVec4(r, g, b, a))
    return True

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
    if not (0 <= variable < enums.ImGuiStyleVar_COUNT):
        warnings.warn("Unknown style variable: {}".format(variable))
        return False

    try:
        if isinstance(value, (tuple, list)):
            cimgui.PushStyleVar(variable, _cast_tuple_ImVec2(value))
        else:
            cimgui.PushStyleVar(variable, <float>(float(value)))
    except ValueError:
        raise ValueError(
            "Style value must be float or two-elements list/tuple"
        )
    else:
        return True

def get_style_color_name(int index):
    """Get the style color name for a given ImGuiCol index.

    .. wraps::
        const char* GetStyleColorName(ImGuiCol idx)
    """
    cdef const char* c_string = cimgui.GetStyleColorName(index)
    cdef bytes py_string = c_string
    return c_string.decode("utf-8")

#-----------------------------------------------------------------------------
# [SECTION] RENDER HELPERS
# Some of those (internal) functions are currently quite a legacy mess - their signature and behavior will change,
# we need a nicer separation between low-level functions and high-level functions relying on the ImGui context.
# Also see imgui_draw.cpp for some more which have been reworked to not rely on ImGui:: context.
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] MAIN CODE (most of the code! lots of stuff, needs tidying up!)
#-----------------------------------------------------------------------------

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

def get_clipboard_text():
    """Also see the ``log_to_clipboard()`` function to capture GUI into clipboard,
    or easily output text data to the clipboard.

    Returns:
        str: Text content of the clipboard

    .. wraps::
        const char* GetClipboardText()
    """
    return _from_bytes(cimgui.GetClipboardText())

def set_clipboard_text(str text):
    """Set the clipboard content

    Args:
        text (str): Text to copy in clipboard

    .. wraps:
        void SetClipboardText(const char* text)
    """
    cimgui.SetClipboardText(_bytes(text))

def get_version():
    """Get the version of Dear ImGui.

    .. wraps::
        void GetVersion()
    """
    cdef const char* c_string = cimgui.GetVersion()
    cdef bytes py_string = c_string
    return c_string.decode("utf-8")

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
    
    # Update submodules:
    internal.UpdateImGuiContext(ctx._ptr)

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

    # Update submodules:
    internal.UpdateImGuiContext(_ptr)

    return _ImGuiContext.from_ptr(_ptr)

def destroy_context(_ImGuiContext ctx = None):
    """DestroyContext

    .. wraps::
        DestroyContext(
                # note: optional
                ImGuiContext* ctx = NULL);
    """

    if ctx and ctx._ptr != NULL:
        del _contexts[<uintptr_t>ctx._ptr]
        cimgui.DestroyContext(ctx._ptr)
        ctx._ptr = NULL
        
        # Update submodules:
        internal.UpdateImGuiContext(NULL)

    else:
        raise RuntimeError("Context invalid (None or destroyed)")

_io_clipboard = {}
def get_io():
    return _IO()

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

def get_time():
    """Seconds since program start.

    Returns:
        float: the time (seconds since program start)

    .. wraps::
        float GetTime()
    """
    return cimgui.GetTime()

def get_background_draw_list():
    """This draw list will be the first rendering one.
    Useful to quickly draw shapes/text behind dear imgui contents.

    Returns:
        DrawList*

    .. wraps::
        ImDrawList* GetBackgroundDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetBackgroundDrawList())

def get_foreground_draw_list():
    """This draw list will be the last rendered one.
    Useful to quickly draw shapes/text over dear imgui contents.

    Returns:
        DrawList*

    .. wraps::
        ImDrawList* GetForegroundDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetForegroundDrawList())

# OBSOLETED in 1.69 (from Mar 2019)
def get_overlay_draw_list():
    """Get a special draw list that will be drawn last (over all windows).

    Useful for drawing overlays.

    Returns:
        ImDrawList*

    .. wraps::
        ImDrawList* GetWindowDrawList()
    """
    return _DrawList.from_ptr(cimgui.GetForegroundDrawList())

def new_frame():
    """Start a new frame.

    After calling this you can submit any command from this point until
    next :any:`new_frame()` or :any:`render()`.

    .. wraps::
        void NewFrame()
    """
    get_current_context()._keepalive_cache.clear()
    cimgui.NewFrame()

def push_clip_rect(
        float clip_rect_min_x,
        float clip_rect_min_y,
        float clip_rect_max_x,
        float clip_rect_max_y,
        bool intersect_with_current_clip_rect = False
    ):
    """Push the clip region, i.e. the area of the screen to be rendered,on the stack. 
    If ``intersect_with_current_clip_rect`` is ``True``, the intersection between pushed 
    clip region and previous one is added on the stack. 
    See: :func:`pop_clip_rect()`
    
    Args:
        clip_rect_min_x, clip_rect_min_y (float): Position of the minimum point of the rectangle
        clip_rect_max_x, clip_rect_max_y (float): Position of the maximum point of the rectangle
        intersect_with_current_clip_rect (bool): If True, intersection with current clip region is pushed on stack.
    
    .. visual-example::
        :auto_layout:
        :width: 150
        :height: 150

        imgui.begin("Example Cliprect")
        
        winpos = imgui.get_window_position()
        imgui.push_clip_rect(0+winpos.x,0+winpos.y,100+winpos.x,100+winpos.y)
        imgui.push_clip_rect(50+winpos.x,50+winpos.y,100+winpos.x,100+winpos.y, True)
        
        imgui.text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
        imgui.text('Vivamus mattis velit ac ex auctor gravida.')
        imgui.text('Quisque varius erat finibus porta interdum.')
        imgui.text('Nam neque magna, dapibus placerat urna eget, facilisis malesuada ipsum.')
        
        imgui.pop_clip_rect()
        imgui.pop_clip_rect()
        
        imgui.end()
    
    .. wraps::
        void PushClipRect(
            const ImVec2& clip_rect_min, 
            const ImVec2& clip_rect_max, 
            bool intersect_with_current_clip_rect
        )
    """
    cimgui.PushClipRect(
        _cast_args_ImVec2(clip_rect_min_x, clip_rect_min_y),
        _cast_args_ImVec2(clip_rect_max_x, clip_rect_max_y),
        intersect_with_current_clip_rect
    )
    
def pop_clip_rect():
    """Pop the last clip region from the stack. See: :func:`push_clip_rect()`.
    
    .. wraps::
        void PopClipRect()
    """
    cimgui.PopClipRect()

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

cpdef calc_text_size(str text, bool hide_text_after_double_hash = False, float wrap_width = -1.0):
    """Calculate text size.
    Text can be multi-line.
    Optionally ignore text after a ## marker.

    .. visual-example::
        :auto_layout:
        :width: 300
        :height: 100

        imgui.begin("Text size calculation")
        text_content = "This is a ##text##!"
        text_size1 = imgui.calc_text_size(text_content)
        imgui.text('"%s" has size %ix%i' % (text_content, text_size1[0], text_size1[1]))
        text_size2 = imgui.calc_text_size(text_content, True)
        imgui.text('"%s" has size %ix%i' % (text_content, text_size2[0], text_size2[1]))
        text_size3 = imgui.calc_text_size(text_content, False, 30.0)
        imgui.text('"%s" has size %ix%i' % (text_content, text_size3[0], text_size3[1]))
        imgui.end()

    Args:
        text (str): text
        hide_text_after_double_hash (bool): if True, text after '##' is ignored
        wrap_width (float): if > 0.0 calculate size using text wrapping

    .. wraps::
        CalcTextSize(const char* text, const char* text_end, bool hide_text_after_double_hash, float wrap_width)
    """
    return _cast_ImVec2_tuple(
        cimgui.CalcTextSize(
            _bytes(text),
            NULL,
            hide_text_after_double_hash,
            wrap_width
        )
    )

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

def get_key_index(int key):
    """Map ImGuiKey_* values into user's key index. == io.KeyMap[key]

    Returns:
       int: io.KeyMap[key]

    .. wraps::
        int GetKeyIndex(ImGuiKey imgui_key)
    """
    return cimgui.GetKeyIndex(key)

def is_key_down(int key_index):
    """Returns if key is being held -- io.KeysDown[user_key_index].
       Note that imgui doesn't know the semantic of each entry of
       io.KeysDown[]. Use your own indices/enums according to how
       your backend/engine stored them into io.KeysDown[]!

    Returns:
        bool: True if specified key is being held.

    .. wraps::
        bool IsKeyDown(int user_key_index)
    """
    return cimgui.IsKeyDown(key_index)

def is_key_pressed(int key_index, bool repeat = False):
    """Was key pressed (went from !Down to Down).
       If repeat=true, uses io.KeyRepeatDelay / KeyRepeatRate

    Returns:
        bool: True if specified key was pressed this frame

    .. wraps::
        bool IsKeyPressed(int user_key_index)
    """
    return cimgui.IsKeyPressed(key_index, repeat)

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

def is_mouse_dragging(int button, float lock_threshold = -1.0):
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

def capture_mouse_from_app(bool want_capture_mouse_value = True):
    """Attention: misleading name!
    Manually override io.WantCaptureMouse flag next frame
    (said flag is entirely left for your application to handle).

    This is equivalent to setting "io.WantCaptureMouse = want_capture_mouse_value;"
    after the next NewFrame() call.

    .. wraps::
        void CaptureMouseFromApp(bool want_capture_mouse_value = true)
    """
    cimgui.CaptureMouseFromApp(want_capture_mouse_value)

def is_item_active():
    """Was the last item active? For ex. button being held or text field
    being edited. Items that don't interact will always return false.

    Returns:
        bool: True if item is active, otherwise False.

    .. wraps::
        bool IsItemActive()
    """
    return cimgui.IsItemActive()

def is_item_activated():
    """Was the last item just made active (item was previously inactive)?

    Returns:
        bool: True if item was just made active

    .. wraps::
        bool IsItemActivated()
    """
    return cimgui.IsItemActivated()

def is_item_deactivated():
    """Was the last item just made inactive (item was previously active)?
    Useful for Undo/Redo patterns with widgets that requires continuous editing.

    Results:
        bool: True if item just made inactive

    .. wraps:
        bool IsItemDeactivated()
    """
    return cimgui.IsItemDeactivated()

def is_item_deactivated_after_edit():
    """Was the last item just made inactive and made a value change when it was active? (e.g. Slider/Drag moved).
    Useful for Undo/Redo patterns with widgets that requires continuous editing.
    Note that you may get false positives (some widgets such as Combo()/ListBox()/Selectable() will return true even when clicking an already selected item).

    Results:
        bool: True if item just made inactive after an edition

    .. wraps::
        bool IsItemDeactivatedAfterEdit()
    """
    return cimgui.IsItemDeactivatedAfterEdit()

def is_item_focused():
    """Check if the last item is focused

    Returns:
        bool: True if item is focused, otherwise False.

    .. wraps::
        bool IsItemFocused()
    """
    return cimgui.IsItemFocused()

def is_item_clicked(cimgui.ImGuiMouseButton mouse_button = 0):
    """ Was the last item hovered and mouse clicked on?
    Button or node that was just being clicked on.

    Args:
        mouse_button: ImGuiMouseButton

    Returns:
        bool: True if item is clicked, otherwise False.

    .. wraps::
        bool IsItemClicked(int mouse_button = 0)
    """
    return cimgui.IsItemClicked(mouse_button)

def is_item_toggled_open():
    """Was the last item open state toggled? set by TreeNode().

    .. wraps::
        bool IsItemToggledOpen()
    """
    return cimgui.IsItemToggledOpen()

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

def is_item_visible():
    """Was the last item visible? Aka not out of sight due to
    clipping/scrolling.

    Returns:
        bool: True if item is visible, otherwise False.

    .. wraps::
        bool IsItemVisible()
    """
    return cimgui.IsItemVisible()

def is_item_edited():
    """Did the last item modify its underlying value this frame? or was pressed?
    This is generally the same as the "bool" return value of many widgets.

    Returns:
        bool: True if item is edited, otherwise False.

    .. wraps::
        bool IsItemEdited()
    """
    return cimgui.IsItemEdited()

def set_item_allow_overlap():
    """Allow last item to be overlapped by a subsequent item.
    Sometimes useful with invisible buttons, selectables, etc.
    to catch unused area.

    .. wraps::
        void SetItemAllowOverlap()
    """
    cimgui.SetItemAllowOverlap()

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

ctypedef fused child_id:
    str
    cimgui.ImGuiID

cdef class _BeginEndChild(object):
    """
    Return value of :func:`begin_child` exposing ``visible`` boolean attribute.
    See :func:`begin_child` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically
    call :func:`end_child` to end the child created with :func:`begin_child`
    when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_child` function.
    """

    cdef readonly bool visible

    def __cinit__(self, bool visible):
        self.visible = visible

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.EndChild()

    def __bool__(self):
        """For legacy support, returns ``visible``."""
        return self.visible

    def __repr__(self):
        return "{}(visible={})".format(
            self.__class__.__name__, self.visible
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.visible is other.visible
        return self.visible is other

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

        with imgui.begin("Example: child region"):
            with imgui.begin_child("region", 150, -50, border=True):
                imgui.text("inside region")
            imgui.text("outside region")

    Example::
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
        _BeginEndChild: Struct with ``visible`` bool attribute. Use with ``with``
        to automatically call :func:`end_child` when the block ends.`

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
    #       in order to take advantage of Python keyword arguments
    return _BeginEndChild.__new__(
        _BeginEndChild,
        cimgui.BeginChild(
            _bytes(label), _cast_args_ImVec2(width, height), border, flags
        )
    )

def end_child():
    """End scrolling region.
    Only call if ``begin_child().visible`` is True.

    .. wraps::
        void EndChild()
    """
    cimgui.EndChild()

cdef class _BeginEnd(object):
    """
    Return value of :func:`begin` exposing ``expanded`` and ``opened`` boolean attributes.
    See :func:`begin` for an explanation of these attributes and examples.

    For legacy support, the attributes can also be accessed by unpacking or indexing into this object.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end` to end the window
    created with :func:`begin` when the block ends, even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin` function.
    """

    cdef readonly bool expanded
    cdef readonly bool opened

    def __cinit__(self, bool expanded, bool opened):
        self.expanded = expanded
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.End()

    def __getitem__(self, item):
        """For legacy support, returns ``(expanded, opened)[item]``."""
        return (self.expanded, self.opened)[item]

    def __iter__(self):
        """For legacy support, returns ``iter((expanded, opened))``."""
        return iter((self.expanded, self.opened))

    def __repr__(self):
        return "{}(expanded={}, opened={})".format(
            self.__class__.__name__, self.expanded, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return (self.expanded, self.opened) == (other.expanded, other.opened)
        return (self.expanded, self.opened) == other


def begin(str label, closable=False, cimgui.ImGuiWindowFlags flags=0):
    """Begin a window.

    .. visual-example::
        :auto_layout:

        with imgui.begin("Example: empty window"):
            pass

    Example::
        imgui.begin("Example: empty window")
        imgui.end()

    Args:
        label (str): label of the window.
        closable (bool): define if window is closable.
        flags: Window flags. See:
            :ref:`list of available flags <window-flag-options>`.

    Returns:
        _BeginEnd: ``(expanded, opened)`` struct of bools. If window is collapsed
        ``expanded==True``. The value of ``opened`` is always True for
        non-closable and open windows but changes state to False on close
        button click for closable windows. Use with ``with`` to automatically call
        :func:`end` when the block ends.

    .. wraps::
        Begin(
            const char* name,
            bool* p_open = NULL,
            ImGuiWindowFlags flags = 0
        )
    """
    cdef cimgui.bool opened = True

    return _BeginEnd.__new__(
        _BeginEnd,
        cimgui.Begin(_bytes(label), &opened if closable else NULL, flags),
        opened
    )

def end():
    """End a window.

    This finishes appending to current window, and pops it off the window
    stack. See: :any:`begin()`.

    .. wraps::
        void End()
    """
    cimgui.End()

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

cpdef push_allow_keyboard_focus(bool allow_focus):
    cimgui.PushAllowKeyboardFocus(allow_focus)

cpdef pop_allow_keyboard_focus():
    cimgui.PopAllowKeyboardFocus()

cpdef push_button_repeat(bool repeat):
    cimgui.PushButtonRepeat(repeat)

cpdef pop_button_repeat():
    cimgui.PopButtonRepeat()


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

def get_window_dpi_scale():
    """Get current window dpi scale.

    .. wraps::
        float GetWindowDpiScale()
    """
    return cimgui.GetWindowDpiScale()

def set_window_position(float x, float y, cimgui.ImGuiCond condition = ALWAYS):
    """Set the size of the current window

    Call inside: func: 'begin()'

    Args:
        x(float): position on the x axis
        y(float): position on the y axis
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Size Demo
        :height: 200

        imgui.begin("Window 1")
        imgui.set_window_position(20,20)
        imgui.end()

        imgui.begin("Window 2")
        imgui.set_window_position(20,50)
        imgui.end()

    .. wraps::
        void SetWindowPos(
            const ImVec2& pos,
            ImGuiCond cond
        )
    """
    cimgui.SetWindowPos(_cast_args_ImVec2(x,y), condition)

def set_window_position_labeled(str label, float x, float y, cimgui.ImGuiCond condition = ALWAYS):
    """Set the size of the window with label

    Args:
        label(str): name of the window to be resized
        x(float): position on the x axis
        y(float): position on the y axis
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Size Demo
        :height: 200

        imgui.set_window_position_labeled("Window 1", 20, 50)
        imgui.set_window_position_labeled("Window 2", 20, 100)

        imgui.begin("Window 1")
        imgui.end()

        imgui.begin("Window 2")
        imgui.end()

    .. wraps::
        void SetWindowPos(
            const char* name,
            const ImVec2& pos,
            ImGuiCond cond
        )
    
    """
    cimgui.SetWindowPos(
        _bytes(label),
        _cast_args_ImVec2(x,y),
        condition
    )

def get_window_size():
    """Get current window size.

    Returns:
        Vec2: two-tuple of window dimensions.

    .. wraps::
        ImVec2 GetWindowSize()
    """
    return _cast_ImVec2_tuple(cimgui.GetWindowSize())

def set_window_size(
    float width, float height, cimgui.ImGuiCond condition=ONCE):
    """Set window size

    Call inside :func:`begin()`.

    **Note:** usage of this function is not recommended. prefer using
    :func:`set_next_window_size()` as this may incur tearing and minor
    side-effects.

    Args:
        width (float): window width. Value 0.0 enables autofit.
        height (float): window height. Value 0.0 enables autofit.
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ONCE`.

    .. visual-example::
        :title: window sizing
        :height: 200

        imgui.begin("Window size")
        imgui.set_window_size(80, 180)
        imgui.end()

    .. wraps::
        void SetWindowSize(
            const ImVec2& size,
            ImGuiCond cond = 0,
        )
    """
    cimgui.SetWindowSize(_cast_args_ImVec2(width, height), condition)

def set_window_size_named(str label, float width, float height, cimgui.ImGuiCond condition = ONCE):
    """Set the window with label to some size

    Args:
        label(string): name of the window
        width(float): new width of the window
        height(float): new height of the window
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ONCE`.

    .. visual-example::
        :title: Window size
        :height: 200

        imgui.set_window_size_named("Window 1",100,100)
        imgui.set_window_size_named("Window 2",100,200)

        imgui.begin("Window 1")
        imgui.end()

        imgui.begin("Window 2")
        imgui.end()

    .. wraps::
        void SetWindowSize(
            const char* name,
            const ImVec2& size,
             ImGuiCond cond
        )
    
    """
    cimgui.SetWindowSize(
        _bytes(label),
        _cast_args_ImVec2(width, height),
        condition
    )

def set_window_collapsed(bool collapsed, cimgui.ImGuiCond condition = ALWAYS):
    """Set the current window to be collapsed

    Call inside: func: 'begin()'

    Args:
        collapsed(bool): set boolean for collapsing the window. Set True for closed
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Collapsed Demo
        :height: 200

        imgui.begin("Window 1")
        imgui.set_window_collapsed(True)
        imgui.end()

    .. wraps::
        void SetWindowCollapsed(
            bool collapsed,
            ImGuiCond cond
        )
    """
    cimgui.SetWindowCollapsed(collapsed, condition)

def set_window_collapsed_labeled(str label, bool collapsed, cimgui.ImGuiCond condition = ALWAYS):
    """Set window with label to collapse

    Args:
        label(string): name of the window
        collapsed(bool): set boolean for collapsing the window. Set True for closed
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. visual-example::
        :title: Window Collapsed Demo
        :height: 200

        imgui.set_window_collapsed_labeled("Window 1", True)
        imgui.begin("Window 1")
        imgui.end()

    .. wraps::
        void SetWindowCollapsed(
            const char* name,
            bool collapsed,
            ImGuiCond cond
        )
    """
    cimgui.SetWindowCollapsed(_bytes(label), collapsed, condition)

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

def set_window_focus():
    """Set window to be focused

    Call inside :func:`begin()`.

    .. visual-example::
        :title: Window focus
        :height: 100

        imgui.begin("Window 1")
        imgui.end()

        imgui.begin("Window 2")
        imgui.set_window_focus()
        imgui.end()

    .. wraps::
        void SetWindowFocus()
    """
    cimgui.SetWindowFocus()

def set_window_focus_labeled(str label):
    """Set focus to the window named label

    Args:
        label(string): the name of the window that will be focused

    .. visual-example::
        :title: Window focus
        :height: 100

        imgui.set_window_focus_labeled("Window 2")

        imgui.begin("Window 1", True)
        imgui.text("Apples")
        imgui.end()

        imgui.begin("Window 2", True)
        imgui.text("Orange")
        imgui.end()

        imgui.begin("Window 3", True)
        imgui.text("Mango")
        imgui.end()

    .. wraps::
        void SetWindowFocus(
            const char* name
        )
    """
    cimgui.SetWindowFocus(_bytes(label))

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

# Useful for non trivial constraints
cdef _callback_user_info _global_next_window_size_constraints_callback_user_info = _callback_user_info()
def set_next_window_size_constraints(
    tuple size_min,
    tuple size_max,
    object callback = None,
    user_data = None):
    """Set next window size limits. use -1,-1 on either X/Y axis to preserve the current size.
    Sizes will be rounded down.

    Call before :func:`begin()`.

    Args:
        size_min (tuple): Minimum window size, use -1 to conserve current size
        size_max (tuple): Maximum window size, use -1 to conserve current size
        callback (callable): a callable.
            Callable takes an imgui._ImGuiSizeCallbackData object as argument
            Callable should return None
        user_data: Any data that the user want to use in the callback.

    .. visual-example::
        :title: Window size constraints
        :height: 200

        imgui.set_next_window_size_constraints((175,50), (200, 100))
        imgui.begin("Constrained Window")
        imgui.text("...")
        imgui.end()

    .. wraps::
        void SetNextWindowSizeConstraints(
            const ImVec2& size_min,
            const ImVec2& size_max,
            ImGuiSizeCallback custom_callback = NULL,
            void* custom_callback_user_data = NULL
        )

    """
    cdef cimgui.ImGuiSizeCallback _callback = NULL
    cdef void *_user_data = NULL
    if callback is not None:
        _callback = _ImGuiSizeCallback
        _global_next_window_size_constraints_callback_user_info.populate(callback, user_data)
        _user_data = <void*>_global_next_window_size_constraints_callback_user_info

    cimgui.SetNextWindowSizeConstraints(
        _cast_tuple_ImVec2(size_min),
        _cast_tuple_ImVec2(size_max),
        _callback, _user_data)

def set_next_window_content_size(float width, float height):
    """Set content size of the next window. Show scrollbars
       if content doesn't fit in the window

    Call before :func:`begin()`.

    Args:
        width(float): width of the content area
        height(float): height of the content area

    .. visual-example::
        :title: Content Size Demo
        :height: 30

        imgui.set_window_size(20,20)
        imgui.set_next_window_content_size(100,100)

        imgui.begin("Window", True)
        imgui.text("Some example text")
        imgui.end()

    .. wraps::
        void SetNextWindowContentSize(
            const ImVec2& size
        )
    """
    cimgui.SetNextWindowContentSize(_cast_args_ImVec2(width, height))

def set_next_window_viewport(cimgui.ImGuiID viewport_id):

    cimgui.SetNextWindowViewport(viewport_id)

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

    It may be useful if you want to do your own drawing via the :class:`_DrawList`
    API.

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

cpdef get_font_size():
    """get current font size (= height in pixels) of current font with current scale applied

    Returns:
        float: current font size (height in pixels)

    .. wraps::
        float GetFontSize()
    """
    return cimgui.GetFontSize()

cpdef get_font_tex_uv_white_pixel():
    return _cast_ImVec2_tuple(cimgui.GetFontTexUvWhitePixel())

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

def set_keyboard_focus_here(int offset = 0):
    """Focus keyboard on the next widget.
    Use positive 'offset' to access sub components of a multiple component widget. Use -1 to access previous widget.

    .. wraps::
        void SetKeyboardFocusHere(int offset = 0)
    """
    return cimgui.SetKeyboardFocusHere(offset)

def set_item_default_focus():
    """Make last item the default focused item of a window.
    Please use instead of "if (is_window_appearing()) set_scroll_here()" to signify "default item".

    .. wraps::
        void SetItemDefaultFocus()
    """
    cimgui.SetItemDefaultFocus()

def push_id(str str_id):
    """Push an ID into the ID stack

    Args:
        str_id (str): ID to push

      wraps::
        PushID(const char* str_id)
    """
    cimgui.PushID(_bytes(str_id))

def pop_id():
    """Pop from the ID stack

      wraps::
        PopID()
    """
    cimgui.PopID()

def get_id(str str_id):
    """Calculate unique ID (hash of whole ID stack + given parameter).
    e.g. if you want to query into ImGuiStorage yourself
    Args:
        str_id (str): String Id

    wraps::
        GetID(const char* str_id)
    """
    return cimgui.GetID(_bytes(str_id))

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

#-----------------------------------------------------------------------------
# [SECTION] ERROR CHECKING
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] LAYOUT
#-----------------------------------------------------------------------------
# - ItemSize()
# - ItemAdd()
# - SameLine()
# - GetCursorScreenPos()
# - SetCursorScreenPos()
# - GetCursorPos(), GetCursorPosX(), GetCursorPosY()
# - SetCursorPos(), SetCursorPosX(), SetCursorPosY()
# - GetCursorStartPos()
# - Indent()
# - Unindent()
# - SetNextItemWidth()
# - PushItemWidth()
# - PushMultiItemsWidths()
# - PopItemWidth()
# - CalcItemWidth()
# - CalcItemSize()
# - GetTextLineHeight()
# - GetTextLineHeightWithSpacing()
# - GetFrameHeight()
# - GetFrameHeightWithSpacing()
# - GetContentRegionMax()
# - GetContentRegionMaxAbs() [Internal]
# - GetContentRegionAvail(),
# - GetWindowContentRegionMin(), GetWindowContentRegionMax()
# - GetWindowContentRegionWidth()
# - BeginGroup()
# - EndGroup()
# Also see in imgui_widgets: tab bars, columns.
#-----------------------------------------------------------------------------

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

def get_cursor_screen_pos():
    """Get the cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 GetCursorScreenPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorScreenPos())
get_cursor_screen_position = get_cursor_screen_pos

def set_cursor_screen_pos(screen_pos):
    """Set the cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 SetCursorScreenPos(const ImVec2& screen_pos)
    """
    cimgui.SetCursorScreenPos(_cast_tuple_ImVec2(screen_pos))
set_cursor_screen_position = set_cursor_screen_pos

def get_cursor_pos():
    """Get the cursor position.

    .. wraps::
        ImVec2 GetCursorPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorPos())
get_cursor_position = get_cursor_pos

def get_cursor_pos_x():
    return cimgui.GetCursorPosX()
get_cursor_position_x = get_cursor_pos_x

def get_cursor_pos_y():
    return cimgui.GetCursorPosY()
get_cursor_position_y = get_cursor_pos_y

def set_cursor_pos(local_pos):
    """Set the cursor position in local coordinates [0..<window size>] (useful to work with ImDrawList API)

    .. wraps::
        ImVec2 SetCursorScreenPos(const ImVec2& screen_pos)
    """
    cimgui.SetCursorPos(_cast_tuple_ImVec2(local_pos))
set_cursor_position = set_cursor_pos

def set_cursor_pos_x(float x):
    cimgui.SetCursorPosX(x)


def set_cursor_pos_y(float y):
    cimgui.SetCursorPosY(y)

def get_cursor_start_pos():
    """Get the initial cursor position.

    .. wraps::
        ImVec2 GetCursorStartPos()
    """
    return _cast_ImVec2_tuple(cimgui.GetCursorStartPos())
get_cursor_start_position = get_cursor_start_pos

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

cpdef set_next_item_width(float item_width):
    """Set width of the _next_ common large "item+label" widget. 
    * ``>0.0`` - width in pixels
    * ``<0.0`` - align xx pixels to the right of window
    (so -FLOAT_MIN always align width to the right side)
    
    Helper to avoid using ``push_item_width()``/``pop_item_width()`` for single items.
    
    Args:
        item_width (float): width of the component
    
    .. visual-example::
        :auto_layout:
        :width: 200
        :height: 200
        
        imgui.begin("Exemple: Next item width")
        imgui.set_next_item_width(imgui.get_window_width() * 0.33)
        imgui.slider_float('Slider 1', 10.2, 0.0, 20.0, '%.2f', 1.0)
        imgui.slider_float('Slider 2', 10.2, 0.0, 20.0, '%.2f', 1.0)
        imgui.end()
    
    .. wraps::
        void SetNextItemWidth(float item_width)
    """
    cimgui.SetNextItemWidth(item_width)

cpdef push_item_width(float item_width):
    """Push item width in the stack.

    **Note:** sizing of child region allows for three modes:

    * ``0.0`` - default to ~2/3 of windows width
    * ``>0.0`` - width in pixels
    * ``<0.0`` - align xx pixels to the right of window
      (so -FLOAT_MIN always align width to the right side)

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

# OBSOLETED in 1.70 (from May 2019)
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

cdef class _BeginEndGroup(object):
    """
    Return value of :func:`begin_group`.
    See :func:`begin_group` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_group`
    to end the group created with :func:`begin_group` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_group` function.
    """

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.EndGroup()

    def __repr__(self):
        return "{}()".format(
            self.__class__.__name__
        )


def begin_group():
    """Start item group and lock its horizontal starting position.

    Captures group bounding box into one "item". Thanks to this you can use
    :any:`is_item_hovered()` or layout primitives such as :any:`same_line()`
    on whole group, etc.

    .. visual-example::
        :auto_layout:
        :width: 500

        with imgui.begin("Example: item groups"):

            with imgui.begin_group():
                imgui.text("First group (buttons):")
                imgui.button("Button A")
                imgui.button("Button B")

            imgui.same_line(spacing=50)

            with imgui.begin_group():
                imgui.text("Second group (text and bullet texts):")
                imgui.bullet_text("Bullet A")
                imgui.bullet_text("Bullet B")

    Example::

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

    Returns:
        _BeginEndGrouop; use with ``with`` to automatically call :func:`end_group` when the block ends.

    .. wraps::
        void BeginGroup()
    """
    cimgui.BeginGroup()
    return _BeginEndGroup.__new__(_BeginEndGroup)


def end_group():
    """End group (see: :any:`begin_group`).

    .. wraps::
        void EndGroup()
    """
    cimgui.EndGroup()

#-----------------------------------------------------------------------------
# [SECTION] SCROLLING
#-----------------------------------------------------------------------------

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

def set_scroll_from_pos_x(float local_x, float center_x_ratio = 0.5):
    """Set scroll from position X

    Adjust scrolling amount to make given position visible.
    Generally GetCursorStartPos() + offset to compute a valid position.

    Args:
        float local_x
        float center_x_ratio = 0.5f

    .. wraps::
        void SetScrollFromPosX(float local_x, float center_x_ratio = 0.5f)
    """
    return cimgui.SetScrollFromPosX(local_x, center_x_ratio)


def set_scroll_from_pos_y(float local_y, float center_y_ratio = 0.5):
    """Set scroll from position Y

    Adjust scrolling amount to make given position visible.
    Generally GetCursorStartPos() + offset to compute a valid position.

    Args:
        float local_y
        float center_y_ratio = 0.5f

    .. wraps::
        void SetScrollFromPosY(float local_y, float center_y_ratio = 0.5f)
    """
    return cimgui.SetScrollFromPosY(local_y, center_y_ratio)

def set_scroll_here_x(float center_x_ratio = 0.5):
    """Set scroll here X.

    Adjust scrolling amount to make current cursor position visible.
    center_x_ratio =
    0.0: left,
    0.5: center,
    1.0: right.

    When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.

    Args:
        float center_x_ratio = 0.5f

    .. wraps::
        void SetScrollHereX(float center_x_ratio = 0.5f)
    """
    return cimgui.SetScrollHereX(center_x_ratio)

def set_scroll_here_y(float center_y_ratio = 0.5):
    """Set scroll here Y.

    Adjust scrolling amount to make current cursor position visible.
    center_y_ratio =
    0.0: top,
    0.5: center,
    1.0: bottom.

    When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.

    Args:
        float center_y_ratio = 0.5f

    .. wraps::
        void SetScrollHereY(float center_y_ratio = 0.5f)
    """
    return cimgui.SetScrollHereY(center_y_ratio)

# REMOVED in 1.82 (from Mars 2021) use 'set_scroll_here_y()'
# OBSOLETED in 1.66 (from Sep 2018)
#def set_scroll_here(float center_y_ratio = 0.5):
#    """Set scroll here.
#
#    adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
#
#    Args:
#        float center_y_ratio = 0.5f
#
#    .. wraps::
#        void SetScrollHere(float center_y_ratio = 0.5f)
#    """
#    return cimgui.SetScrollHere(center_y_ratio)

#-----------------------------------------------------------------------------
# [SECTION] TOOLTIPS
#-----------------------------------------------------------------------------

cdef class _BeginEndTooltip(object):
    """
    Return value of :func:`begin_tooltip`.
    See :func:`begin_tooltip` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_tooltip`
    to end the tooltip created with :func:`begin_tooltip` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_tooltip` function.
    """

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        cimgui.EndTooltip()

    def __repr__(self):
        return "{}()".format(self.__class__.__name__)

def begin_tooltip():
    """Use to create full-featured tooltip windows that aren't just text.

    .. visual-example::
        :auto_layout:
        :width: 600
        :height: 200
        :click: 80 40

        with imgui.begin("Example: tooltip"):
            imgui.button("Click me!")
            if imgui.is_item_hovered():
                with imgui.begin_tooltip():
                    imgui.text("This button is clickable.")
                    imgui.text("This button has full window tooltip.")
                    texture_id = imgui.get_io().fonts.texture_id
                    imgui.image(texture_id, 512, 64, border_color=(1, 0, 0, 1))
    
    .. wraps::
        void BeginTooltip()
    
    Returns:
        _BeginEndTooltip: Use with ``with`` to automatically call :func:`end_tooltip` when the block ends.

    
    """
    cimgui.BeginTooltip()
    return _BeginEndTooltip.__new__(_BeginEndTooltip)

def end_tooltip():
    """End tooltip window.

    See :func:`begin_tooltip()` for full usage example.

    .. wraps::
        void EndTooltip()
    """
    cimgui.EndTooltip()

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

#-----------------------------------------------------------------------------
# [SECTION] POPUPS
#-----------------------------------------------------------------------------

def is_popup_open( str label,  cimgui.ImGuiPopupFlags flags = 0):
    """Popups: test function

    * ``is_popup_open()`` with POPUP_ANY_POPUP_ID: return true if any popup is open at the current BeginPopup() level of the popup stack.
    * ``is_popup_open()`` with POPUP_ANY_POPUP_ID + POPUP_ANY_POPUP_LEVEL: return true if any popup is open.

    Returns:
        bool: True if the popup is open at the current ``begin_popup()`` level of the popup stack.

    .. wraps::
        bool IsPopupOpen(const char* str_id, ImGuiPopupFlags flags = 0)
    """
    return cimgui.IsPopupOpen(_bytes(label), flags)

def open_popup(str label, cimgui.ImGuiPopupFlags flags=0):
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
            const char* str_id,
            ImGuiPopupFlags popup_flags = 0
        )
    """
    cimgui.OpenPopup(_bytes(label), flags)

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

cdef class _BeginEndPopup(object):
    """
    Return value of :func:`begin_popup` exposing ``opened`` boolean attribute.
    See :func:`begin_popup` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_popup`
    (if necessary) to end the popup created with :func:`begin_popup` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_popup` function.
    """

    cdef readonly bool opened

    def __cinit__(self, bool opened):
        self.opened = opened

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndPopup()

    def __bool__(self):
        """For legacy support, returns ``opened``."""
        return self.opened

    def __repr__(self):
        return "{}(opened={})".format(
            self.__class__.__name__, self.opened
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.opened is other.opened
        return self.opened is other


def begin_popup(str label, cimgui.ImGuiWindowFlags flags=0):
    """Open a popup window.

    The attribute ``opened`` is True if the popup is open and you can start outputting
    content to it.
    Use with ``with`` to automatically call :func:`end_popup` if necessary.
    Otherwise, only call :func:`end_popup` if ``opened`` is True.

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        with imgui.begin("Example: simple popup"):
            if imgui.button("select"):
                imgui.open_popup("select-popup")

            imgui.same_line()

            with imgui.begin_popup("select-popup") as select_popup:
                if select_popup.opened:
                    imgui.text("Select one")
                    imgui.separator()
                    imgui.selectable("One")
                    imgui.selectable("Two")
                    imgui.selectable("Three")

    Example::

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
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the popup is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopup(
            const char* str_id,
            ImGuiWindowFlags flags = 0
        )
    """
    return _BeginEndPopup.__new__(
        _BeginEndPopup,
        cimgui.BeginPopup(_bytes(label), flags)
    )

cdef class _BeginEndPopupModal(object):
    """
    Return value of :func:`begin_popup_modal` exposing ``opened`` and ``visible`` boolean attributes.
    See :func:`begin_popup_modal` for an explanation and examples.

    For legacy support, the attributes can also be accessed by unpacking or indexing into this object.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_popup`
    (if necessary) to end the popup created with :func:`begin_popup_modal` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_popup_modal` function.
    """

    cdef readonly bool opened
    cdef readonly bool visible

    def __cinit__(self, bool opened, bool visible):
        self.opened = opened
        self.visible = visible

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.opened:
            cimgui.EndPopup()

    def __getitem__(self, item):
        """For legacy support, returns ``(opened, visible)[item]``."""
        return (self.opened, self.visible)[item]

    def __iter__(self):
        """For legacy support, returns ``iter((opened, visible))``."""
        return iter((self.opened, self.visible))

    def __repr__(self):
        return "{}(opened={}, visible={})".format(
            self.__class__.__name__, self.opened, self.visible
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return (self.opened, self.visible) == (other.opened, other.visible)
        return (self.opened, self.visible) == other


def begin_popup_modal(str title, visible=None, cimgui.ImGuiWindowFlags flags=0):
    """Begin pouring popup contents.

    Differs from :func:`begin_popup` with its modality - meaning it
    opens up on top of every other window.

    The attribute ``opened`` is True if the popup is open and you can start outputting
    content to it.
    Use with ``with`` to automatically call :func:`end_popup` if necessary.
    Otherwise, only call :func:`end_popup` if ``opened`` is True.

    .. visual-example::
        :title: Simple popup window
        :height: 100
        :width: 220
        :auto_layout:

        with imgui.begin("Example: simple popup modal"):
            if imgui.button("Open Modal popup"):
                imgui.open_popup("select-popup")

            imgui.same_line()

            with imgui.begin_popup_modal("select-popup") as select_popup:
                if select_popup.opened:
                    imgui.text("Select an option:")
                    imgui.separator()
                    imgui.selectable("One")
                    imgui.selectable("Two")
                    imgui.selectable("Three")

    Example::

        imgui.begin("Example: simple popup modal")

        if imgui.button("Open Modal popup"):
            imgui.open_popup("select-popup")

        imgui.same_line()

        if imgui.begin_popup_modal("select-popup").opened:
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
        _BeginEndPopupModal: ``(opened, visible)`` struct of bools.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.
        The ``opened`` attribute can be False when the popup is completely clipped
        (e.g. zero size display).

    .. wraps::
        bool BeginPopupModal(
            const char* name,
            bool* p_open = NULL,
            ImGuiWindowFlags extra_flags = 0
        )
    """
    cdef cimgui.bool inout_visible = visible

    return _BeginEndPopupModal.__new__(
        _BeginEndPopupModal,
        cimgui.BeginPopupModal(
            _bytes(title),
            &inout_visible if visible is not None else NULL,
            flags
        ),
        inout_visible
    )

def end_popup():
    """End a popup window.

    Should be called after each XYZPopupXYZ function.
    Only call this function if ``begin_popup_XYZ().opened`` is True.

    For practical example how to use this function, please see documentation
    of :func:`open_popup`.

    .. wraps::
        void EndPopup()
    """
    cimgui.EndPopup()

def open_popup_on_item_click(str label = None, cimgui.ImGuiPopupFlags popup_flags = 1):
    """Helper to open popup when clicked on last item.
    (note: actually triggers on the mouse _released_ event to be consistent with popup behaviors)

    Args:
        label (str): label of the modal window
        flags: ImGuiWindowFlags

    .. wraps::
        void OpenPopupOnItemClick(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)
    """
    if label is None:
        cimgui.OpenPopupOnItemClick(NULL, popup_flags)
    else:
        cimgui.OpenPopupOnItemClick(_bytes(label), popup_flags)

def begin_popup_context_item(str label = None, cimgui.ImGuiPopupFlags mouse_button = 1):
    """This is a helper function to handle the most simple case of associating
    one named popup to one given widget.

    .. visual-example::
        :title: Popup context view
        :height: 100
        :width: 200
        :auto_layout:
        :click: 40 40

        with imgui.begin("Example: popup context view"):
            imgui.text("Right-click to set value.")
            with imgui.begin_popup_context_item("Item Context Menu", mouse_button=0) as popup:
                if popup.opened:
                    imgui.selectable("Set to Zero")

    Example::

        imgui.begin("Example: popup context view")
        imgui.text("Right-click to set value.")
        if imgui.begin_popup_context_item("Item Context Menu", mouse_button=0):
            imgui.selectable("Set to Zero")
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of item.
        mouse_button: ImGuiPopupFlags

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the popup is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopupContextItem(
            const char* str_id = NULL,
            int mouse_button = 1
        )
    """
    if label is None:
        return _BeginEndPopup.__new__(_BeginEndPopup, cimgui.BeginPopupContextItem(NULL, mouse_button))
    else:
        return _BeginEndPopup.__new__(_BeginEndPopup, cimgui.BeginPopupContextItem(_bytes(label), mouse_button))

def begin_popup_context_window(
    str label = None,
    cimgui.ImGuiPopupFlags popup_flags = 1,
    bool also_over_items = True # OBSOLETED in 1.77 (from June 2020)
):
    """Helper function to open and begin popup when clicked on current window.

    As all popup functions it should end with :func:`end_popup`.

    .. visual-example::
        :title: Popup context view
        :height: 100
        :width: 200
        :auto_layout:
        :click: 40 40

        with imgui.begin("Example: popup context window"):
            with imgui.begin_popup_context_window(popup_flags=imgui.POPUP_NONE) as context_window:
                if context_window.opened:
                    imgui.selectable("Clear")

    Example::

        imgui.begin("Example: popup context window")
        if imgui.begin_popup_context_window(popup_flags=imgui.POPUP_NONE):
            imgui.selectable("Clear")
            imgui.end_popup()
        imgui.end()

    Args:
        label (str): label of the window
        popup_flags: ImGuiPopupFlags
        also_over_items (bool): display on top of widget. OBSOLETED in ImGui 1.77 (from June 2020)

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the context window is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopupContextWindow(
            const char* str_id = NULL,
            ImGuiPopupFlags popup_flags = 1
        )
    """

    if label is None:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextWindow(
                NULL,
                popup_flags | (0 if also_over_items else POPUP_NO_OPEN_OVER_ITEMS)
            )
        )
    else:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextWindow(
                _bytes(label),
                popup_flags | (0 if also_over_items else POPUP_NO_OPEN_OVER_ITEMS)
            )
        )

def begin_popup_context_void(str label = None, cimgui.ImGuiPopupFlags popup_flags = 1):
    """Open+begin popup when clicked in void (where there are no windows).

    Args:
        label (str): label of the window
        popup_flags: ImGuiPopupFlags

    Returns:
        _BeginEndPopup: Use ``opened`` bool attribute to tell if the context window is opened.
        Only call :func:`end_popup` if ``opened`` is True.
        Use with ``with`` to automatically call :func:`end_popup` if necessary when the block ends.

    .. wraps::
        bool BeginPopupContextVoid(const char* str_id = NULL, ImGuiPopupFlags popup_flags = 1)
    """

    if label is None:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextVoid(NULL, popup_flags)
        )
    else:
        return _BeginEndPopup.__new__(
            _BeginEndPopup,
            cimgui.BeginPopupContextVoid(_bytes(label), popup_flags)
        )

#-----------------------------------------------------------------------------
# [SECTION] KEYBOARD/GAMEPAD NAVIGATION
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] DRAG AND DROP
#-----------------------------------------------------------------------------

cdef class _BeginEndDragDropSource(object):
    """
    Return value of :func:`begin_drag_drop_source` exposing ``dragging`` boolean attribute.
    See :func:`begin_drag_drop_source` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_drag_drop_source`
    (if necessary) to end the drag-drop source created with :func:`begin_drag_drop_source` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_drag_drop_source` function.
    """

    cdef readonly bool dragging

    def __cinit__(self, bool dragging):
        self.dragging = dragging

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.dragging:
            cimgui.EndDragDropSource()

    def __bool__(self):
        """For legacy support, returns ``dragging``."""
        return self.dragging

    def __repr__(self):
        return "{}(dragging={})".format(
            self.__class__.__name__, self.dragging
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.dragging is other.dragging
        return self.dragging is other

def begin_drag_drop_source(cimgui.ImGuiDragDropFlags flags=0):
    """Set the current item as a drag and drop source. If ``dragging`` is True, you
    can call :func:`set_drag_drop_payload` and :func:`end_drag_drop_source`.
    Use with ``with`` to automatically call :func:`end_drag_drop_source` if necessary.

    **Note:** this is a beta API.

    .. visual-example::
        :auto_layout:
        :width: 300

        with imgui.begin("Example: drag and drop"):

            imgui.button('source')
            with imgui.begin_drag_drop_source() as drag_drop_src:
                if drag_drop_src.dragging:
                    imgui.set_drag_drop_payload('itemtype', b'payload')
                    imgui.button('dragged source')

            imgui.button('dest')
            with imgui.begin_drag_drop_target() as drag_drop_dst:
                if drag_drop_dst.hovered:
                    payload = imgui.accept_drag_drop_payload('itemtype')
                    if payload is not None:
                        print('Received:', payload)

    Example::

        imgui.begin("Example: drag and drop")

        imgui.button('source')
        if imgui.begin_drag_drop_source():
            imgui.set_drag_drop_payload('itemtype', b'payload')
            imgui.button('dragged source')
            imgui.end_drag_drop_source()

        imgui.button('dest')
        if imgui.begin_drag_drop_target():
            payload = imgui.accept_drag_drop_payload('itemtype')
            if payload is not None:
                print('Received:', payload)
            imgui.end_drag_drop_target()

        imgui.end()

    Args:
        flags (ImGuiDragDropFlags): DragDrop flags.

    Returns:
        _BeginEndDragDropSource: Use ``dragging`` to tell if a drag starting at this source is occurring.
        Only call :func:`end_drag_drop_source` if ``dragging`` is True.
        Use with ``with`` to automatically call :func:`end_drag_drop_source` if necessary when the block ends.

    .. wraps::
        bool BeginDragDropSource(ImGuiDragDropFlags flags = 0)
    """
    return _BeginEndDragDropSource.__new__(
        _BeginEndDragDropSource,
        cimgui.BeginDragDropSource(flags)
    )

def end_drag_drop_source():
    """End the drag and drop source.
    Only call if ``begin_drag_drop_source().dragging`` is True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    .. wraps::
        void EndDragDropSource()
    """
    cimgui.EndDragDropSource()

def set_drag_drop_payload(str type, bytes data, cimgui.ImGuiCond condition=0):
    """Set the payload for a drag and drop source. Only call after
    :func:`begin_drag_drop_source` returns True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    Args:
        type (str): user defined type with maximum 32 bytes.
        data (bytes): the data for the payload; will be copied and stored internally.
        condition (:ref:`condition flag <condition-options>`): defines on which
            condition value should be set. Defaults to :any:`imgui.ALWAYS`.

    .. wraps::
        bool SetDragDropPayload(const char* type, const void* data, size_t size, ImGuiCond cond = 0)
    """
    return cimgui.SetDragDropPayload(_bytes(type), <const char*>data, len(data), condition)

cdef class _BeginEndDragDropTarget(object):
    """
    Return value of :func:`begin_drag_drop_target` exposing ``hovered`` boolean attribute.
    See :func:`begin_drag_drop_target` for an explanation and examples.

    Can be used as a context manager (in a ``with`` statement) to automatically call :func:`end_drag_drop_target`
    (if necessary) to end the drag-drop target created with :func:`begin_drag_drop_target` when the block ends,
    even if an exception is raised.

    This class is not intended to be instantiated by the user (thus the `_` name prefix).
    It should be obtained as the return value of the :func:`begin_drag_drop_target` function.
    """

    cdef readonly bool hovered

    def __cinit__(self, bool hovered):
        self.hovered = hovered

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.hovered:
            cimgui.EndDragDropTarget()

    def __bool__(self):
        """For legacy support, returns ``hovered``."""
        return self.hovered

    def __repr__(self):
        return "{}(hovered={})".format(
            self.__class__.__name__, self.hovered
        )

    def __eq__(self, other):
        if other.__class__ is self.__class__:
            return self.hovered is other.hovered
        return self.hovered is other


def begin_drag_drop_target():
    """Set the current item as a drag and drop target. If ``hovered`` is True, you
    can call :func:`accept_drag_drop_payload` and :func:`end_drag_drop_target`.
    Use with ``with`` to automatically call :func:`end_drag_drop_target` if necessary.

    For a complete example see :func:`begin_drag_drop_source`.

    **Note:** this is a beta API.

    Returns:
        _BeginEndDragDropTarget: Use ``hovered` to tell if a drag hovers over the target.
        Only call :func:`end_drag_drop_target` if ``hovered`` is True.
        Use with ``with`` to automatically call :func:`end_drag_drop_target` if necessary when the block ends.

    .. wraps::
        bool BeginDragDropTarget()
    """
    return _BeginEndDragDropTarget.__new__(
        _BeginEndDragDropTarget,
        cimgui.BeginDragDropTarget()
    )

cdef class _ImGuiPayload(object):
    """
    Data payload for Drag and Drop operations: AcceptDragDropPayload(), GetDragDropPayload()
    """

    cdef const cimgui.ImGuiPayload* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(const cimgui.ImGuiPayload* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiPayload()
        instance._ptr = ptr
        return instance

    @property
    def data(self):
        """ Data (copied and owned by dear imgui)"""
        self._require_pointer()
        return <bytes>(self._ptr.Data)

    @property
    def data_size(self):
        """Data size"""
        self._require_pointer()
        return self._ptr.DataSize

    def is_preview(self):
        self._require_pointer()
        return self.ptr_.IsPreview()

    def is_delivery(self):
        self._require_pointer()
        return self.ptr_.IsDelivery()

    def is_data_type(self, str type):
        self._require_pointer()
        return self.ptr_.IsDataType(type)

def accept_drag_drop_payload(str type, cimgui.ImGuiDragDropFlags flags=0):
    """Get the drag and drop payload. Only call after :func:`begin_drag_drop_target`
    returns True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    Args:
        type (str): user defined type with maximum 32 bytes.
        flags (ImGuiDragDropFlags): DragDrop flags.

    Returns:
        bytes: the payload data that was set by :func:`set_drag_drop_payload`.

    .. wraps::
        const ImGuiPayload* AcceptDragDropPayload(const char* type, ImGuiDragDropFlags flags = 0)
    """
    cdef payload = _ImGuiPayload.from_ptr(cimgui.AcceptDragDropPayload(_bytes(type), flags))
    if payload is None:
        return None

    cdef const char* data = <const char *>payload.data
    return <bytes>data[:payload.data_size]

def get_drag_drop_payload():
    """Peek directly into the current payload from anywhere. 
    May return NULL. 
    
    .. todo:: Map ImGuiPayload::IsDataType() to test for the payload type.
    
    .. wraps::
        const ImGuiPayload* GetDragDropPayload()
    """
    cdef payload = _ImGuiPayload.from_ptr(cimgui.GetDragDropPayload())
    if payload is None:
        return None
    cdef const char* data = <const char *>payload.Data
    return <bytes>data[:payload.data_size]

def end_drag_drop_target():
    """End the drag and drop source.
    Only call this function if ``begin_drag_drop_target().hovered`` is True.

    **Note:** this is a beta API.

    For a complete example see :func:`begin_drag_drop_source`.

    .. wraps::
        void EndDragDropTarget()
    """
    cimgui.EndDragDropTarget()

#-----------------------------------------------------------------------------
# [SECTION] LOGGING/CAPTURING
#-----------------------------------------------------------------------------
# All text output from the interface can be captured into tty/file/clipboard.
# By default, tree nodes are automatically opened during logging.
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] SETTINGS
#-----------------------------------------------------------------------------
# - UpdateSettings() [Internal]
# - MarkIniSettingsDirty() [Internal]
# - CreateNewWindowSettings() [Internal]
# - FindWindowSettings() [Internal]
# - FindOrCreateWindowSettings() [Internal]
# - FindSettingsHandler() [Internal]
# - ClearIniSettings() [Internal]
# - LoadIniSettingsFromDisk()
# - LoadIniSettingsFromMemory()
# - SaveIniSettingsToDisk()
# - SaveIniSettingsToMemory()
# - WindowSettingsHandler_***() [Internal]
#-----------------------------------------------------------------------------

def load_ini_settings_from_disk(str ini_file_name):
    """Call after ``create_context()`` and before the first call to ``new_frame()``.
    ``new_frame()`` automatically calls ``load_ini_settings_from_disk(io.ini_file_name)``.

    Args:
        ini_file_name (str): Filename to load settings from.

    .. wraps::
        void LoadIniSettingsFromDisk(const char* ini_filename)
    """
    cimgui.LoadIniSettingsFromDisk(_bytes(ini_file_name))

def load_ini_settings_from_memory(str ini_data):
    """Call after ``create_context()`` and before the first call to ``new_frame()``
    to provide .ini data from your own data source.

    .. wraps::
        void LoadIniSettingsFromMemory(const char* ini_data, size_t ini_size=0)
    """
    #cdef size_t ini_size = len(ini_data)
    cimgui.LoadIniSettingsFromMemory(_bytes(ini_data), 0)

def save_ini_settings_to_disk(str ini_file_name):
    """This is automatically called (if ``io.ini_file_name`` is not empty)
    a few seconds after any modification that should be reflected in the .ini file
    (and also by ``destroy_context``).

    Args:
        ini_file_name (str): Filename to save settings to.

    .. wraps::
        void SaveIniSettingsToDisk(const char* ini_filename)
    """
    cimgui.SaveIniSettingsToDisk(_bytes(ini_file_name))

def save_ini_settings_to_memory():
    """Return a string with the .ini data which you can save by your own mean.
    Call when ``io.want_save_ini_settings`` is set, then save data by your own mean
    and clear ``io.want_save_ini_settings``.

    Returns:
        str: Settings data

    .. wraps::
       const char* SaveIniSettingsToMemory(size_t* out_ini_size = NULL)
    """
    return _from_bytes(cimgui.SaveIniSettingsToMemory(NULL))

#-----------------------------------------------------------------------------
# [SECTION] VIEWPORTS, PLATFORM WINDOWS
#-----------------------------------------------------------------------------
# - GetMainViewport()
# - UpdateViewportsNewFrame() [Internal]
# (this section is more complete in the 'docking' branch)
#-----------------------------------------------------------------------------

cdef class _ImGuiViewport(object):
    """Currently represents the Platform Window created by the application which is hosting our Dear ImGui windows.
       
       About Main Area vs Work Area:
       - Main Area = entire viewport.
       - Work Area = entire viewport minus sections used by main menu bars (for platform windows), or by task bar (for platform monitor).
       - Windows are generally trying to stay within the Work Area of their host viewport.
    """
    
    cdef cimgui.ImGuiViewport* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiViewport* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiViewport()
        instance._ptr = ptr
        return instance

    @property
    def id(self):
        """Unique identifier for the viewport"""
        self._require_pointer()
        return self._ptr.ID

    @property
    def parent_viewport_id(self):
        """(Advanced) 0: no parent. Instruct the platform backend to setup a parent/child relationship between platform windows."""
        self._require_pointer()
        return self._ptr.ParentViewportId

    @property
    def dpi_scale(self):
        """1.0f = 96 DPI = No extra scale."""
        self._require_pointer()
        return self._ptr.DpiScale

    @property
    def flags(self):
        """See ImGuiViewportFlags_"""
        self._require_pointer()
        return self._ptr.Flags
    
    @property
    def pos(self):
        """Main Area: Position of the viewport (Dear ImGui coordinates are the same as OS desktop/native coordinates)"""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.Pos)
    
    @property
    def size(self):
        """Main Area: Size of the viewport."""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.Size)
    
    @property
    def work_pos(self):
        """Work Area: Position of the viewport minus task bars, menus bars, status bars (>= Pos)"""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.WorkPos)
    
    @property
    def work_size(self):
        """Work Area: Size of the viewport minus task bars, menu bars, status bars (<= Size)"""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.WorkSize)
    
    @property
    def draw_data(self):
        """The ImDrawData corresponding to this viewport. Valid after Render() and until the next call to NewFrame()."""
        self._require_pointer()
        return _DrawData.from_ptr(self._ptr.DrawData)

    @property
    def pos(self):
        """Main Area: Position of the viewport (Dear ImGui coordinates are the same as OS desktop/native coordinates)"""
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.Pos)

    @property
    def platform_request_resize(self):
        """Platform window requested resize (e.g. window was resized by the OS / host window manager, authoritative size will be OS window size)"""
        self._require_pointer()
        return self._ptr.PlatformRequestResize

    @property
    def platform_request_move(self):
        """Platform window requested move (e.g. window was moved by the OS / host window manager, authoritative position will be OS window position) """
        self._require_pointer()
        return self._ptr.PlatformRequestMove

    @property
    def platform_request_close(self):
        """Platform window requested closure (e.g. window was moved by the OS / host window manager, e.g. pressing ALT-F4) """
        self._require_pointer()
        return self._ptr.PlatformRequestClose

    def get_center(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.GetCenter())
    
    def get_work_center(self):
        self._require_pointer()
        return _cast_ImVec2_tuple(self._ptr.GetWorkCenter())

cdef class ImGuiWindowClass(object):
    """
    // [ALPHA] Rarely used / very advanced uses only. Use with SetNextWindowClass() and DockSpace() functions.
    // Important: the content of this class is still highly WIP and likely to change and be refactored
    // before we stabilize Docking features. Please be mindful if using this.
    // Provide hints:
    // - To the platform backend via altered viewport flags (enable/disable OS decoration, OS task bar icons, etc.)
    // - To the platform backend for OS level parent/child relationships of viewport.
    // - To the docking system for various options and filtering.
    """

    cdef cimgui.ImGuiWindowClass* _ptr

    def __init__(self):
        pass

    def _require_pointer(self):
        if self._ptr == NULL:
            raise RuntimeError(
                "%s improperly initialized" % self.__class__.__name__
            )

    @staticmethod
    cdef from_ptr(cimgui.ImGuiWindowClass* ptr):
        if ptr == NULL:
            return None

        instance = ImGuiWindowClass()
        instance._ptr = ptr
        return instance

    @property
    def class_id(self):
        self._require_pointer()
        return self._ptr.ClassId

    @property
    def parent_viewport_id(self):
        self._require_pointer()
        return self._ptr.ParentViewportId

    @property
    def viewport_flags_override_set(self):
        self._require_pointer()
        return self._ptr.ViewportFlagsOverrideSet

    @property
    def viewport_flags_override_clear(self):
        self._require_pointer()
        return self._ptr.ViewportFlagsOverrideClear

    @property
    def tab_item_flags_override_set(self):
        self._require_pointer()
        return self._ptr.TabItemFlagsOverrideSet

    @property
    def docknode_flags_override_set(self):
        self._require_pointer()
        return self._ptr.DockNodeFlagsOverrideSet

    @property
    def docking_always_tab_bar(self):
        self._require_pointer()
        return self._ptr.DockingAlwaysTabBar

    @property
    def docking_allow_unclassed(self):
        self._require_pointer()
        return self._ptr.DockingAllowUnclassed

    """
    error C7624 on MSVC 14.27.29110
    def imgui_window_class(self):
        self._require_pointer()
        self._ptr.ImGuiWindowClass()
    """



def get_main_viewport():
    """Currently represents the Platform Window created by the application which is hosting
    our Dear ImGui windows.

    In the future we will extend this concept further to also represent Platform Monitor
    and support a "no main platform window" operation mode.

    Returns:
        _ImGuiViewport: Viewport

    .. wraps::
        ImGuiViewport* GetMainViewport()
    """
    return _ImGuiViewport.from_ptr(cimgui.GetMainViewport())

def get_window_viewport():
    """ Get viewport currently associated to the current window.
    Returns:
        _ImGuiViewport: Viewport

    .. wraps::
        ImGuiViewport* GetWindowViewport()
    """
    return _ImGuiViewport.from_ptr(cimgui.GetMainViewport())

def update_platform_windows():
    return cimgui.UpdatePlatformWindows()

def destroy_platform_windows():
    return cimgui.DestroyPlatformWindows()

cdef void render_platform_windows_default(void* platform_render_arg = NULL, void* renderer_render_arg = NULL):
    cimgui.RenderPlatformWindowsDefault(platform_render_arg, renderer_render_arg)

cdef find_viewport_by_platform_handle(void* platform_handle):
    return _ImGuiViewport.from_ptr(cimgui.FindViewportByPlatformHandle(platform_handle))

def find_viewport_by_id(cimgui.ImGuiID id):
    return _ImGuiViewport.from_ptr(cimgui.FindViewportByID(id))

#-----------------------------------------------------------------------------
# [SECTION] DOCKING
#-----------------------------------------------------------------------------

def dockspace(cimgui.ImGuiID id, tuple size=(0, 0), cimgui.ImGuiDockNodeFlags flags=0):
    """Create an explicit dockspace node within an existing window. Also expose dock node flags and creates a CentralNode by default.
    The Central Node is always displayed even when empty and shrink/extend according to the requested size of its neighbors.
    dockspace() needs to be submitted _before_ any window they can host. If you use a dockspace, submit it early in your app.

    Args:
        id (ImGuiID): Identifier
        size (tuple): Size
        flags (ImGuiDockNodeFlags): DockNode flags.

    Returns:
        ImGuiID: Identifier

    .. wraps::
        ImGuiID DockSpace(ImGuiID id, const ImVec2& size, ImGuiDockNodeFlags flags, const void* window_class)
    """
    return cimgui.DockSpace(id, _cast_tuple_ImVec2(size), flags, NULL)

def get_window_dock_id():
    return cimgui.GetWindowDockID()

def is_window_docked():
    return cimgui.IsWindowDocked()

#-----------------------------------------------------------------------------
# [SECTION] PLATFORM DEPENDENT HELPERS
#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------
# [SECTION] METRICS/DEBUGGER WINDOW
#-----------------------------------------------------------------------------
# - RenderViewportThumbnail() [Internal]
# - RenderViewportsThumbnails() [Internal]
# - MetricsHelpMarker() [Internal]
# - ShowMetricsWindow()
# - DebugNodeColumns() [Internal]
# - DebugNodeDrawList() [Internal]
# - DebugNodeDrawCmdShowMeshAndBoundingBox() [Internal]
# - DebugNodeStorage() [Internal]
# - DebugNodeTabBar() [Internal]
# - DebugNodeViewport() [Internal]
# - DebugNodeWindow() [Internal]
# - DebugNodeWindowSettings() [Internal]
# - DebugNodeWindowsList() [Internal]
#-----------------------------------------------------------------------------

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

#-----------------------------------------------------------------------------

# Nothing to be mapped here

#-----------------------------------------------------------------------------

# Nothing to be mapped here
